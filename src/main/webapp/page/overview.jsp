<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>DocAdmin - Tổng quan</title>
  <script src="${pageContext.request.contextPath}/js/overview.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/overview.css" rel="stylesheet"/>
</head>
<body class="font-body-md text-on-surface">
<aside class="fixed left-0 top-0 z-50 flex h-screen w-[260px] flex-col border-r border-slate-200 bg-white py-4 font-['Be_Vietnam_Pro'] text-sm">
  <div class="mb-8 px-6">
    <h1 class="text-lg font-black text-blue-600">DocShare Admin</h1>
    <p class="text-xs text-slate-500">Management Suite</p>
  </div>
  <nav class="flex-1 space-y-1">
    <a class="flex items-center border-l-4 border-blue-600 bg-[#0555dd] px-6 py-3 font-semibold text-white transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/overview.jsp">
      <span class="material-symbols-outlined mr-3 text-white">dashboard</span>
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
    <a class="flex items-center px-6 py-3 text-slate-600 transition-all duration-200 hover:bg-slate-50 hover:pl-8 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/settings.jsp">
      <span class="material-symbols-outlined mr-3">settings</span>
      <span>Cài đặt</span>
    </a>
  </nav>
  <div class="mt-auto border-t border-slate-100 px-6 pt-4">
    <div class="flex items-center space-x-3">
      <span class="material-symbols-outlined text-slate-400">account_circle</span>
      <span class="truncate font-medium text-slate-700">Huỳnh Thị Thanh Trúc</span>
    </div>
  </div>
</aside>

