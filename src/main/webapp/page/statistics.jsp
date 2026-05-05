<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Thống kê & Báo cáo - DocAdmin</title>
  <script src="${pageContext.request.contextPath}/js/statistics.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/statistics.css" rel="stylesheet"/>
</head>
<body class="bg-background text-on-background">
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
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/management-doc.jsp">
      <span class="material-symbols-outlined mr-3">description</span>
      <span>Quản lý Tài liệu</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/user-admin.jsp">
      <span class="material-symbols-outlined mr-3">group</span>
      <span>Quản lý Người dùng</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/category-admin.jsp">
      <span class="material-symbols-outlined mr-3">category</span>
      <span>Danh mục</span>
    </a>
    <a class="flex items-center border-l-4 border-blue-600 bg-[#0555dd] px-6 py-3 font-semibold text-white transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/statistics.jsp">
      <span class="material-symbols-outlined mr-3 text-white">leaderboard</span>
      <span>Thống kê</span>
    </a>
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/settings.jsp">
      <span class="material-symbols-outlined mr-3">settings</span>
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

<header class="fixed left-[260px] right-0 top-0 z-30 flex h-16 items-center justify-between border-b border-slate-200 bg-white/80 px-8 shadow-sm backdrop-blur-md dark:border-slate-800 dark:bg-slate-900/80">
  <div class="flex flex-col">
    <h2 class="font-h2 text-lg font-bold leading-none text-slate-800 dark:text-slate-100">Thống kê & Báo cáo</h2>
    <p class="mt-1 font-body-md text-xs text-slate-500">Phân tích hiệu quả và dữ liệu hệ thống</p>
  </div>
  <div class="flex items-center gap-6">
    <div class="relative hidden lg:block">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-sm text-slate-400">search</span>
      <input class="w-64 rounded-full border-none bg-slate-100 py-2 pl-10 pr-4 text-sm transition-all focus:ring-2 focus:ring-primary/20 dark:bg-slate-800" placeholder="Tìm kiếm dữ liệu..." type="text"/>
    </div>
    <div class="flex items-center gap-2">
      <button class="rounded-full p-2 transition-transform hover:bg-slate-100 active:scale-95 dark:hover:bg-slate-800" type="button"><span class="material-symbols-outlined text-slate-500">notifications</span></button>
      <button class="rounded-full p-2 transition-transform hover:bg-slate-100 active:scale-95 dark:hover:bg-slate-800" type="button"><span class="material-symbols-outlined text-slate-500">help</span></button>
      <button class="rounded-full p-2 transition-transform hover:bg-slate-100 active:scale-95 dark:hover:bg-slate-800" type="button"><span class="material-symbols-outlined text-slate-500">settings</span></button>
    </div>
    <div class="mx-2 h-8 w-px bg-slate-200"></div>
    <div class="flex items-center gap-3 pl-2">
      <div class="hidden text-right sm:block">
        <p class="text-sm font-bold text-slate-800">Admin_Viet</p>
        <p class="text-[10px] font-bold text-primary">Quản trị viên</p>
      </div>
      <div class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-primary/20 bg-blue-100 text-primary">
        <span class="material-symbols-outlined">account_circle</span>
      </div>
    </div>
  </div>
</header>

