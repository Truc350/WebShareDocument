<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Danh sách tài liệu - DocShare</title>
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
        <a href="${pageContext.request.contextPath}/page/home.jsp">Trang chủ</a>
        <span class="material-symbols-outlined">chevron_right</span>
        <span>Tài liệu</span>
      </nav>

      <section class="documents-hero">
        <div>
          <p class="eyebrow">Kho tài liệu</p>
          <h1>Danh sách tài liệu học tập</h1>
          <p>Tìm kiếm, lọc và sắp xếp tài liệu theo danh mục, môn học hoặc định dạng file.</p>
        </div>
        <form class="documents-search" id="documentsSearch">
          <span class="material-symbols-outlined">search</span>
          <input id="documentKeyword" type="search" placeholder="Tìm kiếm tài liệu...">
          <button class="btn btn-primary" type="submit">Tìm</button>
        </form>
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
            <p>Tìm thấy <strong id="resultCount">6</strong> tài liệu</p>
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
            <article class="doc-card" data-title="Giáo trình Kinh tế Vi mô" data-category="Giáo trình" data-subject="Kinh tế" data-format="PDF" data-downloads="567" data-date="2024-04-12">
              <div class="doc-preview preview-blue"><span class="doc-format">PDF</span><span class="material-symbols-outlined">description</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">article</span> giao-trinh-kinh-te-vimo.pdf</p>
                <h3>Giáo trình Kinh tế Vi mô - Lý thuyết và bài tập ứng dụng</h3>
                <p class="doc-desc">Tài liệu tổng hợp kiến thức nền tảng, biểu đồ cung cầu và bài tập phân tích thị trường.</p>
                <div class="doc-author"><span>NA</span><div><strong>Nguyễn Văn A</strong><small>12 Th04, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>1,234</span><span><span class="material-symbols-outlined">download</span>567</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>

            <article class="doc-card" data-title="Đề thi Toán cao cấp 1" data-category="Đề thi" data-subject="Toán" data-format="DOCX" data-downloads="890" data-date="2024-04-05">
              <div class="doc-preview preview-green"><span class="doc-format">DOCX</span><span class="material-symbols-outlined">article</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">article</span> de-thi-toan-cao-cap-1.docx</p>
                <h3>Đề thi kết thúc học phần Toán cao cấp 1 - Khối ngành Kinh tế</h3>
                <p class="doc-desc">Bộ đề luyện tập có đáp án, phù hợp ôn thi giữa kỳ và cuối kỳ.</p>
                <div class="doc-author"><span>LB</span><div><strong>Lê Thị B</strong><small>05 Th04, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>2,105</span><span><span class="material-symbols-outlined">download</span>890</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>

            <article class="doc-card" data-title="Bài giảng Trí tuệ Nhân tạo" data-category="Tham khảo" data-subject="CNTT" data-format="PPTX" data-downloads="234" data-date="2024-03-28">
              <div class="doc-preview preview-orange"><span class="doc-format">PPTX</span><span class="material-symbols-outlined">present_to_all</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">slideshow</span> bai-giang-tri-tue-nhan-tao.pptx</p>
                <h3>Bài giảng Nhập môn Trí tuệ Nhân tạo - Kiến trúc và thuật toán</h3>
                <p class="doc-desc">Slide giới thiệu tìm kiếm, học máy cơ bản và các ứng dụng AI phổ biến.</p>
                <div class="doc-author"><span>TH</span><div><strong>Trần Huy</strong><small>28 Th03, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>956</span><span><span class="material-symbols-outlined">download</span>234</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>

            <article class="doc-card" data-title="Tài liệu ôn thi Hóa học hữu cơ" data-category="Bài tập" data-subject="Hóa học" data-format="PDF" data-downloads="1120" data-date="2024-03-25">
              <div class="doc-preview preview-red"><span class="doc-format">PDF</span><span class="material-symbols-outlined">science</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">description</span> on-thi-hoa-huu-co.pdf</p>
                <h3>Tài liệu ôn thi THPT Quốc gia môn Hóa học - Chuyên đề Hữu cơ</h3>
                <p class="doc-desc">Công thức, phản ứng thường gặp và hệ thống bài tập theo mức độ.</p>
                <div class="doc-author"><span>PN</span><div><strong>Phạm Ngọc</strong><small>25 Th03, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>3,450</span><span><span class="material-symbols-outlined">download</span>1,120</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>

            <article class="doc-card" data-title="Bài tập Lập trình C cơ bản" data-category="Bài tập" data-subject="CNTT" data-format="PDF" data-downloads="640" data-date="2024-03-20">
              <div class="doc-preview preview-blue"><span class="doc-format">PDF</span><span class="material-symbols-outlined">terminal</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">code</span> bai-tap-lap-trinh-c.pdf</p>
                <h3>Bài tập Lập trình C cơ bản từ con số 0</h3>
                <p class="doc-desc">Bài tập theo chương, từ biến, vòng lặp đến mảng và hàm.</p>
                <div class="doc-author"><span>MT</span><div><strong>Mai Tuấn</strong><small>20 Th03, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>1,840</span><span><span class="material-symbols-outlined">download</span>640</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>

            <article class="doc-card" data-title="Bảng công thức Excel kế toán" data-category="Tham khảo" data-subject="Kinh tế" data-format="XLSX" data-downloads="312" data-date="2024-03-18">
              <div class="doc-preview preview-green"><span class="doc-format">XLSX</span><span class="material-symbols-outlined">table_chart</span></div>
              <div class="doc-body">
                <p class="doc-file"><span class="material-symbols-outlined">table</span> cong-thuc-excel-ke-toan.xlsx</p>
                <h3>Bảng công thức Excel cho kế toán và phân tích tài chính</h3>
                <p class="doc-desc">Template công thức, hàm thống kê và ví dụ xử lý số liệu thực tế.</p>
                <div class="doc-author"><span>QL</span><div><strong>Quỳnh Lâm</strong><small>18 Th03, 2024</small></div></div>
                <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>740</span><span><span class="material-symbols-outlined">download</span>312</span></div>
                <button type="button">Xem chi tiết</button>
              </div>
            </article>
          </div>

          <p class="empty-state" id="emptyState">Không tìm thấy tài liệu phù hợp.</p>

          <div class="pagination" aria-label="Phân trang">
            <button type="button"><span class="material-symbols-outlined">chevron_left</span></button>
            <button type="button">1</button>
            <button class="active" type="button">2</button>
            <button type="button">3</button>
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
