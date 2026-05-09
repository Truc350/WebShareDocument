package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.model.User;
import vn.edu.hcmuaf.fit.websharedocument.service.AuthService;
import vn.edu.hcmuaf.fit.websharedocument.service.DMS;
import vn.edu.hcmuaf.fit.websharedocument.service.FileStorage;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

/**
 * DownloadDocumentServlet – UC-13: Tải Tài Liệu Về Thiết Bị
 *
 * URL pattern : GET /download?id={documentId}
 * Trigger     : JS fetch() trong document-detail.jsp gọi sau khi người dùng
 *               nhấn "Xác nhận tải" tại modal xác nhận (UC13.1.2 → UC13.1.3)
 *
 * Luồng bình thường:
 *   UC13.1.3  → verifySessionAndPermission()  [AuthService]
 *   UC13.1.4  → fetchFile()                   [FileStorage → DocumentDAO]
 *   UC13.1.5  → generateSignedUrl()            [DMS]
 *   UC13.1.6  → showSaveDialog() + stream      [response headers + OutputStream]
 *   UC13.1.8  → writeAuditLog()               [DMS → DocumentDAO.incrementDownloadCount]
 *
 * Luồng thay thế / ngoại lệ:
 *   UC13.2.2  → Không có quyền     → HTTP 403
 *   UC13.2.3  → Tệp không tìm thấy → HTTP 404 + writeErrorLog()
 *   UC13.2.4  → Hủy giữa chừng    → xử lý phía JS (AbortController), server không bắt được
 *   UC13.2.5  → IOException stream  → skipAuditLog(), không ghi log thành công
 *
 * File: DownloadDocumentServlet.java
 */
@WebServlet(name = "DownloadDocumentServlet", urlPatterns = {"/download"})
public class DownloadDocumentServlet extends HttpServlet {

    private AuthService auth;
    private FileStorage storage;
    private DMS dms;

    /**
     * Khởi tạo các service khi servlet được load lần đầu.
     * - uploadDir trỏ đến thư mục /document/uploads trong webapp
     */
    @Override
    public void init() throws ServletException {
        auth    = new AuthService();
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
        dms     = new DMS();
    }

    // ====================================================================
    // [UC13.1.3] Entry point – nhận HTTP GET /download?id=
    // ====================================================================

