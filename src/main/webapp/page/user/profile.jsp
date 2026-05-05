<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi" class="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Hồ sơ cá nhân - DocShare</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet"/>
</head>
<body class="bg-slate-50 font-sans text-slate-800 min-h-screen flex flex-col">
    <!-- TopNavBar -->
    <nav class="bg-white sticky top-0 z-50 border-b border-slate-200 shadow-sm font-manrope">
        <div class="flex items-center justify-between max-w-[1280px] mx-auto px-6 h-16 w-full">
            <div class="flex items-center gap-8 h-full">
                <span class="text-[22px] font-extrabold tracking-tight text-[#0555dd]">DocShare</span>
                <div class="hidden md:flex items-center gap-6 h-full">
                    <a href="#" class="text-[#0555dd] font-semibold h-full flex items-center border-b-2 border-[#0555dd]">Trang chủ</a>
                    <a href="#" class="text-slate-500 font-medium hover:text-[#0555dd] h-full flex items-center border-b-2 border-transparent transition-colors">Tài liệu</a>
                    <a href="#" class="text-slate-500 font-medium hover:text-[#0555dd] h-full flex items-center border-b-2 border-transparent transition-colors">Danh mục</a>
                </div>
            </div>
            <div class="flex items-center gap-4">
                <div class="hidden lg:flex items-center bg-slate-50 rounded-full px-4 py-2.5 w-80 transition-all focus-within:ring-2 focus-within:ring-[#0555dd]/20 border border-slate-100">
                    <span class="material-symbols-outlined text-slate-400 mr-2 text-[20px]">search</span>
                    <input type="text" placeholder="Tìm kiếm tài liệu..." class="bg-transparent border-none p-0 text-sm focus:ring-0 text-slate-700 w-full placeholder:text-slate-400 outline-none"/>
                </div>
                <div class="w-8 h-8 rounded-full overflow-hidden border border-slate-200 cursor-pointer shrink-0">
                    <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDVzesd2P-nam4BHQFwKldg010YLy277-swKDEWeWhvvHtuI5j25aF2P4fkLabJVc1iMTSGhyxW9WodAis0iCWdjs9W7rAItUqEqxuxf825ZNf-rDNp1GN-YDXDXlOjEBL3mmMgCkIHg3-sRGGmJAdcFAyTKpfv9hl96dpMtuq9w4yZiOvvsVBcB7SKHsfnXG2azOAKmI5LcW_JcECELkseJrB5agN_pkmIIzCKJjTJO6MSAn0RW2H2PbbKF-A9_i7HoJX8sOtnKItv" alt="User" class="w-full h-full object-cover"/>
                </div>
            </div>
        </div>
    </nav>

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
                    <div class="flex items-center justify-center md:justify-start gap-3 mb-2">
                        <h1 class="text-2xl font-semibold font-manrope">Nguyễn Minh Tuấn</h1>
                        <span class="px-3 py-0.5 bg-white/20 text-white text-xs rounded-full border border-white/30">Sinh viên</span>
                    </div>
                    <div class="flex flex-wrap justify-center md:justify-start items-center gap-x-6 gap-y-2 text-sm text-white/90 mb-6">
                        <span class="flex items-center gap-1.5"><span class="material-symbols-outlined text-[18px]">school</span> ĐH Nông Lâm TP.HCM</span>
                        <span class="flex items-center gap-1.5"><span class="material-symbols-outlined text-[18px]">calendar_today</span> Tham gia từ 03/2026</span>
                    </div>
                    <div class="flex items-center justify-center md:justify-start gap-8">
                        <div>
                            <span class="block text-2xl font-bold font-manrope">24</span>
                            <span class="text-[10px] text-white/80 uppercase tracking-wide">Tài liệu</span>
                        </div>
                        <div class="w-px h-8 bg-white/20"></div>
                        <div>
                            <span class="block text-2xl font-bold font-manrope">1,234</span>
                            <span class="text-[10px] text-white/80 uppercase tracking-wide">Lượt tải</span>
                        </div>
                        <div class="w-px h-8 bg-white/20"></div>
                        <div>
                            <span class="flex items-center justify-center md:justify-start gap-1 text-2xl font-bold font-manrope">
                                4.3 <span class="material-symbols-outlined text-yellow-400 text-[20px]" style="font-variation-settings: 'FILL' 1;">star</span>
                            </span>
                            <span class="text-[10px] text-white/80 uppercase tracking-wide">Đánh giá</span>
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
                <!-- Giới thiệu -->
                <div class="bg-white p-6 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100">
                    <h3 class="text-base font-semibold text-slate-800 mb-4 font-manrope">Giới thiệu</h3>
                    <p class="text-sm text-slate-600 mb-6 leading-relaxed">
                        Sinh viên năm 3 khoa Công nghệ thông tin, đam mê chia sẻ kiến thức và tài liệu học tập hữu ích cho cộng đồng sinh viên Nông Lâm.
                    </p>
                    <div class="space-y-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0555dd] shrink-0">
                                <span class="material-symbols-outlined text-[20px]">mail</span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400 font-medium uppercase tracking-wide">Email</p>
                                <p class="text-sm font-medium text-slate-800">tuan.minh.nlu@gmail.com</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0555dd] shrink-0">
                                <span class="material-symbols-outlined text-[20px]">phone</span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400 font-medium uppercase tracking-wide">Số điện thoại</p>
                                <p class="text-sm font-medium text-slate-800">098 *** 4567</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0555dd] shrink-0">
                                <span class="material-symbols-outlined text-[20px]">location_on</span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400 font-medium uppercase tracking-wide">Địa chỉ</p>
                                <p class="text-sm font-medium text-slate-800">TP. Thủ Đức, Hồ Chí Minh</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Kỹ năng & Chuyên môn -->
                <div class="bg-white p-6 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100">
                    <h3 class="text-base font-semibold text-slate-800 mb-4 font-manrope">Kỹ năng & Chuyên môn</h3>
                    <div class="flex flex-wrap gap-2">
                        <span class="px-3 py-1.5 bg-slate-100 text-slate-700 text-[13px] rounded-full font-medium">Phân tích dữ liệu</span>
                        <span class="px-3 py-1.5 bg-slate-100 text-slate-700 text-[13px] rounded-full font-medium">Python</span>
                        <span class="px-3 py-1.5 bg-slate-100 text-slate-700 text-[13px] rounded-full font-medium">SQL</span>
                        <span class="px-3 py-1.5 bg-slate-100 text-slate-700 text-[13px] rounded-full font-medium">Soạn thảo văn bản</span>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div id="my-documents-section" class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100 overflow-hidden">
                    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
                        <h3 class="text-base font-semibold text-slate-800 font-manrope">Quản lý tài liệu</h3>
                        <button class="bg-[#0555dd] text-white px-4 py-2.5 rounded-lg text-sm font-medium flex items-center gap-2 hover:bg-blue-700 transition-colors shadow-sm">
                            <span class="material-symbols-outlined text-[18px]">upload</span>
                            Tải lên mới
                        </button>
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
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <span class="material-symbols-outlined text-[#0555dd]">description</span>
                                            <span class="font-medium text-sm text-slate-800">Giao trinh SQL Can Ban.pdf</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-500">12/03/2026</td>
                                    <td class="px-6 py-4 text-sm text-center text-slate-600">452</td>
                                    <td class="px-6 py-4 text-center">
                                        <span class="px-2 py-1 bg-green-100 text-green-700 text-[10px] font-bold rounded uppercase tracking-wide">Công khai</span>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="text-slate-400 hover:text-[#0555dd]"><span class="material-symbols-outlined text-[20px]">more_vert</span></button>
                                    </td>
                                </tr>
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <span class="material-symbols-outlined text-[#0555dd]">article</span>
                                            <span class="font-medium text-sm text-slate-800">Bai tap Python nang cao.docx</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-500">08/03/2026</td>
                                    <td class="px-6 py-4 text-sm text-center text-slate-600">128</td>
                                    <td class="px-6 py-4 text-center">
                                        <span class="px-2 py-1 bg-green-100 text-green-700 text-[10px] font-bold rounded uppercase tracking-wide">Công khai</span>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="text-slate-400 hover:text-[#0555dd]"><span class="material-symbols-outlined text-[20px]">more_vert</span></button>
                                    </td>
                                </tr>
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <span class="material-symbols-outlined text-[#0555dd]">table_chart</span>
                                            <span class="font-medium text-sm text-slate-800">Data Analysis NLU 2025.xlsx</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-500">01/03/2026</td>
                                    <td class="px-6 py-4 text-sm text-center text-slate-600">85</td>
                                    <td class="px-6 py-4 text-center">
                                        <span class="px-2 py-1 bg-yellow-100 text-yellow-700 text-[10px] font-bold rounded uppercase tracking-wide">Nháp</span>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="text-slate-400 hover:text-[#0555dd]"><span class="material-symbols-outlined text-[20px]">more_vert</span></button>
                                    </td>
                                </tr>
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <span class="material-symbols-outlined text-[#0555dd]">present_to_all</span>
                                            <span class="font-medium text-sm text-slate-800">Slide thuyet trinh Marketing.pptx</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-500">25/02/2026</td>
                                    <td class="px-6 py-4 text-sm text-center text-slate-600">569</td>
                                    <td class="px-6 py-4 text-center">
                                        <span class="px-2 py-1 bg-green-100 text-green-700 text-[10px] font-bold rounded uppercase tracking-wide">Công khai</span>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="text-slate-400 hover:text-[#0555dd]"><span class="material-symbols-outlined text-[20px]">more_vert</span></button>
                                    </td>
                                </tr>
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

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 pt-16 pb-8 mt-auto">
        <div class="max-w-[1280px] mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-16">
                <!-- Column 1: Brand & Social -->
                <div class="space-y-4">
                    <h2 class="text-xl font-extrabold tracking-tight text-slate-900">DocShare</h2>
                    <p class="text-slate-500 text-sm leading-relaxed max-w-xs">
                        Nền tảng chia sẻ và lưu trữ tài liệu học thuật hàng đầu cho sinh viên Việt Nam. Chúng tôi tin vào sức mạnh của kiến thức mở.
                    </p>
                    <div class="flex gap-3 pt-2">
                        <a href="#" class="w-10 h-10 flex items-center justify-center rounded-full bg-slate-100 hover:bg-slate-200 transition-colors text-slate-500">
                            <span class="material-symbols-outlined text-xl">language</span>
                        </a>
                        <a href="#" class="w-10 h-10 flex items-center justify-center rounded-full bg-slate-100 hover:bg-slate-200 transition-colors text-slate-500">
                            <span class="material-symbols-outlined text-xl">mail</span>
                        </a>
                    </div>
                </div>

                <!-- Column 2: Tài liệu -->
                <div class="space-y-4">
                    <h3 class="font-semibold text-slate-900">Tài liệu</h3>
                    <ul class="space-y-3">
                        <li><a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] transition-colors">Mới nhất</a></li>
                        <li><a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] transition-colors">Tải nhiều nhất</a></li>
                    </ul>
                </div>

                <!-- Column 3: Hỗ trợ -->
                <div class="space-y-4">
                    <h3 class="font-semibold text-slate-900">Hỗ trợ</h3>
                    <ul class="space-y-3">
                        <li><a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] transition-colors">Hướng dẫn tải</a></li>
                        <li><a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] transition-colors">Điều khoản sử dụng</a></li>
                        <li><a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] transition-colors">Liên hệ</a></li>
                    </ul>
                </div>

                <!-- Column 4: Newsletter -->
                <div class="space-y-4">
                    <h3 class="font-semibold text-slate-900">Newsletter</h3>
                    <p class="text-slate-500 text-sm">
                        Nhận thông báo khi có tài liệu mới về môn học của bạn.
                    </p>
                    <div class="flex items-center gap-2">
                        <div class="flex-grow border border-slate-200 rounded-lg px-4 py-2 bg-white flex items-center">
                            <input type="email" placeholder="Email của bạn" class="w-full border-none p-0 text-sm focus:ring-0 text-slate-800 placeholder:text-slate-400 outline-none"/>
                        </div>
                        <button class="bg-[#0555dd] w-10 h-10 flex items-center justify-center rounded-lg text-white hover:bg-blue-700 transition-colors shrink-0">
                            <span class="material-symbols-outlined text-[20px]">send</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Bottom Row -->
            <div class="pt-8 border-t border-slate-200 flex flex-col md:flex-row justify-between items-center gap-4">
                <p class="text-slate-500 text-sm">
                    © 2024 DocShare. Professional Document Repository.
                </p>
                <div class="flex gap-8">
                    <a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] hover:underline">Privacy Policy</a>
                    <a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] hover:underline">Sitemap</a>
                    <a href="#" class="text-slate-500 text-sm hover:text-[#0555dd] hover:underline">Help Center</a>
                </div>
            </div>
        </div>
    </footer>
    <script src="${pageContext.request.contextPath}/js/profile.js"></script>
</body>
</html>
