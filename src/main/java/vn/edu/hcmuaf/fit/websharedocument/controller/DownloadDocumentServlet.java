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

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

@WebServlet(name = "DownloadDocumentServlet", urlPatterns = {"/download"})
public class DownloadDocumentServlet extends HttpServlet {

    private AuthService auth;
    private FileStorage storage;
    private DMS dms;

    @Override
    public void init() throws ServletException {
        auth = new AuthService();
        storage = new FileStorage(getServletContext().getRealPath("/document/uploads"));
        dms = new DMS();
    }

    // ====================================================================
    // Giao Dien Web (UI) Role theo Sequence Diagram
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

        User user = (User) request.getSession().getAttribute("authUser");
        Integer userId = user != null ? user.getId() : null;

        // Bắt đầu luồng từ UI theo Sequence Diagram
        // UC13.1.2 clickDownload(documentId)
        clickDownload(request, response, userId, documentId);
    }

    private void clickDownload(HttpServletRequest request, HttpServletResponse response, Integer userId, int documentId) throws IOException {
        // UC13.1.3 verifySessionAndPermission(userId, documentId)
        boolean hasPermission = auth.verifySessionAndPermission(userId, documentId);

        if (!hasPermission) {
            // UC13.2.1.1 detectPermissionDenied()
            auth.detectPermissionDenied();
            
            // UC13.2.1.2 showError(403, "Bạn không có quyền tải tài liệu này")
            showError(response, 403, "Bạn không có quyền tải tài liệu này");
            
            // UC13.2.1.3 Use case kết thúc
            return;
        }

        // Quyền hợp lệ - tiếp tục luồng bình thường
        auth.returnPermissionGranted(userId, documentId);

        try {
            // UC13.1.4 fetchFile(documentId)
            FileStorage.FileData fileData = storage.fetchFile(documentId);

            // Tìm thấy tệp thành công
            storage.returnFileData(fileData.getFileName(), fileData.getFileSize());

            // UC13.1.5 generateSignedUrl(documentId, expiry=900s)
            String signedUrl = dms.generateSignedUrl(documentId, 900);
            dms.returnSignedUrl(signedUrl, "expiresAt_XYZ");

            // UC13.1.6 showSaveDialog(fileName, fileSize, signedUrl)
            showSaveDialog(response, fileData.getFileName(), fileData.getFileSize(), signedUrl);

            // UC13.1.7 confirmSave(signedUrl, savePath)
            confirmSave(request, response, documentId, userId, signedUrl, fileData);

        } catch (FileStorage.FileNotFoundException e) {
            // UC13.2.2 Tệp không tìm thấy hoặc lỗi Storage
            
            // UC13.2.2.1 throwFileNotFoundError(documentId)
            storage.throwFileNotFoundError(documentId);
            
            // UC13.2.2.2 showError(404, "Tài liệu hiện không khả dụng")
            showError(response, 404, "Tài liệu hiện không khả dụng");
            
            // UC13.2.2.3 writeErrorLog(documentId, errorCode, timestamp)
            dms.writeErrorLog(documentId, "404", new Date().toString());
            
            // returnLogConfirmed()
            dms.returnLogConfirmed();
            
            // UC13.2.2.4 Use case kết thúc
        }
    }

    private void confirmSave(HttpServletRequest request, HttpServletResponse response, int documentId, Integer userId, String signedUrl, FileStorage.FileData fileData) {
        // startFileTransfer(signedUrl)
        startFileTransfer(signedUrl);

        try (java.io.InputStream inStream = fileData.getInputStream();
             OutputStream outStream = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }

            // Tải xuống hoàn tất thành công
            // UC13.1.7 onDownloadComplete(fileName, savedPath)
            onDownloadComplete(fileData.getFileName(), "Thiết bị của người dùng");

            // UC13.1.8 writeAuditLog(documentId, userId, timestamp, ipAddress)
            dms.writeAuditLog(documentId, userId, new Date().toString(), request.getRemoteAddr());
            
            // returnAuditConfirmed(logId)
            dms.returnAuditConfirmed("LOG_" + System.currentTimeMillis());

            // UC13.1.8 showSuccess("Tải xuống thành công")
            showSuccess("Tải xuống thành công");

        } catch (IOException e) {
            // UC13.2.4 Kết nối bị gián đoạn trong quá trình tải
            
            // UC13.2.4.1 detectConnectionLost()
            detectConnectionLost();
            
            // UC13.2.4.2 showNetworkError("Tải không hoàn tất")
            showNetworkError("Tải không hoàn tất");
            
            // UC13.2.4.3 attemptResumeDownload(resumeToken)
            attemptResumeDownload("RESUME_TOKEN_XYZ");
            
            // UC13.2.4.4 skipAuditLog() - Use case kết thúc
            skipAuditLog();
        }
    }

    // ====================================================================
    // CÁC HÀM TIỆN ÍCH CỦA UI
    // ====================================================================
    
    private void showError(HttpServletResponse response, int status, String msg) throws IOException {
        response.sendError(status, msg);
    }
    
    private void showSaveDialog(HttpServletResponse response, String fileName, long fileSize, String signedUrl) {
        response.setContentType(getServletContext().getMimeType(fileName));
        response.setContentLength((int) fileSize);
        response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s\"", fileName));
    }
    
    private void startFileTransfer(String signedUrl) {
        System.out.println("UI -->> User: startFileTransfer(" + signedUrl + ")");
    }
    
    private void onDownloadComplete(String fileName, String savedPath) {
        System.out.println("UI -->> User: UC13.1.7 onDownloadComplete(" + fileName + ", " + savedPath + ")");
    }
    
    private void showSuccess(String msg) {
        System.out.println("UI -->> User: UC13.1.8 showSuccess(\"" + msg + "\")");
    }
    
    private void detectConnectionLost() {
        System.out.println("UI -->> User: UC13.2.4.1 detectConnectionLost()");
    }
    
    private void showNetworkError(String msg) {
        System.out.println("UI -->> User: UC13.2.4.2 showNetworkError(\"" + msg + "\")");
    }
    
    private void attemptResumeDownload(String token) {
        System.out.println("UI -->> User: UC13.2.4.3 attemptResumeDownload(" + token + ")");
    }
    
    private void skipAuditLog() {
        System.out.println("UI: UC13.2.4.4 skipAuditLog() - Use case kết thúc");
    }
}