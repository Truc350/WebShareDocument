<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Chỉnh sửa tài liệu - DocShare</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-container-highest": "#e1e2ed",
                        "primary-fixed": "#dbe1ff",
                        "surface-tint": "#0053da",
                        "on-primary-fixed": "#00174b",
                        "on-primary-container": "#d1daff",
                        "surface-dim": "#d9d9e5",
                        "surface-container-lowest": "#ffffff",
                        "surface-container": "#ededf9",
                        "on-background": "#191b23",
                        "on-surface": "#191b23",
                        "on-error-container": "#93000a",
                        "surface-variant": "#e1e2ed",
                        "secondary-fixed-dim": "#b7c8e1",
                        "secondary": "#505f76",
                        "background": "#faf8ff",
                        "tertiary-fixed": "#ffdbd0",
                        "on-surface-variant": "#434655",
                        "error-container": "#ffdad6",
                        "secondary-fixed": "#d3e4fe",
                        "surface": "#faf8ff",
                        "surface-container-low": "#f3f3fe",
                        "inverse-surface": "#2e3039",
                        "tertiary-fixed-dim": "#ffb59d",
                        "primary": "#0040ab",
                        "on-tertiary": "#ffffff",
                        "primary-fixed-dim": "#b4c5ff",
                        "inverse-on-surface": "#f0f0fb",
                        "on-tertiary-container": "#ffd2c4",
                        "tertiary-container": "#af3600",
                        "on-primary": "#ffffff",
                        "secondary-container": "#d0e1fb",
                        "tertiary": "#862700",
                        "on-secondary-fixed-variant": "#38485d",
                        "on-secondary-fixed": "#0b1c30",
                        "on-tertiary-fixed-variant": "#832600",
                        "on-tertiary-fixed": "#390c00",
                        "on-secondary-container": "#54647a",
                        "on-primary-fixed-variant": "#003ea7",
                        "inverse-primary": "#b4c5ff",
                        "outline": "#737686",
                        "primary-container": "#0555dd",
                        "outline-variant": "#c3c6d7",
                        "surface-bright": "#faf8ff",
                        "on-error": "#ffffff",
                        "error": "#ba1a1a",
                        "surface-container-high": "#e7e7f3",
                        "on-secondary": "#ffffff"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "unit": "4px",
                        "stack-lg": "24px",
                        "container-max-width": "1280px",
                        "margin-mobile": "16px",
                        "margin-desktop": "32px",
                        "stack-sm": "8px",
                        "gutter": "24px",
                        "stack-md": "16px"
                    },
                    "fontFamily": {
                        "headline-md": ["Manrope"],
                        "error-text": ["Inter"],
                        "body-md": ["Inter"],
                        "body-lg": ["Inter"],
                        "label-sm": ["Inter"],
                        "headline-lg": ["Manrope"],
                        "body-sm": ["Inter"],
                        "label-md": ["Inter"],
                        "headline-sm": ["Manrope"]
                    },
                    "fontSize": {
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                        "error-text": ["12px", {"lineHeight": "16px", "fontWeight": "400"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "label-sm": ["12px", {"lineHeight": "14px", "fontWeight": "500"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "700"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "fontWeight": "500"}],
                        "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}]
                    }
                },
            },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-background font-body-md text-on-background min-h-screen flex flex-col">
