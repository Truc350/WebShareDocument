<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DocShare - Chia sẻ tài liệu học tập</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=${System.currentTimeMillis()}">
</head>
<body>
<jsp:include page="/common/header.jsp"/>
<main>
    <section class="hero">
        <div class="container">
            <h1>Chia sẻ tài liệu học tập dễ dàng</h1>
            <p class="hero-text">Tìm kiếm, tải về và chia sẻ hàng nghìn tài liệu miễn phí từ cộng đồng sinh viên và
                giảng viên uy tín trên toàn quốc.</p>

            <div class="quick-tags">
                <button class="tag" type="button" data-topic="Giáo trình">Giáo trình</button>
                <button class="tag" type="button" data-topic="Tai lieu tham khao">Tài liệu tham khảo</button>
                <button class="tag active" type="button" data-topic="all">Tất cả</button>
            </div>
            <div class="hero-stats">
                <div class="stat-item">
                    <strong><fmt:formatNumber value="${stats.totalDocuments != null ? stats.totalDocuments : 0}" type="number"/>+</strong>
                    <span>Tài liệu</span>
                </div>
                <div class="stat-item">
                    <strong><fmt:formatNumber value="${stats.totalUsers != null ? stats.totalUsers : 0}" type="number"/>+</strong>
                    <span>Sinh viên</span>
                </div>
                <div class="stat-item">
                    <strong><fmt:formatNumber value="${stats.totalCategories != null ? stats.totalCategories : 0}" type="number"/>+</strong>
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
                <c:if test="${not empty mainFeatured}">
                    <article class="main-featured-card document-card" style="cursor: pointer;"
                             onclick="window.location.href='${pageContext.request.contextPath}/page/user/document-detail.jsp?id=${mainFeatured.id}'"
                             data-title="${mainFeatured.title}" data-category="${mainFeatured.categoryName}">
                        <div class="card-image-wrap">
                            <c:if test="${(mainFeatured.viewCount + mainFeatured.downloadCount) > 50}">
                                <span class="badge-hot">HOT</span>
                            </c:if>
                            <c:set var="thumbUrl" value="https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=800"/>
                            <c:if test="${mainFeatured.categoryName == 'Giáo trình'}">
                                <c:set var="thumbUrl" value="https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&q=80&w=800"/>
                            </c:if>
                            <c:if test="${mainFeatured.categoryName == 'Tài liệu tham khảo'}">
                                <c:set var="thumbUrl" value="https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&q=80&w=800"/>
                            </c:if>
                            <img src="${thumbUrl}" alt="${mainFeatured.title}" onerror="this.src='https://placehold.co/800x600/2563eb/white?text=DocShare'">
                        </div>
                        <div class="card-content">
                            <div class="card-tags">
                                <span class="badge-tag">${fn:toUpperCase(mainFeatured.categoryName != null ? mainFeatured.categoryName : 'CHUNG')}</span>
                                <span class="view-count">
                                    <span class="material-symbols-outlined">visibility</span>
                                    <fmt:formatNumber value="${mainFeatured.viewCount}" type="number"/>
                                </span>
                            </div>
                            <h3>${mainFeatured.title}</h3>
                            <p class="card-desc">${fn:substring(mainFeatured.description, 0, 120)}${fn:length(mainFeatured.description) > 120 ? '...' : ''}</p>
                            <div class="author-meta">
                                <div class="author">
                                    <div class="author-avatar"></div>
                                    <span>${mainFeatured.uploaderName != null ? mainFeatured.uploaderName : 'Người dùng DocShare'}</span>
                                </div>
                                <div class="updated-time">
                                    <fmt:parseDate value="${mainFeatured.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                    Cập nhật <fmt:formatDate value="${mainFeatured.getCreatedAtDate()}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                        </div>
                    </article>
                </c:if>
                <div class="sub-featured-list">
                    <c:forEach items="${subFeatured}" var="doc">
                        <article class="small-featured-card document-card" style="cursor: pointer;"
                                 onclick="window.location.href='${pageContext.request.contextPath}/page/user/document-detail.jsp?id=${doc.id}'"
                                 data-title="${doc.title}" data-category="${doc.categoryName}">
                            <div class="card-icon-wrap">
                                <c:choose>
                                    <c:when test="${doc.fileExtension == 'pdf'}">
                                        <span class="material-symbols-outlined" style="color: #ef4444;">picture_as_pdf</span>
                                    </c:when>
                                    <c:when test="${doc.fileExtension == 'docx' || doc.fileExtension == 'doc'}">
                                        <span class="material-symbols-outlined" style="color: #2563eb;">description</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="material-symbols-outlined" style="color: #64748b;">article</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <div class="card-footer" style="margin-bottom: 8px;">
                                    <span class="doc-info">${fn:toUpperCase(doc.fileExtension)} • <fmt:formatNumber value="${doc.fileSize / 1024 / 1024}" maxFractionDigits="1"/> MB</span>
                                </div>
                                <h4>${doc.title}</h4>
                                <p>${fn:substring(doc.description, 0, 60)}${fn:length(doc.description) > 60 ? '...' : ''}</p>
                                <div class="card-footer">
                                    <c:choose>
                                        <c:when test="${doc.downloadCount > 100}">
                                            <span class="status-label">${doc.downloadCount}+ LƯỢT TẢI</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-label">TÀI LIỆU MỚI</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="material-symbols-outlined" style="font-size: 18px; color: #cbd5e1;">arrow_forward</span>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                    <c:if test="${empty subFeatured}">
                        <p style="text-align: center; color: #64748b; padding: 2rem;">Chưa có tài liệu nổi bật khác.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </section>
    <section class="section category-section">
        <div class="container">
            <div class="centered">
                <h2>Danh mục</h2>
                <div style="width: 40px; height: 3px; background: var(--primary); margin: 12px auto 0;"></div>
            </div>
            <div class="category-grid">
                <c:forEach items="${categories}" var="cat">
                    <a href="${pageContext.request.contextPath}/page/user/category.jsp?slug=${cat.slug}" class="category-item">
                        <c:choose>
                            <c:when test="${cat.name == 'Giáo trình'}">
                                <span class="material-symbols-outlined">menu_book</span>
                            </c:when>
                            <c:when test="${cat.name == 'Tài liệu tham khảo'}">
                                <span class="material-symbols-outlined">library_books</span>
                            </c:when>
                            <c:otherwise>
                                <span class="material-symbols-outlined">folder</span>
                            </c:otherwise>
                        </c:choose>
                        <strong>${cat.name}</strong>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>
</main>
<jsp:include page="/common/footer.jsp"/>
<button class="back-to-top" type="button" aria-label="Lên đầu trang">
    <span class="material-symbols-outlined">arrow_upward</span>
</button>
<script src="${pageContext.request.contextPath}/js/home.js?v=${System.currentTimeMillis()}"></script>
</body>
</html>
