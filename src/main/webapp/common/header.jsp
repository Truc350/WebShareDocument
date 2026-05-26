<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String currentPath = request.getRequestURI();
    boolean isHomePage = currentPath.endsWith("/home") || currentPath.endsWith("/index.jsp") || currentPath.endsWith("/");
    boolean isDocumentsPage = currentPath.endsWith("/page/user/documents.jsp");
    boolean isCategoryPage = currentPath.endsWith("/page/user/category.jsp");
    boolean isUploadPage = currentPath.endsWith("/page/user/upload.jsp") || currentPath.endsWith("/upload");
%>
<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    window.LOGGED_IN_USER_ID = '${sessionScope.authUser != null ? sessionScope.authUser.id : (sessionScope.adminUser != null ? sessionScope.adminUser.id : "")}';
</script>
<header class="site-header">
    <div class="container nav-wrap">
        <div class="header-left">
            <a class="brand" href="${pageContext.request.contextPath}/home">
                <span class="material-symbols-outlined">description</span>
                <strong>DocShare</strong>
            </a>
            <nav class="main-nav">
                <a class="<%= isHomePage ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a class="<%= isDocumentsPage ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/page/user/documents.jsp">Tài liệu</a>
                <a class="<%= isCategoryPage ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/page/user/category.jsp">Danh mục</a>
            </nav>
        </div>
        <form class="header-search" id="headerSearch" style="position: relative;">
            <span class="material-symbols-outlined">search</span>
            <input type="search" name="q" autocomplete="off" placeholder="Tìm kiếm tài liệu...">
            <button class="btn btn-primary" type="submit">Tìm</button>
            <div id="searchSuggestions" style="position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ccc; border-radius: 4px; display: none; z-index: 1000; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-top: 4px; max-height: 250px; overflow-y: auto;">
                <ul style="list-style: none; padding: 0; margin: 0;"></ul>
            </div>
        </form>
        <div class="auth-actions" style="display: flex; align-items: center; gap: 12px;">
            <%
                Object loggedInUser = session.getAttribute("authUser");
                if (loggedInUser == null) {
                    loggedInUser = session.getAttribute("adminUser");
                }
            %>
            <% if (loggedInUser != null) { %>
            <!-- UC5.1.1: Truy cập trang Đăng tải tài liệu -->
            <% if (!isUploadPage) { %>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/upload"
               style="padding: 8px 16px; font-size: 14px; display: flex; align-items: center; gap: 6px;">
                <span class="material-symbols-outlined" style="font-size: 20px;">publish</span>
                Đăng tải
            </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/profile" title="Hồ sơ cá nhân"
               style="display: block; width: 40px; height: 40px; border-radius: 50%; overflow: hidden; border: 2px solid #e2e8f0; cursor: pointer; transition: border-color 0.2s;"
               onmouseover="this.style.borderColor='#0555dd'" onmouseout="this.style.borderColor='#e2e8f0'">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDVzesd2P-nam4BHQFwKldg010YLy277-swKDEWeWhvvHtuI5j25aF2P4fkLabJVc1iMTSGhyxW9WodAis0iCWdjs9W7rAItUqEqxuxf825ZNf-rDNp1GN-YDXDXlOjEBL3mmMgCkIHg3-sRGGmJAdcFAyTKpfv9hl96dpMtuq9w4yZiOvvsVBcB7SKHsfnXG2azOAKmI5LcW_JcECELkseJrB5agN_pkmIIzCKJjTJO6MSAn0RW2H2PbbKF-A9_i7HoJX8sOtnKItv"
                     alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
            </a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/logout"
               style="color: #dc3545; padding: 0.5rem; display: flex; align-items: center; justify-content: center;"
               title="Đăng xuất">
                <span class="material-symbols-outlined">logout</span>
            </a>
            <% } else { %>
            <!-- UC5.1.1: Truy cập trang Đăng tải tài liệu (Guest) -->
            <% if (!isUploadPage) { %>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/upload" style="font-size: 14px;">Đăng
                tải</a>
            <% } %>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/register">Đăng ký</a>
            <% } %>
        </div>
        <button class="menu-toggle" type="button">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </div>
    <%-- Tối ưu hóa: Warm-up upload servlet ngay khi người dùng vào bất kỳ trang nào có header --%>
    <script>
        (function() {
            const upUrl = "${pageContext.request.contextPath}/upload";
            if (window.fetch) {
                fetch(upUrl, { method: 'HEAD' }).catch(() => {});
            }
        })();
    </script>
</header>
