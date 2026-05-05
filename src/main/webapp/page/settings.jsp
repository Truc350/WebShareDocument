<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Cài đặt - DocAdmin</title>
  <script src="${pageContext.request.contextPath}/js/settings.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/settings.css" rel="stylesheet"/>
</head>
<body class="text-on-background">
<aside class="fixed left-0 top-0 z-50 flex h-screen w-[260px] flex-col border-r border-slate-200 bg-white py-4 font-['Be_Vietnam_Pro'] text-sm">
  <div class="mb-8 px-6">
    <h1 class="text-lg font-black text-blue-600">DocShare Admin</h1>
    <p class="text-xs text-slate-500">Management Suite</p>
  </div>
  <nav class="flex-1 space-y-1">
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/overview.jsp">
      <span class="material-symbols-outlined mr-3">dashboard</span>
      <span>Tổng quan</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/admin.jsp">
      <span class="material-symbols-outlined mr-3">description</span>
      <span>Quản lý Tài liệu</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/user.jsp">
      <span class="material-symbols-outlined mr-3">group</span>
      <span>Quản lý Người dùng</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/category.jsp">
      <span class="material-symbols-outlined mr-3">category</span>
      <span>Danh mục</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/statistics.jsp">
      <span class="material-symbols-outlined mr-3">leaderboard</span>
      <span>Thống kê</span>
    </a>
    <a class="flex items-center border-l-4 border-blue-600 bg-[#0555dd] px-6 py-3 font-semibold text-white transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/settings.jsp">
      <span class="material-symbols-outlined mr-3 text-white">settings</span>
      <span>Cài đặt</span>
    </a>
  </nav>
  <div class="mb-4 mt-auto border-t border-slate-100 px-6 pt-4">
    <div class="flex items-center space-x-3">
      <span class="material-symbols-outlined text-slate-400">account_circle</span>
      <span class="truncate font-medium text-slate-700">Huỳnh Thị Thanh Trúc</span>
    </div>
  </div>
</aside>

