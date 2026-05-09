<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - DocShare</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/documents.css">
</head>
<body>
<jsp:include page="/common/header.jsp" />

<main class="documents-page">
    <div class="container">
        <nav class="breadcrumb" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/page/user/home.jsp">Trang chủ</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span>Tìm kiếm</span>
        </nav>

        <section class="documents-hero">
            <div>
                <p class="eyebrow">Tìm kiếm tài liệu</p>
                <h1>Kết quả tìm kiếm</h1>
                <p>Hiển thị các tài liệu phù hợp với từ khóa và tiêu chí lọc của bạn.</p>
            </div>
        </section>

        <div class="documents-layout">
            <aside class="filter-sidebar" aria-label="Bộ lọc tài liệu">
                <div class="filter-header">
                    <h2>Bộ lọc</h2>
                    <button id="clearFilters" type="button">Xóa lọc</button>
                </div>

                <section class="filter-group">
                    <h3>Danh mục</h3>
                    <label><input type="checkbox" name="category" value="Giáo trình"> Giáo trình</label>
                    <label><input type="checkbox" name="category" value="Đề thi"> Đề thi</label>
                    <label><input type="checkbox" name="category" value="Bài tập"> Bài tập</label>
                    <label><input type="checkbox" name="category" value="Tham khảo"> Tham khảo</label>
                </section>

                <section class="filter-group">
                    <h3>Môn học</h3>
                    <label><input type="checkbox" name="subject" value="Toán"> Toán</label>
                    <label><input type="checkbox" name="subject" value="CNTT"> CNTT</label>
                    <label><input type="checkbox" name="subject" value="Kinh tế"> Kinh tế</label>
                    <label><input type="checkbox" name="subject" value="Hóa học"> Hóa học</label>
                </section>

                <section class="filter-group">
                    <h3>Định dạng</h3>
                    <label><input type="checkbox" name="format" value="PDF"> PDF</label>
                    <label><input type="checkbox" name="format" value="DOCX"> DOCX</label>
                    <label><input type="checkbox" name="format" value="PPTX"> PPTX</label>
                    <label><input type="checkbox" name="format" value="XLSX"> XLSX</label>
                </section>
            </aside>

            <section class="documents-content">
                <div class="documents-toolbar">
                    <p>Tìm thấy <strong id="resultCount">0</strong> tài liệu</p>
                    <div class="toolbar-actions">
                        <button class="view-toggle active" type="button" data-view="grid" aria-label="Xem dạng lưới">
                            <span class="material-symbols-outlined">grid_view</span>
                        </button>
                        <button class="view-toggle" type="button" data-view="list" aria-label="Xem dạng danh sách">
                            <span class="material-symbols-outlined">view_list</span>
                        </button>
                        <select id="sortDocuments" aria-label="Sắp xếp tài liệu">
                            <option value="newest">Mới nhất</option>
                            <option value="popular">Tải nhiều nhất</option>
                            <option value="title">Tên A-Z</option>
                        </select>
                    </div>
                </div>

                <div class="documents-grid" id="documentsGrid">
                    <!-- Danh sách tài liệu sẽ được render bằng JS tại đây -->
                </div>

                <p class="empty-state" id="emptyState" style="display: none;">Đang tìm kiếm...</p>

                <div class="pagination" aria-label="Phân trang">
                    <button type="button"><span class="material-symbols-outlined">chevron_left</span></button>
                    <button class="active" type="button">1</button>
                    <button type="button"><span class="material-symbols-outlined">chevron_right</span></button>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/home.js"></script>
<script src="${pageContext.request.contextPath}/js/documents.js"></script>
</body>
</html>
