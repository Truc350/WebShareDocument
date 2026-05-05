<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đăng nhập - DocShare</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet"/>
</head>
<body class="flex min-h-screen flex-col bg-surface font-body-md text-on-surface">

<main class="flex flex-grow items-center justify-center bg-surface-container-low px-margin-mobile py-stack-lg md:px-margin-desktop">
  <section class="w-full max-w-[480px] rounded-xl border border-outline-variant bg-surface-container-lowest p-stack-lg shadow-[0_4px_12px_rgba(0,0,0,0.05)]">

    <%-- Logo + tiêu đề --%>
    <div class="mb-stack-lg flex flex-col items-center">
      <div class="mb-stack-sm flex items-center gap-2">
        <span class="material-symbols-outlined material-symbols-filled text-primary-container text-[32px]">menu_book</span>
        <span class="font-headline-md text-headline-md text-primary-container">DocShare</span>
      </div>
      <h1 class="font-headline-sm text-headline-sm text-on-surface" style="margin-top:4px;">Đăng nhập</h1>
    </div>

    <%-- Alert: sai email/mật khẩu --%>
    <% if ("invalid_credentials".equals(request.getAttribute("errorType"))) { %>
    <div class="alert-error">
      <span class="material-symbols-outlined icon">error</span>
      <span class="msg">Email hoặc mật khẩu không đúng</span>
    </div>
    <% } %>

    <%-- Alert: tài khoản bị khóa --%>
    <% if ("account_locked".equals(request.getAttribute("errorType"))) { %>
    <div class="alert-locked">
      <span class="material-symbols-outlined icon">lock</span>
      <span class="msg">Tài khoản tạm thời bị khoá. Vui lòng thử lại sau 15 phút.</span>
    </div>
    <% } %>

    <%-- Alert lỗi chung --%>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert-error">
      <span class="material-symbols-outlined icon">error</span>
      <span class="msg"><%= request.getAttribute("error") %></span>
    </div>
    <% } %>

    <%-- Form --%>
    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/login" method="post" id="loginForm">

      <%-- Email --%>
      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant" for="email">Email</label>
        <div class="input-wrap">
          <input id="email" name="email" type="email" placeholder="Email của bạn" required autocomplete="email"/>
        </div>
      </div>

      <%-- Mật khẩu --%>
      <div class="space-y-unit">
        <div class="flex items-center justify-between">
          <label class="font-label-md text-label-md text-on-surface-variant" for="password">Mật khẩu</label>
          <a class="forgot-link" href="#">Quên mật khẩu?</a>
        </div>
        <div class="input-wrap">
          <input id="password" name="password" type="password" placeholder="Mật khẩu" minlength="8" required autocomplete="current-password"/>
          <button class="pw-toggle" type="button" onclick="togglePassword('password', this)" aria-label="Hiện/ẩn mật khẩu">
            <span class="material-symbols-outlined text-[20px]">visibility</span>
          </button>
        </div>
      </div>

      <%-- Submit --%>
      <button class="mt-stack-md w-full rounded-lg bg-primary-container py-[10px] font-label-md text-label-md text-on-primary transition-all active:scale-[0.98]" type="submit">
        Đăng nhập
      </button>
    </form>

    <%-- Link đăng ký --%>
    <div class="mt-stack-lg pt-stack-md text-center bottom-link">
      Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
    </div>

  </section>
</main>

<footer class="mx-auto flex w-full max-w-[1280px] flex-col items-center justify-between border-t border-slate-100 px-6 py-8 md:flex-row">
  <div class="mb-4 md:mb-0">
    <span class="text-sm font-bold text-slate-900">DocShare</span>
    <span class="ml-2 text-xs text-slate-500">© 2024 DocShare Inc. All rights reserved.</span>
  </div>
  <div class="flex gap-6">
    <a class="text-xs text-slate-500 transition-opacity hover:text-slate-800" href="#">Privacy Policy</a>
    <a class="text-xs text-slate-500 transition-opacity hover:text-slate-800" href="#">Terms of Service</a>
    <a class="text-xs text-slate-500 transition-opacity hover:text-slate-800" href="#">Security</a>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
<script>
  function togglePassword(inputId, btn) {
    var input = document.getElementById(inputId);
    var icon = btn.querySelector('.material-symbols-outlined');
    if (input.type === 'password') {
      input.type = 'text';
      icon.textContent = 'visibility_off';
    } else {
      input.type = 'password';
      icon.textContent = 'visibility';
    }
  }
</script>
</body>
</html>
