package vn.edu.hcmuaf.fit.websharedocument.service;

import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.HttpURLConnection;
import java.util.Arrays;
import java.util.List;

public class FileStorage {

    private String uploadDir;
    private DocumentDAO documentDAO;

    // [EX-02] Danh sách magic bytes của các định dạng file hợp lệ
    // → Dùng để kiểm tra định dạng thực tế, không chỉ dựa vào extension
    private static final List<byte[]> ALLOWED_MAGIC_BYTES = Arrays.asList(
            new byte[]{0x25, 0x50, 0x44, 0x46},             // PDF: %PDF
            new byte[]{0x50, 0x4B, 0x03, 0x04},             // ZIP-based: DOCX, PPTX, XLSX
            new byte[]{(byte)0xD0, (byte)0xCF, 0x11, (byte)0xE0} // Legacy DOC/XLS/PPT (OLE2)
    );

    // [EX-02] Danh sách extension nguy hiểm bị chặn tuyệt đối
    private static final List<String> DANGEROUS_EXTENSIONS = Arrays.asList(
            "exe", "bat", "cmd", "sh", "ps1", "vbs", "js",
            "jar", "dll", "msi", "com", "scr", "php", "py"
    );

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
     * [EX-02] Exception ném ra khi file bị phát hiện là nguy hiểm.
     * → Gọi bởi: checkFileSafety() khi phát hiện magic bytes không hợp lệ
     *            hoặc extension nằm trong danh sách đen
     * → Bắt tại: DownloadDocumentServlet.clickDownload() → HTTP 403 + cảnh báo
     */
    public static class DangerousFileException extends Exception {
        public DangerousFileException(String message) {
            super(message);
        }
    }

