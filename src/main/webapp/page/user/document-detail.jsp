<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Chi tiết tài liệu - DocShare</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "error": "#ba1a1a",
                    "tertiary": "#862700",
                    "surface": "#faf8ff",
                    "surface-dim": "#d9d9e5",
                    "primary-fixed-dim": "#b4c5ff",
                    "primary-container": "#0555dd",
                    "tertiary-container": "#af3600",
                    "background": "#faf8ff",
                    "secondary-container": "#d0e1fb",
                    "outline": "#737686",
                    "inverse-surface": "#2e3039",
                    "on-primary-container": "#d1daff",
                    "on-primary": "#ffffff",
                    "surface-container-high": "#e7e7f3",
                    "surface-bright": "#faf8ff",
                    "surface-tint": "#0053da",
                    "surface-variant": "#e1e2ed",
                    "surface-container-low": "#f3f3fe",
                    "on-error": "#ffffff",
                    "on-tertiary-fixed-variant": "#832600",
                    "on-surface-variant": "#434655",
                    "on-secondary-container": "#54647a",
                    "primary": "#0040ab",
                    "surface-container-lowest": "#ffffff",
                    "on-primary-fixed": "#00174b",
                    "primary-fixed": "#dbe1ff",
                    "on-tertiary-fixed": "#390c00",
                    "on-secondary-fixed-variant": "#38485d",
                    "error-container": "#ffdad6",
                    "inverse-on-surface": "#f0f0fb",
                    "secondary-fixed": "#d3e4fe",
                    "on-surface": "#191b23",
                    "on-primary-fixed-variant": "#003ea7",
                    "on-background": "#191b23",
                    "secondary-fixed-dim": "#b7c8e1",
                    "tertiary-fixed": "#ffdbd0",
                    "secondary": "#505f76",
                    "on-tertiary": "#ffffff",
                    "on-error-container": "#93000a",
                    "surface-container": "#ededf9",
                    "on-secondary": "#ffffff",
                    "tertiary-fixed-dim": "#ffb59d",
                    "outline-variant": "#c3c6d7",
                    "on-tertiary-container": "#ffd2c4",
                    "on-secondary-fixed": "#0b1c30"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "gutter": "24px",
                    "stack-md": "16px",
                    "margin-mobile": "16px",
                    "stack-lg": "24px",
                    "margin-desktop": "32px",
                    "unit": "4px",
                    "stack-sm": "8px",
                    "container-max-width": "1280px"
            },
            "fontFamily": {
                    "body-md": ["Inter"],
                    "label-md": ["Inter"],
                    "body-lg": ["Inter"],
                    "headline-lg": ["Manrope"],
                    "error-text": ["Inter"],
                    "headline-md": ["Manrope"],
                    "headline-sm": ["Manrope"],
                    "label-sm": ["Inter"],
                    "body-sm": ["Inter"]
            },
            "fontSize": {
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "label-md": ["14px", {"lineHeight": "16px", "fontWeight": "500"}],
                    "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                    "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "700"}],
                    "error-text": ["12px", {"lineHeight": "16px", "fontWeight": "400"}],
                    "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                    "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                    "label-sm": ["12px", {"lineHeight": "14px", "fontWeight": "500"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}]
            }
          },
        },
      }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .page-shadow {
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body class="bg-surface font-body-md text-on-background min-h-screen flex flex-col">
<!-- TopNavBar -->
<header class="fixed top-0 z-50 flex items-center justify-between w-full h-16 px-6 lg:px-8 max-w-[1280px] mx-auto left-0 right-0 bg-white dark:bg-slate-900 border-b border-slate-100 dark:border-slate-800 shadow-[0_4px_12px_rgba(0,0,0,0.05)] font-manrope antialiased">
    <div class="flex items-center gap-8">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-extrabold tracking-tight text-blue-700 dark:text-blue-500 cursor-pointer active:scale-95 transition-transform">DocShare</a>
        <nav class="hidden md:flex items-center gap-6">
            <a class="text-blue-600 dark:text-blue-400 border-b-2 border-blue-600 dark:border-blue-400 font-semibold transition-colors duration-200" href="#">Trang chủ</a>
            <a class="text-slate-500 dark:text-slate-400 font-medium hover:text-blue-600 dark:hover:text-blue-300 transition-colors duration-200" href="#">Tài liệu</a>
            <a class="text-slate-500 dark:text-slate-400 font-medium hover:text-blue-600 dark:hover:text-blue-300 transition-colors duration-200" href="#">Danh mục</a>
        </nav>
    </div>
    <div class="flex items-center gap-4">
        <div class="relative hidden lg:block">
            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
            <input class="pl-10 pr-4 py-2 bg-slate-50 border-none rounded-full w-64 text-sm focus:ring-2 focus:ring-primary/20" placeholder="Tìm kiếm tài liệu..." type="text"/>
        </div>
<%
    Object loggedInUser = session.getAttribute("authUser");
    if (loggedInUser == null) {
        loggedInUser = session.getAttribute("adminUser");
    }
%>
<% if (loggedInUser == null) { %>
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/page/user/login.jsp" class="px-4 py-2 text-slate-500 font-medium hover:text-blue-600 active:scale-95 transition-transform duration-150 inline-block text-center">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/page/user/register.jsp" class="px-5 py-2 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition-all active:scale-95 inline-block text-center">Đăng ký</a>
        </div>
<% } else { %>
        <div class="flex items-center gap-3">
            <button class="p-2 text-slate-500 hover:text-blue-600 transition-colors duration-200">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <button class="p-2 text-slate-500 hover:text-blue-600 transition-colors duration-200">
                <span class="material-symbols-outlined">settings</span>
            </button>
            <a href="${pageContext.request.contextPath}/page/user/profile.jsp" class="w-8 h-8 rounded-full overflow-hidden border border-slate-200 cursor-pointer inline-block">
                <img alt="User avatar" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD6Sm4Wwf37q9lf35z5TmeY6HJS_6wxGrNKjlhv4LI43ivt8NdxWrCZwRHs0kfU8d_YqUfc9rQn5v_8at_4Nd1z43Qn48vkZ_UMuwBfz2ICkVcOdOponfwWibINdVdBisSOF8u-_-IJqUbwkmsk8GqaJbfh2pkpnzOBnk4wS-FcOwP5wFdOZTmGemZhv51swvomej2xICs0PSxAayUiI2hsu-8blVlTSfN89ZBXjjHnkCaa0ZZazQEmF8g38DVZhyv41EF3T7t6ojnC"/>
            </a>
        </div>
<% } %>
    </div>
</header>
<!-- Main Content -->
<main class="mt-16 flex-grow">
    <div class="max-w-[1280px] mx-auto px-6 lg:px-8 py-8">
        <!-- Breadcrumbs -->
        <nav class="flex items-center gap-2 text-label-sm text-secondary mb-6">
            <a class="hover:text-primary" href="#">Trang chủ</a>
            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
            <a class="hover:text-primary" href="#">Tài liệu học tập</a>
            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
            <span class="text-on-surface font-medium">Giáo trình Kinh tế học vi mô</span>
        </nav>
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
            <!-- Left Column: PDF Viewer -->
            <div class="lg:col-span-8">
                <div class="bg-white rounded-xl page-shadow overflow-hidden flex flex-col h-[850px] border border-slate-100">
                    <!-- Viewer Toolbar -->
                    <div class="h-12 bg-slate-50 border-b border-slate-100 flex items-center justify-between px-4">
                        <div class="flex items-center gap-4">
                            <span class="text-label-md font-semibold text-slate-700">Trang 1 / 154</span>
                            <div class="h-4 w-[1px] bg-slate-300"></div>
                            <div class="flex items-center gap-2">
                                <button class="p-1 hover:bg-slate-200 rounded transition-colors"><span class="material-symbols-outlined text-[20px]">zoom_out</span></button>
                                <span class="text-label-sm">100%</span>
                                <button class="p-1 hover:bg-slate-200 rounded transition-colors"><span class="material-symbols-outlined text-[20px]">zoom_in</span></button>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <button class="p-1 hover:bg-slate-200 rounded transition-colors"><span class="material-symbols-outlined text-[20px]">print</span></button>
                            <button class="p-1 hover:bg-slate-200 rounded transition-colors"><span class="material-symbols-outlined text-[20px]">fullscreen</span></button>
                        </div>
                    </div>
                    <!-- Viewer Canvas -->
                    <div class="flex-grow bg-slate-200 overflow-y-auto p-8 flex flex-col items-center space-y-8">
                        <!-- Page 1 -->
                        <div class="w-full max-w-[720px] aspect-[1/1.414] bg-white shadow-lg p-12 relative">
                            <div class="absolute top-0 left-0 w-full h-1 bg-primary"></div>
                            <div class="mb-12">
                                <h1 class="font-headline-lg text-slate-900 mb-4 uppercase tracking-wide">Giáo trình Kinh tế học vi mô</h1>
                                <div class="h-1 w-24 bg-primary mb-6"></div>
                                <p class="text-body-lg text-slate-600 font-medium italic">Tái bản lần thứ 5, có sửa đổi và bổ sung</p>
                            </div>
                            <div class="space-y-6">
                                <h2 class="font-headline-sm text-primary">CHƯƠNG 1: TỔNG QUAN VỀ KINH TẾ HỌC VI MÔ</h2>
                                <div class="space-y-4">
                                    <h3 class="font-label-md text-slate-800 uppercase font-bold">1.1. Khái niệm và đối tượng nghiên cứu</h3>
                                    <p class="text-body-md text-slate-700 leading-relaxed">
                                        Kinh tế học vi mô là một phân ngành chính của kinh tế học, tập trung nghiên cứu hành vi của các thực thể kinh tế riêng lẻ như người tiêu dùng, hộ gia đình và doanh nghiệp trong việc đưa ra các quyết định phân bổ nguồn lực khan hiếm.
                                    </p>
                                    <div class="bg-slate-50 p-6 rounded-lg border-l-4 border-primary">
                                        <p class="text-body-md font-semibold text-slate-800 mb-2">Từ khóa quan trọng:</p>
                                        <ul class="list-disc ml-5 text-body-sm text-slate-600 space-y-1">
                                            <li>Sự khan hiếm (Scarcity)</li>
                                            <li>Chi phí cơ hội (Opportunity Cost)</li>
                                            <li>Quy luật cung cầu (Law of Supply and Demand)</li>
                                            <li>Tối đa hóa lợi ích (Utility Maximization)</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="pt-8">
                                    <img alt="Economic Chart" class="w-full rounded-lg border border-slate-100 shadow-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAlUO7XAs4wZ72ejRgtCXNw97m16N4kV7Y1_nLE-jGR7-j9m7TJuP533xN0C2efvSKQWNcf41FxHjEW_QNG4JarC-qw2grbJfsAdbr7AbvKr19H5L5U1_gU0w1AFmqvvdbty1FKbVgbd0NkhA5oBUX9Gh8JtxjLJIZCXFFJRFazfQ4OhMaGhyehLNaBjSNUkk3BCfpbewLLtbuhCxcemYJHqMNvbIEHkEKnkoXgcsADHX1-n5Bbjj8FDmuMSKTn0q_gIGiGNZAfr4hV"/>
                                    <p class="text-center text-label-sm text-slate-500 mt-2 italic text-body-sm">Hình 1.1: Mô hình đường giới hạn khả năng sản xuất (PPF)</p>
                                </div>
                            </div>
                            <div class="absolute bottom-8 right-12 text-label-sm text-slate-400">1</div>
                        </div>
                        <!-- Page 2 (Sneak Peak) -->
                        <div class="w-full max-w-[720px] aspect-[1/1.414] bg-white shadow-lg p-12 opacity-95">
                            <div class="space-y-6">
                                <h3 class="font-label-md text-slate-800 uppercase font-bold">1.2. Ba vấn đề cơ bản của tổ chức kinh tế</h3>
                                <p class="text-body-md text-slate-700 leading-relaxed">
                                    Mọi nền kinh tế, dù ở trình độ phát triển nào, cũng đều phải đối mặt với ba câu hỏi cơ bản nảy sinh từ sự khan hiếm nguồn lực...
                                </p>
                                <div class="grid grid-cols-3 gap-4 py-4">
                                    <div class="p-4 bg-blue-50 rounded-lg text-center">
                                        <p class="font-bold text-primary">CÁI GÌ?</p>
                                        <p class="text-xs text-slate-500 mt-1">Sản xuất sản phẩm nào?</p>
                                    </div>
                                    <div class="p-4 bg-blue-50 rounded-lg text-center">
                                        <p class="font-bold text-primary">THẾ NÀO?</p>
                                        <p class="text-xs text-slate-500 mt-1">Công nghệ sản xuất?</p>
                                    </div>
                                    <div class="p-4 bg-blue-50 rounded-lg text-center">
                                        <p class="font-bold text-primary">CHO AI?</p>
                                        <p class="text-xs text-slate-500 mt-1">Đối tượng thụ hưởng?</p>
                                    </div>
                                </div>
                            </div>
                            <div class="absolute bottom-8 right-12 text-label-sm text-slate-400">2</div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Right Column: Sidebar -->
            <div class="lg:col-span-4 space-y-gutter">
                <!-- Download Action Card -->
                <div class="bg-white p-stack-lg rounded-xl page-shadow border border-slate-100">
                    <button class="w-full bg-primary hover:bg-primary/90 text-white font-semibold py-4 px-6 rounded-lg flex items-center justify-center gap-3 active:scale-[0.98] transition-all">
                        <span class="material-symbols-outlined">download</span>
                        Tải xuống ngay
                    </button>
                    <div class="mt-4 flex items-center justify-center gap-6 text-label-sm text-secondary">
                        <div class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-[18px]">visibility</span>
                            12.4k
                        </div>
                        <div class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-[18px]">download</span>
                            3.2k
                        </div>
                        <div class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-[18px]">share</span>
                            Chia sẻ
                        </div>
                    </div>
                </div>
                <!-- File Info Card -->
                <div class="bg-white p-stack-lg rounded-xl page-shadow border border-slate-100">
                    <h3 class="font-headline-sm text-on-surface mb-4">Thông tin tệp tin</h3>
                    <div class="space-y-4">
                        <div class="flex justify-between items-start border-b border-slate-50 pb-3">
                            <span class="text-body-sm text-secondary">Định dạng</span>
                            <span class="text-label-md font-semibold text-primary bg-primary/10 px-2 py-0.5 rounded">PDF</span>
                        </div>
                        <div class="flex justify-between items-start border-b border-slate-50 pb-3">
                            <span class="text-body-sm text-secondary">Kích thước</span>
                            <span class="text-label-md font-semibold text-on-surface">15.4 MB</span>
                        </div>
                        <div class="flex justify-between items-start border-b border-slate-50 pb-3">
                            <span class="text-body-sm text-secondary">Số trang</span>
                            <span class="text-label-md font-semibold text-on-surface">154 trang</span>
                        </div>
                        <div class="flex justify-between items-start border-b border-slate-50 pb-3">
                            <span class="text-body-sm text-secondary">Ngôn ngữ</span>
                            <span class="text-label-md font-semibold text-on-surface">Tiếng Việt</span>
                        </div>
                        <div class="flex justify-between items-start border-b border-slate-50 pb-3">
                            <span class="text-body-sm text-secondary">Ngày đăng</span>
                            <span class="text-label-md font-semibold text-on-surface">15 Th05, 2024</span>
                        </div>
                        <div class="flex flex-col gap-2 pt-2">
                            <span class="text-body-sm text-secondary">Tags</span>
                            <div class="flex flex-wrap gap-2">
                                <span class="text-[11px] font-semibold bg-slate-100 text-slate-600 px-2 py-1 rounded-full uppercase">Kinh tế học</span>
                                <span class="text-[11px] font-semibold bg-slate-100 text-slate-600 px-2 py-1 rounded-full uppercase">Đại học</span>
                                <span class="text-[11px] font-semibold bg-slate-100 text-slate-600 px-2 py-1 rounded-full uppercase">Vi mô</span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Uploader Profile -->
                <div class="bg-white p-stack-lg rounded-xl page-shadow border border-slate-100 flex items-center gap-4">
                    <img alt="Uploader" class="w-12 h-12 rounded-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuC1UHHcXxvULxHZOoHxOHQTntwLLl0h3ZQBGuiZn6CDydd-e26MJ0X0HPS_r6Xc23gq3t03eJMLAtyF1207zDMsA3GULMqn6ykEnlk5w_RX1Q3_KKGoxged2_YLN0y6EBHvHl4JicedZYreuFUZ2lwbsAhrAFgpXiGFFW_lgkpQcmf-PBUFouzRHCZF4tRPb8F0MN4zLjQzhjS8kCjtczQNNK6WJjxRzkxfkafLVMadj5lLX_RI9k-hZSPPYP5GweFPGMlFtvdx2eYX"/>
                    <div class="flex-grow">
                        <p class="text-label-md font-bold text-on-surface">PGS.TS Nguyễn Thu Hà</p>
                        <p class="text-body-sm text-secondary">Đã đăng 45 tài liệu</p>
                    </div>
                    <button class="p-2 text-primary hover:bg-primary/5 rounded-full transition-colors">
                        <span class="material-symbols-outlined">person_add</span>
                    </button>
                </div>
                <!-- Recommended List Card -->
                <div class="bg-white p-stack-lg rounded-xl page-shadow border border-slate-100">
                    <h3 class="font-headline-sm text-on-surface mb-4">Tài liệu liên quan</h3>
                    <div class="space-y-4">
                        <div class="flex gap-3 group cursor-pointer">
                            <div class="w-12 h-16 bg-slate-100 rounded flex-shrink-0 overflow-hidden">
                                <img alt="Doc 1" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD90jxvU1Myww4NDlb07HkV8_yA2dncfA4jaidQBvayJuU4m0h7jEWnwytBbby8evCtIW4biN3iHtTyuZkymRR7YEre9CBW08NhOWwA1WHRufj7-eaNczWfcq-wgFeB8edHb7kpsss-d0R3TJVxRNJM29gfGU-0ba60ECR7A7uQPRGMqNqRCjVaILOciyTxxue9NEUAHT60QAbaXlUtFr_2x_wnTuDSk2RJPKeGKbeJHvOq8fo8MQUb1vZJ3Hein1_Sobo1uO4Kc-0J"/>
                            </div>
                            <div>
                                <p class="text-label-sm font-semibold text-on-surface group-hover:text-primary transition-colors line-clamp-2">Bài tập Kinh tế học vi mô có lời giải</p>
                                <p class="text-body-sm text-secondary">1.2 MB • 45 trang</p>
                            </div>
                        </div>
                        <div class="flex gap-3 group cursor-pointer">
                            <div class="w-12 h-16 bg-slate-100 rounded flex-shrink-0 overflow-hidden">
                                <img alt="Doc 2" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAX3VfaPYODeVCUZPq6L80nt7nu9Ok2WqnEERHkJkqcRGArayh1CXAfRsSf87TzVT4RqDtpAL4Tkn5u4vu0OGPEcIrV_mk_uVs5Lr9X03JprYtNR9L4SmYKJwd_qDv8JRCZsABg8KT_7K2ppK0U7a7XGHqoZuHLEFrcvdnYX5Cg6p07e2GtKDQZaOR8ENDWHONeu7P3JLy0trTSgIbCUvV9j_52a0NiYLn5ttt1gWN6ZrzNRusKd4Xbu8fy_oY-CcIcaEXo4GTiWX4f"/>
                            </div>
                            <div>
                                <p class="text-label-sm font-semibold text-on-surface group-hover:text-primary transition-colors line-clamp-2">Tóm tắt công thức Kinh tế vi mô</p>
                                <p class="text-body-sm text-secondary">0.5 MB • 8 trang</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<!-- Footer -->
<footer class="w-full py-8 mt-auto flex flex-col md:flex-row justify-between items-center px-6 lg:px-8 max-w-[1280px] mx-auto bg-slate-50 dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800 font-manrope text-sm">
    <div class="mb-4 md:mb-0">
        <span class="text-lg font-bold text-slate-900 dark:text-white">DocShare</span>
        <p class="text-slate-500 dark:text-slate-400 mt-1">© 2024 DocShare Inc. All rights reserved.</p>
    </div>
    <div class="flex flex-wrap justify-center gap-6">
        <a class="text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-100 transition-colors" href="#">Privacy Policy</a>
        <a class="text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-100 transition-colors" href="#">Terms of Service</a>
        <a class="text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-100 transition-colors" href="#">Security</a>
        <a class="text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-100 transition-colors" href="#">Help Center</a>
    </div>
</footer>
</body>
</html>
