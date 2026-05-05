<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Tìm kiếm tài liệu - DocShare</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "secondary": "#495c94",
                      "on-primary-fixed": "#00174b",
                      "on-error-container": "#93000a",
                      "primary-container": "#0555dd",
                      "tertiary-container": "#af3600",
                      "surface-tint": "#0053da",
                      "on-primary-container": "#d1daff",
                      "secondary-fixed-dim": "#b4c5ff",
                      "tertiary-fixed": "#ffdbd0",
                      "surface-variant": "#e1e2ed",
                      "inverse-on-surface": "#f0f0fb",
                      "secondary-fixed": "#dbe1ff",
                      "surface-container-highest": "#e1e2ed",
                      "error-container": "#ffdad6",
                      "outline-variant": "#c3c6d7",
                      "surface-dim": "#d9d9e5",
                      "on-tertiary-fixed": "#390c00",
                      "outline": "#737686",
                      "surface-container-lowest": "#ffffff",
                      "surface-container-low": "#f3f3fe",
                      "on-surface-variant": "#434655",
                      "error": "#ba1a1a",
                      "on-secondary": "#ffffff",
                      "tertiary-fixed-dim": "#ffb59d",
                      "on-tertiary-container": "#ffd2c4",
                      "on-secondary-fixed-variant": "#31447b",
                      "on-primary": "#ffffff",
                      "on-tertiary-fixed-variant": "#832600",
                      "on-secondary-fixed": "#00174b",
                      "on-background": "#191b23",
                      "on-error": "#ffffff",
                      "on-surface": "#191b23",
                      "primary-fixed": "#dbe1ff",
                      "background": "#faf8ff",
                      "primary-fixed-dim": "#b4c5ff",
                      "surface-container": "#ededf9",
                      "primary": "#0040ab",
                      "inverse-surface": "#2e3039",
                      "tertiary": "#862700",
                      "surface": "#faf8ff",
                      "secondary-container": "#acbffe",
                      "on-secondary-container": "#394c84",
                      "surface-container-high": "#e7e7f3",
                      "on-primary-fixed-variant": "#003ea7",
                      "inverse-primary": "#b4c5ff",
                      "surface-bright": "#faf8ff",
                      "on-tertiary": "#ffffff"
              },
              "borderRadius": {
                      "DEFAULT": "0.125rem",
                      "lg": "0.25rem",
                      "xl": "0.5rem",
                      "full": "0.75rem"
              },
              "spacing": {
                      "lg": "24px",
                      "xs": "4px",
                      "md": "16px",
                      "xl": "48px",
                      "container-max": "1200px",
                      "base": "8px",
                      "sm": "8px",
                      "gutter": "24px"
              },
              "fontFamily": {
                      "body-sm": ["Inter"],
                      "h3": ["Inter"],
                      "h1": ["Inter"],
                      "h2": ["Inter"],
                      "body-md": ["Inter"],
                      "label-caps": ["Inter"],
                      "body-lg": ["Inter"]
              },
              "fontSize": {
                      "body-sm": ["14px", {"lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400"}],
                      "h3": ["24px", {"lineHeight": "1.4", "letterSpacing": "0", "fontWeight": "600"}],
                      "h1": ["40px", {"lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                      "h2": ["32px", {"lineHeight": "1.3", "letterSpacing": "-0.01em", "fontWeight": "600"}],
                      "body-md": ["16px", {"lineHeight": "1.5", "letterSpacing": "0", "fontWeight": "400"}],
                      "label-caps": ["12px", {"lineHeight": "1", "letterSpacing": "0.05em", "fontWeight": "700"}],
                      "body-lg": ["18px", {"lineHeight": "1.6", "letterSpacing": "0", "fontWeight": "400"}]
              }
            },
          },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .highlight {
            background-color: #fef08a;
            padding: 0 2px;
            border-radius: 2px;
        }
    </style>
