<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Quản lý Người dùng - DocAdmin</title>
<script src="${pageContext.request.contextPath}/js/admin.js"></script>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-variant": "#e1e2ed",
                    "on-surface": "#191b23",
                    "on-secondary-fixed": "#151c27",
                    "surface-container-high": "#e7e7f3",
                    "inverse-primary": "#b4c5ff",
                    "background": "#faf8ff",
                    "surface-container-low": "#f3f3fe",
                    "secondary-container": "#dce2f3",
                    "on-background": "#191b23",
                    "on-secondary-fixed-variant": "#404754",
                    "secondary-fixed-dim": "#c0c7d6",
                    "secondary-fixed": "#dce2f3",
                    "outline": "#737686",
                    "on-tertiary-fixed-variant": "#832600",
                    "primary-fixed-dim": "#b4c5ff",
                    "on-primary-fixed-variant": "#003ea7",
                    "secondary": "#585f6c",
                    "error": "#ba1a1a",
                    "error-container": "#ffdad6",
                    "surface-bright": "#faf8ff",
                    "primary-container": "#0555dd",
                    "on-error-container": "#93000a",
                    "outline-variant": "#c3c6d7",
                    "surface-container": "#ededf9",
                    "primary": "#0040ab",
                    "tertiary-fixed-dim": "#ffb59d",
                    "inverse-on-surface": "#f0f0fb",
                    "on-tertiary-fixed": "#390c00",
                    "surface-tint": "#0053da",
                    "on-tertiary": "#ffffff",
                    "on-primary": "#ffffff",
                    "surface-container-highest": "#e1e2ed",
                    "on-secondary": "#ffffff",
                    "surface-container-lowest": "#ffffff",
                    "on-secondary-container": "#5e6572",
                    "tertiary-fixed": "#ffdbd0",
                    "surface-dim": "#d9d9e5",
                    "on-tertiary-container": "#ffd2c4",
                    "tertiary": "#862700",
                    "inverse-surface": "#2e3039",
                    "on-surface-variant": "#434655",
                    "on-primary-container": "#d1daff",
                    "surface": "#faf8ff",
                    "tertiary-container": "#af3600",
                    "on-primary-fixed": "#00174b",
                    "primary-fixed": "#dbe1ff",
                    "on-error": "#ffffff"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "2xl": "48px",
                    "sm": "8px",
                    "xs": "4px",
                    "base": "4px",
                    "lg": "24px",
                    "gutter": "16px",
                    "container-margin": "24px",
                    "xl": "32px",
                    "md": "16px"
            },
            "fontFamily": {
                    "label-sm": ["Be Vietnam Pro"],
                    "h2": ["Be Vietnam Pro"],
                    "h3": ["Be Vietnam Pro"],
                    "caption": ["Be Vietnam Pro"],
                    "display": ["Be Vietnam Pro"],
                    "h1": ["Be Vietnam Pro"],
                    "body-md": ["Be Vietnam Pro"],
                    "label-md": ["Be Vietnam Pro"],
                    "body-lg": ["Be Vietnam Pro"]
            }
          }
        }
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background-color: #faf8ff;
        }
    </style>
