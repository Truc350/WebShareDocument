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
     * → File: DMS.java
     */
    public void writeErrorLog(int documentId, String errorCode, String timestamp) {
        System.out.println("DMS: Log Error - DocID: " + documentId + ", Error: " + errorCode + " at " + timestamp);
    }

    /** [UC13.2.3.3] Phản hồi xác nhận đã ghi log lỗi. → File: DMS.java */
    public void returnLogConfirmed() {
        System.out.println("DMS -->> UI: returnLogConfirmed()");
    }

    /**
     * [UC13.1.5] Tạo Signed URL tạm thời để tải xuống (expiry = 900 giây).
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() sau khi fetchFile() thành công
     * → Trả về: URL mô phỏng /download/signed?docId=...&token=temp_token
     * → File: DMS.java
     */
    public String generateSignedUrl(int documentId, int expiry) {
        // Giả lập tạo signed url
        return "/download/signed?docId=" + documentId + "&token=temp_token";
    }

    /** [UC13.1.5] Phản hồi Signed URL đã tạo. → File: DMS.java */
    public void returnSignedUrl(String url, String expiresAt) {
        System.out.println("DMS -->> UI: returnSignedUrl(" + url + ", " + expiresAt + ")");
    }

    /**
     * [UC13.1.8] Ghi audit log sự kiện tải xuống thành công.
     * → Gọi bởi: DownloadDocumentServlet.confirmSave() sau khi stream thành công
     * → Gọi nội bộ: documentDAO.incrementDownloadCount(documentId) → tăng download_count trong DB
     * → File: DMS.java
     */
    public void writeAuditLog(int documentId, Integer userId, String timestamp, String ipAddress) {
        // Tăng lượt tải xuống thành công trong hệ thống (như yêu cầu "mỗi lần tải load lại cập nhật lượt tải")
        documentDAO.incrementDownloadCount(documentId);  // [UC13.1.8 → DocumentDAO]
        System.out.println("DMS: Audit Log - User: " + userId + " downloaded DocID: " + documentId + " at " + timestamp + " from IP: " + ipAddress);
    }

    /** [UC13.1.8] Phản hồi xác nhận đã ghi audit log. → File: DMS.java */
    public void returnAuditConfirmed(String logId) {
        System.out.println("DMS -->> UI: returnAuditConfirmed(" + logId + ")");
    }
}
