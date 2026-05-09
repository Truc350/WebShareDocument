package vn.edu.hcmuaf.fit.websharedocument.service;

public class AuthService {

    // UC13.1.3 verifySessionAndPermission(userId, documentId)
    public boolean verifySessionAndPermission(Integer userId, int documentId) {
        if (userId == null) {
            return false;
        }
        // Giả lập logic kiểm tra quyền nâng cao, ở đây mặc định true nếu có userId
        return true; 
    }

    // UC13.2.1.1 detectPermissionDenied()
    public void detectPermissionDenied() {
        System.out.println("Auth -->> UI: detectPermissionDenied()");
    }

    public void returnPermissionGranted(Integer userId, int documentId) {
        System.out.println("Auth -->> UI: returnPermissionGranted(" + userId + ", " + documentId + ")");
    }
}