</head>
<body class="bg-surface font-body-md text-on-surface">
<!-- TopNavBar -->
<header class="bg-white sticky top-0 z-50 shadow-sm border-b border-gray-200">
<div class="flex items-center justify-between px-6 py-4 max-w-[1200px] mx-auto w-full font-inter text-sm antialiased">
<div class="flex items-center gap-8">
<a href="${pageContext.request.contextPath}/" class="text-2xl font-bold tracking-tight text-blue-700">DocShare</a>
<nav class="hidden md:flex items-center gap-6">
<a class="text-gray-600 font-medium hover:text-blue-600 transition-colors duration-200" href="${pageContext.request.contextPath}/">Trang chủ</a>
<a class="text-blue-700 font-semibold border-b-2 border-blue-700 pb-1" href="${pageContext.request.contextPath}/page/user/search.jsp">Tài liệu</a>
<a class="text-gray-600 font-medium hover:text-blue-600 transition-colors duration-200" href="#">Danh mục</a>
</nav>
</div>
<div class="flex items-center gap-6 flex-1 justify-end">
<div class="relative w-full max-w-md hidden md:block">
<input class="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all text-body-sm" placeholder="Tìm kiếm tài liệu..." type="text" value="giải tích"/>
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">search</span>
</div>
<div class="flex items-center gap-3">
<a href="${pageContext.request.contextPath}/page/login.jsp" class="px-4 py-2 text-gray-600 font-medium hover:text-blue-600 active:scale-95 transition-transform duration-150 inline-block text-center">Đăng nhập</a>
<a href="${pageContext.request.contextPath}/page/register.jsp" class="px-5 py-2 bg-primary-container text-white rounded-lg font-semibold hover:bg-primary transition-all active:scale-95 inline-block text-center">Đăng ký</a>
</div>
</div>
</div>
</header>
<!-- Main Content Layout -->
<main class="max-w-[1200px] mx-auto px-6 py-8 flex gap-gutter">
<!-- Left Sidebar Filter -->
<aside class="w-[240px] flex-shrink-0 flex flex-col gap-8">
<section>
<h3 class="text-label-caps font-label-caps text-on-surface-variant mb-4">LỌC THEO DANH MỤC</h3>
<div class="flex flex-col gap-3">
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Giáo trình</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Đề thi</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Bài tập</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Tham khảo</span>
</label>
</div>
</section>
<section>
<h3 class="text-label-caps font-label-caps text-on-surface-variant mb-4">MÔN HỌC</h3>
<div class="flex flex-col gap-3">
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Toán</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Lý</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Hóa</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">CNTT</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">Kinh tế</span>
</label>
</div>
</section>
<section>
<h3 class="text-label-caps font-label-caps text-on-surface-variant mb-4">ĐỊNH DẠNG FILE</h3>
<div class="flex flex-col gap-3">
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">PDF</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">DOCX</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">PPTX</span>
</label>
<label class="flex items-center gap-2 cursor-pointer group">
<input class="rounded border-gray-300 text-primary focus:ring-primary" type="checkbox"/>
<span class="text-body-sm text-on-surface-variant group-hover:text-primary transition-colors">XLSX</span>
</label>
</div>
</section>
</aside>
<!-- Main Content Area -->
<div class="flex-1">
<div class="flex justify-between items-center mb-8">
<p class="text-body-md text-on-surface">Tìm thấy <span class="font-bold text-primary">48</span> tài liệu cho <span class="italic font-semibold text-primary">'giải tích'</span></p>
<div class="relative">
<button class="flex items-center gap-2 bg-white border border-gray-200 px-4 py-2 rounded-lg text-body-sm font-medium hover:border-primary-container transition-colors">
                        Mới nhất
                        <span class="material-symbols-outlined text-sm">expand_more</span>
