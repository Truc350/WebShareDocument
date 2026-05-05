<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Quản lý Danh mục - DocAdmin</title>
  <script src="${pageContext.request.contextPath}/js/category.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/category.css" rel="stylesheet"/>
</head>
<body class="text-on-surface">
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
    <a class="flex items-center border-l-4 border-blue-600 bg-[#0555dd] px-6 py-3 font-semibold text-white transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/category.jsp">
      <span class="material-symbols-outlined mr-3 text-white">category</span>
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
  <header class="sticky top-0 z-40 flex h-16 w-full items-center justify-between border-b border-slate-200 bg-white px-6 shadow-sm">
    <div class="relative">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
      <input class="w-80 rounded-xl border-none bg-slate-50 py-2 pl-10 pr-4 text-sm outline-none focus:ring-2 focus:ring-blue-100" placeholder="Tìm kiếm hệ thống..." type="text"/>
    </div>
    <div class="flex items-center gap-4">
      <button class="rounded-full p-1 text-slate-500 transition-colors hover:bg-slate-50" type="button"><span class="material-symbols-outlined">notifications</span></button>
      <button class="rounded-full p-1 text-slate-500 transition-colors hover:bg-slate-50" type="button"><span class="material-symbols-outlined">help</span></button>
      <div class="mx-1 h-8 w-px bg-slate-200"></div>
      <div class="flex cursor-pointer items-center gap-3">
        <div class="text-right">
          <p class="text-sm font-bold leading-none text-slate-700">Admin User</p>
          <p class="text-[10px] font-semibold uppercase tracking-wider text-slate-400">Quản trị viên</p>
        </div>
        <div class="flex h-10 w-10 items-center justify-center rounded-xl border-2 border-white bg-blue-100 text-blue-700 shadow-sm">
          <span class="material-symbols-outlined">account_circle</span>
        </div>
      </div>
    </div>
  </header>

  <div class="p-8">
    <div class="mb-8 flex flex-col justify-between gap-4 md:flex-row md:items-center">
      <div>
        <h1 class="mb-1 font-h1 text-h1 text-on-surface">Quản lý Danh mục</h1>
        <p class="font-body-md text-slate-500">Tổ chức danh mục tài liệu, trạng thái hiển thị và số lượng tài liệu liên quan</p>
      </div>
      <div class="flex items-center gap-3">
        <button class="flex items-center gap-2 rounded-xl border border-slate-200 px-5 py-2.5 font-semibold text-slate-700 transition-all hover:bg-slate-50 active:scale-95" type="button">
          <span class="material-symbols-outlined text-xl">file_download</span>
          Xuất danh mục
        </button>
        <button class="flex items-center gap-2 rounded-xl bg-primary px-5 py-2.5 font-semibold text-white shadow-md shadow-blue-100 transition-all hover:bg-blue-800 active:scale-95" type="button">
          <span class="material-symbols-outlined text-xl">add</span>
          Thêm danh mục
        </button>
      </div>
    </div>

    <div class="mb-8 grid grid-cols-1 gap-gutter md:grid-cols-2 lg:grid-cols-4">
      <section class="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="flex h-14 w-14 items-center justify-center rounded-full bg-blue-50 text-blue-700"><span class="material-symbols-outlined text-3xl">category</span></div>
        <div><p class="font-caption text-caption text-slate-500">Tổng danh mục</p><h2 class="font-h1 text-h1 text-on-surface">18</h2></div>
      </section>
      <section class="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="flex h-14 w-14 items-center justify-center rounded-full bg-emerald-50 text-emerald-600"><span class="material-symbols-outlined text-3xl">visibility</span></div>
        <div><p class="font-caption text-caption text-slate-500">Đang hiển thị</p><h2 class="font-h1 text-h1 text-on-surface">15</h2></div>
      </section>
      <section class="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="flex h-14 w-14 items-center justify-center rounded-full bg-amber-50 text-amber-600"><span class="material-symbols-outlined text-3xl">inventory_2</span></div>
        <div><p class="font-caption text-caption text-slate-500">Danh mục trống</p><h2 class="font-h1 text-h1 text-on-surface">3</h2></div>
      </section>
      <section class="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="flex h-14 w-14 items-center justify-center rounded-full bg-purple-50 text-purple-700"><span class="material-symbols-outlined text-3xl">description</span></div>
        <div><p class="font-caption text-caption text-slate-500">Tài liệu đã phân loại</p><h2 class="font-h1 text-h1 text-on-surface">1,248</h2></div>
      </section>
    </div>

    <section class="mb-6 flex flex-wrap items-center gap-4 rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
      <div class="relative min-w-[280px] flex-1">
        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
        <input class="w-full rounded-xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-4 text-sm outline-none transition-all focus:border-blue-700 focus:ring-2 focus:ring-blue-100" placeholder="Tìm theo tên danh mục, mã, mô tả..." type="text"/>
      </div>
      <select class="min-w-[150px] rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-blue-100">
        <option value="">Trạng thái</option>
        <option value="visible">Đang hiển thị</option>
        <option value="hidden">Đang ẩn</option>
      </select>
      <select class="min-w-[150px] rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-blue-100">
        <option value="">Nhóm danh mục</option>
        <option value="academic">Học thuật</option>
        <option value="business">Nghiệp vụ</option>
      </select>
      <button class="flex items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm text-slate-600 transition-colors hover:bg-slate-100" type="button">
        <span class="material-symbols-outlined text-lg">sort</span>
        Sắp xếp
      </button>
    </section>

    <section class="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
      <div class="overflow-x-auto">
        <table class="w-full border-collapse text-left">
          <thead>
          <tr class="border-b border-slate-200 bg-slate-50">
            <th class="w-12 px-6 py-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/></th>
            <th class="px-6 py-4 text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Danh mục</th>
            <th class="px-6 py-4 text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Mã</th>
            <th class="px-6 py-4 text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Nhóm</th>
            <th class="px-6 py-4 text-center text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Số tài liệu</th>
            <th class="px-6 py-4 text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Cập nhật cuối</th>
            <th class="px-6 py-4 text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Trạng thái</th>
            <th class="px-6 py-4 text-right text-label-sm font-label-sm uppercase tracking-wider text-slate-500">Thao tác</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
          <tr class="transition-colors hover:bg-slate-50/50">
            <td class="px-6 py-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/></td>
            <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-50 text-blue-700"><span class="material-symbols-outlined">computer</span></div><div><p class="font-semibold text-slate-800">Công nghệ thông tin</p><p class="text-xs text-slate-500">Tài liệu lập trình, hệ thống, dữ liệu</p></div></div></td>
            <td class="px-6 py-4 text-body-md font-medium text-slate-600">CNTT</td>
            <td class="px-6 py-4"><span class="rounded-full bg-blue-100 px-3 py-1 text-[12px] font-bold text-blue-700">Học thuật</span></td>
            <td class="px-6 py-4 text-center text-body-md text-slate-600">412 tài liệu</td>
            <td class="px-6 py-4 text-body-md text-slate-600">24/05/2024</td>
            <td class="px-6 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-[12px] font-bold text-emerald-700">Hiển thị</span></td>
            <td class="px-6 py-4 text-right"><button class="p-2 text-slate-400 transition-colors hover:text-blue-700" type="button"><span class="material-symbols-outlined">edit</span></button><button class="p-2 text-slate-400 transition-colors hover:text-rose-600" type="button"><span class="material-symbols-outlined">delete</span></button></td>
          </tr>
          <tr class="transition-colors hover:bg-slate-50/50">
            <td class="px-6 py-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/></td>
            <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-50 text-emerald-700"><span class="material-symbols-outlined">calculate</span></div><div><p class="font-semibold text-slate-800">Toán học</p><p class="text-xs text-slate-500">Giáo trình, bài tập, đề thi toán</p></div></div></td>
            <td class="px-6 py-4 text-body-md font-medium text-slate-600">MATH</td>
            <td class="px-6 py-4"><span class="rounded-full bg-blue-100 px-3 py-1 text-[12px] font-bold text-blue-700">Học thuật</span></td>
            <td class="px-6 py-4 text-center text-body-md text-slate-600">268 tài liệu</td>
            <td class="px-6 py-4 text-body-md text-slate-600">22/05/2024</td>
            <td class="px-6 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-[12px] font-bold text-emerald-700">Hiển thị</span></td>
            <td class="px-6 py-4 text-right"><button class="p-2 text-slate-400 transition-colors hover:text-blue-700" type="button"><span class="material-symbols-outlined">edit</span></button><button class="p-2 text-slate-400 transition-colors hover:text-rose-600" type="button"><span class="material-symbols-outlined">delete</span></button></td>
          </tr>
          <tr class="transition-colors hover:bg-slate-50/50">
            <td class="px-6 py-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/></td>
            <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-purple-50 text-purple-700"><span class="material-symbols-outlined">payments</span></div><div><p class="font-semibold text-slate-800">Kinh tế</p><p class="text-xs text-slate-500">Tài chính, kinh tế vi mô, vĩ mô</p></div></div></td>
            <td class="px-6 py-4 text-body-md font-medium text-slate-600">ECON</td>
            <td class="px-6 py-4"><span class="rounded-full bg-slate-100 px-3 py-1 text-[12px] font-bold text-slate-600">Nghiệp vụ</span></td>
            <td class="px-6 py-4 text-center text-body-md text-slate-600">146 tài liệu</td>
            <td class="px-6 py-4 text-body-md text-slate-600">18/05/2024</td>
            <td class="px-6 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-[12px] font-bold text-emerald-700">Hiển thị</span></td>
            <td class="px-6 py-4 text-right"><button class="p-2 text-slate-400 transition-colors hover:text-blue-700" type="button"><span class="material-symbols-outlined">edit</span></button><button class="p-2 text-slate-400 transition-colors hover:text-rose-600" type="button"><span class="material-symbols-outlined">delete</span></button></td>
          </tr>
          <tr class="transition-colors hover:bg-slate-50/50">
            <td class="px-6 py-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/></td>
            <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-100 text-slate-600"><span class="material-symbols-outlined">folder_off</span></div><div><p class="font-semibold text-slate-800">Khác</p><p class="text-xs text-slate-500">Tài liệu chưa phân nhóm rõ ràng</p></div></div></td>
            <td class="px-6 py-4 text-body-md font-medium text-slate-600">OTHER</td>
            <td class="px-6 py-4"><span class="rounded-full bg-slate-100 px-3 py-1 text-[12px] font-bold text-slate-600">Hệ thống</span></td>
            <td class="px-6 py-4 text-center text-body-md text-slate-600">0 tài liệu</td>
            <td class="px-6 py-4 text-body-md text-slate-600">10/05/2024</td>
            <td class="px-6 py-4"><span class="rounded-full bg-amber-100 px-3 py-1 text-[12px] font-bold text-amber-700">Đang ẩn</span></td>
            <td class="px-6 py-4 text-right"><button class="p-2 text-slate-400 transition-colors hover:text-blue-700" type="button"><span class="material-symbols-outlined">edit</span></button><button class="p-2 text-slate-400 transition-colors hover:text-rose-600" type="button"><span class="material-symbols-outlined">delete</span></button></td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="flex flex-col items-center justify-between gap-4 bg-slate-50 px-6 py-4 sm:flex-row">
        <p class="text-sm font-medium text-slate-500">Hiển thị 1 - 10 trong tổng số 18 danh mục</p>
        <div class="flex items-center gap-2">
          <button class="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-400 transition-all hover:border-blue-700 hover:text-blue-700 active:scale-95" type="button"><span class="material-symbols-outlined">chevron_left</span></button>
          <button class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-700 font-bold text-white shadow-md shadow-blue-100" type="button">1</button>
          <button class="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 transition-all hover:border-blue-700 hover:text-blue-700 active:scale-95" type="button">2</button>
          <button class="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-400 transition-all hover:border-blue-700 hover:text-blue-700 active:scale-95" type="button"><span class="material-symbols-outlined">chevron_right</span></button>
        </div>
      </div>
    </section>
  </div>
</main>
</body>
</html>
