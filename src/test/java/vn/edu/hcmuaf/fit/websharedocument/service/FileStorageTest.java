package vn.edu.hcmuaf.fit.websharedocument.service;

import org.junit.jupiter.api.Test;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import static org.junit.jupiter.api.Assertions.*;

public class FileStorageTest {

    @Test
    public void testCheckFileSafety_WithSafePdf_ShouldNotThrowException() {
        FileStorage fileStorage = new FileStorage("dummyUploadDir");
        
        // Magic bytes for PDF: 0x25, 0x50, 0x44, 0x46 (which is "%PDF")
        byte[] pdfContent = new byte[]{0x25, 0x50, 0x44, 0x46, 0x01, 0x02, 0x03};
        InputStream inputStream = new ByteArrayInputStream(pdfContent);
        
        assertDoesNotThrow(() -> {
            fileStorage.checkFileSafety(inputStream, "document.pdf", "pdf");
        });
    }

    @Test
    public void testCheckFileSafety_WithDangerousExtension_ShouldThrowException() {
        FileStorage fileStorage = new FileStorage("dummyUploadDir");
        
        byte[] content = new byte[]{0x01, 0x02, 0x03, 0x04};
        InputStream inputStream = new ByteArrayInputStream(content);
        
        assertThrows(FileStorage.DangerousFileException.class, () -> {
            fileStorage.checkFileSafety(inputStream, "malicious.exe", "exe");
        });
    }

    @Test
    public void testCheckFileSafety_WithFakePdf_ShouldThrowException() {
        FileStorage fileStorage = new FileStorage("dummyUploadDir");
        
        // Extension is pdf but magic bytes are not PDF magic bytes
        byte[] content = new byte[]{0x01, 0x02, 0x03, 0x04}; 
        InputStream inputStream = new ByteArrayInputStream(content);
        
        assertThrows(FileStorage.DangerousFileException.class, () -> {
            fileStorage.checkFileSafety(inputStream, "fake.pdf", "pdf");
        });
    }
}
