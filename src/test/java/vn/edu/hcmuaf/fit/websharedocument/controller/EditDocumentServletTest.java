package vn.edu.hcmuaf.fit.websharedocument.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Lớp kiểm thử đơn vị cho EditDocumentServlet.
 * Sử dụng Mockito để giả lập môi trường Servlet (request, response, session, context)
 * và kiểm tra các ràng buộc validation cũng như phân quyền chỉnh sửa của UC15.
 */
public class EditDocumentServletTest {

    private EditDocumentServlet servlet;
    private DocumentDAO mockDocumentDAO;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;
    private ServletContext servletContext;
    private User testUser;

    @BeforeEach
    public void setUp() throws Exception {
        // Khởi tạo servlet và các đối tượng giả lập (mock)
        servlet = new EditDocumentServlet();
        mockDocumentDAO = mock(DocumentDAO.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
        servletContext = mock(ServletContext.class);

        // Inject mockDocumentDAO vào Servlet thông qua Reflection (vì biến documentDAO trong servlet là final)
        Field field = EditDocumentServlet.class.getDeclaredField("documentDAO");
        field.setAccessible(true);
        field.set(servlet, mockDocumentDAO);

        // Định nghĩa hành vi giả lập mặc định cho các đối tượng request/session
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/context");
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        // Giả lập người dùng đã đăng nhập thành công với ID = 1
        testUser = new User();
        testUser.setId(1);
        testUser.setUsername("testuser");
        when(session.getAttribute("authUser")).thenReturn(testUser);
    }

    /**
     * UC15.1.2 & UC15.2.1: Người dùng không có quyền chỉnh sửa tài liệu (Tài liệu thuộc sở hữu của người khác)
     * Mong đợi: Từ chối yêu cầu chỉnh sửa, hiển thị thông báo lỗi và chuyển hướng về trang cá nhân.
     */
    @Test
    public void testDoPost_PermissionDenied() throws Exception {
        // Giả lập request gửi lên documentId = 10
        when(request.getParameter("documentId")).thenReturn("10");

        // Giả lập tài liệu tồn tại nhưng thuộc về User khác (userId = 2)
        Document existingDoc = new Document();
        existingDoc.setId(10);
        existingDoc.setUserId(2); 
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(existingDoc);
        
        // Giả lập hàm kiểm tra quyền sở hữu trả về false
        when(mockDocumentDAO.isOwner(10, 1)).thenReturn(false);

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Xác minh thông báo lỗi được lưu vào session và chuyển hướng đúng về trang cá nhân
        verify(session).setAttribute("flashError", "Bạn không có quyền chỉnh sửa tài liệu này.");
        verify(response).sendRedirect("/context/profile");
    }

    /**
     * EX-03: Tài liệu bị xóa trong khi đang chỉnh sửa
     * Mong đợi: Từ chối yêu cầu, hiển thị thông báo "Tài liệu không còn tồn tại" và chuyển về danh sách.
     */
    @Test
    public void testDoPost_DocumentDeleted() throws Exception {
        // Giả lập request gửi lên documentId = 10
        when(request.getParameter("documentId")).thenReturn("10");
        
        // Giả lập tài liệu đã bị xóa khỏi hệ thống (hàm trả về null)
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(null);

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Xác minh thông báo lỗi và chuyển hướng về trang cá nhân
        verify(session).setAttribute("flashError", "Tài liệu không còn tồn tại.");
        verify(response).sendRedirect("/context/profile");
    }

    /**
     * UC15.2.2: Dữ liệu nhập không hợp lệ - Tiêu đề bị để trống
     * Mong đợi: Lưu thông báo lỗi tiêu đề trống và chuyển tiếp (forward) trở lại trang chỉnh sửa kèm highlight.
     */
    @Test
    public void testDoPost_ValidationFailed_EmptyTitle() throws Exception {
        // Giả lập tài liệu tồn tại và hợp lệ thuộc quyền sở hữu của người dùng hiện tại
        when(request.getParameter("documentId")).thenReturn("10");
        Document existingDoc = new Document();
        existingDoc.setId(10);
        existingDoc.setUserId(1);
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(existingDoc);
        when(mockDocumentDAO.isOwner(10, 1)).thenReturn(true);

        // Giả lập các tham số gửi lên từ form (tiêu đề bị bỏ trống)
        when(request.getParameter("title")).thenReturn(""); 
        when(request.getParameter("description")).thenReturn("Mô tả hợp lệ");
        when(request.getParameter("categoryId")).thenReturn("1");
        when(request.getParameter("privacy")).thenReturn("public");
        when(request.getParameter("tags")).thenReturn("toan, dai-so");

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Xác minh Servlet đã thiết lập thông báo lỗi và forward lại trang edit-document.jsp
        verify(request).setAttribute("titleError", "Tên tài liệu không được để trống.");
        verify(request).getRequestDispatcher("/page/user/edit-document.jsp");
        verify(dispatcher).forward(request, response);
    }

    /**
     * UC15.2.2: Dữ liệu nhập không hợp lệ - Tiêu đề vượt quá 255 ký tự
     * Mong đợi: Thiết lập lỗi giới hạn độ dài của tiêu đề và trả về trang chỉnh sửa.
     */
    @Test
    public void testDoPost_ValidationFailed_TitleTooLong() throws Exception {
        // Giả lập tài liệu hợp lệ và thuộc quyền sở hữu
        when(request.getParameter("documentId")).thenReturn("10");
        Document existingDoc = new Document();
        existingDoc.setId(10);
        existingDoc.setUserId(1);
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(existingDoc);
        when(mockDocumentDAO.isOwner(10, 1)).thenReturn(true);

        // Tạo tiêu đề dài 256 ký tự (vượt mức cho phép là 255)
        String longTitle = "a".repeat(256);
        when(request.getParameter("title")).thenReturn(longTitle);
        when(request.getParameter("description")).thenReturn("Mô tả hợp lệ");
        when(request.getParameter("categoryId")).thenReturn("1");
        when(request.getParameter("privacy")).thenReturn("public");
        when(request.getParameter("tags")).thenReturn("toan, dai-so");

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Xác minh thông báo lỗi giới hạn ký tự và quay lại trang form
        verify(request).setAttribute("titleError", "Tên tài liệu không được vượt quá 255 ký tự.");
        verify(request).getRequestDispatcher("/page/user/edit-document.jsp");
        verify(dispatcher).forward(request, response);
    }

    /**
     * UC15.2.2: Dữ liệu nhập không hợp lệ - Thẻ (tags) chứa các ký tự đặc biệt bị cấm
     * Mong đợi: Thiết lập lỗi định dạng thẻ và quay lại trang chỉnh sửa.
     */
    @Test
    public void testDoPost_ValidationFailed_InvalidTagCharacters() throws Exception {
        // Giả lập tài liệu hợp lệ và thuộc quyền sở hữu
        when(request.getParameter("documentId")).thenReturn("10");
        Document existingDoc = new Document();
        existingDoc.setId(10);
        existingDoc.setUserId(1);
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(existingDoc);
        when(mockDocumentDAO.isOwner(10, 1)).thenReturn(true);

        when(request.getParameter("title")).thenReturn("Tiêu đề hợp lệ");
        when(request.getParameter("description")).thenReturn("Mô tả hợp lệ");
        when(request.getParameter("categoryId")).thenReturn("1");
        when(request.getParameter("privacy")).thenReturn("public");
        
        // Thẻ chứa ký tự '#' và '@' là các ký tự không được phép
        when(request.getParameter("tags")).thenReturn("toan#, lap-trinh@");

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Xác minh lỗi định dạng thẻ và quay lại trang form
        verify(request).setAttribute("tagsError", "Thẻ chứa ký tự không hợp lệ. Chỉ cho phép chữ, số, khoảng trắng và dấu gạch ngang.");
        verify(request).getRequestDispatcher("/page/user/edit-document.jsp");
        verify(dispatcher).forward(request, response);
    }

    /**
     * UC15.1.9 & UC15.1.10: Chỉnh sửa thông tin tài liệu thành công (Không thay đổi file)
     * Mong đợi: Lưu thông tin cập nhật vào CSDL, hiển thị thông báo thành công và chuyển hướng về trang cá nhân.
     */
    @Test
    public void testDoPost_Success() throws Exception {
        // Giả lập tài liệu hợp lệ và thuộc quyền sở hữu
        when(request.getParameter("documentId")).thenReturn("10");
        
        // Dữ liệu tài liệu hiện tại trong DB
        Document existingDoc = new Document();
        existingDoc.setId(10);
        existingDoc.setUserId(1);
        existingDoc.setIsActive(1);
        existingDoc.setFilePath("tailieu.pdf");
        existingDoc.setFileName("tailieu.pdf");
        existingDoc.setFileType("application/pdf");
        existingDoc.setFileExtension("pdf");
        existingDoc.setFileSize(512L);
        
        when(mockDocumentDAO.getDocumentByIdForEdit(10)).thenReturn(existingDoc);
        when(mockDocumentDAO.isOwner(10, 1)).thenReturn(true);

        // Giả lập thông tin chỉnh sửa mới hợp lệ từ form gửi lên
        when(request.getParameter("title")).thenReturn("Tiêu đề mới cập nhật");
        when(request.getParameter("description")).thenReturn("Mô tả mới cập nhật");
        when(request.getParameter("categoryId")).thenReturn("2");
        when(request.getParameter("privacy")).thenReturn("public");
        when(request.getParameter("tags")).thenReturn("toan, dai-so");

        // Giả lập cập nhật thông tin trong database thành công
        when(mockDocumentDAO.updateDocumentInfo(any(Document.class))).thenReturn(true);

        // Thực thi Servlet
        servlet.doPost(request, response);

        // Sử dụng ArgumentCaptor để bắt đối tượng Document được gửi xuống hàm updateDocumentInfo trong DAO
        ArgumentCaptor<Document> captor = ArgumentCaptor.forClass(Document.class);
        verify(mockDocumentDAO).updateDocumentInfo(captor.capture());
        Document updated = captor.getValue();

        // Xác minh các thông tin cập nhật trong đối tượng Document có trùng khớp với dữ liệu form đã nhập
        assertEquals("Tiêu đề mới cập nhật", updated.getTitle());
        assertEquals("Mô tả mới cập nhật", updated.getDescription());
        assertEquals(2, updated.getCategoryId());
        assertEquals(1, updated.getIsActive()); // privacy = "public" ánh xạ thành trạng thái isActive = 1
        assertEquals(List.of("toan", "dai-so"), updated.getTags());
        
        // Xác minh thông tin tệp cũ được giữ nguyên do người dùng không tải lên tệp thay thế mới
        assertEquals("tailieu.pdf", updated.getFilePath());
        assertEquals("tailieu.pdf", updated.getFileName());

        // Xác minh thông báo thành công được lưu vào session và chuyển hướng đúng về trang cá nhân
        verify(session).setAttribute("flashSuccess", "Cập nhật tài liệu thành công");
        verify(response).sendRedirect("/context/profile");
    }
}