</button>
</div>
</div>
<!-- Grid of Document Cards -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
<!-- Card 1 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuC7s_JcQph7d9Zoqlze-gyuQewjhFoCFLtMkMnJR3oL6DgqkQbwtQr81jrVM3AIX4hdDTqe8X_FqPPcf01xFNvm480ZdPrMNq-UaUM6S2LiXNsDCACkPjOLhGXsH3HjarfBj9r6EtolJrgCorAy1MX61I6D8bEyfrqt3YKK9E7N4St829MIVV6izBlzjEfNEc_2W9PcDiPOxmVnEcxLTWYl9R-j97Enot0lhz8SJvsPb6XSfh8q7nxx8tjMFCXcG3dul9fLuX2i1JAD"/>
<span class="absolute top-2 right-2 bg-red-600 text-white px-2 py-1 rounded text-[10px] font-bold">PDF</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Giáo trình <span class="highlight">Giải tích</span> 1 - ĐH Bách Khoa</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: PGS.TS Nguyễn Văn A</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 1.2k</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 450</span>
</div>
</div>
</div>
<!-- Card 2 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDB-MgGh9FMkL-MSYtjlW2rlYPR3aNl9xEjAp5XNhxYX7CbFMCoJ_sSsU7tmBbmwdoNKXg_gWSyqGb9vDzZj2kicIhw_LiJlCtIQsi5itTaTEOIR43Xn0Fry4DtM_cXtSiFb2JAeFNYQtoA_j1uYvU7F7Q1MiidQvQ_ANOQJ8qAXwGGDODtG-75HY-Vmok6liNuxFeIYEbLJh0N4bEuyvyM3ShNCZd9XK4uWu7SUUf3B6kVPueJbodhTm2zdr853oZEvSL9VVuL-YR-"/>
<span class="absolute top-2 right-2 bg-blue-600 text-white px-2 py-1 rounded text-[10px] font-bold">DOCX</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Bài tập <span class="highlight">Giải tích</span> nâng cao có lời giải</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: Trần Thị B</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 890</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 312</span>
</div>
</div>
</div>
<!-- Card 3 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCbzVebjhJvHqhCiwxHhI9qv-VW7Kaz-roxisYw4Q10juLRCg9l5h7cbU8x8rmio-HQfz-H0Eqk5qIxj_01LUxc6WqLmvwyXzaXIHkpJ4gNxCfwdjEtJp3lmRK8vYCTSgCzDDXjhplgbTyGoXbkgTb5N5P5X38AeSe7bRT_5Xd3SICar0-pMHucv6zhvTOJnURmNZVQ-JSiwaqVP_qfC4Vbzbg7WoNN9FteCUv5QPGY6rMPoUyme5YBZ5K-gQF12Qf8ED74JsaVuBu8"/>
<span class="absolute top-2 right-2 bg-orange-600 text-white px-2 py-1 rounded text-[10px] font-bold">PPTX</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Slide bài giảng <span class="highlight">Giải tích</span> đa biến</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: Khoa Toán - KHTN</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 2.5k</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 1.1k</span>
</div>
</div>
</div>
<!-- Card 4 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuC9VHJ7-IHN5NajmckxpW7t1u9WZXkUX5JNWxNMKOERL-RtkTTNT_IEPjcE_2Ir26ZQLk9ZXjTbfvZ1Zty8Ph-qKEmpTnj60JY-ric7m9b9TcjaLc4UJRFaoHW1cDe2VW5_z9-q33RF5E2iWaDk4Yi_oWNuPSUuxuwfn8yTDjbx6sAtEd3SQ26xjnwehe6oyY-3aVgxYD-zP-msO9alhd7Ar4Rasxq9eGbDfLYC1BwPArg4B5ZOJZNdiD2KHoSL9gUorMg9nkPKxuA8"/>
<span class="absolute top-2 right-2 bg-red-600 text-white px-2 py-1 rounded text-[10px] font-bold">PDF</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Tổng hợp công thức <span class="highlight">Giải tích</span> 2</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: CLB Sinh viên 5 tốt</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 4.1k</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 2.8k</span>
</div>
</div>
</div>
<!-- Card 5 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBSD_WhcXBpgwzbec0c3b4ag7amZfkW-2f34xdDGkhf5FJwLzw8OskaWJNsPtT4jGQnWUipOqa5Xf96UgTSiqfQ4faXPcETKS6vhKgTKKfBE07nl9sFsxn3aMitXcvKzttN0Fq-NeJyMCoxd1_pfhkbBasanZA0L4FgDg36KUvfuFhs-tnPP_dxZ7JVx-bpWuWoezXWTdNnK4FGiVBDz-aZSNHZvXeF1WTDBXLDpMUqZChyoHwIHn92s-GUMwXCtPhFccbi2QLML--f"/>
<span class="absolute top-2 right-2 bg-red-600 text-white px-2 py-1 rounded text-[10px] font-bold">PDF</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Đề thi giữa kỳ <span class="highlight">Giải tích</span> 1 - 2023</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: Phòng Đào tạo</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 650</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 180</span>
</div>
</div>
</div>
<!-- Card 6 -->
<div class="bg-white border border-gray-100 rounded-xl p-md shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer" onclick="window.location.href='document-detail.jsp'">
<div class="aspect-[3/4] bg-gray-100 rounded-lg mb-4 overflow-hidden relative">
<img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDzg3d-Bl7dq0p-L1UCpmfqGwfewo7dLa1Bny5EMmjYG5EDLFIxdOHfgx6bVnoqB83WTD26V9PN7VFoQAgtcpf-BtMR5jxdpTLed_rL9JbXDPaDThECAxqRvFCh2_MEARAHUr7ZuVBfK8q2bhhYy03YFnkquWiBwCHsz-knO_sTCkkt21220MzJMZ99thNXf4ie0CTdlbCLwrZzP36YGxk4dHBDi2uxTVUZoy2fZJQIb7nX03Flva_5RsItm6az_gwgkDgDP1M-Pt_y"/>
<span class="absolute top-2 right-2 bg-red-600 text-white px-2 py-1 rounded text-[10px] font-bold">PDF</span>
</div>
<h4 class="text-body-md font-bold text-on-surface leading-snug mb-2">Lịch sử phát triển <span class="highlight">Giải tích</span></h4>
<p class="text-body-sm text-on-surface-variant mb-4">Tác giả: TS. Lê Văn L</p>
<div class="flex items-center justify-between text-body-sm text-gray-400">
<div class="flex items-center gap-3">
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">visibility</span> 320</span>
<span class="flex items-center gap-1"><span class="material-symbols-outlined text-[18px]">download</span> 54</span>
</div>
</div>
</div>
</div>
<!-- Pagination (Generated for Completeness) -->
<div class="mt-12 flex justify-center gap-2">
<button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 hover:border-primary-container hover:text-primary transition-colors"><span class="material-symbols-outlined">chevron_left</span></button>
<button class="w-10 h-10 flex items-center justify-center rounded-lg bg-primary-container text-white font-bold">1</button>
<button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 hover:border-primary-container hover:text-primary transition-colors">2</button>
<button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 hover:border-primary-container hover:text-primary transition-colors">3</button>
<button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 hover:border-primary-container hover:text-primary transition-colors"><span class="material-symbols-outlined">chevron_right</span></button>
</div>
</div>
</main>
<!-- Footer -->
<footer class="bg-white border-t border-gray-200 mt-20">
<div class="max-w-[1200px] mx-auto px-6 py-16">
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-12 mb-12">
<div class="lg:col-span-2">
<span class="text-2xl font-bold tracking-tight text-blue-700 block mb-4">DocShare</span>
<p class="text-on-surface-variant text-body-sm max-w-xs mb-6">
          Nền tảng chia sẻ và lưu trữ tài liệu học tập hàng đầu cho sinh viên Việt Nam. Kết nối tri thức, nâng tầm tương lai.
        </p>
