<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>

<html class="light" lang="vi">

<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>DocuVerify VN - Quản lý Tài liệu</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link
            href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;200;300;400;500;600;700;800;900&amp;display=swap"
            rel="stylesheet"/>
    <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
            rel="stylesheet"/>
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
        <a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/overview">
            <span class="material-symbols-outlined mr-3" data-icon="dashboard">dashboard</span>
            <span>Tổng quan</span>
        </a>

        <a class="flex items-center px-6 py-3 bg-[#0555dd] text-white border-l-4 border-blue-600 font-semibold transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/management-doc">
            <span class="material-symbols-outlined mr-3 text-white" data-icon="description">description</span>
            <span>Quản lý Tài liệu</span>
        </a>

        <a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/user-admin">
            <span class="material-symbols-outlined mr-3" data-icon="group">group</span>
            <span>Quản lý Người dùng</span>
        </a>

        <a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/category-admin">
            <span class="material-symbols-outlined mr-3" data-icon="category">category</span>
            <span>Danh mục</span>
        </a>

        <a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/statistics">
            <span class="material-symbols-outlined mr-3" data-icon="leaderboard">leaderboard</span>
            <span>Thống kê</span>
        </a>

        <a class="flex items-center px-6 py-3 text-slate-600 hover:bg-slate-50 hover:pl-8 transition-all duration-200 active:scale-[0.98]"
           href="${pageContext.request.contextPath}/admin/settings">
            <span class="material-symbols-outlined mr-3" data-icon="settings">settings</span>
            <span>Cài đặt</span>
        </a>
    </nav>