<main class="ml-[260px] min-h-screen">
  <header class="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-200 bg-white/90 px-8 backdrop-blur-md dark:border-slate-800 dark:bg-slate-900/90">
    <div class="flex flex-1 items-center gap-4">
      <div class="relative w-full max-w-md">
        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
        <input class="w-full rounded-xl border-none bg-slate-50 py-2 pl-10 pr-4 text-sm transition-all focus:ring-2 focus:ring-primary-container/20" placeholder="Tìm kiếm tài liệu, người dùng..." type="text"/>
      </div>
    </div>
    <div class="flex items-center gap-6">
      <div class="flex items-center gap-3">
        <button class="relative rounded-full p-2 text-slate-500 transition-colors hover:bg-slate-100" type="button">
          <span class="material-symbols-outlined">notifications</span>
          <span class="absolute right-2 top-2 h-2 w-2 rounded-full border-2 border-white bg-error"></span>
        </button>
        <button class="rounded-full p-2 text-slate-500 transition-colors hover:bg-slate-100" type="button">
          <span class="material-symbols-outlined">history</span>
        </button>
      </div>
      <div class="h-8 w-px bg-slate-200"></div>
      <div class="flex items-center gap-3">
        <div class="hidden text-right sm:block">
          <p class="text-sm font-bold text-slate-900">Huỳnh Thị Thanh Trúc</p>
          <p class="text-[10px] font-bold uppercase tracking-normal text-slate-500">Quản trị viên</p>
        </div>
        <div class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-primary-container/20 bg-blue-100 text-blue-600">
          <span class="material-symbols-outlined">account_circle</span>
        </div>
      </div>
    </div>
  </header>

  <div class="space-y-8 p-8">
    <div class="flex items-end justify-between">
      <div>
        <h2 class="font-display text-display text-slate-900">Tổng quan</h2>
        <p class="font-body-lg text-slate-500">Chào mừng trở lại, Huỳnh Thị Thanh Trúc</p>
      </div>
      <div class="flex items-center gap-3">
        <div class="mr-4 text-right">
          <p class="text-sm font-medium text-slate-900">Thứ Ba, 31 tháng 3, 2026</p>
        </div>
        <button class="flex items-center gap-2 rounded-xl border-2 border-primary-container px-5 py-2.5 font-label-md text-primary-container transition-all hover:bg-primary-container/5" type="button">
          <span class="material-symbols-outlined text-lg">ios_share</span>
          Xuất báo cáo
        </button>
      </div>
    </div>

    <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
      <section class="flex flex-col justify-between rounded-xl border border-slate-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-blue-50 p-2 text-primary"><span class="material-symbols-outlined">description</span></div>
          <span class="rounded-full bg-emerald-50 px-2 py-1 text-[10px] font-bold text-emerald-600">+34 tháng này</span>
        </div>
        <p class="mb-1 text-sm text-slate-500">Tổng tài liệu</p>
        <h3 class="text-2xl font-bold text-slate-900">1,248</h3>
      </section>
      <section class="flex flex-col justify-between rounded-xl border border-slate-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-blue-50 p-2 text-primary"><span class="material-symbols-outlined">group</span></div>
          <span class="rounded-full bg-emerald-50 px-2 py-1 text-[10px] font-bold text-emerald-600">+128</span>
        </div>
        <p class="mb-1 text-sm text-slate-500">Người dùng</p>
        <h3 class="text-2xl font-bold text-slate-900">3,874</h3>
      </section>
      <section class="flex flex-col justify-between rounded-xl border border-slate-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-blue-50 p-2 text-primary"><span class="material-symbols-outlined">download</span></div>
          <span class="rounded-full bg-emerald-50 px-2 py-1 text-[10px] font-bold text-emerald-600">+2,341</span>
        </div>
        <p class="mb-1 text-sm text-slate-500">Lượt tải</p>
        <h3 class="text-2xl font-bold text-slate-900">12,540</h3>
      </section>
      <section class="flex flex-col justify-between rounded-xl border-l-4 border-error bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-red-50 p-2 text-error"><span class="material-symbols-outlined">schedule</span></div>
          <span class="rounded-full bg-error-container/30 px-2 py-1 text-[10px] font-bold text-error">Cần xử lý ngay</span>
        </div>
        <p class="mb-1 text-sm text-slate-500">Tài liệu chờ duyệt</p>
        <h3 class="text-2xl font-bold text-slate-900">15</h3>
      </section>
      <section class="flex flex-col justify-between rounded-xl border-l-4 border-amber-400 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-amber-50 p-2 text-amber-600"><span class="material-symbols-outlined">report_problem</span></div>
          <span class="rounded-full bg-amber-100 px-2 py-1 text-[10px] font-bold text-amber-700">Cần kiểm tra</span>
        </div>
        <p class="mb-1 text-sm text-slate-500">Tài liệu vi phạm</p>
        <h3 class="text-2xl font-bold text-slate-900">3</h3>
      </section>
      <section class="flex flex-col justify-between rounded-xl border border-slate-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-start justify-between">
          <div class="rounded-lg bg-slate-100 p-2 text-slate-600"><span class="material-symbols-outlined">dns</span></div>
        </div>
        <p class="mb-1 text-sm text-slate-500">Dung lượng</p>
        <h3 class="text-lg font-bold text-slate-900">48.6 <span class="text-xs font-normal text-slate-400">/ 100 GB</span></h3>
        <div class="mt-2 h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
          <div class="h-full rounded-full bg-primary storage-progress"></div>
        </div>
      </section>
    </div>

    <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
      <section class="rounded-xl border border-slate-100 bg-white p-6 shadow-sm lg:col-span-2">
        <div class="mb-8 flex items-center justify-between">
          <h3 class="font-h3 text-slate-900">Lượt tải tài liệu theo tháng</h3>
          <div class="flex rounded-lg bg-slate-100 p-1">
            <button class="rounded-md px-4 py-1.5 text-xs font-bold transition-all" type="button">Ngày</button>
            <button class="rounded-md px-4 py-1.5 text-xs font-bold transition-all" type="button">Tuần</button>
            <button class="rounded-md bg-white px-4 py-1.5 text-xs font-bold text-primary shadow-sm transition-all" type="button">Tháng</button>
          </div>
        </div>
        <div class="relative flex h-[280px] w-full items-end gap-4 overflow-hidden rounded-xl bg-slate-50 p-4">
          <div class="chart-grid pointer-events-none absolute inset-0 opacity-10"></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-40 w-full rounded-t-sm bg-primary/20"></div><span class="text-center text-[10px] text-slate-400">T.10</span></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-65 w-full rounded-t-sm bg-primary/40"></div><span class="text-center text-[10px] text-slate-400">T.11</span></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-55 w-full rounded-t-sm bg-primary/30"></div><span class="text-center text-[10px] text-slate-400">T.12</span></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-85 w-full rounded-t-sm bg-primary/60"></div><span class="text-center text-[10px] text-slate-400">T.01</span></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-95 w-full rounded-t-sm bg-primary/80"></div><span class="text-center text-[10px] font-bold text-primary">T.02</span></div>
          <div class="z-10 flex flex-1 flex-col justify-end gap-1"><div class="bar-70 w-full rounded-t-sm bg-primary/50"></div><span class="text-center text-[10px] text-slate-400">T.03</span></div>
        </div>
      </section>

      <section class="rounded-xl border border-slate-100 bg-white p-6 shadow-sm">
        <h3 class="mb-6 font-h3 text-slate-900">Tài liệu theo danh mục</h3>
        <div class="flex flex-col items-center justify-center space-y-6">
          <div class="relative flex h-48 w-48 items-center justify-center">
            <svg class="h-full w-full -rotate-90">
              <circle cx="96" cy="96" fill="transparent" r="80" stroke="#f1f5f9" stroke-width="24"></circle>
              <circle cx="96" cy="96" fill="transparent" r="80" stroke="#0040ab" stroke-dasharray="502" stroke-dashoffset="341" stroke-linecap="round" stroke-width="24"></circle>
            </svg>
            <div class="absolute inset-0 flex flex-col items-center justify-center">
              <span class="text-3xl font-bold text-slate-900">32%</span>
              <span class="text-[10px] font-bold uppercase text-slate-500">CNTT</span>
            </div>
          </div>
          <div class="grid w-full grid-cols-2 gap-x-8 gap-y-3 px-2">
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-primary"></div><span class="text-xs text-slate-600">CNTT (32%)</span></div>
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-blue-400"></div><span class="text-xs text-slate-600">Toán học (21%)</span></div>
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-blue-300"></div><span class="text-xs text-slate-600">Vật lý (15%)</span></div>
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-slate-400"></div><span class="text-xs text-slate-600">Kinh tế (12%)</span></div>
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-slate-300"></div><span class="text-xs text-slate-600">Ngôn ngữ (11%)</span></div>
            <div class="flex items-center gap-2"><div class="h-2 w-2 rounded-full bg-slate-200"></div><span class="text-xs text-slate-600">Khác (9%)</span></div>
          </div>
        </div>
      </section>
    </div>

    <div class="grid grid-cols-1 gap-8 xl:grid-cols-2">
      <section class="overflow-hidden rounded-xl border border-slate-100 bg-white shadow-sm">
        <div class="flex items-center justify-between border-b border-slate-50 p-6">
          <h3 class="font-h3 text-slate-900">Tài liệu được tải nhiều nhất</h3>
          <button class="text-sm font-bold text-primary hover:underline" type="button">Xem tất cả</button>
        </div>
        <div class="overflow-x-auto">
          <table class="w-full text-left">
            <thead class="bg-slate-50 text-[10px] font-bold uppercase text-slate-400">
            <tr><th class="px-6 py-4">Thứ hạng</th><th class="px-6 py-4">Tên tài liệu</th><th class="px-6 py-4">Lượt tải</th><th class="px-6 py-4">Xu hướng</th></tr>
            </thead>
            <tbody class="divide-y divide-slate-50">
            <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-amber-100 text-sm font-bold text-amber-700">1</div></td><td class="px-6 py-4"><p class="line-clamp-1 font-bold text-slate-900">Giáo trình Giải Tích 1 - ĐHBK</p><p class="text-xs text-slate-400">Toán học • PDF</p></td><td class="px-6 py-4 font-bold text-slate-700">1,420</td><td class="px-6 py-4 text-emerald-500"><span class="material-symbols-outlined align-middle text-lg">trending_up</span></td></tr>
            <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-sm font-bold text-slate-600">2</div></td><td class="px-6 py-4"><p class="line-clamp-1 font-bold text-slate-900">Đề thi Vật Lý Đại Cương 2024</p><p class="text-xs text-slate-400">Vật lý • DOCX</p></td><td class="px-6 py-4 font-bold text-slate-700">985</td><td class="px-6 py-4 text-emerald-500"><span class="material-symbols-outlined align-middle text-lg">trending_up</span></td></tr>
            <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-orange-50 text-sm font-bold text-orange-700">3</div></td><td class="px-6 py-4"><p class="line-clamp-1 font-bold text-slate-900">Cấu trúc dữ liệu và Giải thuật</p><p class="text-xs text-slate-400">CNTT • PDF</p></td><td class="px-6 py-4 font-bold text-slate-700">842</td><td class="px-6 py-4 text-slate-400"><span class="material-symbols-outlined align-middle text-lg">trending_flat</span></td></tr>
            <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-50 text-sm font-bold text-slate-400">4</div></td><td class="px-6 py-4"><p class="line-clamp-1 font-bold text-slate-900">Kinh tế vĩ mô - Bài tập mẫu</p><p class="text-xs text-slate-400">Kinh tế • PDF</p></td><td class="px-6 py-4 font-bold text-slate-700">765</td><td class="px-6 py-4 text-emerald-500"><span class="material-symbols-outlined align-middle text-lg">trending_up</span></td></tr>
            <tr class="transition-colors hover:bg-slate-50/50"><td class="px-6 py-4"><div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-50 text-sm font-bold text-slate-400">5</div></td><td class="px-6 py-4"><p class="line-clamp-1 font-bold text-slate-900">Tiếng Anh chuyên ngành CNTT</p><p class="text-xs text-slate-400">Ngôn ngữ • PDF</p></td><td class="px-6 py-4 font-bold text-slate-700">530</td><td class="px-6 py-4 text-rose-500"><span class="material-symbols-outlined align-middle text-lg">trending_down</span></td></tr>
            </tbody>
          </table>
        </div>
      </section>

      <section class="overflow-hidden rounded-xl border border-slate-100 bg-white shadow-sm">
        <div class="flex items-center justify-between border-b border-slate-50 p-6">
          <h3 class="font-h3 text-slate-900">Hoạt động gần đây</h3>
          <button class="text-sm font-bold text-primary hover:underline" type="button">Xóa nhật ký</button>
        </div>
        <div class="space-y-6 p-6">
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-emerald-500"></div><div class="absolute bottom-[-24px] left-1 top-4 w-0.5 bg-slate-100"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Nguyễn Văn A</span> vừa tải lên <span class="font-bold text-primary">Tài liệu lập trình Python.pdf</span></p><p class="mt-1 text-xs text-slate-400">2 phút trước • Danh mục CNTT</p></div></div>
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-rose-500"></div><div class="absolute bottom-[-24px] left-1 top-4 w-0.5 bg-slate-100"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Admin</span> đã xóa tài liệu <span class="font-bold text-slate-900">"Spam Content 123"</span></p><p class="mt-1 text-xs text-slate-400">15 phút trước • Lý do: Vi phạm bản quyền</p></div></div>
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-blue-500"></div><div class="absolute bottom-[-24px] left-1 top-4 w-0.5 bg-slate-100"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Trần Thị B</span> đã cập nhật ảnh đại diện và thông tin cá nhân</p><p class="mt-1 text-xs text-slate-400">45 phút trước</p></div></div>
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-amber-500"></div><div class="absolute bottom-[-24px] left-1 top-4 w-0.5 bg-slate-100"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Hệ thống</span> vừa phát hiện một báo cáo vi phạm nội dung mới</p><p class="mt-1 text-xs text-slate-400">1 giờ trước • Cần kiểm duyệt</p></div></div>
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-emerald-500"></div><div class="absolute bottom-[-24px] left-1 top-4 w-0.5 bg-slate-100"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Lê Văn C</span> đã đăng ký tài khoản Premium thành công</p><p class="mt-1 text-xs text-slate-400">2 giờ trước</p></div></div>
          <div class="flex gap-4"><div class="relative"><div class="relative z-10 mt-1.5 h-2.5 w-2.5 rounded-full bg-slate-400"></div></div><div><p class="text-sm text-slate-600"><span class="font-bold text-slate-900">Phạm Văn D</span> đã hoàn thành khảo sát chất lượng dịch vụ</p><p class="mt-1 text-xs text-slate-400">4 giờ trước</p></div></div>
        </div>
      </section>
    </div>
  </div>
  <div class="h-24"></div>
</main>
</body>
</html>
