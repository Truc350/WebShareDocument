package vn.edu.hcmuaf.fit.websharedocument.service;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.HttpURLConnection;

public class FileStorage {

    private String uploadDir;
    private DocumentDAO documentDAO;

    public FileStorage(String uploadDir) {
        this.uploadDir = uploadDir;
        this.documentDAO = new DocumentDAO();
    }

    public static class FileData {
        private String fileName;
        private long fileSize;
        private InputStream inputStream;
        private boolean isRemote;
        private String remoteUrl;

        public FileData(String fileName, long fileSize, InputStream inputStream, boolean isRemote, String remoteUrl) {
            this.fileName = fileName;
            this.fileSize = fileSize;
            this.inputStream = inputStream;
            this.isRemote = isRemote;
            this.remoteUrl = remoteUrl;
        }

        public String getFileName() { return fileName; }
        public long getFileSize() { return fileSize; }
        public InputStream getInputStream() { return inputStream; }
        public boolean isRemote() { return isRemote; }
        public String getRemoteUrl() { return remoteUrl; }
    }

    public static class FileNotFoundException extends Exception {
        public FileNotFoundException(String message) {
            super(message);
        }
    }

    /**
     * [UC13.1.4] Lấy dữ liệu tệp theo documentId từ kho lưu trữ.
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() sau khi quyền hợp lệ
     * → Bước 1: documentDAO.getDocumentById(documentId) → lấy Document từ DB
     * → Bước 2a: filePath bắt đầu bằng "http" → Remote file (Supabase/Cloudinary) → HttpURLConnection
     * → Bước 2b: filePath cục bộ → new File(uploadDir, filePath) → FileInputStream
     * → throw FileNotFoundException → UC13.2.3 (tệp không tìm thấy)
     * → return FileData → tiếp tục UC13.1.5 (generateSignedUrl)
     * → File: FileStorage.java
     */
    public FileData fetchFile(int documentId) throws FileNotFoundException {
        Document document = documentDAO.getDocumentById(documentId);  // [UC13.1.4 → DocumentDAO]
        
        if (document == null) {
            throw new FileNotFoundException("Document DB record not found");  // [UC13.2.3.1]
        }

        String path = document.getFilePath();
        try {
            if (path != null && path.startsWith("http")) {
                // [UC13.1.4] Tệp lưu trên Remote (Supabase / Cloudinary)
                URL url = new URL(path);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.connect();
                if (conn.getResponseCode() != 200) {
                    throw new FileNotFoundException("Remote file not accessible: " + conn.getResponseCode());  // [UC13.2.3.1]
                }
                long size = conn.getContentLengthLong();
                if (size < 0) size = document.getFileSize(); // Fallback to DB size
                
                return new FileData(document.getFileName(), size, conn.getInputStream(), true, path);
            } else {
                // [UC13.1.4] Tệp lưu cục bộ trên disk
                File file = new File(uploadDir, path);
                if (!file.exists()) {
                    throw new FileNotFoundException("Physical file not found in storage");  // [UC13.2.3.1]
                }
                return new FileData(document.getFileName(), file.length(), new FileInputStream(file), false, null);
            }
        } catch (Exception e) {
            throw new FileNotFoundException("Error fetching file: " + e.getMessage());
        }
    }

    /**
     * [UC13.2.3.1] Log thông báo tệp không tìm thấy (gọi sau khi throw FileNotFoundException).
     * → Gọi bởi: DownloadDocumentServlet trong khối catch FileStorage.FileNotFoundException
     * → File: FileStorage.java
     */
    public void throwFileNotFoundError(int documentId) {
        System.out.println("Storage -->> UI: throwFileNotFoundError(" + documentId + ")");
    }

    /**
     * [UC13.1.4] Log xác nhận đã tìm thấy và trả về dữ liệu tệp.
     * → Gọi bởi: DownloadDocumentServlet sau khi fetchFile() thành công
     * → File: FileStorage.java
     */
    public void returnFileData(String fileName, long fileSize) {
        System.out.println("Storage -->> UI: returnFileData(" + fileName + ", " + fileSize + ")");
    }
}
