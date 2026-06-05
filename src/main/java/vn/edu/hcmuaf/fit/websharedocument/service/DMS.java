package vn.edu.hcmuaf.fit.websharedocument.service;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;

public class DMS {

    private DocumentDAO documentDAO;

    public DMS() {
        this.documentDAO = new DocumentDAO();
    }

    /**
     * [UC13.2.3.3] Ghi log lỗi nội bộ khi tìm tệp thất bại (DB null / remote 4xx / local missing).
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() trong khối catch FileNotFoundException
     */
    public void writeErrorLog(int documentId, String errorCode, String timestamp) {
        System.out.println("DMS: Log Error - DocID: " + documentId + ", Error: " + errorCode + " at " + timestamp);
    }

    /** [UC13.2.3.3] Phản hồi xác nhận đã ghi log lỗi. */
    public void returnLogConfirmed() {
        System.out.println("DMS -->> UI: returnLogConfirmed()");
    }

    /**
     * [EX-02] Ghi log sự kiện bảo mật khi phát hiện tệp nguy hiểm.
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() trong khối catch DangerousFileException
     * → Ghi nhận: documentId, userId, lý do chặn, thời gian, địa chỉ IP
     * → Dùng để: đội kỹ thuật điều tra và xử lý tệp vi phạm
     */
    public void writeSecurityLog(int documentId, Integer userId, String reason, String timestamp, String ipAddress) {
        System.out.println("DMS: [SECURITY] Dangerous file blocked – DocID: " + documentId
                + ", UserID: " + userId
                + ", Reason: " + reason
                + ", IP: " + ipAddress
                + " at " + timestamp);
    }

    /**
     * [UC13.1.6] Tạo Signed URL tạm thời để tải xuống (expiry = 900 giây).
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() sau khi fetchFile() thành công
     */
    public String generateSignedUrl(int documentId, int expiry) {
        return "/download/signed?docId=" + documentId + "&token=temp_token";
    }

    /** [UC13.1.6] Phản hồi Signed URL đã tạo. */
    public void returnSignedUrl(String url, String expiresAt) {
        System.out.println("DMS -->> UI: returnSignedUrl(" + url + ", " + expiresAt + ")");
    }

    /**
     * [UC13.1.9] Ghi audit log sự kiện tải xuống thành công.
     * → Gọi bởi: DownloadDocumentServlet.confirmSave() sau khi stream thành công
     * → Gọi nội bộ: documentDAO.incrementDownloadCount(documentId)
     */
    public void writeAuditLog(int documentId, Integer userId, String timestamp, String ipAddress) {
        documentDAO.incrementDownloadCount(documentId);
        System.out.println("DMS: Audit Log - User: " + userId + " downloaded DocID: " + documentId
                 + " at " + timestamp + " from IP: " + ipAddress);
    }

    /** [UC13.1.9] Phản hồi xác nhận đã ghi audit log. */
    public void returnAuditConfirmed(String logId) {
        System.out.println("DMS -->> UI: returnAuditConfirmed(" + logId + ")");
    }
}