<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đăng nhập - DocShare</title>
  <script src="${pageContext.request.contextPath}/js/login.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet"/>
</head>
<body class="flex min-h-screen flex-col bg-surface font-body-md text-on-surface">
<main class="flex flex-grow items-center justify-center bg-surface-container-low px-margin-mobile py-stack-lg md:px-margin-desktop">
  <section class="w-full max-w-[480px] rounded-xl border border-outline-variant bg-surface-container-lowest p-stack-lg shadow-[0_4px_12px_rgba(0,0,0,0.05)]">
    <div class="mb-stack-lg flex flex-col items-center">
      <div class="mb-stack-sm flex items-center gap-2">
        <span class="material-symbols-outlined material-symbols-filled text-primary-container text-[32px]">menu_book</span>
        <span class="font-headline-md text-headline-md text-primary-container">DocShare</span>
      </div>
      <h1 class="font-headline-sm text-headline-sm text-on-surface">Đăng nhập tài khoản</h1>
      <p class="mt-2 text-center font-body-sm text-body-sm text-on-surface-variant">Truy cập kho tài liệu học tập và quản lý tài khoản của bạn.</p>
    </div>

    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/page/overview.jsp" method="post">
      <div class="space-y-unit">
        <label class="font-label-md text-label-md text-on-surface-variant">Email</label>
        <input class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" placeholder="example@email.com" required type="email"/>
      </div>

      <div class="space-y-unit">
        <div class="flex items-center justify-between">
          <label class="font-label-md text-label-md text-on-surface-variant">Mật khẩu</label>
          <a class="font-label-sm text-label-sm text-primary-container hover:underline" href="#">Quên mật khẩu?</a>
        </div>
        <div class="relative">
          <input class="w-full rounded-lg border border-outline-variant bg-white px-4 py-[10px] pr-12 outline-none transition-all focus:border-primary-container focus:ring-1 focus:ring-primary-container" minlength="8" placeholder="Nhập mật khẩu" required type="password"/>
          <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline" type="button">
            <span class="material-symbols-outlined text-[20px]">visibility</span>
          </button>
        </div>
      </div>

      <div class="flex items-center justify-between">
        <label class="flex cursor-pointer items-center gap-2">
          <input class="h-4 w-4 rounded border-outline-variant text-primary-container focus:ring-primary-container" type="checkbox"/>
          <span class="font-body-sm text-body-sm text-on-surface-variant">Ghi nhớ đăng nhập</span>
        </label>
      </div>

      <button class="mt-stack-md w-full rounded-lg bg-primary-container py-[10px] font-label-md text-label-md text-on-primary transition-all hover:bg-primary active:scale-[0.98]" type="submit">
        Đăng nhập
      </button>
    </form>

    <div class="mt-stack-lg border-t border-outline-variant pt-stack-md text-center">
      <a class="font-label-md text-label-md text-primary-container underline-offset-4 hover:underline decoration-primary-container" href="${pageContext.request.contextPath}/page/register.jsp">
        Chưa có tài khoản? Tạo tài khoản mới
      </a>
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
</body>
</html>
