<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng tải tài liệu - DocShare</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/upload.css">
</head>
<body>
<jsp:include page="/common/header.jsp"/>
<main class="upload-page">
    <div class="upload-shell">
        <section class="upload-heading">
            <h1>
                <span class="material-symbols-outlined">upload_file</span>
                Đăng tải tài liệu mới
            </h1>
            <p>Chia sẻ kiến thức của bạn với cộng đồng người học trên toàn thế giới.</p>
        </section>
        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="upload-alert success">
            <span class="material-symbols-outlined">check_circle</span>
            <div>
                <strong><%= request.getAttribute("successMessage") %>
                </strong>
                <p>File đã lưu: <%= request.getAttribute("uploadedFileName") %>
                </p>
            </div>
        </div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="upload-alert error">
            <span class="material-symbols-outlined">error</span>
            <div>
                <strong>Chưa thể đăng tải</strong>
                <p><%= request.getAttribute("errorMessage") %>
                </p>
            </div>
        </div>
        <% } %>
        <section class="upload-card">
            <form id="uploadForm" action="${pageContext.request.contextPath}/upload" method="post"
                  enctype="multipart/form-data" novalidate data-context="${pageContext.request.contextPath}">
                <label class="dropzone" id="dropzone" for="documentFile">
                    <input id="documentFile" name="documentFile" type="file"
                           accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt,.png,.jpg,.jpeg">
                    <span class="upload-cloud">
              <span class="material-symbols-outlined">cloud_upload</span>
            </span>
                    <strong>Kéo thả file vào đây hoặc</strong>
                    <span class="choose-file">
              <span class="material-symbols-outlined">attach_file</span>
              Chọn file
            </span>
                    <small>Hỗ trợ: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, TXT, PNG, JPG · Tối đa 50MB</small>
                </label>
                <div class="file-preview" id="filePreview" hidden>
                    <span class="material-symbols-outlined">draft</span>
                    <div>
                        <strong id="fileName">Tên file</strong>
                        <p id="fileMeta">0 MB</p>
                    </div>
                    <button id="removeFile" type="button" aria-label="Xóa file">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <div class="form-grid">
                    <div class="field full">
                        <label for="title">Tiêu đề tài liệu*</label>
                        <input id="title" name="title" type="text" placeholder="Nhập tiêu đề ngắn gọn và rõ ràng"
                               required>
                    </div>
                    <div class="field">
                        <label for="category">Danh mục*</label>
                        <select id="category" name="category" required>
                            <option value="">Chọn danh mục</option>
                            <option value="Giáo trình">Giáo trình</option>
                            <option value="Tài liệu tham khảo">Tài liệu tham khảo</option>
                        </select>
                    </div>
                    <div class="field">
                        <label for="subject">Môn học*</label>
                        <input id="subject" name="subject" type="text" placeholder="Nhập tên môn học" required>
                    </div>
                    <div class="field full">
                        <label for="description">Mô tả</label>
                        <textarea id="description" name="description" rows="4"
                                  placeholder="Mô tả nội dung tài liệu để người khác dễ dàng tìm kiếm..."></textarea>
                    </div>
                    <label class="terms full">
                        <input id="terms" name="terms" type="checkbox" required>
                        <span>Tôi đồng ý với <a href="#">điều khoản chia sẻ bản quyền</a> của DocShare và cam kết tài liệu không vi phạm pháp luật.</span>
                    </label>
                </div>
                <p class="form-error" id="formError" aria-live="polite"></p>
                <div class="upload-actions">
                    <!-- UC5.2.2: Người dùng nhấn nút 'Hủy' -->
                    <button class="cancel-btn" type="button" id="cancelForm"
                            data-home="${pageContext.request.contextPath}/page/user/home.jsp">Hủy
                    </button>
                    <button class="submit-btn" id="submitUpload" type="submit">
                        <span class="material-symbols-outlined">publish</span>
                        Đăng tải ngay
                    </button>
                </div>
            </form>
        </section>
        <section class="upload-tips">
            <article>
                <span class="material-symbols-outlined">verified</span>
                <div>
                    <h2>Độ tin cậy cao</h2>
                    <p>Tài liệu có đầy đủ mô tả và thẻ tag có tỉ lệ tải về cao hơn 40%.</p>
                </div>
            </article>
            <article>
                <span class="material-symbols-outlined">lightbulb</span>
                <div>
                    <h2>Mẹo đăng tải</h2>
                    <p>Sử dụng tiêu đề rõ ràng và gắn thẻ chính xác giúp tài liệu dễ được tìm thấy hơn.</p>
                </div>
            </article>
        </section>
    </div>
</main>
<jsp:include page="/common/footer.jsp"/>
<div id="customModal" class="modal-overlay" hidden>
    <div class="modal-card">
        <div class="modal-icon">
            <span class="material-symbols-outlined" id="modalIcon">warning</span>
        </div>
        <h2 id="modalTitle">Xác nhận</h2>
        <p id="modalMessage">Bạn có chắc chắn muốn thực hiện hành động này?</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="modalCancel">Hủy bỏ</button>
            <button type="button" class="btn btn-danger" id="modalConfirm">Đồng ý</button>
        </div>
    </div>
</div>
<!-- UC5.1.8: Hiển thị thanh tiến trình -->
<div id="progressContainer" class="modal-overlay progress-overlay" hidden>
    <div class="modal-card progress-card">
        <div class="modal-icon progress-icon">
            <span class="material-symbols-outlined rotating">sync</span>
        </div>
        <h2>Đang truyền tải tài liệu</h2>
        <p id="progressStatus">Đang gửi tệp lên File Storage System...</p>
        <div class="progress-bar-bg">
            <div class="progress-bar-fill" id="progressBarFill"></div>
        </div>
        <div class="progress-percentage" id="progressText">0%</div>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelUpload">Hủy tải lên</button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/home.js"></script>
<script src="${pageContext.request.contextPath}/js/upload.js"></script>
</body>
</html>
