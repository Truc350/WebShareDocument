<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Chỉnh sửa tài liệu - DocShare</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;family=Inter:wght@400;500;600&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary-container": "#0555dd", "on-surface": "#191b23",
                        "secondary": "#505f76", "outline-variant": "#c3c6d7",
                        "surface-container-lowest": "#ffffff", "surface-container-low": "#f3f3fe",
                        "error": "#ba1a1a", "primary": "#0040ab", "background": "#faf8ff"
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .field-error {
            border-color: #ba1a1a !important;
        }

        .error-msg {
            color: #ba1a1a;
            font-size: 12px;
            margin-top: 4px;
        }
    </style>
</head>
<body class="bg-background font-sans text-on-surface min-h-screen flex flex-col">

<jsp:include page="/common/header.jsp"/>

<%-- ── UC15.1.8 / UC15.2.1.2: Flash messages từ session ──────────────── --%>
<c:if test="${not empty sessionScope.flashSuccess}">
    <div id="flash-success"
         class="fixed top-4 right-4 z-50 flex items-center gap-3 bg-green-50 border border-green-200 text-green-800 px-5 py-3 rounded-xl shadow-lg">
        <span class="material-symbols-outlined text-green-600">check_circle</span>
        <span class="text-sm font-medium">${sessionScope.flashSuccess}</span>
        <button onclick="this.parentElement.remove()" class="ml-2 text-green-600 hover:text-green-800">
            <span class="material-symbols-outlined text-[18px]">close</span>
        </button>
    </div>
    <c:remove var="flashSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flashError}">
    <div id="flash-error"
         class="fixed top-4 right-4 z-50 flex items-center gap-3 bg-red-50 border border-red-200 text-red-800 px-5 py-3 rounded-xl shadow-lg">
        <span class="material-symbols-outlined text-red-500">error</span>
        <span class="text-sm font-medium">${sessionScope.flashError}</span>
        <button onclick="this.parentElement.remove()" class="ml-2 text-red-500 hover:text-red-700">
            <span class="material-symbols-outlined text-[18px]">close</span>
        </button>
    </div>
    <c:remove var="flashError" scope="session"/>
</c:if>

