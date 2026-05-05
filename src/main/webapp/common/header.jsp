<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String currentPath = request.getRequestURI();
  boolean isHomePage = currentPath.endsWith("/page/home.jsp") || currentPath.endsWith("/index.jsp") || currentPath.endsWith("/");
  boolean isDocumentsPage = currentPath.endsWith("/page/documents.jsp");
  boolean isCategoryPage = currentPath.endsWith("/page/category.jsp");
%>
<header class="site-header">
  <div class="container nav-wrap">
    <div class="header-left">
      <a class="brand" href="${pageContext.request.contextPath}/page/home.jsp">
        <span class="material-symbols-outlined">description</span>
        <strong>DocShare</strong>
      </a>

      <nav class="main-nav">
        <a class="<%= isHomePage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/home.jsp">Trang chủ</a>
        <a class="<%= isDocumentsPage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/documents.jsp">Tài liệu</a>
        <a class="<%= isCategoryPage ? "active" : "" %>" href="${pageContext.request.contextPath}/page/category-admin.jsp">Danh mục</a>
      </nav>
    </div>

    <form class="header-search" id="headerSearch">
      <span class="material-symbols-outlined">search</span>
      <input type="search" placeholder="Tìm kiếm tài liệu...">
      <button class="btn btn-primary" type="submit">Tìm</button>
    </form>

    <div class="auth-actions">
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/register">Đăng ký</a>
    </div>

    <button class="menu-toggle" type="button">
      <span class="material-symbols-outlined">menu</span>
    </button>
  </div>
</header>
