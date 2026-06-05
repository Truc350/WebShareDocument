package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.io.ByteArrayInputStream;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class UploadDocumentServletTest {

    private UploadDocumentServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private ServletContext servletContext;

    @BeforeEach
    public void setUp() throws Exception {
        servlet = new UploadDocumentServlet();
        request = Mockito.mock(HttpServletRequest.class);
        response = Mockito.mock(HttpServletResponse.class);
        session = Mockito.mock(HttpSession.class);
        servletContext = Mockito.mock(ServletContext.class);

        jakarta.servlet.ServletConfig config = Mockito.mock(jakarta.servlet.ServletConfig.class);
        Mockito.when(config.getServletContext()).thenReturn(servletContext);
        servlet.init(config);

        // Giả lập Servlet Context (Nơi lưu file)
        Mockito.when(request.getServletContext()).thenReturn(servletContext);
        Mockito.when(servletContext.getRealPath("/document/uploads")).thenReturn("C:/temp/uploads");
    }

    @Test
    public void testChunkedUpload_NotLastChunk_ReturnsChunkSuccess() throws Exception {
        // 1. CHUẨN BỊ DỮ LIỆU GIẢ (MOCK DATA)
        User mockUser = new User();
        mockUser.setId(1);
        Mockito.when(request.getSession()).thenReturn(session);
        Mockito.when(session.getAttribute("authUser")).thenReturn(mockUser);

        // Giả lập trình duyệt gửi lên Chunk số 0 trong tổng số 3 Chunk
        Mockito.when(request.getParameter("chunkIndex")).thenReturn("0");
        Mockito.when(request.getParameter("totalChunks")).thenReturn("3");
        Mockito.when(request.getParameter("fileId")).thenReturn("123456_test.pdf");
        Mockito.when(request.getParameter("fileName")).thenReturn("test.pdf");

        // Giả lập nội dung của file chunk
        Part mockPart = Mockito.mock(Part.class);
        Mockito.when(mockPart.getInputStream()).thenReturn(new ByteArrayInputStream("Nội dung file giả lập".getBytes()));
        Mockito.when(request.getPart("fileChunk")).thenReturn(mockPart);

        // Hứng kết quả trả về từ Servlet
        StringWriter stringWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(stringWriter);
        Mockito.when(response.getWriter()).thenReturn(printWriter);

        // 2. THỰC THI (Hành động gọi hàm doPost)
        servlet.doPost(request, response);

        // 3. KIỂM TRA KẾT QUẢ (ASSERT)
        printWriter.flush();
        String resultJson = stringWriter.toString();

        // Vì là chunk 0 (chưa phải cuối cùng), hệ thống phải trả về chunk_success
        assertTrue(resultJson.contains("\"status\":\"chunk_success\""), "Nên trả về trạng thái chunk_success cho mảnh file đầu tiên");
    }
}