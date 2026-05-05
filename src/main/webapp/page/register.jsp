<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đăng ký - DocShare</title>
  <script src="${pageContext.request.contextPath}/js/register.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/register.css" rel="stylesheet"/>
</head>
<body class="flex min-h-screen flex-col bg-surface font-body-md text-on-surface">
<main class="flex flex-grow items-center justify-center bg-surface-container-low px-margin-mobile py-stack-lg md:px-margin-desktop">
  <section class="w-full max-w-[480px] rounded-xl border border-outline-variant bg-surface-container-lowest p-stack-lg shadow-[0_4px_12px_rgba(0,0,0,0.05)]">
    <div class="mb-stack-lg flex flex-col items-center">
      <div class="mb-stack-sm flex items-center gap-2">
        <span class="material-symbols-outlined material-symbols-filled text-primary-container text-[32px]">menu_book</span>
        <span class="font-headline-md text-headline-md text-primary-container">DocShare</span>
      </div>
      <h1 class="font-headline-sm text-headline-sm text-on-surface">Tạo tài khoản mới</h1>
    </div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="mb-4 text-center font-label-md text-error-custom" style="color: red;">
        <%= request.getAttribute("error") %>
      </div>
    <% } %>

    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/register" method="post">
      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Họ và tên</label>
        <input name="fullName" class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" placeholder="Nguyễn Văn A" required type="text"/>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Email</label>
        <input name="email" class="error-border w-full rounded-lg border bg-white px-4 py-[10px] outline-none transition-all focus:ring-1 focus:ring-error-custom" placeholder="example@email.com" required type="email"/>
        <p class="error-message">Email này đã được sử dụng. Vui lòng dùng email khác.</p>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Số điện thoại</label>
        <input name="phone" class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" pattern="0[3|7|8|9][0-9]{8}" placeholder="0901234567" required type="tel"/>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Mật khẩu</label>
        <div class="relative">
          <input name="password" class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] pr-12 outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" minlength="8" placeholder="Tối thiểu 8 ký tự" required type="password"/>
          <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline" type="button">
            <span class="material-symbols-outlined text-[20px]">visibility</span>
          </button>
        </div>
      </div>

      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Nhập lại mật khẩu</label>
        <input name="confirmPassword" class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" placeholder="Nhập lại mật khẩu" required type="password"/>
      </div>

      <button class="mt-stack-md w-full rounded-lg bg-primary-container py-[10px] font-label-md text-label-md text-on-primary transition-all active:scale-[0.98]" type="submit">
        Tạo tài khoản
      </button>
    </form>

    <div class="mt-stack-lg border-t border-outline-variant pt-stack-md text-center">
      <a class="font-label-md text-label-md text-primary-container underline-offset-4 hover:underline decoration-primary-container" href="${pageContext.request.contextPath}/page/login.jsp">
        Đã có tài khoản? Đăng nhập
      </a>
    </div>
  </section>
</main>

<div class="fixed bottom-8 left-1/2 z-50 -translate-x-1/2">
  <div class="flex animate-bounce items-center gap-3 rounded-xl bg-on-background px-6 py-3 text-on-primary-fixed-variant shadow-lg">
    <span class="material-symbols-outlined material-symbols-filled text-green-500">check_circle</span>
    <span class="font-label-md text-label-md text-white">Đăng ký thành công!</span>
  </div>
</div>

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
</body>
</html>