    /**
     * [UC13.1.3] Servlet nhận request từ JS fetch() trong document-detail.jsp.
     * → Đọc param "id", lấy userId từ session, chuyển sang clickDownload()
     * → userId = null nếu chưa đăng nhập → UC13.2.2 (permission denied)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) return;

        int documentId;
        try {
            documentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid ID");
            return;
        }

        // Lấy userId từ session (null nếu chưa đăng nhập → UC13.2.2)
        User user     = (User) request.getSession().getAttribute("authUser");
        Integer userId = user != null ? user.getId() : null;

        // [UC13.1.2] Điểm vào của toàn bộ luồng tải xuống phía server
        clickDownload(request, response, userId, documentId);
    }

    // ====================================================================
    // [UC13.1.3 → UC13.1.6] Điều phối luồng chính
    // ====================================================================

    /**
     * Điều phối toàn bộ luồng tải xuống:
     *   1. Xác minh quyền (UC13.1.3)
     *   2. Lấy file từ storage (UC13.1.4)
     *   3. Tạo Signed URL (UC13.1.5)
     *   4. Thiết lập headers & stream file (UC13.1.6)
     */
    private void clickDownload(HttpServletRequest request, HttpServletResponse response,
                               Integer userId, int documentId) throws IOException {

        // ── UC13.1.3: Kiểm tra quyền ─────────────────────────────────────
        // → AuthService.verifySessionAndPermission()
        // → false → UC13.2.2 (HTTP 403)
        boolean hasPermission = auth.verifySessionAndPermission(userId, documentId);

        if (!hasPermission) {
            // [UC13.2.2.1] Phát hiện quyền bị từ chối
            auth.detectPermissionDenied();

            // [UC13.2.2.2] Trả về HTTP 403 → JS .catch() → showErrorModal
            showError(response, 403, "Bạn không có quyền tải tài liệu này");

            // [UC13.2.2.3] Use case kết thúc – không ghi audit log
            return;
        }

        // [UC13.1.3] Quyền hợp lệ → tiếp tục
        auth.returnPermissionGranted(userId, documentId);

        try {
            // ── UC13.1.4: Lấy file từ FileStorage ────────────────────────
            // → FileStorage.fetchFile() gọi DocumentDAO.getDocumentById()
            // → Hỗ trợ cả Remote URL (http) và Local File (disk)
            // → throw FileNotFoundException → catch bên dưới → UC13.2.3
            FileStorage.FileData fileData = storage.fetchFile(documentId);

            // [UC13.1.4] File tìm thấy – log xác nhận
            storage.returnFileData(fileData.getFileName(), fileData.getFileSize());

            // ── UC13.1.5: Tạo Signed URL ──────────────────────────────────
            // → DMS.generateSignedUrl() tạo URL tạm (expiry = 900s)
            String signedUrl = dms.generateSignedUrl(documentId, 900);
            dms.returnSignedUrl(signedUrl, "expiresAt_XYZ");

            // ── UC13.1.6: Thiết lập HTTP Response headers ─────────────────
            // → Content-Type, Content-Length (dùng bởi JS để tính % tiến trình)
            // → Content-Disposition: attachment → trình duyệt hiểu đây là file tải
            showSaveDialog(response, fileData.getFileName(), fileData.getFileSize(), signedUrl);

            // ── UC13.1.6 → UC13.1.8: Stream file và ghi audit log ─────────
            confirmSave(request, response, documentId, userId, signedUrl, fileData);

        } catch (FileStorage.FileNotFoundException e) {
            // ── UC13.2.3: Tệp không tìm thấy hoặc lỗi Storage ───────────
            // Xảy ra khi: DB null / remote HTTP != 200 / local file missing

            // [UC13.2.3.1] Log thông báo file không tìm thấy
            storage.throwFileNotFoundError(documentId);

            // [UC13.2.3.2] Trả HTTP 404 → JS .catch() → showErrorModal
            showError(response, 404, "Tài liệu hiện không khả dụng");

            // [UC13.2.3.3] Ghi error log nội bộ để đội kỹ thuật xử lý
            dms.writeErrorLog(documentId, "404", new Date().toString());
            dms.returnLogConfirmed();

            // [UC13.2.3.4] Use case kết thúc
        }
    }

    // ====================================================================
    // [UC13.1.6 → UC13.1.8] Stream file & ghi audit log
    // ====================================================================

