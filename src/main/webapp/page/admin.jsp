<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>DocuVerify VN - Quản lý Tài liệu</title>
  <script src="${pageContext.request.contextPath}/js/admin.js"></script>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet"/>
</head>
<body class="flex bg-background text-on-background antialiased">
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
    <a class="flex items-center border-l-4 border-blue-600 bg-[#0555dd] px-6 py-3 font-semibold text-white transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/admin.jsp">
      <span class="material-symbols-outlined mr-3 text-white">description</span>
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

<main class="ml-[260px] min-h-screen flex-grow">
  <header class="sticky top-0 z-40 flex h-16 w-full items-center justify-between border-b border-slate-200 bg-white/90 px-6 shadow-sm backdrop-blur-md">
    <div class="flex flex-col">
      <h2 class="text-xl font-bold leading-tight text-blue-700">Quản lý Tài liệu</h2>
      <p class="text-xs font-medium text-slate-500">Xem xét và quản lý toàn bộ tài liệu trên hệ thống</p>
    </div>
    <div class="flex items-center gap-4">
      <button class="flex items-center gap-2 rounded-xl border border-blue-700 px-4 py-2 font-semibold text-blue-700 transition-colors hover:bg-blue-50" type="button">
        <span class="material-symbols-outlined text-[20px]">file_download</span>
        <span>Xuất báo cáo</span>
      </button>
      <div class="mx-2 h-8 w-px bg-slate-200"></div>
      <div class="flex gap-2">
        <button class="rounded-full p-2 text-slate-600 transition-colors hover:bg-slate-50" type="button">
          <span class="material-symbols-outlined">notifications</span>
        </button>
        <button class="rounded-full p-2 text-slate-600 transition-colors hover:bg-slate-50" type="button">
          <span class="material-symbols-outlined">help</span>
        </button>
      </div>
      <div class="ml-2 flex cursor-pointer items-center gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-full border border-slate-200 bg-blue-100 text-blue-700">
          <span class="material-symbols-outlined">account_circle</span>
        </div>
        <div class="hidden text-right lg:block">
          <p class="text-sm font-bold text-slate-900">Admin_VN</p>
          <p class="text-[10px] uppercase tracking-normal text-slate-500">Ngôn ngữ: Tiếng Việt</p>
        </div>
      </div>
    </div>
  </header>

  <div class="p-container-margin">
    <div class="mb-xl grid grid-cols-1 gap-gutter md:grid-cols-2 lg:grid-cols-4">
      <section class="flex items-start justify-between rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div>
          <p class="mb-xs text-label-md text-slate-500">Chờ duyệt</p>
          <h3 class="text-display leading-none text-primary">15</h3>
          <p class="mt-sm flex items-center gap-1 text-caption font-semibold text-tertiary-container">
            <span class="material-symbols-outlined text-[14px]">pending</span>
            Cần xử lý gấp
          </p>
        </div>
        <div class="rounded-full bg-blue-50 p-sm">
          <span class="material-symbols-outlined text-blue-700">hourglass_empty</span>
        </div>
      </section>

      <section class="flex items-start justify-between rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div>
          <p class="mb-xs text-label-md text-slate-500">Đã duyệt</p>
          <h3 class="text-display leading-none text-slate-900">1,233</h3>
          <p class="mt-sm flex items-center gap-1 text-caption font-semibold text-emerald-600">
            <span class="material-symbols-outlined text-[14px]">trending_up</span>
            +12% tháng này
          </p>
        </div>
        <div class="rounded-full bg-emerald-50 p-sm">
          <span class="material-symbols-outlined text-emerald-600">check_circle</span>
        </div>
      </section>

      <section class="flex items-start justify-between rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div>
          <p class="mb-xs text-label-md text-slate-500">Vi phạm</p>
          <h3 class="text-display leading-none text-error">8</h3>
          <p class="mt-sm flex items-center gap-1 text-caption font-semibold text-error">
            <span class="material-symbols-outlined text-[14px]">warning</span>
            Cần rà soát lại
          </p>
        </div>
        <div class="rounded-full bg-red-50 p-sm">
          <span class="material-symbols-outlined text-error">report_problem</span>
        </div>
      </section>

      <section class="flex items-start justify-between rounded-xl border border-slate-200 bg-white p-lg shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div>
          <p class="mb-xs text-label-md text-slate-500">Tổng tài liệu</p>
          <h3 class="text-display leading-none text-slate-900">1,248</h3>
          <p class="mt-sm flex items-center gap-1 text-caption font-semibold text-slate-500">
            <span class="material-symbols-outlined text-[14px]">storage</span>
            Hệ thống ổn định
          </p>
        </div>
        <div class="rounded-full bg-slate-100 p-sm">
          <span class="material-symbols-outlined text-slate-600">folder</span>
        </div>
      </section>
    </div>

    <div class="mb-lg flex border-b border-slate-200">
      <button class="relative flex items-center gap-2 px-8 py-4 text-body-lg font-bold text-blue-700" type="button">
        <span class="material-symbols-outlined text-[20px]">pending_actions</span>
        <span>Chờ Duyệt</span>
        <span class="rounded-full bg-tertiary-container px-2 py-0.5 text-[11px] text-white">15</span>
        <span class="absolute bottom-0 left-0 h-1 w-full rounded-t-full bg-blue-700"></span>
      </button>
      <button class="flex items-center gap-2 px-8 py-4 text-body-lg font-medium text-slate-500 transition-colors hover:text-slate-700" type="button">
        <span class="material-symbols-outlined text-[20px]">verified</span>
        <span>Đã Duyệt</span>
        <span class="rounded-full bg-emerald-100 px-2 py-0.5 text-[11px] text-emerald-700">1,233</span>
      </button>
    </div>

    <div class="space-y-lg">
      <section class="flex items-center justify-between rounded-xl border border-[#FFE082] bg-[#FFF9E6] p-md">
        <div class="flex items-center gap-3">
          <div class="rounded-full bg-white p-2 text-[#FBC02D] shadow-sm">
            <span class="material-symbols-outlined">notification_important</span>
          </div>
          <p class="text-sm font-medium text-[#7F5F01]">Có 15 tài liệu đang chờ được xét duyệt trong hôm nay. Vui lòng kiểm tra để đảm bảo tiến độ hệ thống.</p>
        </div>
        <button class="rounded-lg bg-[#FBC02D] px-5 py-2 font-bold text-white shadow-sm transition-all hover:bg-[#F9A825] active:scale-95" type="button">
          Duyệt tất cả
        </button>
      </section>

      <section class="flex flex-wrap items-center gap-md rounded-xl border border-slate-200 bg-white p-md shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="relative min-w-[300px] flex-grow">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
          <input class="w-full rounded-xl border border-slate-200 bg-surface-bright py-2.5 pl-10 pr-4 text-sm transition-all focus:border-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-100" placeholder="Tìm kiếm tên tài liệu, người tải lên..." type="text"/>
        </div>
        <select class="rounded-xl border border-slate-200 bg-surface-bright px-4 py-2.5 text-sm focus:border-blue-700 focus:ring-2 focus:ring-blue-100">
          <option>Danh mục: Tất cả</option>
          <option>Tài chính</option>
          <option>Pháp lý</option>
          <option>Nhân sự</option>
        </select>
        <select class="rounded-xl border border-slate-200 bg-surface-bright px-4 py-2.5 text-sm focus:border-blue-700 focus:ring-2 focus:ring-blue-100">
          <option>Định dạng: Tất cả</option>
          <option>PDF</option>
          <option>DOCX</option>
          <option>JPG/PNG</option>
        </select>
        <select class="rounded-xl border border-slate-200 bg-surface-bright px-4 py-2.5 text-sm focus:border-blue-700 focus:ring-2 focus:ring-blue-100">
          <option>Thời gian: 7 ngày qua</option>
          <option>24 giờ qua</option>
          <option>Tháng này</option>
        </select>
        <button class="rounded-xl border border-slate-200 p-2.5 text-slate-600 hover:bg-slate-50" type="button">
          <span class="material-symbols-outlined">tune</span>
        </button>
      </section>

      <section class="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-[0_1px_3px_rgba(0,0,0,0.08)]">
        <div class="overflow-x-auto">
          <table class="w-full border-collapse text-left">
            <thead>
            <tr class="border-b border-slate-200 bg-surface-bright">
              <th class="w-10 p-4"><input class="rounded border-slate-300 text-blue-700 focus:ring-blue-700" type="checkbox"/></th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Tài liệu</th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Người tải lên</th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Danh mục</th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Định dạng</th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Kích thước</th>
              <th class="p-4 text-sm font-bold uppercase tracking-wider text-slate-700">Thời gian tải</th>
              <th class="p-4 text-right text-sm font-bold uppercase tracking-wider text-slate-700">Thao tác</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
            <tr class="group transition-colors hover:bg-slate-50/50">
              <td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
              <td class="p-4">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-8 items-center justify-center rounded bg-red-50 text-red-600"><span class="material-symbols-outlined text-[20px]">picture_as_pdf</span></div>
                  <div><p class="text-sm font-bold text-slate-900">Hop_dong_lao_dong_2024.pdf</p><p class="text-[10px] text-slate-400">ID: DOC-00921</p></div>
                </div>
              </td>
              <td class="p-4 text-sm font-medium text-slate-600">Nguyễn Văn An</td>
              <td class="p-4"><span class="rounded-full bg-blue-50 px-2.5 py-1 text-[11px] font-bold text-blue-700">Nhân sự</span></td>
              <td class="p-4 text-sm uppercase text-slate-500">PDF</td>
              <td class="p-4 text-sm text-slate-500">2.4 MB</td>
              <td class="p-4 text-sm text-slate-500">10:45 - 12/10/2023</td>
              <td class="p-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button class="rounded-lg border border-blue-200 px-3 py-1.5 text-xs font-bold text-blue-700 transition-colors hover:bg-blue-50" type="button">Xem trước</button>
                  <button class="rounded-lg p-1.5 text-emerald-600 hover:bg-emerald-50" type="button"><span class="material-symbols-outlined">done</span></button>
                  <button class="rounded-lg p-1.5 text-error hover:bg-red-50" type="button"><span class="material-symbols-outlined">close</span></button>
                </div>
              </td>
            </tr>

            <tr class="group transition-colors hover:bg-slate-50/50">
              <td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
              <td class="p-4">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-8 items-center justify-center rounded bg-blue-50 text-blue-600"><span class="material-symbols-outlined text-[20px]">description</span></div>
                  <div><p class="text-sm font-bold text-slate-900">Bao_cao_tai_chinh_Q3.docx</p><p class="text-[10px] text-slate-400">ID: DOC-00922</p></div>
                </div>
              </td>
              <td class="p-4 text-sm font-medium text-slate-600">Trần Thị Bích</td>
              <td class="p-4"><span class="rounded-full bg-purple-50 px-2.5 py-1 text-[11px] font-bold text-purple-700">Tài chính</span></td>
              <td class="p-4 text-sm uppercase text-slate-500">DOCX</td>
              <td class="p-4 text-sm text-slate-500">1.8 MB</td>
              <td class="p-4 text-sm text-slate-500">09:30 - 12/10/2023</td>
              <td class="p-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button class="rounded-lg border border-blue-200 px-3 py-1.5 text-xs font-bold text-blue-700 transition-colors hover:bg-blue-50" type="button">Xem trước</button>
                  <button class="rounded-lg p-1.5 text-emerald-600 hover:bg-emerald-50" type="button"><span class="material-symbols-outlined">done</span></button>
                  <button class="rounded-lg p-1.5 text-error hover:bg-red-50" type="button"><span class="material-symbols-outlined">close</span></button>
                </div>
              </td>
            </tr>

            <tr class="group transition-colors hover:bg-slate-50/50">
              <td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
              <td class="p-4">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-8 items-center justify-center rounded bg-orange-50 text-orange-600"><span class="material-symbols-outlined text-[20px]">image</span></div>
                  <div><p class="text-sm font-bold text-slate-900">CCCD_Mat_Truoc.jpg</p><p class="text-[10px] text-slate-400">ID: DOC-00923</p></div>
                </div>
              </td>
              <td class="p-4 text-sm font-medium text-slate-600">Lê Hoàng Nam</td>
              <td class="p-4"><span class="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-bold text-amber-700">Xác thực</span></td>
              <td class="p-4 text-sm uppercase text-slate-500">JPG</td>
              <td class="p-4 text-sm text-slate-500">4.1 MB</td>
              <td class="p-4 text-sm text-slate-500">08:15 - 12/10/2023</td>
              <td class="p-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button class="rounded-lg border border-blue-200 px-3 py-1.5 text-xs font-bold text-blue-700 transition-colors hover:bg-blue-50" type="button">Xem trước</button>
                  <button class="rounded-lg p-1.5 text-emerald-600 hover:bg-emerald-50" type="button"><span class="material-symbols-outlined">done</span></button>
                  <button class="rounded-lg p-1.5 text-error hover:bg-red-50" type="button"><span class="material-symbols-outlined">close</span></button>
                </div>
              </td>
            </tr>

            <tr class="group transition-colors hover:bg-slate-50/50">
              <td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
              <td class="p-4">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-8 items-center justify-center rounded bg-red-50 text-red-600"><span class="material-symbols-outlined text-[20px]">picture_as_pdf</span></div>
                  <div><p class="text-sm font-bold text-slate-900">Chung_tu_thue_2023.pdf</p><p class="text-[10px] text-slate-400">ID: DOC-00924</p></div>
                </div>
              </td>
              <td class="p-4 text-sm font-medium text-slate-600">Phạm Minh Đức</td>
              <td class="p-4"><span class="rounded-full bg-purple-50 px-2.5 py-1 text-[11px] font-bold text-purple-700">Tài chính</span></td>
              <td class="p-4 text-sm uppercase text-slate-500">PDF</td>
              <td class="p-4 text-sm text-slate-500">0.9 MB</td>
              <td class="p-4 text-sm text-slate-500">07:50 - 12/10/2023</td>
              <td class="p-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button class="rounded-lg border border-blue-200 px-3 py-1.5 text-xs font-bold text-blue-700 transition-colors hover:bg-blue-50" type="button">Xem trước</button>
                  <button class="rounded-lg p-1.5 text-emerald-600 hover:bg-emerald-50" type="button"><span class="material-symbols-outlined">done</span></button>
                  <button class="rounded-lg p-1.5 text-error hover:bg-red-50" type="button"><span class="material-symbols-outlined">close</span></button>
                </div>
              </td>
            </tr>

            <tr class="group transition-colors hover:bg-slate-50/50">
              <td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
              <td class="p-4">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-8 items-center justify-center rounded bg-green-50 text-green-600"><span class="material-symbols-outlined text-[20px]">article</span></div>
                  <div><p class="text-sm font-bold text-slate-900">Giai_trinh_du_an_A.docx</p><p class="text-[10px] text-slate-400">ID: DOC-00925</p></div>
                </div>
              </td>
              <td class="p-4 text-sm font-medium text-slate-600">Vũ Thị Loan</td>
              <td class="p-4"><span class="rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-bold text-slate-700">Kỹ thuật</span></td>
              <td class="p-4 text-sm uppercase text-slate-500">DOCX</td>
              <td class="p-4 text-sm text-slate-500">3.2 MB</td>
              <td class="p-4 text-sm text-slate-500">23:10 - 11/10/2023</td>
              <td class="p-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button class="rounded-lg border border-blue-200 px-3 py-1.5 text-xs font-bold text-blue-700 transition-colors hover:bg-blue-50" type="button">Xem trước</button>
                  <button class="rounded-lg p-1.5 text-emerald-600 hover:bg-emerald-50" type="button"><span class="material-symbols-outlined">done</span></button>
                  <button class="rounded-lg p-1.5 text-error hover:bg-red-50" type="button"><span class="material-symbols-outlined">close</span></button>
                </div>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

        <div class="flex items-center justify-between border-t border-slate-200 bg-surface-bright px-6 py-4">
          <p class="text-sm text-slate-500">Hiển thị <span class="font-bold text-slate-900">1-5</span> trong số <span class="font-bold text-slate-900">15</span> tài liệu</p>
          <div class="flex items-center gap-2">
            <button class="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 text-slate-400 opacity-50" disabled type="button">
              <span class="material-symbols-outlined">chevron_left</span>
            </button>
            <button class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-700 text-sm font-bold text-white" type="button">1</button>
            <button class="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 text-sm text-slate-600 hover:bg-white" type="button">2</button>
            <button class="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 text-sm text-slate-600 hover:bg-white" type="button">3</button>
            <button class="flex h-8 w-8 items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white" type="button">
              <span class="material-symbols-outlined">chevron_right</span>
            </button>
          </div>
        </div>
      </section>
    </div>
  </div>
</main>
</body>
</html>
