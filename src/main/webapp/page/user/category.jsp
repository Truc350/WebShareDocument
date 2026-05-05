<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Danh mục - DocShare</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/category.css">
</head>
<body>
  <jsp:include page="/common/header.jsp" />

  <main class="category-page">
    <section class="category-hero">
      <div class="container">
        <h1>Khám phá theo danh mục</h1>
        <p>Tìm tài liệu theo môn học, loại tài liệu và nhiều hơn nữa</p>
      </div>
    </section>

    <section class="doc-type-section">
      <div class="container">
        <div class="inline-title">
          <h2>Loại tài liệu</h2>
          <span>2 PHÂN LOẠI</span>
        </div>

        <div class="type-grid category-results">
          <article class="type-card category-item-card type-blue" data-title="Giáo trình sách giáo khoa giảng viên">
            <div class="type-emoji">📚</div>
            <h3>Giáo trình</h3>
            <p>Sách giáo khoa, giáo trình chính thức từ các giảng viên.</p>
            <div class="type-meta">
              <span>1,240 tài liệu</span>
              <a href="${pageContext.request.contextPath}/page/user/documents.jsp">Xem tất cả <span class="material-symbols-outlined">arrow_forward</span></a>
            </div>
          </article>

          <article class="type-card category-item-card type-orange" data-title="Bài tập bài tập lớn bài tập về nhà lời giải">
            <div class="type-emoji">✏️</div>
            <h3>Bài tập</h3>
            <p>Bài tập lớn, bài tập về nhà có lời giải từ sinh viên giỏi.</p>
            <div class="type-meta">
              <span>670 tài liệu</span>
              <a href="${pageContext.request.contextPath}/page/user/documents.jsp">Xem tất cả <span class="material-symbols-outlined">arrow_forward</span></a>
            </div>
          </article>
        </div>
      </div>
    </section>

    <section class="field-section">
      <div class="container">
        <h2>Theo Khoa / Ngành học</h2>
        <p class="section-subtitle">Lọc tài liệu theo lĩnh vực chuyên môn của bạn</p>

        <div class="field-grid category-results" id="fieldGrid">
          <a class="field-card category-item-card blue" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Công nghệ thông tin">
            <span class="field-icon"><span class="material-symbols-outlined">computer</span></span>
            <div><h3>Công nghệ thông tin</h3><p>1,245 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 85%"></i>
          </a>

          <a class="field-card category-item-card green" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Toán học">
            <span class="field-icon"><span class="material-symbols-outlined">architecture</span></span>
            <div><h3>Toán học</h3><p>890 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 60%"></i>
          </a>

          <a class="field-card category-item-card purple" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Vật lý">
            <span class="field-icon"><span class="material-symbols-outlined">science</span></span>
            <div><h3>Vật lý</h3><p>540 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 45%"></i>
          </a>

          <a class="field-card category-item-card orange" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Hóa học">
            <span class="field-icon"><span class="material-symbols-outlined">experiment</span></span>
            <div><h3>Hóa học</h3><p>420 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 35%"></i>
          </a>

          <a class="field-card category-item-card teal" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Kinh tế">
            <span class="field-icon"><span class="material-symbols-outlined">query_stats</span></span>
            <div><h3>Kinh tế</h3><p>1,100 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 75%"></i>
          </a>

          <a class="field-card category-item-card red" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="Tiếng Anh">
            <span class="field-icon"><span class="material-symbols-outlined">translate</span></span>
            <div><h3>Tiếng Anh</h3><p>950 tài liệu</p></div>
            <span class="material-symbols-outlined arrow">chevron_right</span>
            <i style="--value: 65%"></i>
          </a>
        </div>

        <button class="field-more" id="toggleFields" type="button">
          Xem tất cả khoa/ngành học
          <span class="material-symbols-outlined">expand_more</span>
        </button>
      </div>
    </section>

    <section class="format-section">
      <div class="container">
        <h2>Theo Định dạng file</h2>
        <div class="format-grid category-results">
          <a class="format-card category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="PDF"><strong class="red">PDF</strong><div><b>2,340 files</b><span>Portable Doc</span></div></a>
          <a class="format-card category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="DOCX"><strong class="blue">DOCX</strong><div><b>1,120 files</b><span>Word Document</span></div></a>
          <a class="format-card category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="PPTX"><strong class="orange">PPTX</strong><div><b>567 files</b><span>PowerPoint</span></div></a>
          <a class="format-card category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="XLSX"><strong class="green">XLSX</strong><div><b>234 files</b><span>Excel Sheet</span></div></a>
          <a class="format-card category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="TXT"><strong class="gray">TXT</strong><div><b>89 files</b><span>Plain Text</span></div></a>
        </div>
      </div>
    </section>

    <section class="topic-section">
      <div class="container">
        <div class="topic-box">
          <h2>Chủ đề phổ biến</h2>
          <div class="tag-cloud category-results">
            <a class="category-item-card large" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="giải tích">#giải-tích</a>
            <a class="category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="lập trình java">#lập-trình-java</a>
            <a class="category-item-card small" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="cơ sở dữ liệu">#cơ-sở-dữ-liệu</a>
            <a class="category-item-card large" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="vật lý đại cương">#vật-lý-đại-cương</a>
            <a class="category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="kinh tế vi mô">#kinh-tế-vi-mô</a>
            <a class="category-item-card small" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="tiếng anh chuyên ngành">#tiếng-anh-chuyên-ngành</a>
            <a class="category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="giải tích 2">#giải-tích-2</a>
            <a class="category-item-card small" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="lập trình web">#lập-trình-web</a>
            <a class="category-item-card" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="toán rời rạc">#toán-rời-rạc</a>
            <a class="category-item-card small" href="${pageContext.request.contextPath}/page/user/documents.jsp" data-title="hóa hữu cơ">#hóa-hữu-cơ</a>
          </div>
          <p class="empty-category" id="emptyCategory">Không tìm thấy danh mục phù hợp.</p>
        </div>
      </div>
    </section>
  </main>

  <jsp:include page="/common/footer.jsp" />

  <script src="${pageContext.request.contextPath}/js/home.js"></script>
  <script src="${pageContext.request.contextPath}/js/category.js"></script>
</body>
</html>
