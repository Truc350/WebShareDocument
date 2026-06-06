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
 * URL pattern : GET /download?id={documentId}&customName={customName}
 * Trigger     : JS fetch() trong document-detail.jsp gọi sau khi người dùng
 *               nhập tên tùy chỉnh và nhấn "Xác nhận tải" (UC13.1.2 → UC13.1.3)
 *
 * Luồng bình thường:
 *   UC13.1.2  → Giao diện hiển thị modal, pre-fill tên không kèm extension
 *   UC13.1.3  → Người dùng chỉnh sửa tên mới và nhấn xác nhận tải
 *   UC13.1.4  → verifySessionAndPermission() [AuthService]
 *   UC13.1.5  → checkFileSafety() (magic bytes + extension blacklist) [FileStorage]
 *   UC13.1.6  → Nhận customName (UC13.2.6.4), tự động ghép đuôi gốc (UC13.2.6.5), tạo Signed URL [DMS], set response headers
 *   UC13.1.7  → Stream tệp tin về trình duyệt & cập nhật % tiến trình
 *   UC13.1.8  → Tệp tải hoàn tất, ghép Blob kích hoạt hộp thoại lưu
 *   UC13.1.9  → writeAuditLog() + incrementDownloadCount() [DMS -> DocumentDAO] + hiển thị thông báo thành công
 *
 * Luồng thay thế / ngoại lệ:
 *   UC13.2.1  → Hủy tại modal xác nhận
 *   UC13.2.2  → Không có quyền tải tài liệu
 *   UC13.2.3  → Tệp không tìm thấy hoặc lỗi Storage
 *   UC13.2.4  → Hủy tải xuống giữa chừng (stream)
 *   UC13.2.5  → Kết nối bị gián đoạn (IOException)
 *   UC13.2.6  → Nhánh thay đổi tên tệp (1-5)
 *   EX-02     → File nguy hiểm bị chặn (EX-02.1 -> EX-02.4)
 *
 * File: DownloadDocumentServlet.java
 */
@WebServlet(name = "DownloadDocumentServlet", urlPatterns = {"/download"})
public class DownloadDocumentServlet extends HttpServlet {

    private AuthService auth;
    private FileStorage storage;
    private DMS dms;

    @Override
    public void init() throws ServletException {
        auth    = new AuthService();
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
        dms     = new DMS();
    }

    // ====================================================================
    // [UC13.1.3] Entry point – nhận HTTP GET /download?id=
    // ====================================================================

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

        User user      = (User) request.getSession().getAttribute("authUser");
        Integer userId = user != null ? user.getId() : null;