</head>
<body class="text-on-surface">
<!-- SideNavBar Shell -->
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
<a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/management-doc.jsp">
<span class="material-symbols-outlined mr-3" data-icon="description">description</span>
<span>Quản lý Tài liệu</span>
</a>
<!-- Active State: User Management (Quản lý Người dùng) -->
<a class="flex items-center px-6 py-3 bg-[#0555dd] text-white border-l-4 border-blue-600 font-semibold transition-all duration-200 active:scale-[0.98]" href="${pageContext.request.contextPath}/page/user-admin.jsp">
<span class="material-symbols-outlined mr-3 text-white" data-icon="group">group</span>
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
<!-- Main Content Area -->
<main class="ml-[260px] min-h-screen">
<!-- TopAppBar -->
<header class="sticky top-0 w-full h-16 bg-white border-b border-slate-200 shadow-sm flex justify-between items-center px-6 z-40">
<div class="flex items-center gap-4">
<div class="relative">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" data-icon="search">search</span>
<input class="pl-10 pr-4 py-2 bg-slate-50 border-none rounded-xl text-sm w-80 focus:ring-2 focus:ring-blue-100 outline-none" placeholder="Tìm kiếm hệ thống..." type="text"/>
</div>
</div>
<div class="flex items-center gap-4">
<div class="flex items-center gap-2 p-1 rounded-full hover:bg-slate-50 transition-colors cursor-pointer">
<span class="material-symbols-outlined text-slate-500" data-icon="notifications">notifications</span>
</div>
<div class="flex items-center gap-2 p-1 rounded-full hover:bg-slate-50 transition-colors cursor-pointer">
<span class="material-symbols-outlined text-slate-500" data-icon="help">help</span>
</div>
<div class="h-8 w-px bg-slate-200 mx-1"></div>
<div class="flex items-center gap-3 cursor-pointer group">
<div class="text-right">
<p class="text-sm font-bold text-slate-700 leading-none">Admin User</p>
<p class="text-[10px] text-slate-400 uppercase tracking-wider font-semibold">Quản trị viên</p>
</div>
<img alt="Admin" class="w-10 h-10 rounded-xl object-cover border-2 border-white shadow-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA9c1huBIgh0JIsrrzy6hTSiUF84szi_aQUIg7Sfv5Qp0Zmf3kySvY3fTGj_p8MaUTiYO8Gcnn-PwJZoqUjAifp_XrOJUSwocPHy_Aq9oU8b1pktxKXzKBs8521vT8vtG1O29_NSUjzJTgfrVX9Q9lwuuZmegIXncGe7YWAne9tfMOuIlll5CwX4AQrYjAzK2Bnq8B1PWqco6xQe8z6p9xlYaLlamW7ApLjeNbixZIqC_1YcbobcG6OL2heg7_xpIYtYC3bDPsLtOs"/>
</div>
</div>
</header>
<!-- Content Canvas -->
<div class="p-8">
<!-- Header Section -->
<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
<div>
<h1 class="font-h1 text-h1 text-on-surface mb-1">Quản lý Người dùng</h1>
<p class="font-body-md text-slate-500">Xem xét, phân quyền và quản lý tài khoản thành viên</p>
</div>
<div class="flex items-center gap-3">
<button class="flex items-center gap-2 px-5 py-2.5 rounded-xl border border-slate-200 text-slate-700 font-semibold hover:bg-slate-50 transition-all active:scale-95">
<span class="material-symbols-outlined text-xl" data-icon="file_download">file_download</span>
                        Xuất danh sách
                    </button>
<button class="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-primary text-white font-semibold hover:bg-blue-800 transition-all shadow-md shadow-blue-100 active:scale-95">
<span class="material-symbols-outlined text-xl" data-icon="person_add">person_add</span>
                        Thêm người dùng
                    </button>