<jsp:include page="/common/header.jsp" />
<main class="flex-grow py-8 px-4 sm:px-6">
<div class="max-w-[800px] mx-auto">
<!-- Breadcrumb -->
<nav class="flex items-center gap-2 mb-6 text-body-sm text-secondary">
<a class="hover:text-primary transition-colors" href="${pageContext.request.contextPath}/page/user/profile.jsp">Hồ sơ cá nhân</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<a class="hover:text-primary transition-colors" href="${pageContext.request.contextPath}/page/user/profile.jsp">Tài liệu của tôi</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<span class="font-semibold text-on-background">Chỉnh sửa tài liệu</span>
</nav>
<!-- Main Content Card -->
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_12px_rgba(0,0,0,0.05)] overflow-hidden">
<!-- Card Header -->
<div class="p-stack-lg border-b border-outline-variant bg-white">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-primary-container text-3xl">edit_note</span>
<h1 class="font-headline-md text-headline-md text-on-surface">Chỉnh sửa tài liệu</h1>
</div>
<p class="text-body-sm text-secondary mt-1">Cập nhật thông tin và cài đặt hiển thị cho tài liệu của bạn.</p>
</div>
<!-- Form Content -->
<form class="p-stack-lg space-y-gutter">
<!-- Title Input -->
<div class="space-y-stack-sm">
<label class="font-label-md text-label-md text-on-surface" for="doc-title">Tên tài liệu</label>
<input class="w-full px-4 py-2.5 bg-white border border-[#cbd5e1] rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd] outline-none transition-all font-body-md" id="doc-title" type="text" value="Giao trinh SQL Can Ban.pdf"/>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-gutter">
<!-- Category Selector -->
<div class="space-y-stack-sm">
<label class="font-label-md text-label-md text-on-surface" for="category">Danh mục</label>
<div class="relative">
<select class="w-full appearance-none px-4 py-2.5 bg-white border border-[#cbd5e1] rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd] outline-none transition-all font-body-md pr-10" id="category">
<option selected="" value="cntt">Công nghệ thông tin</option>
<option value="kt">Kinh tế</option>
<option value="nn">Ngoại ngữ</option>
<option value="khxh">Khoa học xã hội</option>
</select>
<span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-secondary">expand_more</span>
</div>
</div>
<!-- Tags Input -->
<div class="space-y-stack-sm">
<label class="font-label-md text-label-md text-on-surface" for="tags">Thẻ (Tags)</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-secondary text-[20px]">sell</span>
<input class="w-full pl-10 pr-4 py-2.5 bg-white border border-[#cbd5e1] rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd] outline-none transition-all font-body-md" id="tags" placeholder="Ví dụ: SQL, Database" type="text" value="SQL, Database, Cơ bản"/>
</div>
</div>
</div>
<!-- Description Textarea -->
<div class="space-y-stack-sm">
<label class="font-label-md text-label-md text-on-surface" for="description">Mô tả tài liệu</label>
<textarea class="w-full px-4 py-2.5 bg-white border border-[#cbd5e1] rounded-lg focus:ring-2 focus:ring-[#0555dd] focus:border-[#0555dd] outline-none transition-all font-body-md resize-none" id="description" rows="4">Tài liệu cung cấp kiến thức nền tảng về ngôn ngữ truy vấn SQL, bao gồm các câu lệnh cơ bản như SELECT, INSERT, UPDATE, DELETE và cách làm việc với các hệ quản trị cơ sở dữ liệu phổ biến.</textarea>
</div>
<!-- Privacy Status -->
<div class="space-y-stack-sm">
<label class="font-label-md text-label-md text-on-surface">Trạng thái quyền riêng tư</label>
<div class="flex gap-gutter">
<label class="flex items-center gap-3 cursor-pointer group">
<input checked="" class="w-5 h-5 text-[#0555dd] focus:ring-[#0555dd] border-slate-300" name="privacy" type="radio" value="public"/>
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-secondary group-hover:text-primary transition-colors">public</span>
<span class="font-body-sm">Công khai</span>
</div>
</label>
<label class="flex items-center gap-3 cursor-pointer group">
<input class="w-5 h-5 text-[#0555dd] focus:ring-[#0555dd] border-slate-300" name="privacy" type="radio" value="draft"/>
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-secondary group-hover:text-primary transition-colors">draft</span>
<span class="font-body-sm">Nháp</span>
</div>
</label>
</div>
</div>
<!-- File Management -->
<div class="p-stack-md bg-surface-container-low rounded-lg border border-outline-variant">
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
<div class="flex items-center gap-4">
<div class="w-12 h-12 bg-white rounded flex items-center justify-center border border-slate-200">
<span class="material-symbols-outlined text-error text-3xl">picture_as_pdf</span>
</div>
<div>
<p class="font-label-md text-on-surface">Tệp hiện tại</p>
<p class="text-body-sm text-secondary truncate max-w-[200px] sm:max-w-xs">Giao trinh SQL Can Ban.pdf</p>
</div>
</div>
<button class="flex items-center justify-center gap-2 px-4 py-2 bg-white border border-[#cbd5e1] rounded-lg hover:bg-slate-50 transition-colors text-label-md font-semibold text-secondary" type="button">
<span class="material-symbols-outlined text-[20px]">cloud_upload</span>
                                Thay đổi tệp
                            </button>
</div>
</div>
<!-- Action Buttons -->
<div class="flex items-center justify-end gap-stack-md pt-4 border-t border-outline-variant">
<button class="px-6 py-2.5 border border-[#cbd5e1] text-secondary font-semibold rounded-lg hover:bg-slate-50 transition-all text-label-md" type="button">
                            Hủy
                        </button>
<button class="px-8 py-2.5 bg-[#0555dd] text-white font-semibold rounded-lg hover:bg-primary-container/90 transition-all shadow-md active:opacity-80 text-label-md" type="submit">
                            Lưu thay đổi
                        </button>
</div>
</form>
</div>
<!-- Ad/Illustration Section -->
<div class="mt-8 rounded-xl overflow-hidden relative h-[200px] group">
<img alt="DocShare Promo" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" src="https://lh3.googleusercontent.com/aida/ADBb0ugoTKWNrMggCQjsdruojq-gWbKV56mubWP-ROJS93AGswutNI7aX_vdygqPkUyl0NeO3c4VZoX7F9851L-7_N-u6Jl4EcM3zZ7mNkypJcbHWVm8HUOb0MixqhEF3EZpQWDq4uU5yBdK4Lv-E_SUC6Q4cAUgaByqNiuRkrhu10T0TH4WYlx_ZeOUGudCC5OHwUp4nT3Ou1t1hgSV9AOlyivfmO_STcdygjsH8Qo3ClLEhErUfT1xUvhpEaFxJzBylAEbUtZFrJLJUA"/>
<div class="absolute inset-0 bg-gradient-to-r from-primary/80 to-transparent flex items-center p-stack-lg">
<div class="max-w-md text-white">
<h3 class="font-headline-sm text-headline-sm mb-2">Bảo mật tài liệu của bạn</h3>
<p class="text-body-sm opacity-90">Mọi tài liệu tải lên DocShare đều được mã hóa đầu cuối và lưu trữ trên hệ thống máy chủ an toàn nhất.</p>
</div>
</div>
</div>
</div>
</main>
<jsp:include page="/common/footer.jsp" />
</body></html>