    /**
     * [UC13.1.4] Lấy dữ liệu tệp theo documentId từ kho lưu trữ.
     * → Gọi bởi: DownloadDocumentServlet.clickDownload() sau khi quyền hợp lệ
     * → Bước 1: documentDAO.getDocumentById(documentId) → lấy Document từ DB
     * → Bước 2a: filePath bắt đầu bằng "http" → Remote file (Supabase/Cloudinary) → HttpURLConnection
     * → Bước 2b: filePath cục bộ → new File(uploadDir, filePath) → FileInputStream
     * → [UC13.1.4b] checkFileSafety() → phát hiện file nguy hiểm → throw DangerousFileException → EX-02
     * → throw FileNotFoundException → UC13.2.3 (tệp không tìm thấy)
     * → return FileData → tiếp tục UC13.1.5 (generateSignedUrl)
     */
    public FileData fetchFile(int documentId) throws FileNotFoundException, DangerousFileException {
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
                if (size < 0) size = document.getFileSize();

                InputStream inputStream = conn.getInputStream();
                java.io.BufferedInputStream bis = new java.io.BufferedInputStream(inputStream);
                bis.mark(1024);

                // ── [UC13.1.4b] Kiểm tra an toàn tệp ────────────────────
                checkFileSafety(bis, document.getFileName(), document.getFileExtension());

                bis.reset();

                return new FileData(document.getFileName(), size, bis, true, path);

            } else {
                // [UC13.1.4] Tệp lưu cục bộ trên disk
                File file = new File(uploadDir, path);
                if (!file.exists()) {
                    throw new FileNotFoundException("Physical file not found in storage");  // [UC13.2.3.1]
                }

                // ── [UC13.1.4b] Kiểm tra an toàn tệp ────────────────────
                try (InputStream checkStream = new FileInputStream(file)) {
                    checkFileSafety(checkStream, document.getFileName(), document.getFileExtension());
                }

                return new FileData(document.getFileName(), file.length(), new FileInputStream(file), false, null);
            }
        } catch (DangerousFileException e) {
            // Ném tiếp lên DownloadDocumentServlet để xử lý → EX-02
            throw e;
        } catch (Exception e) {
            throw new FileNotFoundException("Error fetching file: " + e.getMessage());
        }
    }

    // ====================================================================
    // [UC13.1.4b] KIỂM TRA AN TOÀN TỆP – EX-02
    // ====================================================================

    /**
     * [UC13.1.4b] Kiểm tra tính an toàn của tệp trước khi phục vụ tải xuống.
     *
     * Hai lớp kiểm tra:
     *   1. Kiểm tra extension: nếu nằm trong DANGEROUS_EXTENSIONS → từ chối ngay
     *   2. Kiểm tra magic bytes: đọc 4 byte đầu và so sánh với ALLOWED_MAGIC_BYTES
     *      → Phát hiện file nguy hiểm được đổi tên thành .pdf / .docx để qua mặt
     *
     * → Gọi bởi: fetchFile() ngay sau khi lấy được InputStream
     * → throw DangerousFileException → bắt tại DownloadDocumentServlet → EX-02
     */
    public void checkFileSafety(InputStream inputStream, String fileName, String fileExtension)
            throws DangerousFileException, java.io.IOException {

        // ── Lớp 1: Kiểm tra extension ──────────────────────────────────
        if (fileExtension != null && DANGEROUS_EXTENSIONS.contains(fileExtension.toLowerCase())) {
            throwDangerousFileDetected(fileName, "Nguy hiểm: extension bị chặn (" + fileExtension + ")");
            throw new DangerousFileException("Extension bị chặn: " + fileExtension);
        }

        // ── Lớp 2: Kiểm tra magic bytes ────────────────────────────────
        byte[] header = new byte[4];
        int bytesRead = inputStream.read(header, 0, 4);

        if (bytesRead < 4) {
            // File quá nhỏ hoặc rỗng → không hợp lệ
            throwDangerousFileDetected(fileName, "File quá nhỏ hoặc rỗng");
            throw new DangerousFileException("File không hợp lệ: kích thước quá nhỏ");
        }

        boolean isSafe = false;
        for (byte[] magic : ALLOWED_MAGIC_BYTES) {
            if (Arrays.equals(Arrays.copyOf(header, magic.length), magic)) {
                isSafe = true;
                break;
            }
        }

        if (!isSafe) {
            throwDangerousFileDetected(fileName, "Magic bytes không khớp với định dạng cho phép");
            throw new DangerousFileException("File nguy hiểm: nội dung không hợp lệ – " + fileName);
        }

        // [UC13.1.4b] Kiểm tra qua – file an toàn
        returnSafeFileConfirmed(fileName);
    }

    // ====================================================================
    // CÁC HÀM LOG – ánh xạ với các bước trong Sequence Diagram
    // ====================================================================

    /**
     * [UC13.2.3.1] Log thông báo tệp không tìm thấy.
     */
    public void throwFileNotFoundError(int documentId) {
        System.out.println("Storage -->> UI: throwFileNotFoundError(" + documentId + ")");
    }

    /**
     * [UC13.1.4] Log xác nhận đã tìm thấy và trả về dữ liệu tệp.
     */
    public void returnFileData(String fileName, long fileSize) {
        System.out.println("Storage -->> UI: returnFileData(" + fileName + ", " + fileSize + ")");
    }

    /**
     * [UC13.1.4b] Log phát hiện file nguy hiểm trước khi ném exception.
     * → Gọi bởi: checkFileSafety() khi phát hiện file không hợp lệ
     */
    public void throwDangerousFileDetected(String fileName, String reason) {
        System.out.println("Storage -->> UI: throwDangerousFileDetected(" + fileName + ") – " + reason);
    }

    /**
     * [UC13.1.4b] Log xác nhận file đã qua kiểm tra an toàn.
     * → Gọi bởi: checkFileSafety() khi magic bytes khớp với định dạng hợp lệ
     */
    public void returnSafeFileConfirmed(String fileName) {
        System.out.println("Storage -->> UI: returnSafeFileConfirmed(" + fileName + ") – File an toàn");
    }
}