package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import vn.edu.hcmuaf.fit.websharedocument.model.User;
import vn.edu.hcmuaf.fit.websharedocument.service.AuthService;
import vn.edu.hcmuaf.fit.websharedocument.service.DMS;
import vn.edu.hcmuaf.fit.websharedocument.service.FileStorage;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Lớp kiểm thử đơn vị cho DownloadDocumentServlet (UC-13: Tải tài liệu về thiết bị)
 * Sử dụng Mockito để giả lập Servlet environment và mock các Service phụ thuộc (AuthService, FileStorage, DMS).
 */
public class DownloadDocumentServletTest {

    private DownloadDocumentServlet servlet;
    private AuthService mockAuth;
    private FileStorage mockStorage;
    private DMS mockDms;

    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private ServletContext servletContext;

    private User testUser;
    private ByteArrayOutputStream responseOutputStream;

    @BeforeEach
    public void setUp() throws Exception {
        servlet = new DownloadDocumentServlet();
        mockAuth = mock(AuthService.class);
        mockStorage = mock(FileStorage.class);
        mockDms = mock(DMS.class);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        servletContext = mock(ServletContext.class);
        // Inject mock dependencies via Reflection
        setField(servlet, "auth", mockAuth);
        setField(servlet, "storage", mockStorage);
        setField(servlet, "dms", mockDms);
        // Set up servlet context mock for real/mock servlet behaviour if needed
        setField(servlet, "servletContext", servletContext);
        when(servletContext.getMimeType(anyString())).thenReturn("application/pdf");
        // Set up basic request mock behaviour
        when(request.getSession()).thenReturn(session);
        when(request.getRemoteAddr()).thenReturn("127.0.0.1");
        // Mock output stream for response
        responseOutputStream = new ByteArrayOutputStream();
        when(response.getOutputStream()).thenReturn(new jakarta.servlet.ServletOutputStream() {
            @Override
            public boolean isReady() { return true; }
            @Override
            public void setWriteListener(jakarta.servlet.WriteListener writeListener) {}
            @Override
            public void write(int b) throws IOException {
                responseOutputStream.write(b);
            }
        });
        // Set up default active user
        testUser = new User();
        testUser.setId(1);
        testUser.setUsername("testuser");
        when(session.getAttribute("authUser")).thenReturn(testUser);
    }
    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }
    /**
     * UC13.1.9: Luồng tải xuống thành công - Không đổi tên (Tên tệp gốc)
     * Mong đợi: Stream tệp tin thành công, đặt đúng headers, và ghi audit log.
     */
    @Test
    public void testDoGet_Success_OriginalName() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        when(request.getParameter("customName")).thenReturn(null);

        // Mock permission check (UC13.1.4)
        when(mockAuth.verifySessionAndPermission(1, 10)).thenReturn(true);

        // Mock FileStorage output
        byte[] dummyContent = "%PDF-dummy-content".getBytes();
        InputStream dummyInputStream = new ByteArrayInputStream(dummyContent);
        FileStorage.FileData fileData = new FileStorage.FileData("document.pdf", dummyContent.length, dummyInputStream, false, null);
        when(mockStorage.fetchFile(10)).thenReturn(fileData);

        // Mock DMS output (UC13.1.6)
        when(mockDms.generateSignedUrl(10, 900)).thenReturn("/signed/10");

        // Execute servlet
        servlet.doGet(request, response);

        // Verify headers set correctly (UC13.1.6)
        verify(response).setContentType("application/pdf");
        verify(response).setContentLength(dummyContent.length);
        verify(response).setHeader("Content-Disposition", "attachment; filename=\"document.pdf\"");

        // Verify the stream content is exactly written
        assertArrayEquals(dummyContent, responseOutputStream.toByteArray());

        // Verify Audit Log is written (UC13.1.9)
        verify(mockDms).writeAuditLog(eq(10), eq(1), anyString(), eq("127.0.0.1"));
    }

    /**
     * UC13.2.6: Đổi tên tệp lưu trữ tùy chỉnh (customName không kèm extension)
     * Mong đợi: Tự động trích và ghép đuôi tệp gốc (.pdf) vào tên tệp tùy chỉnh.
     */
    @Test
    public void testDoGet_Success_WithCustomNameWithoutExtension() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        // User inputs "Report2026"
        when(request.getParameter("customName")).thenReturn("Report2026");

        when(mockAuth.verifySessionAndPermission(1, 10)).thenReturn(true);

        byte[] dummyContent = "%PDF-dummy".getBytes();
        InputStream dummyInputStream = new ByteArrayInputStream(dummyContent);
        FileStorage.FileData fileData = new FileStorage.FileData("annual_report.pdf", dummyContent.length, dummyInputStream, false, null);
        when(mockStorage.fetchFile(10)).thenReturn(fileData);

        when(mockDms.generateSignedUrl(10, 900)).thenReturn("/signed/10");

        servlet.doGet(request, response);

        // Check if file header Content-Disposition has "Report2026.pdf" (UC13.2.6.5)
        verify(response).setHeader("Content-Disposition", "attachment; filename=\"Report2026.pdf\"");
        assertArrayEquals(dummyContent, responseOutputStream.toByteArray());
    }

    /**
     * UC13.2.6: Đổi tên tệp lưu trữ tùy chỉnh (customName có sẵn extension trùng khớp)
     * Mong đợi: Giữ nguyên tên tệp mới đã nhập và không lặp lại extension.
     */
    @Test
    public void testDoGet_Success_WithCustomNameIncludingExtension() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        // User inputs "Report2026.pdf"
        when(request.getParameter("customName")).thenReturn("Report2026.pdf");

        when(mockAuth.verifySessionAndPermission(1, 10)).thenReturn(true);

        byte[] dummyContent = "%PDF-dummy".getBytes();
        InputStream dummyInputStream = new ByteArrayInputStream(dummyContent);
        FileStorage.FileData fileData = new FileStorage.FileData("annual_report.pdf", dummyContent.length, dummyInputStream, false, null);
        when(mockStorage.fetchFile(10)).thenReturn(fileData);

        servlet.doGet(request, response);

        // Content-Disposition must be "Report2026.pdf"
        verify(response).setHeader("Content-Disposition", "attachment; filename=\"Report2026.pdf\"");
    }

    /**
     * UC13.2.2: Từ chối quyền tải tài liệu (User chưa đăng nhập hoặc không có quyền)
     * Mong đợi: Trả về lỗi HTTP 403 Forbidden.
     */
    @Test
    public void testDoGet_AccessDenied() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        when(session.getAttribute("authUser")).thenReturn(null); // No logged in user

        when(mockAuth.verifySessionAndPermission(null, 10)).thenReturn(false);

        servlet.doGet(request, response);

        // Verify response sent error 403 (UC13.2.2.2)
        verify(response).sendError(eq(403), contains("không có quyền"));
        // Ensure fetchFile and audit log are never called
        verify(mockStorage, never()).fetchFile(anyInt());
        verify(mockDms, never()).writeAuditLog(anyInt(), any(), any(), any());
    }

    /**
     * UC13.2.3: Tệp không tìm thấy trên kho lưu trữ
     * Mong đợi: Trả về HTTP 404 và ghi log lỗi vào DMS.
     */
    @Test
    public void testDoGet_FileNotFound() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        when(mockAuth.verifySessionAndPermission(1, 10)).thenReturn(true);

        // Throw FileNotFoundException when fetching
        when(mockStorage.fetchFile(10)).thenThrow(new FileStorage.FileNotFoundException("Physical file not found"));

        servlet.doGet(request, response);

        // Verify sent HTTP 404 (UC13.2.3.2)
        verify(response).sendError(eq(404), contains("không khả dụng"));

        // Verify DMS log error is recorded (UC13.2.3.3)
        verify(mockDms).writeErrorLog(eq(10), eq("404"), anyString());
    }

    /**
     * EX-02: Tệp bị chặn vì lý do bảo mật (DangerousFileException)
     * Mong đợi: Trả về HTTP 403 Forbidden và ghi nhận nhật ký bảo mật (writeSecurityLog).
     */
    @Test
    public void testDoGet_DangerousFileBlocked() throws Exception {
        when(request.getParameter("id")).thenReturn("10");
        when(mockAuth.verifySessionAndPermission(1, 10)).thenReturn(true);

        // Throw DangerousFileException when fetching (EX-02.1)
        when(mockStorage.fetchFile(10)).thenThrow(new FileStorage.DangerousFileException("Extension bị chặn: exe"));

        servlet.doGet(request, response);

        // Verify response sent HTTP 403 (EX-02.3)
        verify(response).sendError(eq(403), contains("nội dung không an toàn"));

        // Verify DMS logged the security threat (EX-02.2)
        verify(mockDms).writeSecurityLog(eq(10), eq(1), contains("Extension bị chặn"), anyString(), eq("127.0.0.1"));

        // Ensure audit log is not written
        verify(mockDms, never()).writeAuditLog(anyInt(), any(), any(), any());
    }
}
