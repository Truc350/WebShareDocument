<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>Chỉnh sửa tài liệu - Admin</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>body { font-family: 'Be Vietnam Pro', sans-serif; background-color: #f8fafc; }</style>
</head>
<body class="p-8 flex justify-center items-center min-h-screen">

<div class="w-full max-w-2xl bg-white p-8 rounded-2xl shadow-[0_4px_20px_rgba(0,0,0,0.05)] border border-slate-200">
    <div class="flex items-center gap-3 mb-6 border-b border-slate-100 pb-4">
        <span class="material-symbols-outlined text-blue-600 text-3xl">edit_document</span>
        <div>
            <h2 class="text-xl font-bold text-slate-800">Chỉnh sửa thông tin tài liệu</h2>
            <p class="text-xs text-slate-500">Mã tài liệu: DOC-${doc.id}</p>
        </div>
    </div>

    <%-- BRS yêu cầu: Thông báo lỗi hiển thị trực tiếp bên dưới (không dùng popup) --%>
    <c:if test="${not empty errorMessage}">
        <div class="mb-6 p-4 bg-red-50 text-red-600 border border-red-200 rounded-xl text-sm font-medium flex items-center gap-2">
            <span class="material-symbols-outlined text-[18px]">error</span>
                ${errorMessage}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/edit-doc" method="post" class="space-y-6">
        <input type="hidden" name="id" value="${doc.id}">

        <div>
            <label class="block text-sm font-bold text-slate-700 mb-2">Tiêu đề tài liệu <span class="text-red-500">*</span></label>
            <input type="text" name="title" value="${doc.title}" required
                   class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-100 focus:border-blue-600 transition-all">
        </div>

        <div>
            <label class="block text-sm font-bold text-slate-700 mb-2">Danh mục</label>
            <select name="categoryId" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-100 focus:border-blue-600 transition-all">
                <c:forEach items="${listCategories}" var="cat">
                    <option value="${cat.id}" ${cat.id == doc.categoryId ? 'selected' : ''}>${cat.name}</option>
                </c:forEach>
            </select>
        </div>

        <div>
            <label class="block text-sm font-bold text-slate-700 mb-2">Mô tả nội dung</label>
            <textarea name="description" rows="5" maxlength="1000" placeholder="Nhập mô tả tài liệu (tối đa 1000 ký tự)..."
                      class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-blue-100 focus:border-blue-600 transition-all">${doc.description}</textarea>
        </div>

        <div class="flex justify-end gap-3 pt-6 border-t border-slate-100">
            <a href="${pageContext.request.contextPath}/admin/management-doc"
               class="px-6 py-2.5 text-sm font-bold text-slate-600 bg-slate-100 rounded-xl hover:bg-slate-200 transition-colors">
                Hủy bỏ
            </a>
            <button type="submit"
                    class="px-6 py-2.5 text-sm font-bold text-white bg-blue-600 rounded-xl hover:bg-blue-700 transition-colors shadow-sm hover:shadow-md">
                Lưu thay đổi
            </button>
        </div>
    </form>
</div>

</body>
</html>