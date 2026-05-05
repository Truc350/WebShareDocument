<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>DocuVerify VN - Quản lý Tài liệu</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;200;300;400;500;600;700;800;900&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="${pageContext.request.contextPath}/js/admin.js"></script>
<link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
        }
    </style>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-tertiary-fixed-variant": "#832600",
                        "surface-variant": "#e1e2ed",
                        "on-secondary-container": "#5e6572",
                        "inverse-on-surface": "#f0f0fb",
                        "error-container": "#ffdad6",
                        "on-primary-fixed-variant": "#003ea7",
                        "tertiary": "#862700",
                        "surface-bright": "#faf8ff",
                        "primary-fixed": "#dbe1ff",
                        "on-tertiary-fixed": "#390c00",
                        "surface-container-lowest": "#ffffff",
                        "surface-container": "#ededf9",
                        "surface-container-low": "#f3f3fe",
                        "surface": "#faf8ff",
                        "on-secondary-fixed": "#151c27",
                        "on-primary-fixed": "#00174b",
                        "background": "#faf8ff",
                        "outline-variant": "#c3c6d7",
                        "outline": "#737686",
                        "on-primary-container": "#d1daff",
                        "on-background": "#191b23",
                        "tertiary-container": "#af3600",
                        "inverse-primary": "#b4c5ff",
                        "surface-dim": "#d9d9e5",
                        "inverse-surface": "#2e3039",
                        "secondary-fixed": "#dce2f3",
                        "tertiary-fixed-dim": "#ffb59d",
                        "primary-fixed-dim": "#b4c5ff",
                        "on-surface": "#191b23",
                        "secondary": "#585f6c",
                        "on-tertiary": "#ffffff",
                        "on-secondary": "#ffffff",
                        "on-error-container": "#93000a",
                        "primary-container": "#0555dd",
                        "on-error": "#ffffff",
                        "tertiary-fixed": "#ffdbd0",
                        "primary": "#0040ab",
                        "on-primary": "#ffffff",
                        "error": "#ba1a1a",
                        "surface-tint": "#0053da",
                        "surface-container-high": "#e7e7f3",
                        "secondary-container": "#dce2f3",
                        "on-tertiary-container": "#ffd2c4",
                        "surface-container-highest": "#e1e2ed",
                        "on-surface-variant": "#434655",
                        "on-secondary-fixed-variant": "#404754",
                        "secondary-fixed-dim": "#c0c7d6"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "xs": "4px",
                        "container-margin": "24px",
                        "md": "16px",
                        "2xl": "48px",
                        "xl": "32px",
                        "lg": "24px",
                        "sm": "8px",
                        "gutter": "16px",
                        "base": "4px"
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-background text-on-background antialiased flex">
<!-- SideNavBar -->
<aside class="fixed left-0 top-0 h-screen w-[260px] border-r border-slate-200 bg-white z-50 flex flex-col py-4 font-['Be_Vietnam_Pro'] text-sm">
<div class="px-6 mb-8">
<h1 class="text-lg font-black text-blue-600">DocShare Admin</h1>
<p class="text-xs text-slate-500">Management Suite</p>
</div>
<nav class="flex-1 space-y-1">
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/overview.jsp">
<span class="material-symbols-outlined mr-3" data-icon="dashboard">dashboard</span>
<span>Tổng quan</span>
</a>
<!-- Active State: Document Management (Quản lý Tài liệu) -->
<a class="flex items-center px-6 py-3 bg-[#0555dd] text-white border-l-4 border-blue-600 font-semibold transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/management-doc.jsp">
<span class="material-symbols-outlined mr-3 text-white" data-icon="description">description</span>
<span>Quản lý Tài liệu</span>
</a>
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/user-admin.jsp">
<span class="material-symbols-outlined mr-3" data-icon="group">group</span>
<span>Quản lý Người dùng</span>
</a>
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/category-admin.jsp">
<span class="material-symbols-outlined mr-3" data-icon="category">category</span>
<span>Danh mục</span>
</a>
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/statistics.jsp">
<span class="material-symbols-outlined mr-3" data-icon="leaderboard">leaderboard</span>
<span>Thống kê</span>
</a>
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/settings.jsp">
<span class="material-symbols-outlined mr-3" data-icon="settings">settings</span>
<span>Cài đặt</span>
</a>
</nav>
<div class="px-6 pt-4 mt-auto border-t border-slate-100">
<div class="flex items-center space-x-3">
<span class="material-symbols-outlined text-slate-400" data-icon="account_circle">account_circle</span>
<span class="font-medium text-slate-700 truncate">Huỳnh Thị Thanh Trúc</span>
</div>
</div>
</aside>
<main class="flex-grow ml-[260px] min-h-screen">
<!-- TopAppBar -->
<header class="sticky top-0 w-full h-16 border-b border-slate-200 bg-white/90 backdrop-blur-md z-40 shadow-sm flex justify-between items-center px-6">
<div class="flex flex-col">
<h2 class="text-xl font-bold text-blue-700 leading-tight">Quản lý Tài liệu</h2>
<p class="text-xs text-slate-500 font-medium">Xem xét và quản lý toàn bộ tài liệu trên hệ thống</p>
</div>
<div class="flex items-center gap-4">
<button class="flex items-center gap-2 px-4 py-2 border border-blue-700 text-blue-700 rounded-xl font-semibold hover:bg-blue-50 transition-colors">
<span class="material-symbols-outlined text-[20px]" data-icon="file_download">file_download</span>
<span>Xuất báo cáo</span>
</button>
<div class="h-8 w-px bg-slate-200 mx-2"></div>
<div class="flex gap-2">
<button class="p-2 text-slate-600 hover:bg-slate-50 rounded-full transition-colors">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
</button>
<button class="p-2 text-slate-600 hover:bg-slate-50 rounded-full transition-colors">
<span class="material-symbols-outlined" data-icon="help">help</span>
</button>
</div>
<div class="flex items-center gap-3 ml-2 cursor-pointer">
<div class="w-10 h-10 rounded-full overflow-hidden border border-slate-200">
<img alt="Administrator Profile" class="w-full h-full object-cover" data-alt="A professional headshot of a corporate administrator, wearing a sharp navy blue suit and a clean white shirt. The lighting is soft and flattering, creating a premium light-mode aesthetic with high clarity. The background is a blurred high-end office environment with soft blue and white highlights, maintaining a sophisticated professional tone." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDGHxk49jIrSBKOiNI5fUbJYGPxX9ptw0X-pK-4wlJID8r7broWNr8TmotwHqoPJ5u54GPg1I0SL1Wk0P0EBZZeEh26dtYiEHC5w5lCfZ18qQwdViBJ7P3R_4cfp8o2TCFc93ks5lW1OBrX_73c1QTAhxuBhiB8I9zrv93eH6aS60Dwzs_2u4xCfKOJW7bLuP3aI_BGVmQk2xIG2WMjzxd5qfq682zUlTZ209o2niS8FtkN1TdUqbd51JznMpSDs3spM8SPByngBHo"/>
</div>
<div class="hidden lg:block text-right">
<p class="text-sm font-bold text-slate-900">Admin_VN</p>
<p class="text-[10px] text-slate-500 uppercase tracking-tighter">Ngôn ngữ: Tiếng Việt</p>
</div>
</div>
</div>
</header>
<!-- Content Area -->
<div class="p-container-margin">
<!-- Section 1: Stats Cards -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter mb-xl">
<div class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
<div>
<p class="text-slate-500 text-label-md mb-xs">Chờ duyệt</p>
<h3 class="text-display text-primary leading-none">15</h3>
<p class="text-caption text-tertiary-container mt-sm font-semibold flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]" data-icon="pending">pending</span>
                            Cần xử lý gấp
                        </p>
