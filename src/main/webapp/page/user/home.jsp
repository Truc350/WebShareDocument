<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>DocShare - Chia sẻ tài liệu học tập</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
  <jsp:include page="/common/header.jsp" />


  <main>
    <section class="hero">
      <div class="container">
        <h1>Chia sẻ tài liệu học tập dễ dàng</h1>
        <p class="hero-text">Tìm kiếm, tải về và chia sẻ hàng nghìn tài liệu miễn phí từ cộng đồng sinh viên và giảng viên uy tín trên toàn quốc.</p>
        
        <div class="search-container">
          <form class="search-panel" id="homeSearch">
            <span class="material-symbols-outlined">search</span>
            <input id="searchInput" name="keyword" type="text" placeholder="Tìm kiếm tài liệu theo tên hoặc chủ đề...">
            <button class="btn btn-primary" type="submit">Tìm kiếm</button>
          </form>
        </div>

        <div class="quick-tags">
          <button class="tag" type="button" data-topic="Giáo trình">Giáo trình</button>
          <button class="tag" type="button" data-topic="Bài tập">Bài tập</button>
          <button class="tag active" type="button" data-topic="all">Tất cả</button>
        </div>

        <div class="hero-stats">
          <div class="stat-item">
            <strong>10,000+</strong>
            <span>Tài liệu</span>
          </div>
          <div class="stat-item">
            <strong>5,000+</strong>
            <span>Sinh viên</span>
          </div>
          <div class="stat-item">
            <strong>500+</strong>
            <span>Môn học</span>
          </div>
        </div>
      </div>
    </section>

    <section class="section">
      <div class="container">
        <div class="section-heading">
          <div>
            <p class="eyebrow">KHÁM PHÁ</p>
            <h2>Tài liệu nổi bật nhất</h2>
          </div>
          <a class="link-more" href="${pageContext.request.contextPath}/page/user/category.jsp">
            Xem tất cả
            <span class="material-symbols-outlined">arrow_forward</span>
          </a>
        </div>

        <div class="featured-grid" id="documentGrid">
          <!-- Featured Main Card -->
          <article class="main-featured-card document-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/page/user/document-detail.jsp'" data-title="Giáo trình Giải tích 1 - Đại học Bách Khoa Hà Nội" data-category="Kỹ thuật">
            <div class="card-image-wrap">
              <span class="badge-hot">HOT</span>
              <img src="https://images.unsplash.com/photo-1544391439-1df5c17ad713?auto=format&fit=crop&q=80&w=800" alt="Laptop mockup">
            </div>
            <div class="card-content">
              <div class="card-tags">
                <span class="badge-tag">KỸ THUẬT</span>
                <span class="view-count">
                  <span class="material-symbols-outlined">visibility</span>
                  12.5k
                </span>
              </div>
              <h3>Giáo trình Giải tích 1 - Đại học Bách Khoa Hà Nội</h3>
              <p class="card-desc">Bộ tài liệu tổng hợp đầy đủ các chương từ giới hạn hàm số, đạo hàm đến tích phân bất định. Bao gồm lý thuyết trọng tâm...</p>
              <div class="author-meta">
                <div class="author">
                  <div class="author-avatar"></div>
                  <span>Nguyễn Văn An</span>
                </div>
                <div class="updated-time">Cập nhật 2 ngày trước</div>
              </div>
            </div>
          </article>

          <!-- Sub Featured Cards -->
          <div class="sub-featured-list">
            <article class="small-featured-card document-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/page/user/document-detail.jsp'" data-title="Lập trình C cơ bản từ con số 0" data-category="Công nghệ">
              <div class="card-icon-wrap">
                <span class="material-symbols-outlined" style="color: #2563eb;">terminal</span>
              </div>
              <div class="card-body">
                <div class="card-footer" style="margin-bottom: 8px;">
                  <span class="doc-info">PDF • 4.2 MB</span>
                </div>
                <h4>Lập trình C cơ bản từ con số 0</h4>
                <p>Hướng dẫn chi tiết cài đặt môi trường và các cú pháp cơ bản trong C...</p>
                <div class="card-footer">
                  <span class="status-label">TÀI LIỆU FREE</span>
                  <span class="material-symbols-outlined" style="font-size: 18px; color: #cbd5e1;">arrow_forward</span>
                </div>
              </div>
            </article>

            <article class="small-featured-card document-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/page/user/document-detail.jsp'" data-title="Tâm lý học đại cương - Tổng hợp đề thi" data-category="Khoa học">
              <div class="card-icon-wrap">
                <span class="material-symbols-outlined" style="color: #2563eb;">psychology</span>
              </div>
              <div class="card-body">
                <div class="card-footer" style="margin-bottom: 8px;">
                  <span class="doc-info">DOCX • 1.8 MB</span>
                </div>
                <h4>Tâm lý học đại cương - Tổng hợp đề thi</h4>
                <p>Ngân hàng câu hỏi trắc nghiệm và tự luận ôn tập kỳ thi cuối kỳ...</p>
                <div class="card-footer">
                  <span class="status-label">500+ LƯỢT TẢI</span>
                  <span class="material-symbols-outlined" style="font-size: 18px; color: #cbd5e1;">arrow_forward</span>
                </div>
              </div>
            </article>
          </div>
        </div>
      </div>
    </section>

    <section class="section category-section">
      <div class="container">
        <div class="centered">
          <h2>Duyệt theo chuyên ngành</h2>
          <div style="width: 40px; height: 3px; background: var(--primary); margin: 12px auto 0;"></div>
        </div>
        
        <div class="category-grid">
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">account_balance</span>
            <strong>Kinh tế</strong>
          </a>
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">gavel</span>
            <strong>Luật học</strong>
          </a>
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">developer_board</span>
            <strong>Công nghệ</strong>
          </a>
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">medical_services</span>
            <strong>Y dược</strong>
          </a>
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">palette</span>
            <strong>Nghệ thuật</strong>
          </a>
          <a href="${pageContext.request.contextPath}/page/user/category.jsp" class="category-item">
            <span class="material-symbols-outlined">language</span>
            <strong>Ngoại ngữ</strong>
          </a>
        </div>
      </div>
    </section>
  </main>

  <jsp:include page="/common/footer.jsp" />


  <button class="back-to-top" type="button" aria-label="Lên đầu trang">
    <span class="material-symbols-outlined">arrow_upward</span>
  </button>

  <script src="${pageContext.request.contextPath}/js/home.js"></script>
</body>
</html>