</aside>
<main class="flex-grow ml-[260px] min-h-screen">
    <!-- TopAppBar -->
    <header
            class="sticky top-0 w-full h-16 border-b border-slate-200 bg-white/90 backdrop-blur-md z-40 shadow-sm flex justify-between items-center px-6">
        <div class="flex flex-col">
            <h2 class="text-xl font-bold text-blue-700 leading-tight">Quản lý Tài liệu</h2>
            <p class="text-xs text-slate-500 font-medium">Xem xét và quản lý toàn bộ tài liệu trên hệ thống</p>
        </div>
        <div class="flex items-center gap-4">
            <button
                    class="flex items-center gap-2 px-4 py-2 border border-blue-700 text-blue-700 rounded-xl font-semibold hover:bg-blue-50 transition-colors">
                        <span class="material-symbols-outlined text-[20px]"
                              data-icon="file_download">file_download</span>
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
                    <img alt="Administrator Profile" class="w-full h-full object-cover"
                         data-alt="A professional headshot of a corporate administrator, wearing a sharp navy blue suit and a clean white shirt. The lighting is soft and flattering, creating a premium light-mode aesthetic with high clarity. The background is a blurred high-end office environment with soft blue and white highlights, maintaining a sophisticated professional tone."
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuDGHxk49jIrSBKOiNI5fUbJYGPxX9ptw0X-pK-4wlJID8r7broWNr8TmotwHqoPJ5u54GPg1I0SL1Wk0P0EBZZeEh26dtYiEHC5w5lCfZ18qQwdViBJ7P3R_4cfp8o2TCFc93ks5lW1OBrX_73c1QTAhxuBhiB8I9zrv93eH6aS60Dwzs_2u4xCfKOJW7bLuP3aI_BGVmQk2xIG2WMjzxd5qfq682zUlTZ209o2niS8FtkN1TdUqbd51JznMpSDs3spM8SPByngBHo"/>
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
            <div
                    class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
                <div>
                    <p class="text-slate-500 text-label-md mb-xs">Chờ duyệt</p>
                    <h3 class="text-display text-primary leading-none">${pendingDocs != null ? pendingDocs : 0}</h3>
                    <p class="text-caption text-tertiary-container mt-sm font-semibold flex items-center gap-1">
                        <span class="material-symbols-outlined text-[14px]" data-icon="pending">pending</span>
                        Cần xử lý gấp
                    </p>
                </div>
                <div class="p-sm bg-blue-50 rounded-full">
                            <span class="material-symbols-outlined text-blue-700"
                                  data-icon="hourglass_empty">hourglass_empty</span>
                </div>
            </div>
            <div
                    class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
                <div>
                    <p class="text-slate-500 text-label-md mb-xs">Đã duyệt</p>
                    <h3 class="text-display text-slate-900 leading-none">${approvedDocs != null ? approvedDocs : 0}</h3>
                    <p class="text-caption text-emerald-600 mt-sm font-semibold flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]"
                                      data-icon="trending_up">trending_up</span>
                        +12% tháng này
                    </p>
                </div>
                <div class="p-sm bg-emerald-50 rounded-full">
                            <span class="material-symbols-outlined text-emerald-600"
                                  data-icon="check_circle">check_circle</span>
                </div>
            </div>
            <div
                    class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
                <div>
                    <p class="text-slate-500 text-label-md mb-xs">Vi phạm</p>
                    <h3 class="text-display text-error leading-none">${violationDocs != null ? violationDocs : 0}</h3>
                    <p class="text-caption text-error mt-sm font-semibold flex items-center gap-1">
                        <span class="material-symbols-outlined text-[14px]" data-icon="warning">warning</span>
                        Cần rà soát lại
                    </p>
                </div>
                <div class="p-sm bg-red-50 rounded-full">
                            <span class="material-symbols-outlined text-error"
                                  data-icon="report_problem">report_problem</span>
                </div>
            </div>
            <div
                    class="bg-white p-lg rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex items-start justify-between">
                <div>
                    <p class="text-slate-500 text-label-md mb-xs">Tổng tài liệu</p>
                    <h3 class="text-display text-slate-900 leading-none">${totalDocs != null ? totalDocs : 0}</h3>
                    <p class="text-caption text-slate-500 mt-sm font-semibold flex items-center gap-1">
                        <span class="material-symbols-outlined text-[14px]" data-icon="storage">storage</span>
                        Hệ thống ổn định</p>
                </div>
                <div class="p-sm bg-slate-100 rounded-full">
                    <span class="material-symbols-outlined text-slate-600" data-icon="folder">folder</span>
                </div>
            </div>
        </div>
        <!-- Section 2: Tab Navigation -->
        <div class="flex border-b border-slate-200 mb-6 overflow-x-auto">
            <a class="whitespace-nowrap px-4 py-2 text-sm font-medium transition-colors ${currentTab == -1 ? 'text-blue-700 border-b-2 border-blue-700' : 'text-slate-500 hover:text-slate-700'}"
               href="${pageContext.request.contextPath}/admin/management-doc?tab=-1">
                Tất cả tài liệu
                <span class="ml-2 bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full text-[10px]">${totalDocs != null ? totalDocs : 0}</span>
            </a>
            <a class="px-4 py-2 text-sm font-medium transition-colors ${currentTab == 0 || empty currentTab ? 'text-blue-700 border-b-2 border-blue-700' : 'text-slate-500 hover:text-slate-700'}"
               href="${pageContext.request.contextPath}/admin/management-doc?tab=0">
                Đang chờ duyệt
                <span class="ml-2 bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full text-[10px]">${pendingDocs}</span>
            </a>

            <a class="px-4 py-2 text-sm font-medium transition-colors ${currentTab == 1 ? 'text-blue-700 border-b-2 border-blue-700' : 'text-slate-500 hover:text-slate-700'}"
               href="${pageContext.request.contextPath}/admin/management-doc?tab=1">
                Đã duyệt
            </a>

            <a class="px-4 py-2 text-sm font-medium transition-colors ${currentTab == 2 ? 'text-blue-700 border-b-2 border-blue-700' : 'text-slate-500 hover:text-slate-700'}"
               href="${pageContext.request.contextPath}/admin/management-doc?tab=2">
                Vi phạm
            </a>
        </div>
        <!-- Section 3: Tab Content -->
        <div class="space-y-lg">
            <!-- Yellow Banner -->
            <div class="bg-[#FFF9E6] border border-[#FFE082] rounded-xl p-md flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-white rounded-full shadow-sm text-[#FBC02D]">
                                <span class="material-symbols-outlined"
                                      data-icon="notification_important">notification_important</span>
                    </div>
                    <p class="text-sm font-medium text-[#7F5F01]">Có ${pendingDocs != null ? pendingDocs : 0} tài liệu
                        đang chờ được xét duyệt. Vui lòng kiểm tra để đảm bảo tiến độ hệ thống.</p>
                </div>
                <button
                        class="px-5 py-2 bg-[#FBC02D] hover:bg-[#F9A825] text-white font-bold rounded-lg shadow-sm transition-all transform active:scale-95">
                    Duyệt tất cả
                </button>
            </div>
            <!-- Filter Bar -->
            <div class="bg-white p-md rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 flex flex-wrap items-center gap-md">

                <div class="relative flex-grow min-w-[300px]">
                    <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
                          data-icon="search">search</span>
                    <input id="searchInput"
                           class="w-full pl-10 pr-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-700 text-sm transition-all"
                           placeholder="Tìm kiếm nhanh tên tài liệu, người tải lên..." type="text"/>
                </div>

                <select id="categoryFilter"
                        class="px-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700">
                    <option value="all">Danh mục: Tất cả</option>
                    <c:forEach items="${listCategories}" var="cat">
                        <option value="${cat.name}">${cat.name}</option>
                    </c:forEach>
                </select>

                <select id="formatFilter"
                        class="px-4 py-2.5 bg-surface-bright border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-100 focus:border-blue-700">
                    <option value="all">Định dạng: Tất cả</option>
                    <option value="pdf">PDF</option>
                    <option value="docx">DOCX</option>
                    <option value="jpg">JPG/PNG</option>
                </select>

                <button id="resetFilterBtn"
                        class="p-2.5 text-slate-600 border border-slate-200 rounded-xl hover:bg-blue-50 hover:text-blue-700 transition-colors"
                        title="Đặt lại bộ lọc">
                    <span class="material-symbols-outlined" data-icon="sync">sync</span>
                </button>
            </div>
            <!-- Pending Documents Table -->
            <div
                    class="bg-white rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-slate-200 overflow-hidden">
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="bg-surface-bright border-b border-slate-200">
                        <th class="p-4 w-10">
                            <input class="rounded border-slate-300 text-blue-700 focus:ring-blue-700"
                                   type="checkbox"/>
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Tài liệu
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Người tải
                            lên
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Danh mục
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Định dạng
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Kích thước
                        </th>
                        <th class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider">Thời gian
                            tải
                        </th>
                        <th
                                class="p-4 font-bold text-slate-700 text-sm uppercase tracking-wider text-right">
                            Thao tác
                        </th>
                    </tr>
                    </thead>
                    <tbody id="documentTableBody" class="divide-y divide-slate-100">
                    <c:forEach items="${listDocs}" var="doc">
                        <tr class="document-row hover:bg-slate-50/50 transition-colors group"
                            data-category="${doc.categoryName}"
                            data-format="${doc.fileExtension}">
                            <td class="p-4">
                                <input class="rounded border-slate-300 text-blue-700 focus:ring-blue-700"
                                       type="checkbox" value="${doc.id}"/>
                            </td>
                            <td class="p-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-10 bg-blue-50 text-blue-600 flex items-center justify-center rounded">
                                        <span class="material-symbols-outlined text-[20px]" data-icon="description">description</span>
                                    </div>
                                    <div>
                                        <p class="font-bold text-slate-900 text-sm">${doc.fileName}</p>
                                        <p class="text-[10px] text-slate-400">ID: DOC-${doc.id}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="p-4 text-sm text-slate-600 font-medium">${doc.uploaderName}</td>
                            <td class="p-4">
                                <c:choose>
                                    <c:when test="${doc.categoryName == 'Nhân sự'}">
                                        <span class="px-2.5 py-1 bg-blue-50 text-blue-700 rounded-full text-[11px] font-bold">${doc.categoryName}</span>
                                    </c:when>
                                    <c:when test="${doc.categoryName == 'Tài chính'}">
                                        <span class="px-2.5 py-1 bg-purple-50 text-purple-700 rounded-full text-[11px] font-bold">${doc.categoryName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2.5 py-1 bg-slate-100 text-slate-700 rounded-full text-[11px] font-bold">
                                                ${not empty doc.categoryName ? doc.categoryName : 'Khác'}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="p-4 text-sm text-slate-500 uppercase">${doc.fileExtension}</td>
                            <td class="p-4 text-sm text-slate-500">
                                <fmt:formatNumber value="${doc.fileSize / 1048576.0}" maxFractionDigits="2"/> MB
                            </td>
                            <td class="p-4 text-sm text-slate-500">
                                <fmt:formatDate value="${doc.createdAtDate}" pattern="HH:mm - dd/MM/yyyy"/>
                            </td>
                            <td class="p-4 text-right">
                                <div class="flex items-center justify-end gap-2">
                                    <c:set var="vUrl" value="${doc.viewUrl}" />
                                    <a href="${vUrl.startsWith('http') ? vUrl : pageContext.request.contextPath.concat(vUrl)}"
                                       target="_blank"
                                       class="px-3 py-1.5 text-xs font-bold text-blue-700 border border-blue-200 rounded-lg hover:bg-blue-50 transition-colors inline-block text-center">
                                        Xem
                                    </a>

                                        <%-- Nút Duyệt: Biến thẻ <button> thành thẻ <a> để gọi Servlet Update --%>
                                    <c:if test="${doc.isActive == 0}">
                                        <a href="${pageContext.request.contextPath}/admin/update-doc-status?id=${doc.id}&status=1"
                                           class="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg inline-block" title="Duyệt">
                                            <span class="material-symbols-outlined">done</span>
                                        </a>
                                    </c:if>

                                        <%-- Nút Xóa/Từ chối: Biến thẻ <button> thành thẻ <a> để gọi Servlet Update --%>
                                    <a href="${pageContext.request.contextPath}/admin/update-doc-status?id=${doc.id}&status=2"
                                       class="p-1.5 text-error hover:bg-red-50 rounded-lg inline-block" title="Xóa"
                                       onclick="return confirm('Bạn có chắc chắn muốn chuyển tài liệu này sang Vi phạm / Xóa không?')">
                                        <span class="material-symbols-outlined" data-icon="close">close</span>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listDocs}">
                        <tr>
                            <td colspan="8" class="p-8 text-center text-slate-500">Chưa có tài liệu nào trên hệ thống.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- Pagination Footer -->
                <div class="px-6 py-4 bg-surface-bright border-t border-slate-200 flex items-center justify-between">
                    <p class="text-sm text-slate-500">Hiển thị <span class="font-bold text-slate-900">
                        <c:out value="${empty listDocs ? 0 : 1}"/> - <c:out value="${fn:length(listDocs)}"/>
                    </span> trong số <span class="font-bold text-slate-900">${totalDocs != null ? totalDocs : 0}</span>
                        tài liệu</p>
                    <div class="flex items-center gap-2">
                        <button
                                class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-400 hover:bg-white disabled:opacity-50"
                                disabled="">
                            <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
                        </button>
                        <button
                                class="w-8 h-8 flex items-center justify-center rounded-lg bg-blue-700 text-white font-bold text-sm">
                            1
                        </button>
                        <button
                                class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white text-sm">
                            2
                        </button>
                        <button
                                class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white text-sm">
                            3
                        </button>
                        <button
                                class="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 text-slate-600 hover:bg-white">
                                    <span class="material-symbols-outlined"
                                          data-icon="chevron_right">chevron_right</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");
        const categoryFilter = document.getElementById("categoryFilter");
        const formatFilter = document.getElementById("formatFilter");
        const resetFilterBtn = document.getElementById("resetFilterBtn");

        const tableRows = document.querySelectorAll("#documentTableBody .document-row");

        function filterTable() {
            const keyword = searchInput.value.toLowerCase().trim();
            const category = categoryFilter.value;
            const format = formatFilter.value;

            tableRows.forEach(row => {
                // Lấy nội dung text của cả hàng để tìm kiếm chữ
                const textContent = row.textContent.toLowerCase();
                const rowCategory = row.getAttribute("data-category");
                const rowFormat = (row.getAttribute("data-format") || "").toLowerCase();

                let isMatch = true;

                // 1. Kiểm tra từ khóa
                if (keyword && !textContent.includes(keyword)) {
                    isMatch = false;
                }

                // 2. Kiểm tra danh mục
                if (category !== "all" && rowCategory !== category) {
                    isMatch = false;
                }

                // 3. Kiểm tra định dạng
                if (format !== "all") {
                    if (format === 'jpg') {
                        if (rowFormat !== 'jpg' && rowFormat !== 'png' && rowFormat !== 'jpeg') isMatch = false;
                    } else if (rowFormat !== format) {
                        isMatch = false;
                    }
                }

                // Hiển thị hoặc ẩn hàng
                row.style.display = isMatch ? "" : "none";
            });
        }

        // Bắt sự kiện mỗi khi người dùng gõ phím hoặc chọn dropdown
        searchInput.addEventListener("input", filterTable);
        categoryFilter.addEventListener("change", filterTable);
        formatFilter.addEventListener("change", filterTable);

        // Nút đặt lại bộ lọc
        resetFilterBtn.addEventListener("click", function () {
            searchInput.value = "";
            categoryFilter.value = "all";
            formatFilter.value = "all";
            filterTable();
        });
    });
</script>
</body>

</html>