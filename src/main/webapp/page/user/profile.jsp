<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Hồ sơ cá nhân - DocShare</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/home.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet"/>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen flex flex-col">
    <jsp:include page="/common/header.jsp" />

    <!-- Profile Header Section -->
    <div class="bg-[#0555dd] w-full pt-12 pb-10">
        <div class="max-w-[1280px] mx-auto px-6 flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
            <div class="flex flex-col md:flex-row items-center md:items-start gap-8 w-full">
                <!-- Avatar -->
                <div class="w-32 h-32 md:w-[140px] md:h-[140px] rounded-full border-4 border-white overflow-hidden shrink-0 shadow-md">
                    <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuBdNPD2JiPV6VEO7xln8yjuCxG1QGiHdoK4mhoAi0XYJbOfHDgEjYVQCjZI--SfQVRz_jJvxt-ek3_XGs1am53WCuYMmAPyXCXtIJiajiKINvlM4WoPL0eqf2yWU6NNpaeB6TLHYOKnijC0HiecLoX8uH0_5xSnwV4JaQzlDt6_KOi_iJ-H9jgMtMfwhAztPujTmjaDWgfj_8uW1tOih8EMNEZDqVkTtvATiHooYNor8ezflhxx4gAEDUS1kVTlz48QYgSxznztuPfu" alt="Avatar" class="w-full h-full object-cover"/>
                </div>
                <!-- Info -->
                <div class="flex flex-col text-white pt-2 w-full md:w-auto text-center md:text-left">
                    <div class="flex items-center justify-center md:justify-start gap-3 mb-6">
                        <h1 class="text-2xl font-semibold font-manrope">${authUser.fullName}</h1>
                        <span class="px-3 py-0.5 bg-white/20 text-white text-xs rounded-full border border-white/30">${authUser.role == 'admin' ? 'Quản trị viên' : 'Học viên'}</span>
                    </div>
                    <div class="flex items-center justify-center md:justify-start gap-8">
                        <div>
                            <span class="block text-2xl font-bold font-manrope">${totalDocuments != null ? totalDocuments : 0}</span>
                            <span class="text-[10px] text-white/80 uppercase tracking-wide">Tài liệu</span>
                        </div>
                        <div class="w-px h-8 bg-white/20"></div>
                        <div>
                            <span class="block text-2xl font-bold font-manrope">${totalDownloads != null ? totalDownloads : 0}</span>
                            <span class="text-[10px] text-white/80 uppercase tracking-wide">Lượt tải</span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Edit Button -->
            <div class="shrink-0 mt-4 md:mt-4">
                <button class="bg-white text-[#0555dd] px-5 py-2.5 rounded-lg font-semibold text-sm flex items-center gap-2 hover:bg-slate-50 transition-colors shadow-sm">
                    <span class="material-symbols-outlined text-[18px]">edit</span>
                    Chỉnh sửa hồ sơ
                </button>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="max-w-[1280px] mx-auto px-6 w-full mt-4">
        <div class="flex border-b border-slate-200">
            <button class="px-6 py-4 text-sm transition-all active-tab">Thông tin cá nhân</button>
            <button class="px-6 py-4 text-sm text-slate-500 hover:text-[#0555dd] font-medium transition-all">Tài liệu của tôi</button>
        </div>
    </div>

    <!-- Main Content -->
    <main class="max-w-[1280px] mx-auto px-6 py-8 w-full flex-grow">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column -->
            <div id="personal-info-section" class="lg:col-span-1 space-y-6">
                <div class="bg-white p-6 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100">
                    <h3 class="text-base font-semibold text-slate-800 mb-4 font-manrope">Thông tin cá nhân</h3>
                    <div class="space-y-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0555dd] shrink-0">
                                <span class="material-symbols-outlined text-[20px]">mail</span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400 font-medium uppercase tracking-wide">Email</p>
                                <p class="text-sm font-medium text-slate-800">${authUser.email}</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0555dd] shrink-0">
                                <span class="material-symbols-outlined text-[20px]">calendar_today</span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400 font-medium uppercase tracking-wide">Ngày tham gia</p>
                                <p class="text-sm font-medium text-slate-800"><fmt:formatDate value="${authUser.createdAt}" pattern="dd/MM/yyyy" /></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div id="my-documents-section" class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100 overflow-hidden">
                    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
                        <h3 class="text-base font-semibold text-slate-800 font-manrope">Quản lý tài liệu</h3>
                        <a href="${pageContext.request.contextPath}/upload" class="bg-[#0555dd] text-white px-4 py-2.5 rounded-lg text-sm font-medium flex items-center gap-2 hover:bg-blue-700 transition-colors shadow-sm">
                            <span class="material-symbols-outlined text-[18px]">upload</span>
                            Tải lên mới
                        </a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                            <tr class="border-b border-slate-100">
                                <th class="px-6 py-4 text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Tên tài liệu</th>
                                <th class="px-6 py-4 text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Ngày đăng</th>
                                <th class="px-6 py-4 text-[11px] font-semibold text-slate-500 uppercase tracking-wider text-center">Tải về</th>
                                <th class="px-6 py-4 text-[11px] font-semibold text-slate-500 uppercase tracking-wider text-center">Trạng thái</th>
                                <th class="px-6 py-4"></th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${not empty myDocuments}">
                                    <c:forEach var="doc" items="${myDocuments}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="px-6 py-4">
                                                <div class="flex items-center gap-3">
                                                    <span class="material-symbols-outlined text-[#0555dd]">description</span>
                                                    <span class="font-medium text-sm text-slate-800">${doc.title}</span>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-slate-500">
                                                <c:if test="${doc.createdAt != null}">
                                                    ${doc.createdAt.dayOfMonth}/${doc.createdAt.monthValue}/${doc.createdAt.year}
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-center text-slate-600">${doc.downloadCount}</td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${doc.isActive == 1}">
                                                        <span class="px-2 py-1 bg-green-100 text-green-700 text-[10px] font-bold rounded uppercase tracking-wide">Công khai</span>
                                                    </c:when>
                                                    <c:when test="${doc.isActive == 0}">
                                                        <span class="px-2 py-1 bg-amber-100 text-amber-700 text-[10px] font-bold rounded uppercase tracking-wide">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${doc.isActive == 2}">
                                                        <span class="px-2 py-1 bg-red-100 text-red-700 text-[10px] font-bold rounded uppercase tracking-wide">Vi phạm (yêu cầu sửa lại)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2 py-1 bg-slate-100 text-slate-700 text-[10px] font-bold rounded uppercase tracking-wide">Khác</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-right">
                                                <div class="flex items-center justify-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/edit-document?id=${doc.id}" class="p-1.5 rounded hover:bg-blue-50 text-slate-400 hover:text-[#0555dd] transition-colors block" title="Chỉnh sửa">
                                                        <span class="material-symbols-outlined text-[20px]">edit</span>
                                                    </a>
                                                    <button class="btn-delete-doc p-1.5 rounded hover:bg-red-50 text-slate-400 hover:text-red-500 transition-colors" data-id="${doc.id}" title="Xóa">
                                                        <span class="material-symbols-outlined text-[20px] pointer-events-none">delete</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="px-6 py-8 text-center text-slate-500">
                                            Chưa có tài liệu nào.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-4 border-t border-slate-100 flex justify-center bg-white">
                        <button class="text-[#0555dd] font-semibold text-sm hover:underline">Xem tất cả tài liệu</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/common/footer.jsp" />

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 backdrop-blur-sm">
        <div class="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 transform transition-all scale-95 opacity-0" id="deleteModalContent">
            <div class="flex items-center gap-3 text-red-600 mb-4">
                <div class="w-10 h-10 rounded-full bg-red-50 flex items-center justify-center shrink-0">
                    <span class="material-symbols-outlined text-2xl">delete_forever</span>
                </div>
                <h3 class="text-lg font-bold font-manrope">Xác nhận xóa</h3>
            </div>
            <p class="text-slate-600 text-sm mb-6">Bạn có chắc chắn muốn xóa tài liệu này không? File trên hệ thống cũng sẽ bị xóa vĩnh viễn và không thể hoàn tác.</p>
            <div class="flex items-center justify-end gap-3">
                <button type="button" id="btnCancelDelete" class="px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">Hủy</button>
                <button type="button" id="btnConfirmDelete" class="px-4 py-2 text-sm font-medium text-white bg-red-600 hover:bg-red-700 rounded-lg transition-colors flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px] animate-spin hidden" id="deleteSpinner">sync</span>
                    <span id="deleteBtnText">Xóa tài liệu</span>
                </button>
            </div>
        </div>
    </div>

    <!-- Hidden element to pass context path to JS -->
    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">

    <script src="${pageContext.request.contextPath}/js/profile.js"></script>
</body>
</html>
