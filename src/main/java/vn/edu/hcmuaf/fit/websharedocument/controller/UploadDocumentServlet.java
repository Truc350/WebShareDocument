package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Set;

@WebServlet(name = "UploadDocumentServlet", value = "/upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 50L * 1024L * 1024L,
        maxRequestSize = 60L * 1024L * 1024L
)
public class UploadDocumentServlet extends HttpServlet {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt");
    private static final DateTimeFormatter FILE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String title = trim(request.getParameter("title"));
            String category = trim(request.getParameter("category"));
            String subject = trim(request.getParameter("subject"));
            Part filePart = request.getPart("documentFile");

            if (title.isEmpty() || category.isEmpty() || subject.isEmpty()) {
                forwardError(request, response, "Vui lòng nhập tiêu đề, danh mục và môn học.");
                return;
            }

            if (filePart == null || filePart.getSize() == 0) {
                forwardError(request, response, "Vui lòng chọn file tài liệu.");
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = getExtension(originalFileName);
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                forwardError(request, response, "Định dạng file không được hỗ trợ.");
                return;
            }

            Path uploadDir = resolveUploadDir();
            Files.createDirectories(uploadDir);

            String storedFileName = buildStoredFileName(originalFileName, extension);
            Path targetFile = uploadDir.resolve(storedFileName);
            Files.copy(filePart.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);

            request.setAttribute("successMessage", "Đăng tải tài liệu thành công.");
            request.setAttribute("uploadedFileName", originalFileName);
            request.setAttribute("storedFileName", storedFileName);
            request.setAttribute("uploadedFileSize", filePart.getSize());
            request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
        } catch (IllegalStateException ex) {
            forwardError(request, response, "File vượt quá dung lượng tối đa 50MB.");
        } catch (Exception ex) {
            forwardError(request, response, "Có lỗi khi lưu file. Vui lòng thử lại.");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/page/user/upload.jsp").forward(request, response);
    }

    private String getExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot < 0 || lastDot == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(lastDot + 1).toLowerCase(Locale.ROOT);
    }

    private String buildStoredFileName(String originalFileName, String extension) {
        String baseName = originalFileName.substring(0, originalFileName.length() - extension.length() - 1)
                .replaceAll("[^a-zA-Z0-9._-]", "_");
        String timestamp = LocalDateTime.now().format(FILE_TIME_FORMAT);
        return timestamp + "_" + baseName + "." + extension;
    }

    private Path resolveUploadDir() {
        String realPath = getServletContext().getRealPath("/document/uploads");
        if (realPath != null) {
            return Paths.get(realPath);
        }
        return Paths.get(System.getProperty("user.home"), "DocShareUploads");
    }
}