<main class="flex-grow py-8 px-4 sm:px-6">
    <div class="max-w-[800px] mx-auto">

        <%-- ── UC15.1.1: Breadcrumb ──────────────────────────────────────── --%>
        <nav class="flex items-center gap-2 mb-6 text-sm text-slate-500">
            <a class="hover:text-[#0555dd] transition-colors"
               href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
            <a class="hover:text-[#0555dd] transition-colors"
               href="${pageContext.request.contextPath}/profile">Tài liệu của tôi</a>
            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
            <span class="font-semibold text-slate-800">Chỉnh sửa tài liệu</span>
        </nav>

        <%-- ── UC15 Exception 1: Lỗi toàn form ─────────────────────────── --%>
        <c:if test="${not empty globalError}">
            <div class="mb-4 flex items-center gap-3 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                <span class="material-symbols-outlined text-red-500">error</span>
                    ${globalError}
            </div>
        </c:if>

        <%-- ── UC15.1.3: Main Content Card ──────────────────────────────── --%>
        <div class="bg-white rounded-xl shadow-[0_4px_12px_rgba(0,0,0,0.05)] overflow-hidden">

            <%-- Card Header --%>
            <div class="p-6 border-b border-slate-100 bg-white">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-[#0555dd] text-3xl">edit_note</span>
                    <h1 class="text-2xl font-semibold font-manrope text-slate-800">Chỉnh sửa tài liệu</h1>
                </div>
                <p class="text-sm text-slate-500 mt-1">Cập nhật thông tin và cài đặt hiển thị cho tài liệu của bạn.</p>
            </div>

            <%-- ── UC15.1.4 / UC15.1.5: Form chỉnh sửa ────────────────── --%>
            <%-- action → POST /edit-document (UC15.1.5) --%>
            <form id="editDocumentForm"
                  action="${pageContext.request.contextPath}/edit-document"
                  method="post"
                  class="p-6 space-y-6"
                  novalidate>

                <%-- Hidden: documentId để servlet nhận biết tài liệu cần update --%>
                <input type="hidden" name="documentId" value="${document.id}"/>

                <%-- ── UC15.1.3 / UC15.1.6: Tên tài liệu (bắt buộc, ≤255) ─ --%>
                <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-slate-700" for="title">
                        Tên tài liệu <span class="text-red-500">*</span>
                    </label>
                    <input id="title" name="title" type="text"
                           maxlength="255"
                           value="${not empty inputTitle ? inputTitle : document.title}"
                           class="w-full px-4 py-2.5 bg-white border border-slate-300 rounded-lg
                              focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd]
                              outline-none transition-all text-sm
                              ${not empty titleError ? 'field-error' : ''}"/>
                    <%-- UC15.2.2.2: Hiển thị lỗi ngay bên dưới trường --%>
                    <c:if test="${not empty titleError}">
                        <p class="error-msg flex items-center gap-1">
                            <span class="material-symbols-outlined text-[14px]">error</span>
                                ${titleError}
                        </p>
                    </c:if>
                    <p class="text-xs text-slate-400" id="titleCounter">
                        <span id="titleLen">0</span>/255 ký tự
                    </p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <%-- ── UC15.1.3: Danh mục (Chủ đề) ─────────────────── --%>
                    <div class="space-y-1.5">
                        <label class="block text-sm font-medium text-slate-700" for="categoryId">
                            Danh mục
                        </label>
                        <div class="relative">
                            <select id="categoryId" name="categoryId"
                                    class="w-full appearance-none px-4 py-2.5 bg-white border border-slate-300
                                       rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd]
                                       outline-none transition-all text-sm pr-10">
                                <option value="">-- Không chọn --</option>
                                <%--                                <c:forEach var="cat" items="${categories}">--%>
                                <%--                                    <c:set var="catId" value="${cat[0]}"/>--%>
                                <%--                                    <c:set var="selectedCatId"--%>
                                <%--                                           value="${not empty inputCategoryId ? inputCategoryId : document.categoryId}"/>--%>
                                <%--                                    <option value="${catId}"--%>
                                <%--                                        ${catId == selectedCatId ? 'selected' : ''}>--%>
                                <%--                                            ${cat[1]}--%>
                                <%--                                    </option>--%>
                                <%--                                </c:forEach>--%>
                                <c:forEach var="cat" items="${categories}">

                                    <c:set var="selectedCatId"
                                           value="${not empty inputCategoryId ? inputCategoryId : document.categoryId}"/>

                                    <option value="${cat.id}"
                                        ${cat.id == selectedCatId ? 'selected' : ''}>

                                            ${cat.name}

                                    </option>

                                </c:forEach>
                            </select>
                            <span class="material-symbols-outlined absolute right-3 top-1/2
                                     -translate-y-1/2 pointer-events-none text-slate-400">
                            expand_more
                        </span>
                        </div>
                    </div>

                    <%-- ── UC15.1.3 / UC15.1.6: Tags ────────────────────── --%>
                    <div class="space-y-1.5">
                        <label class="block text-sm font-medium text-slate-700" for="tags">
                            Thẻ (Tags)
                        </label>
                        <div class="relative">
                        <span class="material-symbols-outlined absolute left-3 top-1/2
                                     -translate-y-1/2 text-slate-400 text-[20px]">sell</span>
                            <input id="tags" name="tags" type="text"
                                   placeholder="Ví dụ: SQL, Database, Cơ bản"
                                   value="${not empty inputTags ? inputTags : document.tagsAsString}"
                                   class="w-full pl-10 pr-4 py-2.5 bg-white border border-slate-300
                                      rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd]
                                      outline-none transition-all text-sm
                                      ${not empty tagsError ? 'field-error' : ''}"/>
                        </div>
                        <%-- UC15.2.2.2: Hiển thị lỗi tags --%>
                        <c:if test="${not empty tagsError}">
                            <p class="error-msg flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]">error</span>
                                    ${tagsError}
                            </p>
                        </c:if>
                        <p class="text-xs text-slate-400">Phân cách bằng dấu phẩy</p>
                    </div>
                </div>

                <%-- ── UC15.1.3: Mô tả tài liệu (≤2000 ký tự) ──────────── --%>
                <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-slate-700" for="description">
                        Mô tả tài liệu
                    </label>
                    <textarea id="description" name="description"
                              rows="4" maxlength="2000"
                              placeholder="Mô tả nội dung tài liệu..."
                              class="w-full px-4 py-2.5 bg-white border border-slate-300 rounded-lg
                                 focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd]
                                 outline-none transition-all text-sm resize-none
                                 ${not empty descriptionError ? 'field-error' : ''}"><c:out
                            value="${not empty inputDescription ? inputDescription : document.description}"/></textarea>
                    <%-- UC15.2.2.2: Hiển thị lỗi mô tả --%>
                    <c:if test="${not empty descriptionError}">
                        <p class="error-msg flex items-center gap-1">
                            <span class="material-symbols-outlined text-[14px]">error</span>
                                ${descriptionError}
                        </p>
                    </c:if>
                    <p class="text-xs text-slate-400">
                        <span id="descLen">0</span>/2000 ký tự
                    </p>
                </div>

                <%-- ── UC15.1.3: Trạng thái công khai (is_active) ────────── --%>
                <div class="space-y-2">
                    <label class="block text-sm font-medium text-slate-700">
                        Trạng thái hiển thị
                    </label>
                    <c:set var="currentPrivacy"
                           value="${not empty inputPrivacy ? inputPrivacy : (document.active ? 'public' : 'draft')}"/>
                    <div class="flex gap-6">
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="privacy" value="public"
                            ${currentPrivacy == 'public' ? 'checked' : ''}
                                   class="w-5 h-5 text-[#0555dd] focus:ring-[#0555dd] border-slate-300"/>
                            <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-slate-500
                                         group-hover:text-[#0555dd] transition-colors">public</span>
                                <span class="text-sm">Công khai</span>
                            </div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="privacy" value="draft"
                            ${currentPrivacy == 'draft' ? 'checked' : ''}
                                   class="w-5 h-5 text-[#0555dd] focus:ring-[#0555dd] border-slate-300"/>
                            <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-slate-500
                                         group-hover:text-[#0555dd] transition-colors">draft</span>
                                <span class="text-sm">Nháp</span>
                            </div>
                        </label>
                    </div>
                </div>

                <%-- ── UC15 Assumption 1: Hiển thị file hiện tại (không thay thế) ─ --%>
                <div class="p-4 bg-slate-50 rounded-lg border border-slate-200">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 bg-white rounded-lg flex items-center justify-center
                                    border border-slate-200 shrink-0">
                                <c:choose>
                                    <c:when test="${document.fileExtension == 'pdf'}">
                                        <span class="material-symbols-outlined text-red-500 text-3xl">picture_as_pdf</span>
                                    </c:when>
                                    <c:when test="${document.fileExtension == 'docx' or document.fileExtension == 'doc'}">
                                        <span class="material-symbols-outlined text-blue-600 text-3xl">article</span>
                                    </c:when>
                                    <c:when test="${document.fileExtension == 'xlsx' or document.fileExtension == 'xls'}">
                                        <span class="material-symbols-outlined text-green-600 text-3xl">table_chart</span>
                                    </c:when>
                                    <c:when test="${document.fileExtension == 'pptx' or document.fileExtension == 'ppt'}">
                                        <span class="material-symbols-outlined text-orange-500 text-3xl">present_to_all</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="material-symbols-outlined text-slate-500 text-3xl">description</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <p class="text-sm font-medium text-slate-700">Tệp hiện tại</p>
                                <p class="text-sm text-slate-500 truncate max-w-[200px] sm:max-w-xs">
                                    ${document.fileName}
                                </p>
                                <p class="text-xs text-slate-400 mt-0.5">
                                    <%-- File size: hiển thị KB/MB --%>
                                    <c:choose>
                                        <c:when test="${document.fileSize >= 1048576}">
                                            <fmt:formatNumber
                                                    value="${document.fileSize / 1048576.0}"
                                                    maxFractionDigits="1"/> MB
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber
                                                    value="${document.fileSize / 1024.0}"
                                                    maxFractionDigits="0"/> KB
                                        </c:otherwise>
                                    </c:choose>
                                    · .${document.fileExtension}
                                </p>
                            </div>
                        </div>
                        <%-- Assumption 1: Không thay thế file đã tải lên --%>
                        <div class="flex items-center gap-2 px-3 py-2 bg-slate-100 rounded-lg
                                text-xs text-slate-500 font-medium">
                            <span class="material-symbols-outlined text-[16px]">lock</span>
                            Không thể thay đổi tệp
                        </div>
                    </div>
                </div>

                <%-- ── UC15.2.3 / UC15.1.5: Action Buttons ──────────────── --%>
                <div class="flex items-center justify-end gap-3 pt-4 border-t border-slate-100">

                    <%-- UC15.2.3: Nút Huỷ – không lưu, quay về trang trước --%>
                    <button type="button" id="btnCancel"
                            class="px-6 py-2.5 border border-slate-300 text-slate-600 font-semibold
                               rounded-lg hover:bg-slate-50 transition-all text-sm">
                        Huỷ
                    </button>

                    <%-- UC15.1.5: Nút Lưu thay đổi --%>
                    <button type="submit" id="btnSave"
                            class="px-8 py-2.5 bg-[#0555dd] text-white font-semibold rounded-lg
                               hover:bg-blue-700 transition-all shadow-md active:opacity-80 text-sm
                               flex items-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed">
                        <span class="material-symbols-outlined text-[18px]" id="btnSaveIcon">save</span>
                        <span id="btnSaveText">Lưu thay đổi</span>
                    </button>
                </div>
            </form>
        </div>

    </div>
</main>

<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/edit-document.js"></script>
</body>
</html>
