<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String currentPath = request.getRequestURI();
  boolean isHomePage = currentPath.endsWith("/page/user/home.jsp") || currentPath.endsWith("/index.jsp") || currentPath.endsWith("/");
  boolean isDocumentsPage = currentPath.endsWith("/page/user/documents.jsp");
  boolean isCategoryPage = currentPath.endsWith("/page/user/category.jsp");
%>
<header class="site-header">
  <div class="container nav-wrap">
    <div class="header-left">
      <a class="brand" href="${pageContext.request.contextPath}/page/user/home.jsp">
        <span class="material-symbols-outlined">description</span>
        <strong>DocShare</strong>
      </a>

      <nav class="main-nav">
        <a class="<%= isHomePage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/user/home.jsp">Trang chủ</a>
        <a class="<%= isDocumentsPage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/user/documents.jsp">Tài liệu</a>
        <a class="<%= isCategoryPage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/user/category.jsp">Danh mục</a>
      </nav>
    </div>

    <form class="header-search" id="headerSearch">
      <span class="material-symbols-outlined">search</span>
      <input type="search" placeholder="Tìm kiếm tài liệu...">
      <button class="btn btn-primary" type="submit">Tìm</button>
    </form>

    <div class="auth-actions" style="display: flex; align-items: center; gap: 12px;">
      <%
        Object loggedInUser = session.getAttribute("authUser");
        if (loggedInUser == null) {
          loggedInUser = session.getAttribute("adminUser");
        }
      %>
      <% if (loggedInUser != null) { %>
        <a href="${pageContext.request.contextPath}/page/user/profile.jsp" title="Hồ sơ cá nhân" style="display: block; width: 40px; height: 40px; border-radius: 50%; overflow: hidden; border: 2px solid #e2e8f0; cursor: pointer; transition: border-color 0.2s;" onmouseover="this.style.borderColor='#0555dd'" onmouseout="this.style.borderColor='#e2e8f0'">
          <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDVzesd2P-nam4BHQFwKldg010YLy277-swKDEWeWhvvHtuI5j25aF2P4fkLabJVc1iMTSGhyxW9WodAis0iCWdjs9W7rAItUqEqxuxf825ZNf-rDNp1GN-YDXDXlOjEBL3mmMgCkIHg3-sRGGmJAdcFAyTKpfv9hl96dpMtuq9w4yZiOvvsVBcB7SKHsfnXG2azOAKmI5LcW_JcECELkseJrB5agN_pkmIIzCKJjTJO6MSAn0RW2H2PbbKF-A9_i7HoJX8sOtnKItv" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
        </a>
      <% } else { %>
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/register">Đăng ký</a>
      <% } %>
    </div>

    <button class="menu-toggle" type="button">
      <span class="material-symbols-outlined">menu</span>
    </button>
  </div>
</header>