<div class="flex gap-4">
<a class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant hover:bg-primary-container hover:text-white transition-all" href="#">
<span class="material-symbols-outlined text-[20px]">public</span>
</a>
<a class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant hover:bg-primary-container hover:text-white transition-all" href="#">
<span class="material-symbols-outlined text-[20px]">mail</span>
</a>
<a class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant hover:bg-primary-container hover:text-white transition-all" href="#">
<span class="material-symbols-outlined text-[20px]">groups</span>
</a>
</div>
</div>
<div>
<h4 class="font-bold text-on-surface mb-6">Về DocShare</h4>
<ul class="flex flex-col gap-4 text-body-sm text-on-surface-variant">
<li><a class="hover:text-primary transition-colors" href="#">Giới thiệu</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Tuyển dụng</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Blog kiến thức</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Đối tác</a></li>
</ul>
</div>
<div>
<h4 class="font-bold text-on-surface mb-6">Hỗ trợ</h4>
<ul class="flex flex-col gap-4 text-body-sm text-on-surface-variant">
<li><a class="hover:text-primary transition-colors" href="#">Trung tâm trợ giúp</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Liên hệ hỗ trợ</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Báo cáo nội dung</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Câu hỏi thường gặp</a></li>
</ul>
</div>
<div>
<h4 class="font-bold text-on-surface mb-6">Pháp lý</h4>
<ul class="flex flex-col gap-4 text-body-sm text-on-surface-variant">
<li><a class="hover:text-primary transition-colors" href="#">Điều khoản sử dụng</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Chính sách bảo mật</a></li>
<li><a class="hover:text-primary transition-colors" href="#">Bản quyền nội dung</a></li>
</ul>
</div>
</div>
<div class="border-t border-gray-100 pt-12">
<div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-8">
<div class="max-w-md w-full">
<h4 class="font-bold text-on-surface mb-2">Bản tin</h4>
<p class="text-body-sm text-on-surface-variant mb-4">Nhận cập nhật mới nhất về các tài liệu và tính năng mới.</p>
<form class="flex gap-2">
<input class="flex-1 px-4 py-2 bg-surface-container-lowest border border-outline-variant rounded-lg focus:outline-none focus:border-primary transition-all text-body-sm" placeholder="Email của bạn" type="email"/>
<button class="px-6 py-2 bg-primary text-white rounded-lg font-semibold hover:bg-primary-container transition-all active:scale-95" type="submit">Đăng ký</button>
</form>
</div>
<div class="text-body-sm text-on-surface-variant">
          © 2024 DocShare. All rights reserved.
        </div>
</div>
</div>
</div>
</footer>
<!-- Toast Notifications Stack -->
</body></html>