</div>
<div class="p-sm bg-blue-50 rounded-full">
<span class="material-symbols-outlined text-blue-700" data-icon="hourglass_empty">hourglass_empty</span>
</div>
</div>
<div class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
<div>
<p class="text-slate-500 text-label-md mb-xs">Đã duyệt</p>
<h3 class="text-display text-slate-900 leading-none">1,233</h3>
<p class="text-caption text-emerald-600 mt-sm font-semibold flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]" data-icon="trending_up">trending_up</span>
                            +12% tháng này
                        </p>
</div>
<div class="p-sm bg-emerald-50 rounded-full">
<span class="material-symbols-outlined text-emerald-600" data-icon="check_circle">check_circle</span>
</div>
</div>
<div class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
<div>
<p class="text-slate-500 text-label-md mb-xs">Vi phạm</p>
<h3 class="text-display text-error leading-none">8</h3>
<p class="text-caption text-error mt-sm font-semibold flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]" data-icon="warning">warning</span>
                            Cần rà soát lại
                        </p>
</div>
<div class="p-sm bg-red-50 rounded-full">
<span class="material-symbols-outlined text-error" data-icon="report_problem">report_problem</span>
</div>
</div>
<div class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
<div>
<p class="text-slate-500 text-label-md mb-xs">Tổng tài liệu</p>
<h3 class="text-display text-slate-900 leading-none">1,248</h3>
<p class="text-caption text-slate-500 mt-sm font-semibold flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]" data-icon="storage">storage</span>
                            Hệ thống ổn định
                        </p>
