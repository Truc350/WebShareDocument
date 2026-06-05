package vn.edu.hcmuaf.fit.websharedocument.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedConstruction;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import vn.edu.hcmuaf.fit.websharedocument.dao.DocumentDAO;
import vn.edu.hcmuaf.fit.websharedocument.model.Document;
import vn.edu.hcmuaf.fit.websharedocument.model.User;

import static org.mockito.Mockito.*;

class UpdateDocumentStatusServletTest {

    private UpdateDocumentStatusServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    private AutoCloseable closeable;

    @BeforeEach
    void setUp() {
        closeable = MockitoAnnotations.openMocks(this);
        servlet = new UpdateDocumentStatusServlet();
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/context");
    }

    @AfterEach
    void tearDown() throws Exception {
        closeable.close();
    }

    @Test
    void testDoGet_NotLoggedIn() throws Exception {
        when(session.getAttribute("authUser")).thenReturn(null);

        servlet.doGet(request, response);

        verify(response).sendRedirect("/context/login");
    }

    @Test
    void testDoGet_NotAdmin() throws Exception {
        User user = new User();
        user.setRole("user");
        when(session.getAttribute("authUser")).thenReturn(user);

        servlet.doGet(request, response);

        verify(response).sendRedirect("/context/login");
    }

    @Test
    void testDoGet_ApproveDocument() throws Exception {
        User admin = new User();
        admin.setId(1);
        admin.setRole("admin");

        when(session.getAttribute("authUser")).thenReturn(admin);
        when(request.getParameter("id")).thenReturn("10");
        when(request.getParameter("status")).thenReturn("1");
        when(request.getRemoteAddr()).thenReturn("127.0.0.1");

        try (MockedConstruction<DocumentDAO> mocked = Mockito.mockConstruction(DocumentDAO.class,
                (mock, context) -> {
                    when(mock.updateDocumentStatus(10, 1)).thenReturn(true);
                })) {

            servlet.doGet(request, response);

            DocumentDAO mockDao = mocked.constructed().get(0);
            verify(mockDao).updateDocumentStatus(10, 1);
            verify(mockDao).logActivity(1, "APPROVE_DOCUMENT", "document", 10, "Admin duyệt tài liệu", "127.0.0.1");
            verify(session).setAttribute("message", "Thao tác thành công!");
            verify(response).sendRedirect("/context/admin/management-doc");
        }
    }
    
    @Test
    void testDoGet_MarkViolationDocument() throws Exception {
        User admin = new User();
        admin.setId(1);
        admin.setRole("admin");

        when(session.getAttribute("authUser")).thenReturn(admin);
        when(request.getParameter("id")).thenReturn("15");
        when(request.getParameter("status")).thenReturn("2");
        when(request.getRemoteAddr()).thenReturn("127.0.0.1");

        try (MockedConstruction<DocumentDAO> mocked = Mockito.mockConstruction(DocumentDAO.class,
                (mock, context) -> {
                    when(mock.updateDocumentStatus(15, 2)).thenReturn(true);
                })) {

            servlet.doGet(request, response);

            DocumentDAO mockDao = mocked.constructed().get(0);
            verify(mockDao).updateDocumentStatus(15, 2);
            verify(mockDao).logActivity(1, "MARK_VIOLATION", "document", 15, "Admin đánh dấu tài liệu vi phạm", "127.0.0.1");
            verify(session).setAttribute("message", "Thao tác thành công!");
            verify(response).sendRedirect("/context/admin/management-doc");
        }
    }

    @Test
    void testDoGet_DeletePermanently() throws Exception {
        User admin = new User();
        admin.setId(1);
        admin.setRole("admin");

        when(session.getAttribute("authUser")).thenReturn(admin);
        when(request.getParameter("id")).thenReturn("20");
        when(request.getParameter("status")).thenReturn("3");
        when(request.getRemoteAddr()).thenReturn("127.0.0.1");

        Document doc = new Document();
        // Giả lập đường dẫn file Supabase
        doc.setFilePath("https://tlbznphszzpondlykmst.supabase.co/storage/v1/object/public/documents/test-file.pdf");

        try (MockedConstruction<DocumentDAO> mocked = Mockito.mockConstruction(DocumentDAO.class,
                (mock, context) -> {
                    when(mock.getDocumentByIdForEdit(20)).thenReturn(doc);
                    when(mock.deleteDocumentByAdmin(20)).thenReturn(true);
                })) {

            servlet.doGet(request, response);

            DocumentDAO mockDao = mocked.constructed().get(0);
            verify(mockDao).getDocumentByIdForEdit(20);
            verify(mockDao).deleteDocumentByAdmin(20);
            verify(mockDao).logActivity(1, "DELETE_PERMANENTLY", "document", 20, "Admin xóa vĩnh viễn tài liệu do vẫn vi phạm", "127.0.0.1");
            verify(session).setAttribute("message", "Xóa tài liệu vi phạm vĩnh viễn thành công!");
            verify(response).sendRedirect("/context/admin/management-doc");
        }
    }
}