    /**
     * [UC13.1.6] Stream dữ liệu tệp từ InputStream → OutputStream (response).
     *   - Buffer 8192 bytes/lần để tối ưu hiệu suất
     *   - JS phía client dùng ReadableStream.getReader().pump() để đọc từng chunk
     *     và cập nhật thanh tiến trình real-time
     *
     * [UC13.1.8] Sau khi stream thành công:
     *   → DMS.writeAuditLog() → DocumentDAO.incrementDownloadCount()
     *
     * [UC13.2.5] IOException giữa chừng:
     *   → skipAuditLog() – không ghi log thành công
     *   → JS .catch() nhận lỗi → showErrorModal
     */
    private void confirmSave(HttpServletRequest request, HttpServletResponse response,
                             int documentId, Integer userId,
                             String signedUrl, FileStorage.FileData fileData) {

        // [UC13.1.6] Bắt đầu truyền file (log)
        startFileTransfer(signedUrl);

        try (java.io.InputStream inStream = fileData.getInputStream();
             OutputStream outStream = response.getOutputStream()) {

            // [UC13.1.6] Đọc InputStream → ghi OutputStream, buffer 8192 bytes/lần
            // → JS ReadableStream reader nhận từng chunk và cập nhật setProgress()
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }

            // ── Stream hoàn tất thành công ────────────────────────────────

            // [UC13.1.7] onDownloadComplete – log xác nhận file đã truyền xong
            onDownloadComplete(fileData.getFileName(), "Thiết bị của người dùng");

            // [UC13.1.8] Ghi audit log + tăng download_count trong DB
            // → DMS.writeAuditLog() gọi nội bộ DocumentDAO.incrementDownloadCount()
            dms.writeAuditLog(documentId, userId, new Date().toString(), request.getRemoteAddr());
            dms.returnAuditConfirmed("LOG_" + System.currentTimeMillis());

            // [UC13.1.8] JS nhận HTTP 200 → showSuccessModal
            showSuccess("Tải xuống thành công");

        } catch (IOException e) {
            // ── UC13.2.5: Kết nối bị gián đoạn trong quá trình streaming ──

            // [UC13.2.5.1] Phát hiện mất kết nối
            detectConnectionLost();

            // [UC13.2.5.2] JS .catch() nhận lỗi → showErrorModal ["Tải thất bại"]
            showNetworkError("Tải không hoàn tất");

            // [UC13.2.5.3] skipAuditLog – không ghi log sự kiện tải thành công
            // [UC13.2.5.4] Use case kết thúc
            skipAuditLog();
        }
    }

    // ====================================================================
    // CÁC HÀM TIỆN ÍCH – ánh xạ 1-1 với các bước trong Sequence Diagram
    // ====================================================================

    /**
     * [UC13.2.2.2 / UC13.2.3.2] Gửi HTTP error response về JS fetch().
     * → JS .catch(err) nhận lỗi → onDownloadDone() → showErrorModal
     */
    private void showError(HttpServletResponse response, int status, String msg) throws IOException {
        response.sendError(status, msg);
    }

    /**
     * [UC13.1.6] Thiết lập HTTP Response headers cho trình duyệt:
     * - Content-Type     : loại MIME của file
     * - Content-Length   : kích thước file → JS dùng để tính % tiến trình
     * - Content-Disposition: attachment → kích hoạt save dialog
     */
    private void showSaveDialog(HttpServletResponse response, String fileName, long fileSize, String signedUrl) {
        response.setContentType(getServletContext().getMimeType(fileName));
        response.setContentLength((int) fileSize);
        response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s\"", fileName));
    }

    /** [UC13.1.6] Log bắt đầu truyền file. */
    private void startFileTransfer(String signedUrl) {
        System.out.println("Servlet: startFileTransfer(" + signedUrl + ")");
    }

    /** [UC13.1.7] Log xác nhận file đã truyền hoàn tất đến thiết bị người dùng. */
    private void onDownloadComplete(String fileName, String savedPath) {
        System.out.println("Servlet: UC13.1.7 onDownloadComplete(" + fileName + ", " + savedPath + ")");
    }

    /** [UC13.1.8] Log thông báo tải xuống thành công (hiển thị trên server log). */
    private void showSuccess(String msg) {
        System.out.println("Servlet: UC13.1.8 showSuccess(\"" + msg + "\")");
    }

    /** [UC13.2.5.1] Log phát hiện mất kết nối trong quá trình stream. */
    private void detectConnectionLost() {
        System.out.println("Servlet: UC13.2.5.1 detectConnectionLost()");
    }

    /** [UC13.2.5.2] Log lỗi mạng – tải không hoàn tất. */
    private void showNetworkError(String msg) {
        System.out.println("Servlet: UC13.2.5.2 showNetworkError(\"" + msg + "\")");
    }

    /**
     * [UC13.2.5.3 / UC13.2.5.4] Bỏ qua ghi audit log khi tải bị gián đoạn.
     * → Không tăng download_count vì file chưa được tải hoàn tất.
     */
    private void skipAuditLog() {
        System.out.println("Servlet: UC13.2.5.3 skipAuditLog() – Use case kết thúc");
    }
}