        // [UC13.2.6.4] Backend Servlet nhận tham số customName từ request
        String customName = request.getParameter("customName");
        clickDownload(request, response, userId, documentId, customName);
    }

    // ====================================================================
    // [UC13.1.4 → UC13.1.7] Điều phối luồng chính
    // ====================================================================

    private void clickDownload(HttpServletRequest request, HttpServletResponse response,
                               Integer userId, int documentId, String customName) throws IOException {

        // ── UC13.1.4: Kiểm tra quyền ─────────────────────────────────────
        boolean hasPermission = auth.verifySessionAndPermission(userId, documentId);

        if (!hasPermission) {
            // [UC13.2.2.1] Phát hiện quyền bị từ chối
            auth.detectPermissionDenied();

            // [UC13.2.2.2] Trả về HTTP 403 → JS .catch() → showErrorModal
            showError(response, 403, "Bạn không có quyền tải tài liệu này");

            // [UC13.2.2.3] Use case kết thúc – không ghi audit log
            return;
        }

        auth.returnPermissionGranted(userId, documentId);

        try {
            // ── UC13.1.5: Lấy file và kiểm tra an toàn ──────────────────
            // → fetchFile() gọi nội bộ checkFileSafety() (kiểm tra magic bytes + blacklist)
            // → throw DangerousFileException → EX-02 (bên dưới)
            // → throw FileNotFoundException  → UC13.2.3 (bên dưới)
            FileStorage.FileData fileData = storage.fetchFile(documentId);

            storage.returnFileData(fileData.getFileName(), fileData.getFileSize());

            // ── UC13.1.6: Tạo Signed URL & Xử lý tên tệp tùy chỉnh ───────
            String signedUrl = dms.generateSignedUrl(documentId, 900);
            dms.returnSignedUrl(signedUrl, "expiresAt_XYZ");

            // [UC13.2.6.5] Servlet kiểm tra và tự động ghép nối đuôi tệp gốc vào tên mới
            String finalFileName = fileData.getFileName();
            if (customName != null && !customName.trim().isEmpty()) {
                String trimmedCustom = customName.trim();
                String ext = "";
                int dotIdx = finalFileName.lastIndexOf('.');
                if (dotIdx >= 0) {
                    ext = finalFileName.substring(dotIdx);
                }
                
                // If user didn't write the extension, append it
                if (!ext.isEmpty() && !trimmedCustom.toLowerCase().endsWith(ext.toLowerCase())) {
                    finalFileName = trimmedCustom + ext;
                } else {
                    finalFileName = trimmedCustom;
                }
            }

            // Expose the Content-Disposition header
            response.setHeader("Access-Control-Expose-Headers", "Content-Disposition");

            // Thiết lập HTTP Response headers (UC13.1.6)
            showSaveDialog(response, finalFileName, fileData.getFileSize(), signedUrl);

            // ── UC13.1.7: Bắt đầu truyền dữ liệu dưới dạng stream ─────────
            confirmSave(request, response, documentId, userId, signedUrl, fileData, finalFileName);

        } catch (FileStorage.DangerousFileException e) {
            // ── EX-02: File bị phát hiện là nguy hiểm (EX-02.1) ──────────
            // Xảy ra khi: extension nằm trong danh sách đen hoặc magic bytes không khớp

            // [EX-02.2] Log sự kiện bảo mật nội bộ để đội kỹ thuật xử lý
            dms.writeSecurityLog(documentId, userId, e.getMessage(), new Date().toString(), request.getRemoteAddr());

            // [EX-02.3] Trả HTTP 403 + thông báo cảnh báo rõ ràng cho người dùng
            showError(response, 403, "Tệp bị từ chối: nội dung không an toàn. Vui lòng liên hệ quản trị viên.");

            // [EX-02.4] Kết thúc luồng – JS nhận lỗi và reset trạng thái tải
        } catch (FileStorage.FileNotFoundException e) {
            // ── UC13.2.3: Tệp không tìm thấy hoặc lỗi Storage ───────────

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
    // [UC13.1.7 → UC13.1.9] Stream file & ghi audit log
    // ====================================================================

    private void confirmSave(HttpServletRequest request, HttpServletResponse response,
                             int documentId, Integer userId,
                             String signedUrl, FileStorage.FileData fileData, String finalFileName) {

        startFileTransfer(signedUrl);

        try (java.io.InputStream inStream = fileData.getInputStream();
             OutputStream outStream = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }

            // UC13.1.8: Tệp được tải xuống hoàn tất từ phía server
            onDownloadComplete(finalFileName, "Thiết bị của người dùng");

            // UC13.1.9: Ghi audit log sự kiện tải xuống thành công & tăng lượt tải
            dms.writeAuditLog(documentId, userId, new Date().toString(), request.getRemoteAddr());
            dms.returnAuditConfirmed("LOG_" + System.currentTimeMillis());

            showSuccess("Tải xuống thành công");

        } catch (IOException e) {
            // ── UC13.2.5: Kết nối bị gián đoạn trong quá trình streaming ──
            detectConnectionLost();
            showNetworkError("Tải không hoàn tất");
            skipAuditLog();
        }
    }

    // ====================================================================
    // CÁC HÀM TIỆN ÍCH – ánh xạ 1-1 với các bước trong Sequence Diagram
    // ====================================================================

    private void showError(HttpServletResponse response, int status, String msg) throws IOException {
        response.sendError(status, msg);
    }

    private void showSaveDialog(HttpServletResponse response, String fileName, long fileSize, String signedUrl) {
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType != null) {
            response.setContentType(mimeType);
        } else {
            response.setContentType("application/octet-stream");
        }
        response.setContentLength((int) fileSize);
        
        try {
            String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            String asciiFileName = fileName.replaceAll("[^\\x20-\\x7E]", "?");
            response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s\"; filename*=UTF-8''%s", asciiFileName, encodedFileName));
        } catch (java.io.UnsupportedEncodingException e) {
            response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s\"", fileName));
        }
    }

    private void startFileTransfer(String signedUrl) {
        System.out.println("Servlet: startFileTransfer(" + signedUrl + ")");
    }

    private void onDownloadComplete(String fileName, String savedPath) {
        System.out.println("Servlet: UC13.1.8 onDownloadComplete(" + fileName + ", " + savedPath + ")");
    }

    private void showSuccess(String msg) {
        System.out.println("Servlet: UC13.1.9 showSuccess(\"" + msg + "\")");
    }

    private void detectConnectionLost() {
        System.out.println("Servlet: UC13.2.5.1 detectConnectionLost()");
    }

    private void showNetworkError(String msg) {
        System.out.println("Servlet: UC13.2.5.2 showNetworkError(\"" + msg + "\")");
    }

    private void skipAuditLog() {
        System.out.println("Servlet: UC13.2.5.3 skipAuditLog() – Use case kết thúc");
    }
}