</div>
</div>
<!-- Stats Grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter mb-8">
<div class="bg-white p-lg rounded-xl border border-slate-200 shadow-[0_1px_3px_rgba(0,0,0,0.08)] flex items-center gap-4">
<div class="w-14 h-14 rounded-full bg-blue-50 flex items-center justify-center text-blue-700">
<span class="material-symbols-outlined text-3xl" data-icon="group">group</span>
</div>
<div>
<p class="text-caption font-caption text-slate-500">Tổng người dùng</p>
<h2 class="font-h1 text-h1 text-on-surface">3,874</h2>
</div>
</div>
<div class="bg-white p-lg rounded-xl border border-slate-200 shadow-[0_1px_3px_rgba(0,0,0,0.08)] flex items-center gap-4">
<div class="w-14 h-14 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600">
<span class="material-symbols-outlined text-3xl" data-icon="how_to_reg">how_to_reg</span>
</div>
<div>
<p class="text-caption font-caption text-slate-500">Đang hoạt động</p>
<h2 class="font-h1 text-h1 text-on-surface">3,241</h2>
</div>
</div>
<div class="bg-white p-lg rounded-xl border border-slate-200 shadow-[0_1px_3px_rgba(0,0,0,0.08)] flex items-center gap-4">
<div class="w-14 h-14 rounded-full bg-rose-50 flex items-center justify-center text-rose-600">
<span class="material-symbols-outlined text-3xl" data-icon="block">block</span>
</div>
<div>
<p class="text-caption font-caption text-slate-500">Tài khoản bị khóa</p>
<h2 class="font-h1 text-h1 text-on-surface">24</h2>
</div>
</div>
<div class="bg-white p-lg rounded-xl border border-slate-200 shadow-[0_1px_3px_rgba(0,0,0,0.08)] flex items-center gap-4">
<div class="w-14 h-14 rounded-full bg-amber-50 flex items-center justify-center text-amber-600">
<span class="material-symbols-outlined text-3xl" data-icon="person_add_alt">person_add_alt</span>
</div>
<div>
<p class="text-caption font-caption text-slate-500">Đăng ký hôm nay</p>
<h2 class="font-h1 text-h1 text-on-surface">18</h2>
</div>
</div>
</div>
<!-- Filters Bar -->
<div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm mb-6 flex flex-wrap items-center gap-4">
<div class="flex-1 min-w-[280px] relative">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" data-icon="search">search</span>
<input class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700 outline-none transition-all" placeholder="Tìm theo tên, email, MSSV..." type="text"/>
</div>
<div class="flex items-center gap-3">
<select class="bg-slate-50 border border-slate-200 rounded-xl text-sm px-4 py-2.5 outline-none focus:ring-2 focus:ring-blue-100 min-w-[120px]">
<option value="">Vai trò</option>
<option value="admin">Admin</option>
<option value="user">User</option>
</select>
<select class="bg-slate-50 border border-slate-200 rounded-xl text-sm px-4 py-2.5 outline-none focus:ring-2 focus:ring-blue-100 min-w-[140px]">
<option value="">Trạng thái</option>
<option value="active">Hoạt động</option>
<option value="locked">Bị khóa</option>
<option value="unverified">Chưa xác thực</option>
</select>
<button class="bg-slate-50 border border-slate-200 rounded-xl text-sm px-4 py-2.5 flex items-center gap-2 text-slate-600 hover:bg-slate-100 transition-colors">
<span class="material-symbols-outlined text-lg" data-icon="sort">sort</span>
                        Sắp xếp
                    </button>
