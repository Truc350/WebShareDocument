package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet(name = "DeleteDocumentServlet", value = "/delete-document")
public class DeleteDocumentServlet extends HttpServlet {

    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (User) session.getAttribute("adminUser");
        }

        if (authUser == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập lại.\"}");
            return;
        }

        String documentIdRaw = request.getParameter("id");
        if (documentIdRaw == null || documentIdRaw.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID tài liệu không hợp lệ.\"}");
            return;
        }

        try {
            int documentId = Integer.parseInt(documentIdRaw);
            
            // Get document to check owner and file path
            Document doc = documentDAO.getDocumentByIdForEdit(documentId);
            
            if (doc == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Tài liệu không tồn tại.\"}");
                return;
            }
            
            if (doc.getUserId() != authUser.getId()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn không có quyền xóa tài liệu này.\"}");
                return;
            }

            // 1. Delete file from Supabase Storage
            boolean supabaseDeleted = true; // Assume success if no valid URL
            String fileUrl = doc.getFilePath();
            
            if (fileUrl != null && fileUrl.contains("/object/public/documents/")) {
                String objectPath = fileUrl.substring(fileUrl.indexOf("/object/public/documents/") + "/object/public/documents/".length());
                supabaseDeleted = deleteFileFromSupabase(objectPath);
            }

            // 2. Delete from Database
            boolean dbDeleted = documentDAO.deleteDocument(documentId, authUser.getId());

            if (dbDeleted) {
                response.getWriter().write("{\"success\": true, \"message\": \"Đã xóa tài liệu thành công.\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể xóa tài liệu trong CSDL.\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID tài liệu không hợp lệ.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Đã xảy ra lỗi máy chủ.\"}");
        }
    }

    private boolean deleteFileFromSupabase(String objectPath) {
        String supabaseUrl = "https://tlbznphszzpondlykmst.supabase.co";
        String supabaseKey = "sb_publishable_3IaZByYoSWSHakJqFMOifQ_ud2mNCpg";
        String bucketName = "documents";

        try {
            // URL to delete: https://[URL]/storage/v1/object/[BUCKET]/[PATH]
            URL url = new URL(supabaseUrl + "/storage/v1/object/" + bucketName + "/" + objectPath);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");
            conn.setRequestProperty("Authorization", "Bearer " + supabaseKey);
            conn.setRequestProperty("apikey", supabaseKey);

            int responseCode = conn.getResponseCode();
            
            // Consume response stream if needed
            if (responseCode >= 200 && responseCode < 300) {
                try (InputStream is = conn.getInputStream()) {
                    is.readAllBytes();
                }
                return true;
            } else {
                try (InputStream err = conn.getErrorStream()) {
                    if (err != null) err.readAllBytes();
                }
                System.err.println("Failed to delete from Supabase: HTTP " + responseCode);
                return false;
            }
        } catch (Exception e) {
            System.err.println("Exception while deleting from Supabase:");
            e.printStackTrace();
            return false;
        }
    }
}