<main class="ml-[260px] min-h-screen p-8 pt-24">
  <section class="mb-8 flex flex-col justify-between gap-4 rounded-xl border border-slate-100 bg-white p-4 shadow-sm md:flex-row md:items-center">
    <div class="flex items-center gap-4">
      <div class="flex items-center gap-2">
        <span class="material-symbols-outlined text-slate-400">calendar_today</span>
        <div class="flex items-center gap-2 rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
          <input class="border-none bg-transparent p-0 text-sm text-slate-600 focus:ring-0" type="date" value="2023-11-01"/>
          <span class="text-slate-400">→</span>
          <input class="border-none bg-transparent p-0 text-sm text-slate-600 focus:ring-0" type="date" value="2023-11-30"/>
        </div>
      </div>
      <select class="rounded-lg border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-600 focus:border-primary focus:ring-primary">
        <option>Tất cả danh mục</option>
        <option>CNTT</option>
        <option>Toán học</option>
      </select>
    </div>
    <button class="flex items-center justify-center gap-2 rounded-lg bg-primary px-6 py-2.5 font-label-md text-white shadow-lg shadow-primary/20 transition-all hover:bg-primary-container active:scale-95" type="button">
      <span class="material-symbols-outlined text-base">download</span>
      Xuất báo cáo chi tiết (.xlsx)
    </button>
  </section>

  <section class="mb-8 grid grid-cols-1 gap-gutter md:grid-cols-2 lg:grid-cols-4">
    <div class="group relative flex flex-col gap-sm overflow-hidden rounded-xl border border-slate-100 bg-white p-lg shadow-sm">
      <div class="flex items-start justify-between"><div class="rounded-xl bg-blue-50 p-3 text-primary transition-transform group-hover:scale-110"><span class="material-symbols-outlined material-symbols-filled">file_download</span></div><span class="rounded-full bg-emerald-50 px-2 py-1 text-xs font-bold text-emerald-500">+12%</span></div>
      <div class="mt-2"><p class="font-label-md text-slate-500">Tổng lượt tải</p><h2 class="mt-1 text-h1 font-black text-slate-800">42,850</h2></div>
      <div class="absolute bottom-0 left-0 h-1 w-full origin-left scale-x-0 bg-primary transition-transform group-hover:scale-x-100"></div>
    </div>
    <div class="group relative flex flex-col gap-sm overflow-hidden rounded-xl border border-slate-100 bg-white p-lg shadow-sm">
      <div class="flex items-start justify-between"><div class="rounded-xl bg-indigo-50 p-3 text-indigo-600 transition-transform group-hover:scale-110"><span class="material-symbols-outlined material-symbols-filled">add_circle</span></div><span class="rounded-full bg-emerald-50 px-2 py-1 text-xs font-bold text-emerald-500">+5%</span></div>
      <div class="mt-2"><p class="font-label-md text-slate-500">Tài liệu mới</p><h2 class="mt-1 text-h1 font-black text-slate-800">1,248</h2></div>
      <div class="absolute bottom-0 left-0 h-1 w-full origin-left scale-x-0 bg-indigo-500 transition-transform group-hover:scale-x-100"></div>
    </div>
    <div class="group relative flex flex-col gap-sm overflow-hidden rounded-xl border border-slate-100 bg-white p-lg shadow-sm">
      <div class="flex items-start justify-between"><div class="rounded-xl bg-cyan-50 p-3 text-cyan-600 transition-transform group-hover:scale-110"><span class="material-symbols-outlined material-symbols-filled">group_add</span></div><span class="rounded-full bg-emerald-50 px-2 py-1 text-xs font-bold text-emerald-500">+8%</span></div>
      <div class="mt-2"><p class="font-label-md text-slate-500">Người dùng mới</p><h2 class="mt-1 text-h1 font-black text-slate-800">342</h2></div>
      <div class="absolute bottom-0 left-0 h-1 w-full origin-left scale-x-0 bg-cyan-500 transition-transform group-hover:scale-x-100"></div>
    </div>
    <div class="group relative flex flex-col gap-sm overflow-hidden rounded-xl border border-slate-100 bg-white p-lg shadow-sm">
      <div class="flex items-start justify-between"><div class="rounded-xl bg-blue-50 p-3 text-primary transition-transform group-hover:scale-110"><span class="material-symbols-outlined material-symbols-filled">visibility</span></div><span class="rounded-full bg-emerald-50 px-2 py-1 text-xs font-bold text-emerald-500">+15%</span></div>
      <div class="mt-2"><p class="font-label-md text-slate-500">Lượt xem tài liệu</p><h2 class="mt-1 text-h1 font-black text-slate-800">125.8K</h2></div>
      <div class="absolute bottom-0 left-0 h-1 w-full origin-left scale-x-0 bg-primary transition-transform group-hover:scale-x-100"></div>
    </div>
  </section>

  <section class="mb-8 grid grid-cols-1 gap-gutter lg:grid-cols-10">
    <div class="rounded-xl border border-slate-100 bg-white p-lg shadow-sm lg:col-span-7">
      <div class="mb-8 flex items-center justify-between">
        <h3 class="font-h3 text-h3 text-slate-800">Xu hướng lượt tải và tải lên</h3>
        <div class="flex gap-4">
          <div class="flex items-center gap-2"><span class="h-3 w-3 rounded-full bg-primary"></span><span class="text-xs font-medium text-slate-500">Lượt tải</span></div>
          <div class="flex items-center gap-2"><span class="h-3 w-3 rounded-full bg-emerald-500"></span><span class="text-xs font-medium text-slate-500">Tải lên</span></div>
        </div>
      </div>
      <div class="group relative flex h-[300px] w-full items-end gap-2">
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-40 w-full rounded-t-sm bg-primary/20"></div><div class="bar-20 w-full rounded-t-sm bg-emerald-500/20"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-55 w-full rounded-t-sm bg-primary/20"></div><div class="bar-25 w-full rounded-t-sm bg-emerald-500/20"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-45 w-full rounded-t-sm bg-primary/30"></div><div class="bar-30 w-full rounded-t-sm bg-emerald-500/30"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-65 w-full rounded-t-sm bg-primary/40"></div><div class="bar-35 w-full rounded-t-sm bg-emerald-500/40"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-50 w-full rounded-t-sm bg-primary/20"></div><div class="bar-40 w-full rounded-t-sm bg-emerald-500/20"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-75 w-full rounded-t-sm bg-primary/30"></div><div class="bar-45 w-full rounded-t-sm bg-emerald-500/30"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-60 w-full rounded-t-sm bg-primary/40"></div><div class="bar-50 w-full rounded-t-sm bg-emerald-500/40"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-85 w-full rounded-t-sm bg-primary/30"></div><div class="bar-55 w-full rounded-t-sm bg-emerald-500/30"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-70 w-full rounded-t-sm bg-primary/40"></div><div class="bar-60 w-full rounded-t-sm bg-emerald-500/40"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-95 w-full rounded-t-sm bg-primary/50"></div><div class="bar-70 w-full rounded-t-sm bg-emerald-500/50"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-80 w-full rounded-t-sm bg-primary/60"></div><div class="bar-65 w-full rounded-t-sm bg-emerald-500/60"></div></div>
        <div class="flex h-full flex-1 flex-col justify-end gap-1"><div class="bar-100 w-full rounded-t-sm bg-primary"></div><div class="bar-75 w-full rounded-t-sm bg-emerald-500"></div></div>
        <div class="absolute -bottom-6 left-0 flex w-full justify-between text-[10px] font-bold uppercase text-slate-400"><span>Jan</span><span>Mar</span><span>May</span><span>Jul</span><span>Sep</span><span>Nov</span></div>
      </div>
    </div>

    <div class="flex flex-col rounded-xl border border-slate-100 bg-white p-lg shadow-sm lg:col-span-3">
      <h3 class="mb-6 font-h3 text-h3 text-slate-800">Cơ cấu tài liệu</h3>
      <div class="flex flex-1 flex-col items-center justify-center">
        <svg class="h-48 w-48 -rotate-90" viewBox="0 0 100 100">
          <circle cx="50" cy="50" fill="transparent" r="40" stroke="#0040ab" stroke-dasharray="251.2" stroke-dashoffset="62.8" stroke-width="12"></circle>
          <circle cx="50" cy="50" fill="transparent" r="40" stroke="#10B981" stroke-dasharray="251.2" stroke-dashoffset="188.4" stroke-width="12"></circle>
          <circle cx="50" cy="50" fill="transparent" r="40" stroke="#F59E0B" stroke-dasharray="251.2" stroke-dashoffset="220" stroke-width="12"></circle>
          <circle cx="50" cy="50" fill="transparent" r="40" stroke="#8B5CF6" stroke-dasharray="251.2" stroke-dashoffset="240" stroke-width="12"></circle>
          <circle cx="50" cy="50" fill="white" r="30"></circle>
        </svg>
        <div class="mt-6 w-full space-y-2">
          <div class="flex items-center justify-between text-xs"><div class="flex items-center gap-2"><span class="h-2 w-2 rounded-full bg-primary"></span> CNTT</div><span class="font-bold">45%</span></div>
          <div class="flex items-center justify-between text-xs"><div class="flex items-center gap-2"><span class="h-2 w-2 rounded-full bg-emerald-500"></span> Kinh tế</div><span class="font-bold">25%</span></div>
          <div class="flex items-center justify-between text-xs"><div class="flex items-center gap-2"><span class="h-2 w-2 rounded-full bg-amber-500"></span> Toán học</div><span class="font-bold">15%</span></div>
          <div class="flex items-center justify-between text-xs"><div class="flex items-center gap-2"><span class="h-2 w-2 rounded-full bg-violet-500"></span> Ngôn ngữ</div><span class="font-bold">10%</span></div>
          <div class="flex items-center justify-between text-xs"><div class="flex items-center gap-2"><span class="h-2 w-2 rounded-full bg-slate-300"></span> Khác</div><span class="font-bold">5%</span></div>
        </div>
      </div>
    </div>
  </section>

  <section class="grid grid-cols-1 gap-gutter lg:grid-cols-2">
    <div class="overflow-hidden rounded-xl border border-slate-100 bg-white shadow-sm">
      <div class="flex items-center justify-between border-b border-slate-100 p-6"><h3 class="font-h3 text-h3 text-slate-800">Tài liệu được tải nhiều nhất</h3><button class="text-xs font-bold text-primary hover:underline" type="button">Xem tất cả</button></div>
      <table class="w-full text-left">
        <thead class="bg-slate-50 text-[10px] font-bold uppercase tracking-wider text-slate-400"><tr><th class="px-6 py-4">Hạng</th><th class="px-6 py-4">Tên tài liệu</th><th class="px-6 py-4">Lượt tải</th><th class="px-6 py-4 text-right">Tăng trưởng</th></tr></thead>
        <tbody class="divide-y divide-slate-100 text-sm">
        <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4 font-bold text-slate-400">#01</td><td class="px-6 py-4"><p class="max-w-[180px] truncate font-bold text-slate-800">Giáo trình Python cơ bản</p><p class="text-[10px] text-slate-400">Danh mục: CNTT</p></td><td class="px-6 py-4 font-medium">1,450</td><td class="px-6 py-4 text-right font-bold text-emerald-500">+24%</td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4 font-bold text-slate-400">#02</td><td class="px-6 py-4"><p class="max-w-[180px] truncate font-bold text-slate-800">Kinh tế vĩ mô 2023</p><p class="text-[10px] text-slate-400">Danh mục: Kinh tế</p></td><td class="px-6 py-4 font-medium">1,210</td><td class="px-6 py-4 text-right font-bold text-emerald-500">+18%</td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4 font-bold text-slate-400">#03</td><td class="px-6 py-4"><p class="max-w-[180px] truncate font-bold text-slate-800">Toán cao cấp A1 - Giải tích</p><p class="text-[10px] text-slate-400">Danh mục: Toán học</p></td><td class="px-6 py-4 font-medium">980</td><td class="px-6 py-4 text-right font-bold text-emerald-500">+12%</td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4 font-bold text-slate-400">#04</td><td class="px-6 py-4"><p class="max-w-[180px] truncate font-bold text-slate-800">Tiếng Anh chuyên ngành</p><p class="text-[10px] text-slate-400">Danh mục: Ngôn ngữ</p></td><td class="px-6 py-4 font-medium">850</td><td class="px-6 py-4 text-right font-bold text-amber-500">+5%</td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4 font-bold text-slate-400">#05</td><td class="px-6 py-4"><p class="max-w-[180px] truncate font-bold text-slate-800">Lịch sử Đảng - Tóm tắt</p><p class="text-[10px] text-slate-400">Danh mục: Khác</p></td><td class="px-6 py-4 font-medium">720</td><td class="px-6 py-4 text-right font-bold text-slate-400">-2%</td></tr>
        </tbody>
      </table>
    </div>

    <div class="overflow-hidden rounded-xl border border-slate-100 bg-white shadow-sm">
      <div class="flex items-center justify-between border-b border-slate-100 p-6"><h3 class="font-h3 text-h3 text-slate-800">Người đóng góp hàng đầu</h3><button class="text-xs font-bold text-primary hover:underline" type="button">Xem bảng xếp hạng</button></div>
      <table class="w-full text-left">
        <thead class="bg-slate-50 text-[10px] font-bold uppercase tracking-wider text-slate-400"><tr><th class="px-6 py-4">Thành viên</th><th class="px-6 py-4">Tài liệu</th><th class="px-6 py-4">Tổng lượt tải</th><th class="px-6 py-4 text-right">Uy tín</th></tr></thead>
        <tbody class="divide-y divide-slate-100 text-sm">
        <tr class="transition-colors hover:bg-slate-50/50"><td class="flex items-center gap-3 px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-xs font-bold text-primary">NC</div><div><p class="font-bold text-slate-800">nguyen_vanc</p><p class="text-[10px] text-emerald-500">Verified</p></div></td><td class="px-6 py-4 font-medium">42</td><td class="px-6 py-4">12,450</td><td class="px-6 py-4 text-right"><span class="rounded-full bg-primary/10 px-2 py-1 text-xs font-bold text-primary">9.8/10</span></td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="flex items-center gap-3 px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-emerald-100 text-xs font-bold text-emerald-700">LB</div><div><p class="font-bold text-slate-800">le_thiba</p><p class="text-[10px] text-emerald-500">Verified</p></div></td><td class="px-6 py-4 font-medium">35</td><td class="px-6 py-4">9,820</td><td class="px-6 py-4 text-right"><span class="rounded-full bg-primary/10 px-2 py-1 text-xs font-bold text-primary">9.5/10</span></td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="flex items-center gap-3 px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-indigo-100 text-xs font-bold text-indigo-700">TM</div><div><p class="font-bold text-slate-800">tran_minh92</p><p class="text-[10px] text-slate-400">Regular</p></div></td><td class="px-6 py-4 font-medium">28</td><td class="px-6 py-4">7,640</td><td class="px-6 py-4 text-right"><span class="rounded-full bg-primary/10 px-2 py-1 text-xs font-bold text-primary">9.2/10</span></td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="flex items-center gap-3 px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-amber-100 text-xs font-bold text-amber-700">HO</div><div><p class="font-bold text-slate-800">hoang_oanh</p><p class="text-[10px] text-emerald-500">Verified</p></div></td><td class="px-6 py-4 font-medium">21</td><td class="px-6 py-4">5,900</td><td class="px-6 py-4 text-right"><span class="rounded-full bg-primary/10 px-2 py-1 text-xs font-bold text-primary">8.9/10</span></td></tr>
        <tr class="transition-colors hover:bg-slate-50/50"><td class="flex items-center gap-3 px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-xs font-bold text-slate-700">VD</div><div><p class="font-bold text-slate-800">vu_ducal</p><p class="text-[10px] text-slate-400">Regular</p></div></td><td class="px-6 py-4 font-medium">18</td><td class="px-6 py-4">4,210</td><td class="px-6 py-4 text-right"><span class="rounded-full bg-primary/10 px-2 py-1 text-xs font-bold text-primary">8.7/10</span></td></tr>
        </tbody>
      </table>
    </div>
  </section>
</main>
</body>
</html>