</div>
<div class="p-sm bg-slate-100 rounded-full">
<span class="material-symbols-outlined text-slate-600" data-icon="folder">folder</span>
</div>
</div>
</div>
<!-- Section 2: Tab Navigation -->
<div class="flex border-b border-slate-200 mb-lg">
<button class="relative px-8 py-4 text-blue-700 font-bold text-body-lg flex items-center gap-2">
<span>📋 Chờ Duyệt</span>
<span class="bg-tertiary-container text-white text-[11px] px-2 py-0.5 rounded-full">15</span>
<div class="absolute bottom-0 left-0 w-full h-1 bg-blue-700 rounded-t-full"></div>
</button>
<button class="px-8 py-4 text-slate-500 font-medium text-body-lg flex items-center gap-2 hover:text-slate-700 transition-colors">
<span>✅ Đã Duyệt</span>
<span class="bg-emerald-100 text-emerald-700 text-[11px] px-2 py-0.5 rounded-full">1,233</span>
</button>
</div>
<!-- Section 3: Tab Content -->
<div class="space-y-lg">
<!-- Yellow Banner -->
<div class="bg-[#FFF9E6] border border-[#FFE082] rounded-xl p-md flex items-center justify-between">
<div class="flex items-center gap-3">
<div class="p-2 bg-white rounded-full shadow-sm text-[#FBC02D]">
<span class="material-symbols-outlined" data-icon="notification_important">notification_important</span>
</div>
<p class="text-sm font-medium text-[#7F5F01]">Có 15 tài liệu đang chờ được xét duyệt trong hôm nay. Vui lòng kiểm tra để đảm bảo tiến độ hệ thống.</p>
</div>
<button class="px-5 py-2 bg-[#FBC02D] hover:bg-[#F9A825] text-white font-bold rounded-lg shadow-sm transition-all transform active:scale-95">
                        Duyệt tất cả
                    </button>
