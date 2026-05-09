package vn.edu.hcmuaf.fit.websharedocument.service;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;

public class DMS {

    private DocumentDAO documentDAO;

    public DMS() {
        this.documentDAO = new DocumentDAO();
    }

    // UC13.2.2.3 writeErrorLog(documentId, errorCode, timestamp)
    public void writeErrorLog(int documentId, String errorCode, String timestamp) {
        System.out.println("DMS: Log Error - DocID: " + documentId + ", Error: " + errorCode + " at " + timestamp);
    }

    public void returnLogConfirmed() {
        System.out.println("DMS -->> UI: returnLogConfirmed()");
    }

    // UC13.1.5 generateSignedUrl(documentId, expiry=900s)
    public String generateSignedUrl(int documentId, int expiry) {
        // Giả lập tạo signed url
        return "/download/signed?docId=" + documentId + "&token=temp_token";
    }

    public void returnSignedUrl(String url, String expiresAt) {
        System.out.println("DMS -->> UI: returnSignedUrl(" + url + ", " + expiresAt + ")");
    }

    // UC13.1.8 writeAuditLog(documentId, userId, timestamp, ipAddress)
    public void writeAuditLog(int documentId, Integer userId, String timestamp, String ipAddress) {
        // Tăng lượt tải xuống thành công trong hệ thống (như yêu cầu "mỗi lần tải load lại cập nhật lượt tải")
        documentDAO.incrementDownloadCount(documentId);
        System.out.println("DMS: Audit Log - User: " + userId + " downloaded DocID: " + documentId + " at " + timestamp + " from IP: " + ipAddress);
    }

    public void returnAuditConfirmed(String logId) {
        System.out.println("DMS -->> UI: returnAuditConfirmed(" + logId + ")");
    }
}
