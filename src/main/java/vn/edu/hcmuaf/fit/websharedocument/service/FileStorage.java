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

    // UC13.1.4 fetchFile(documentId)
    public FileData fetchFile(int documentId) throws FileNotFoundException {
        Document document = documentDAO.getDocumentById(documentId);
        
        if (document == null) {
            throw new FileNotFoundException("Document DB record not found");
        }

        String path = document.getFilePath();
        try {
            if (path != null && path.startsWith("http")) {
                // Tệp lưu trên Cloudinary hoặc Server ngoài
                URL url = new URL(path);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.connect();
                if (conn.getResponseCode() != 200) {
                    throw new FileNotFoundException("Remote file not accessible: " + conn.getResponseCode());
                }
                long size = conn.getContentLengthLong();
                if (size < 0) size = document.getFileSize(); // Fallback to DB size
                
                return new FileData(document.getFileName(), size, conn.getInputStream(), true, path);
            } else {
                // Tệp lưu cục bộ
                File file = new File(uploadDir, path);
                if (!file.exists()) {
                    throw new FileNotFoundException("Physical file not found in storage");
                }
                return new FileData(document.getFileName(), file.length(), new FileInputStream(file), false, null);
            }
        } catch (Exception e) {
            throw new FileNotFoundException("Error fetching file: " + e.getMessage());
        }
    }

    // UC13.2.2.1 throwFileNotFoundError(documentId)
    public void throwFileNotFoundError(int documentId) {
        System.out.println("Storage -->> UI: throwFileNotFoundError(" + documentId + ")");
    }

    public void returnFileData(String fileName, long fileSize) {
        System.out.println("Storage -->> UI: returnFileData(" + fileName + ", " + fileSize + ")");
    }
}