</div>
<!-- Filter Bar -->
<div class="bg-white p-md rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex flex-wrap items-center gap-md">
<div class="relative flex-grow min-w-[300px]">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" data-icon="search">search</span>
<input class="w-full pl-10 pr-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-700 text-sm transition-all" placeholder="Tìm kiếm tên tài liệu, người tải lên..." type="text"/>
</div>
<select class="px-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700">
<option>Danh mục: Tất cả</option>
<option>Tài chính</option>
<option>Pháp lý</option>
<option>Nhân sự</option>
</select>
<select class="px-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700">
<option>Định dạng: Tất cả</option>
<option>PDF</option>
<option>DOCX</option>
<option>JPG/PNG</option>
</select>
<select class="px-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700">
<option>Thời gian: 7 ngày qua</option>
<option>24 giờ qua</option>
<option>Tháng này</option>
</select>
<button class="p-2.5 text-slate-600 border border-slate-200 rounded-xl hover:bg-slate-50">
<span class="material-symbols-outlined" data-icon="tune">tune</span>
</button>
</div>
<!-- Pending Documents Table -->
<div class="bg-white rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 overflow-hidden">
<table class="w-full text-left border-collapse">
<thead>
<tr class="bg-surface-bright border-b border-slate-200">
<th class="p-4 w-10">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-700" type="checkbox"/>
</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Tài liệu</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Người tải lên</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Danh mục</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Định dạng</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Kích thước</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Thời gian tải</th>
<th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider text-right">Thao tác</th>
</tr>
</thead>
<tbody class="divide-y divide-slate-100">
<!-- Row 1 -->
<tr class="hover:bg-slate-50/50 transition-colors group">
<td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
<td class="p-4">
<div class="flex items-center gap-3">
<div class="w-8 h-10 bg-red-50 text-red-600 flex items-center justify-center rounded">
<span class="material-symbols-outlined text-[20px]" data-icon="picture_as_pdf">picture_as_pdf</span>
</div>
<div>
<p class="font-bold text-slate-900 text-sm">Hop_dong_lao_dong_2024.pdf</p>
<p class="text-[10px] text-slate-400">ID: DOC-00921</p>
</div>
</div>
</td>
<td class="p-4 text-sm text-slate-600 font-medium">Nguyễn Văn An</td>
<td class="p-4">
<span class="px-2.5 py-1 bg-blue-50 text-blue-700 rounded-full text-[11px] font-bold">Nhân sự</span>
</td>
<td class="p-4 text-sm text-slate-500 uppercase">PDF</td>
<td class="p-4 text-sm text-slate-500">2.4 MB</td>
<td class="p-4 text-sm text-slate-500">10:45 - 12/10/2023</td>
<td class="p-4 text-right">
<div class="flex items-center justify-end gap-2">
<button class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors">Xem trước</button>
<button class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><span class="material-symbols-outlined" data-icon="done">done</span></button>
<button class="p-1.5 text-error hover:bg-red-50 rounded-lg"><span class="material-symbols-outlined" data-icon="close">close</span></button>
</div>
</td>
</tr>
<!-- Row 2 -->
<tr class="hover:bg-slate-50/50 transition-colors group">
<td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
<td class="p-4">
<div class="flex items-center gap-3">
<div class="w-8 h-10 bg-blue-50 text-blue-600 flex items-center justify-center rounded">
<span class="material-symbols-outlined text-[20px]" data-icon="description">description</span>
</div>
<div>
<p class="font-bold text-slate-900 text-sm">Bao_cao_tai_chinh_Q3.docx</p>
<p class="text-[10px] text-slate-400">ID: DOC-00922</p>
</div>
</div>
</td>
<td class="p-4 text-sm text-slate-600 font-medium">Trần Thị Bích</td>
<td class="p-4">
<span class="px-2.5 py-1 bg-purple-50 text-purple-700 rounded-full text-[11px] font-bold">Tài chính</span>
</td>
<td class="p-4 text-sm text-slate-500 uppercase">DOCX</td>
<td class="p-4 text-sm text-slate-500">1.8 MB</td>
<td class="p-4 text-sm text-slate-500">09:30 - 12/10/2023</td>
<td class="p-4 text-right">
<div class="flex items-center justify-end gap-2">
<button class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors">Xem trước</button>
<button class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><span class="material-symbols-outlined" data-icon="done">done</span></button>
<button class="p-1.5 text-error hover:bg-red-50 rounded-lg"><span class="material-symbols-outlined" data-icon="close">close</span></button>
</div>
</td>
</tr>
<!-- Row 3 -->
<tr class="hover:bg-slate-50/50 transition-colors group">
<td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
<td class="p-4">
<div class="flex items-center gap-3">
<div class="w-8 h-10 bg-orange-50 text-orange-600 flex items-center justify-center rounded">
<span class="material-symbols-outlined text-[20px]" data-icon="image">image</span>
</div>
<div>
<p class="font-bold text-slate-900 text-sm">CCCD_Mat_Truoc.jpg</p>
<p class="text-[10px] text-slate-400">ID: DOC-00923</p>
</div>
</div>
</td>
<td class="p-4 text-sm text-slate-600 font-medium">Lê Hoàng Nam</td>
<td class="p-4">
<span class="px-2.5 py-1 bg-amber-50 text-amber-700 rounded-full text-[11px] font-bold">Xác thực</span>
</td>
<td class="p-4 text-sm text-slate-500 uppercase">JPG</td>
<td class="p-4 text-sm text-slate-500">4.1 MB</td>
<td class="p-4 text-sm text-slate-500">08:15 - 12/10/2023</td>
<td class="p-4 text-right">
<div class="flex items-center justify-end gap-2">
<button class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors">Xem trước</button>
<button class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><span class="material-symbols-outlined" data-icon="done">done</span></button>
<button class="p-1.5 text-error hover:bg-red-50 rounded-lg"><span class="material-symbols-outlined" data-icon="close">close</span></button>
</div>
</td>
</tr>
<!-- Row 4 -->
<tr class="hover:bg-slate-50/50 transition-colors group">
<td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
<td class="p-4">
<div class="flex items-center gap-3">
<div class="w-8 h-10 bg-red-50 text-red-600 flex items-center justify-center rounded">
<span class="material-symbols-outlined text-[20px]" data-icon="picture_as_pdf">picture_as_pdf</span>
</div>
<div>
<p class="font-bold text-slate-900 text-sm">Chung_tu_thue_2023.pdf</p>
<p class="text-[10px] text-slate-400">ID: DOC-00924</p>
</div>
</div>
</td>
<td class="p-4 text-sm text-slate-600 font-medium">Phạm Minh Đức</td>
<td class="p-4">
<span class="px-2.5 py-1 bg-purple-50 text-purple-700 rounded-full text-[11px] font-bold">Tài chính</span>
</td>
<td class="p-4 text-sm text-slate-500 uppercase">PDF</td>
<td class="p-4 text-sm text-slate-500">0.9 MB</td>
<td class="p-4 text-sm text-slate-500">07:50 - 12/10/2023</td>
<td class="p-4 text-right">
<div class="flex items-center justify-end gap-2">
<button class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors">Xem trước</button>
<button class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><span class="material-symbols-outlined" data-icon="done">done</span></button>
<button class="p-1.5 text-error hover:bg-red-50 rounded-lg"><span class="material-symbols-outlined" data-icon="close">close</span></button>
</div>
</td>
</tr>
<!-- Row 5 -->
<tr class="hover:bg-slate-50/50 transition-colors group">
<td class="p-4"><input class="rounded border-slate-300" type="checkbox"/></td>
<td class="p-4">
<div class="flex items-center gap-3">
<div class="w-8 h-10 bg-green-50 text-green-600 flex items-center justify-center rounded">
<span class="material-symbols-outlined text-[20px]" data-icon="article">article</span>
</div>
<div>
<p class="font-bold text-slate-900 text-sm">Giai_trinh_du_an_A.docx</p>
<p class="text-[10px] text-slate-400">ID: DOC-00925</p>
</div>
</div>
</td>
<td class="p-4 text-sm text-slate-600 font-medium">Vũ Thị Loan</td>
<td class="p-4">
<span class="px-2.5 py-1 bg-slate-100 text-slate-700 rounded-full text-[11px] font-bold">Kỹ thuật</span>
</td>
<td class="p-4 text-sm text-slate-500 uppercase">DOCX</td>
<td class="p-4 text-sm text-slate-500">3.2 MB</td>
<td class="p-4 text-sm text-slate-500">23:10 - 11/10/2023</td>
<td class="p-4 text-right">
<div class="flex items-center justify-end gap-2">
<button class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors">Xem trước</button>
<button class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><span class="material-symbols-outlined" data-icon="done">done</span></button>
<button class="p-1.5 text-error hover:bg-red-50 rounded-lg"><span class="material-symbols-outlined" data-icon="close">close</span></button>
</div>
</td>
</tr>
</tbody>
</table>
<!-- Pagination Footer -->
<div class="px-6 py-4 bg-surface-bright border-t border-slate-200 flex items-center justify-between">
<p class="text-sm text-slate-500">Hiển thị <span class="font-bold text-slate-900">1-5</span> trong số <span class="font-bold text-slate-900">15</span> tài liệu</p>
<div class="flex items-center gap-2">
<button class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-400 hover:bg-white disabled:opacity-50" disabled="">
<span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
</button>
<button class="w-8 h-8 flex items-center justify-center rounded-lg bg-blue-700 text-white font-bold text-sm">1</button>
<button class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white text-sm">2</button>
<button class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white text-sm">3</button>
<button class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white">
<span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
</button>
</div>
</div>
</div>
</div>
</div>
</main>
</body></html>
