<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đăng ký - DocShare</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/register.css" rel="stylesheet"/>
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
      <h1 class="font-headline-sm text-headline-sm text-on-surface">Tạo tài khoản mới</h1>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="mb-4 text-center font-label-md text-label-md text-error-custom">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/register" method="post" id="registerForm" novalidate>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant" for="fullName">Họ và tên</label>
        <input
                id="fullName"
                name="fullName"
                type="text"
                class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container"
                placeholder="Nguyễn Văn A"
                required/>
      </div>

      <div class="space-y-unit" id="emailField">
        <label class="font-label-md text-label-md text-on-surface-variant" for="email">Email</label>
        <input
                id="email"
                name="email"
                type="email"
                class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container"
                placeholder="example@email.com"
                required/>
        <p class="error-message" id="emailError" style="display:none;">
          Email này đã được sử dụng. Vui lòng dùng email khác.
        </p>
        <% if ("email_existed".equals(request.getAttribute("errorType"))) { %>
        <script>
          document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('email').classList.add('error-border');
            document.getElementById('emailError').style.display = 'block';
          });
        </script>
        <% } %>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant" for="phone">Số điện thoại</label>
        <input
                id="phone"
                name="phone"
                type="tel"
                class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container"
                pattern="0[3789][0-9]{8}"
                placeholder="0901234567"
                required/>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant" for="password">Mật khẩu</label>
        <div class="relative">
          <input
                  id="password"
                  name="password"
                  type="password"
                  class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] pr-12 outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container"
                  minlength="8"
                  placeholder="Tối thiểu 8 ký tự"
                  required/>
          <button
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-outline"
                  type="button"
                  aria-label="Hiện/ẩn mật khẩu"
                  onclick="togglePassword('password', this)">
            <span class="material-symbols-outlined text-[20px]">visibility</span>
          </button>
        </div>
        <p class="error-message" id="passwordError" style="display:none;">
          Mật khẩu phải có ít nhất 8 ký tự.
        </p>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant" for="confirmPassword">Nhập lại mật khẩu</label>
        <input
                id="confirmPassword"
                name="confirmPassword"
                type="password"
                class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container"
                placeholder="Nhập lại mật khẩu"
                required/>
        <p class="error-message" id="confirmPasswordError" style="display:none;">
          Mật khẩu nhập lại không khớp.
        </p>
      </div>

      <button
              class="mt-stack-md w-full rounded-lg bg-primary-container py-[10px] font-label-md text-label-md text-on-primary transition-all active:scale-[0.98]"
              type="submit">
        Tạo tài khoản
      </button>
    </form>

    <div class="mt-stack-lg border-t border-outline-variant pt-stack-md text-center">
      <a class="font-label-md text-label-md text-primary-container underline-offset-4 hover:underline decoration-primary-container"
         href="${pageContext.request.contextPath}/login">
        Đã có tài khoản? Đăng nhập
      </a>
    </div>

  </section>
</main>

<% if (request.getAttribute("success") != null) { %>
<div class="fixed bottom-8 left-1/2 z-50 -translate-x-1/2" id="successToast">
  <div class="flex items-center gap-3 rounded-xl bg-on-background px-6 py-3 shadow-lg">
    <span class="material-symbols-outlined material-symbols-filled text-green-500">check_circle</span>
    <span class="font-label-md text-label-md text-white">Đăng ký thành công!</span>
  </div>
</div>
<script>
  setTimeout(function () {
    var toast = document.getElementById('successToast');
    if (toast) toast.style.display = 'none';
  }, 4000);
</script>
<% } %>

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

<script src="${pageContext.request.contextPath}/js/register.js"></script>
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

  document.getElementById('registerForm').addEventListener('submit', function (e) {
    var valid = true;

    var password = document.getElementById('password');
    var confirmPassword = document.getElementById('confirmPassword');
    var passwordError = document.getElementById('passwordError');
    var confirmPasswordError = document.getElementById('confirmPasswordError');

    password.classList.remove('error-border');
    confirmPassword.classList.remove('error-border');
    passwordError.style.display = 'none';
    confirmPasswordError.style.display = 'none';

    if (password.value.length > 0 && password.value.length < 8) {
      password.classList.add('error-border');
      passwordError.style.display = 'block';
      valid = false;
    }

    if (confirmPassword.value && password.value !== confirmPassword.value) {
      confirmPassword.classList.add('error-border');
      confirmPasswordError.style.display = 'block';
      valid = false;
    }

    if (!valid) e.preventDefault();
  });
</script>
</body>
</html>
