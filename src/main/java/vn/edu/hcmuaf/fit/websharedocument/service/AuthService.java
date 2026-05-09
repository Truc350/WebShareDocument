package vn.edu.hcmuaf.fit.websharedocument.service;

public class AuthService {

    /**
     * [UC13.1.3] Xác minh phiên đăng nhập và quyền tải xuống của người dùng.
     * → Gọi bởi: DownloadDocumentServlet.clickDownload()
     * → userId = null nếu chưa đăng nhập (session không có authUser)
     * → return false → UC13.2.2 (permission denied)
     * → return true  → tiếp tục UC13.1.4 (fetchFile)
     * → File: AuthService.java
     */
    public boolean verifySessionAndPermission(Integer userId, int documentId) {
        if (userId == null) {
            return false;
        }
        // Giả lập logic kiểm tra quyền nâng cao, ở đây mặc định true nếu có userId
        return true; 
    }

    /**
     * [UC13.2.2.1] Phát hiện quyền bị từ chối (userId null hoặc không có quyền).
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() khi verifySessionAndPermission() = false
     * → File: AuthService.java
     */
    public void detectPermissionDenied() {
        System.out.println("Auth -->> UI: detectPermissionDenied()");
    }

    /**
     * [UC13.1.3] Xác nhận quyền hợp lệ, tiếp tục luồng bình thường.
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() khi verifySessionAndPermission() = true
     * → File: AuthService.java
     */
    public void returnPermissionGranted(Integer userId, int documentId) {
        System.out.println("Auth -->> UI: returnPermissionGranted(" + userId + ", " + documentId + ")");
    }
}