</div>
</div>
<!-- Data Table -->
<div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
<div class="overflow-x-auto">
<table class="w-full text-left border-collapse">
<thead>
<tr class="bg-slate-50 border-b border-slate-200">
<th class="py-4 px-6 w-12">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/>
</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider">Người dùng</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider">MSSV</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider">Vai trò</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider text-center">Tài liệu đã tải</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider">Lần đăng nhập cuối</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider">Trạng thái</th>
<th class="py-4 px-6 text-label-sm font-label-sm text-slate-500 uppercase tracking-wider text-right">Thao tác</th>
</tr>
</thead>
<tbody class="divide-y divide-slate-100">
<!-- Row 1 -->
<tr class="hover:bg-slate-50/50 transition-colors">
<td class="py-4 px-6">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/>
</td>
<td class="py-4 px-6">
<div class="flex items-center gap-3">
<img alt="User" class="w-10 h-10 rounded-full border border-slate-100" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAjHJ_TokFddHGakLf4r9Tp2jglCS73FuThSmvYaF4R8A-693tOcw8rXIaFYgJ031M0kzzHMzOvlN1AdeCDeH8EXtUFp4ECfebNCsI00vesGylrDPhtOapzgMTxnxkc7NQ3BWzGGDGcdNOKcA1yR0txUncbULNKAW8ouydL4yOZLW1aPr8imbZUGB2T2NaR_YdZ3tZ8YJ8wDOuO3XVIYOlFmPj9p7Ax-TWC8BLSWUuZeqKnPvfy7Efyew7KZ8ayyoA3UZQaSBRmNlQ"/>
<div>
<p class="font-semibold text-slate-800">Huỳnh Thị Thanh Trúc</p>
<p class="text-xs text-slate-500">truc.ht@university.edu.vn</p>
</div>
</div>
</td>
<td class="py-4 px-6 text-body-md font-medium text-slate-600">23130350</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-blue-100 text-blue-700">Admin</span>
</td>
<td class="py-4 px-6 text-center text-body-md text-slate-600">48 tài liệu</td>
<td class="py-4 px-6 text-body-md text-slate-600">10:45 - 24/05/2024</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-emerald-100 text-emerald-700">Hoạt động</span>
</td>
<td class="py-4 px-6 text-right">
<button class="p-2 text-slate-400 hover:text-blue-700 transition-colors">
<span class="material-symbols-outlined" data-icon="edit">edit</span>
</button>
<button class="p-2 text-slate-400 hover:text-rose-600 transition-colors">
<span class="material-symbols-outlined" data-icon="delete">delete</span>
</button>
</td>
</tr>
<!-- Row 2 -->
<tr class="hover:bg-slate-50/50 transition-colors">
<td class="py-4 px-6">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/>
</td>
<td class="py-4 px-6">
<div class="flex items-center gap-3">
<img alt="User" class="w-10 h-10 rounded-full border border-slate-100" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD83DFAxX_TtSWA6Z4wRpx0T9DZU4qyGRbn9O-aYxh88BFiw1u1ZSrC6Rp_JVUoRMhTt5hfYhFCRReYF-awBxeoPxJw5p3FG8uHivTG8SQyMe0_AA92FjuC9iySFrDrnq_aNz93ppRO4m-o_f-OhfcOz50ukUzUkhXyG-qAPeGdthY86i9QCNApxuJ5D1cURtUO1EuHelXpsb3-nWJcZWN6cPU4xat90OdoetYxNtAsqXMB3OWYwyMW1UaYT6bKty2Kl9ou6Jbc_k0"/>
<div>
<p class="font-semibold text-slate-800">Trần Thị Quỳnh Trâm</p>
<p class="text-xs text-slate-500">tram.ttq@university.edu.vn</p>
</div>
</div>
</td>
<td class="py-4 px-6 text-body-md font-medium text-slate-600">23130341</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-slate-100 text-slate-600">User</span>
</td>
<td class="py-4 px-6 text-center text-body-md text-slate-600">12 tài liệu</td>
<td class="py-4 px-6 text-body-md text-slate-600">08:12 - 24/05/2024</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-emerald-100 text-emerald-700">Hoạt động</span>
</td>
<td class="py-4 px-6 text-right">
<button class="p-2 text-slate-400 hover:text-blue-700 transition-colors">
<span class="material-symbols-outlined" data-icon="edit">edit</span>
</button>
<button class="p-2 text-slate-400 hover:text-rose-600 transition-colors">
<span class="material-symbols-outlined" data-icon="delete">delete</span>
</button>
</td>
</tr>
<!-- Row 3 -->
<tr class="hover:bg-slate-50/50 transition-colors">
<td class="py-4 px-6">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/>
</td>
<td class="py-4 px-6">
<div class="flex items-center gap-3">
<img alt="User" class="w-10 h-10 rounded-full border border-slate-100" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCrBB4dpCPeiBHj80BS-LCIc8oEQIrD9aIKBjb1iNYQsuV9ZJW-B4qc2nq1zzUWwJmSbkiSq_VG9KmqJda7JCrTjbWhSvFK4Q2XQ7wbKh5ZyjwFsCDS8vX3wy9QI4FJ7nVFpc1_wM7zrW3iLcIWAt5oX2cOegeYefjIIp7l72XiodjUGI8S7pPNvfMy8PJsLagv4PhIZm7gcCyYcwHtfayeiZXC0JjfkHFotcnDqDihNwdidJzrOqgCahK_Iv51RM-_aPBwAsq9uMA"/>
<div>
<p class="font-semibold text-slate-800">Lê Văn Phong</p>
<p class="text-xs text-slate-500">phong.lv@university.edu.vn</p>
</div>
</div>
</td>
<td class="py-4 px-6 text-body-md font-medium text-slate-600">23130189</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-slate-100 text-slate-600">User</span>
</td>
<td class="py-4 px-6 text-center text-body-md text-slate-600">3 tài liệu</td>
<td class="py-4 px-6 text-body-md text-slate-600">15:30 - 20/05/2024</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-rose-100 text-rose-700">Bị khóa</span>
</td>
<td class="py-4 px-6 text-right">
<button class="p-2 text-slate-400 hover:text-blue-700 transition-colors">
<span class="material-symbols-outlined" data-icon="edit">edit</span>
</button>
<button class="p-2 text-slate-400 hover:text-rose-600 transition-colors">
<span class="material-symbols-outlined" data-icon="delete">delete</span>
</button>
</td>
</tr>
<!-- Row 4 -->
<tr class="hover:bg-slate-50/50 transition-colors">
<td class="py-4 px-6">
<input class="rounded border-slate-300 text-blue-700 focus:ring-blue-500" type="checkbox"/>
</td>
<td class="py-4 px-6">
<div class="flex items-center gap-3">
<img alt="User" class="w-10 h-10 rounded-full border border-slate-100" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBmnViHVBGuF1fNHVqAjkMI8cI-dMxSMSo0Bv6-7WEwVyf2OT9dMEsK5UEt7V3pt6_idIEsmABXpCAMcpoh-nk9h7M6lKz4P1c7WPuhFJI4ECtJ4pEf0r6QjYHIR38TEP-UxtzMRmJy89MZ_uQMgS39UiRJAdq_29NxPo7_8W_hAehQaZ2BUQjcktD_6K9HjZQikUL78zI-MN-cUtRxrtrMpAC-q9kIJY_aebT42RzO7F8m1PXWAwRTmny8vqREwKPe9NYHfGJhew8"/>
<div>
<p class="font-semibold text-slate-800">Phan Thị Lan</p>
<p class="text-xs text-slate-500">lan.pt@university.edu.vn</p>
</div>
</div>
</td>
<td class="py-4 px-6 text-body-md font-medium text-slate-600">23130301</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-slate-100 text-slate-600">User</span>
</td>
<td class="py-4 px-6 text-center text-body-md text-slate-600">0 tài liệu</td>
<td class="py-4 px-6 text-body-md text-slate-600">Chưa đăng nhập</td>
<td class="py-4 px-6">
<span class="px-3 py-1 rounded-full text-[12px] font-bold bg-amber-100 text-amber-700">Chưa xác thực</span>
</td>
<td class="py-4 px-6 text-right">
<button class="p-2 text-slate-400 hover:text-blue-700 transition-colors">
<span class="material-symbols-outlined" data-icon="edit">edit</span>
</button>
<button class="p-2 text-slate-400 hover:text-rose-600 transition-colors">
<span class="material-symbols-outlined" data-icon="delete">delete</span>
</button>
</td>
</tr>
</tbody>
</table>
</div>
<!-- Pagination -->
<div class="bg-slate-50 px-6 py-4 flex flex-col sm:flex-row items-center justify-between gap-4">
<p class="text-sm text-slate-500 font-medium">Hiển thị 1 - 10 trong tổng số 3,874 người dùng</p>
<div class="flex items-center gap-2">
<button class="w-10 h-10 flex items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-400 hover:text-blue-700 hover:border-blue-700 transition-all active:scale-95">
<span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
</button>
<button class="w-10 h-10 flex items-center justify-center rounded-xl bg-blue-700 text-white font-bold shadow-md shadow-blue-100">1</button>
<button class="w-10 h-10 flex items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 hover:text-blue-700 hover:border-blue-700 transition-all active:scale-95">2</button>
<button class="w-10 h-10 flex items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 hover:text-blue-700 hover:border-blue-700 transition-all active:scale-95">3</button>
<span class="text-slate-400 px-2">...</span>
<button class="w-10 h-10 flex items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-600 hover:text-blue-700 hover:border-blue-700 transition-all active:scale-95">388</button>
<button class="w-10 h-10 flex items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-400 hover:text-blue-700 hover:border-blue-700 transition-all active:scale-95">
<span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
</button>
</div>
</div>
</div>
</div>
</main>
</body></html>