<main class="ml-[260px] min-h-screen">
  <header class="sticky top-0 z-40 flex h-16 w-full items-center justify-between border-b border-slate-200 bg-white/90 px-8 shadow-sm backdrop-blur-md">
    <div class="flex flex-col">
      <h2 class="font-h1 text-h1 text-on-background">Cài đặt</h2>
      <p class="text-caption text-slate-500">Quản lý thông tin cá nhân và cấu hình hệ thống</p>
    </div>
    <div class="flex items-center gap-4">
      <button class="relative rounded-full p-2 text-slate-600 transition-colors hover:bg-slate-100" type="button">
        <span class="material-symbols-outlined">notifications</span>
        <span class="absolute right-2 top-2 h-2 w-2 rounded-full border-2 border-white bg-error"></span>
      </button>
      <div class="mx-1 h-8 w-px bg-slate-200"></div>
      <div class="flex cursor-pointer items-center gap-3 rounded-full p-1 pr-3 transition-all hover:bg-slate-50">
        <div class="flex h-8 w-8 items-center justify-center rounded-full border border-slate-200 bg-blue-100 text-primary">
          <span class="material-symbols-outlined text-[20px]">account_circle</span>
        </div>
        <span class="text-sm font-semibold text-slate-700">Admin_User</span>
      </div>
    </div>
  </header>

  <div class="mx-auto max-w-6xl space-y-8 p-8">
    <div class="flex gap-8 overflow-x-auto border-b border-slate-200">
      <button class="tab-active flex items-center gap-2 whitespace-nowrap pb-4 text-sm font-semibold" type="button">
        <span class="material-symbols-outlined text-[20px]">person</span>
        Hồ sơ cá nhân
      </button>
      <button class="flex items-center gap-2 whitespace-nowrap pb-4 text-sm font-medium text-slate-500 hover:text-blue-600" type="button">
        <span class="material-symbols-outlined text-[20px]">settings_applications</span>
        Cấu hình hệ thống
      </button>
      <button class="flex items-center gap-2 whitespace-nowrap pb-4 text-sm font-medium text-slate-500 hover:text-blue-600" type="button">
        <span class="material-symbols-outlined text-[20px]">notifications_active</span>
        Thông báo
      </button>
      <button class="flex items-center gap-2 whitespace-nowrap pb-4 text-sm font-medium text-slate-500 hover:text-blue-600" type="button">
        <span class="material-symbols-outlined text-[20px]">verified_user</span>
        Bảo mật
      </button>
    </div>

    <div class="grid grid-cols-12 gap-6">
      <section class="col-span-12 rounded-xl border border-slate-200 bg-white p-8 shadow-sm lg:col-span-8">
        <div class="mb-8 flex items-center justify-between">
          <h3 class="font-h2 text-h2 text-on-background">Hồ sơ cá nhân</h3>
          <span class="text-caption text-slate-400">Cập nhật lần cuối: 2 giờ trước</span>
        </div>
        <div class="flex flex-col gap-10 md:flex-row">
          <div class="flex flex-col items-center gap-4">
            <div class="group relative">
              <div class="flex h-32 w-32 items-center justify-center rounded-2xl bg-blue-50 text-primary shadow-md ring-4 ring-blue-50">
                <span class="material-symbols-outlined text-[88px]">account_circle</span>
              </div>
              <button class="absolute -bottom-2 -right-2 rounded-lg bg-primary p-2 text-white shadow-lg transition-all hover:bg-primary-container" type="button">
                <span class="material-symbols-outlined text-[18px]">edit</span>
              </button>
            </div>
            <p class="max-w-[140px] text-center text-caption text-slate-500">Dung lượng tối đa 2MB. Định dạng: JPG, PNG.</p>
          </div>
          <div class="grid flex-1 grid-cols-1 gap-6 md:grid-cols-2">
            <div class="space-y-2">
              <label class="font-label-md text-label-md text-on-surface-variant">Họ và tên</label>
              <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 text-body-md transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" type="text" value="Nguyễn Văn Admin"/>
            </div>
            <div class="space-y-2">
              <label class="font-label-md text-label-md text-on-surface-variant">Email</label>
              <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 text-body-md transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" type="email" value="admin@docshare.edu.vn"/>
            </div>
            <div class="space-y-2">
              <label class="font-label-md text-label-md text-on-surface-variant">MSSV</label>
              <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 text-body-md transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" type="text" value="ADMIN_2024"/>
            </div>
            <div class="space-y-2">
              <label class="font-label-md text-label-md text-on-surface-variant">Số điện thoại</label>
              <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 text-body-md transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" type="text" value="0987 654 321"/>
            </div>
            <div class="pt-4 md:col-span-2">
              <button class="flex items-center justify-center gap-2 rounded-xl bg-primary-container px-8 py-3 text-sm font-bold text-white shadow-md transition-all hover:bg-primary active:scale-95" type="button">
                <span class="material-symbols-outlined text-[18px]">save</span>
                Lưu thay đổi
              </button>
            </div>
          </div>
        </div>
      </section>

      <section class="col-span-12 rounded-xl border border-slate-200 bg-white p-8 shadow-sm lg:col-span-4">
        <h3 class="mb-6 font-h2 text-h2 text-on-background">Thông báo</h3>
        <div class="space-y-6">
          <p class="text-body-md text-slate-500">Nhận thông báo qua Email khi có các sự kiện sau:</p>
          <div class="space-y-4">
            <label class="flex cursor-pointer items-center gap-3 rounded-xl bg-slate-50 p-4 transition-colors hover:bg-blue-50"><input checked class="h-5 w-5 rounded border-slate-300 text-primary focus:ring-primary" type="checkbox"/><span class="text-body-md font-medium text-slate-700">Tài liệu mới</span></label>
            <label class="flex cursor-pointer items-center gap-3 rounded-xl bg-slate-50 p-4 transition-colors hover:bg-blue-50"><input checked class="h-5 w-5 rounded border-slate-300 text-primary focus:ring-primary" type="checkbox"/><span class="text-body-md font-medium text-slate-700">Người dùng mới</span></label>
            <label class="flex cursor-pointer items-center gap-3 rounded-xl bg-slate-50 p-4 transition-colors hover:bg-blue-50"><input class="h-5 w-5 rounded border-slate-300 text-primary focus:ring-primary" type="checkbox"/><span class="text-body-md font-medium text-slate-700">Báo cáo vi phạm</span></label>
          </div>
        </div>
      </section>

      <section class="col-span-12 rounded-xl border border-slate-200 bg-white p-8 shadow-sm lg:col-span-7">
        <h3 class="mb-6 font-h2 text-h2 text-on-background">Cấu hình hệ thống</h3>
        <div class="grid grid-cols-1 gap-8 md:grid-cols-2">
          <div class="space-y-6">
            <div class="flex items-center justify-between gap-4">
              <div class="flex flex-col"><span class="text-body-md font-semibold text-slate-700">Cho phép đăng ký mới</span><span class="text-caption text-slate-500">Mở cổng đăng ký cho người dùng</span></div>
              <label class="relative inline-flex cursor-pointer items-center"><input checked class="peer sr-only" type="checkbox"/><div class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none"></div></label>
            </div>
            <div class="flex items-center justify-between gap-4">
              <div class="flex flex-col"><span class="text-body-md font-semibold text-slate-700">Duyệt tài liệu tự động</span><span class="text-caption text-slate-500">Sử dụng AI để kiểm tra sơ bộ</span></div>
              <label class="relative inline-flex cursor-pointer items-center"><input class="peer sr-only" type="checkbox"/><div class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none"></div></label>
            </div>
            <div class="flex items-center justify-between gap-4">
              <div class="flex flex-col"><span class="text-body-md font-semibold text-slate-700">Bảo trì hệ thống</span><span class="text-caption text-slate-500">Tạm dừng mọi hoạt động hệ thống</span></div>
              <label class="relative inline-flex cursor-pointer items-center"><input class="peer sr-only" type="checkbox"/><div class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none"></div></label>
            </div>
          </div>
          <div class="space-y-4 rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-6">
            <label class="font-label-md text-label-md text-slate-700">Dung lượng tối đa mỗi tệp (MB)</label>
            <div class="relative">
              <input class="w-full rounded-xl border-slate-200 bg-white py-3 pl-4 pr-12 text-body-md transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" type="number" value="25"/>
              <span class="absolute right-4 top-1/2 -translate-y-1/2 text-sm font-bold text-slate-400">MB</span>
            </div>
            <p class="text-caption italic text-slate-400">Khuyến nghị tối đa 50MB để đảm bảo hiệu suất truyền tải.</p>
          </div>
        </div>
      </section>

      <section class="col-span-12 rounded-xl border border-slate-200 bg-white p-8 shadow-sm lg:col-span-5">
        <h3 class="mb-6 font-h2 text-h2 text-on-background">Bảo mật</h3>
        <form class="space-y-4">
          <div class="space-y-2">
            <label class="font-label-sm text-label-sm text-slate-600">Mật khẩu hiện tại</label>
            <div class="relative">
              <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" placeholder="••••••••" type="password"/>
              <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 cursor-pointer text-slate-400">visibility</span>
            </div>
          </div>
          <div class="space-y-2">
            <label class="font-label-sm text-label-sm text-slate-600">Mật khẩu mới</label>
            <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" placeholder="••••••••" type="password"/>
          </div>
          <div class="space-y-2">
            <label class="font-label-sm text-label-sm text-slate-600">Xác nhận mật khẩu mới</label>
            <input class="w-full rounded-xl border-slate-200 bg-surface-container-low px-4 py-3 transition-all focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20" placeholder="••••••••" type="password"/>
          </div>
          <div class="mt-4 border-t border-slate-100 py-4">
            <div class="mb-4 flex items-center justify-between gap-4">
              <div class="flex flex-col"><span class="text-body-md font-semibold text-slate-700">Xác thực 2 lớp</span><span class="text-caption text-slate-500">Tăng cường bảo mật tài khoản</span></div>
              <label class="relative inline-flex cursor-pointer items-center"><input class="peer sr-only" type="checkbox"/><div class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none"></div></label>
            </div>
            <button class="w-full rounded-xl border-2 border-primary bg-white py-3 text-sm font-bold text-primary transition-all hover:bg-blue-50" type="submit">Cập nhật bảo mật</button>
          </div>
        </form>
      </section>
    </div>
  </div>
</main>
</body>
</html>
