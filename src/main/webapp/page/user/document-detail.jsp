<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.websharedocument.model.Document" %>
<%
    Document doc = (Document) request.getAttribute("document");
    if (doc == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    // Tiện ích format kích thước file
    String sizeDisplay;
    double sizeMB = doc.getFileSize() / (1024.0 * 1024.0);
    if (sizeMB >= 1) {
        sizeDisplay = String.format("%.2f MB", sizeMB);
    } else {
        sizeDisplay = String.format("%.1f KB", doc.getFileSize() / 1024.0);
    }
    // Format ngày đăng tải
    String uploadDate = "";
    if (doc.getCreatedAt() != null) {
        uploadDate = String.format("%02d/%02d/%d",
                doc.getCreatedAt().getDayOfMonth(),
                doc.getCreatedAt().getMonthValue(),
                doc.getCreatedAt().getYear());
    }
    String categoryName = doc.getCategoryName() != null ? doc.getCategoryName() : "Chưa phân loại";
    String uploaderName = doc.getUploaderName() != null ? doc.getUploaderName() : "Ẩn danh";
    String ext = doc.getFileExtension() != null ? doc.getFileExtension().toUpperCase() : "FILE";
    String description = doc.getDescription() != null && !doc.getDescription().isEmpty()
            ? doc.getDescription() : "Chưa có mô tả.";
    String fileUrl = request.getContextPath() + "/document/uploads/" + doc.getFilePath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= doc.getTitle() %> - DocShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@600;700;800&display=swap"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <style>
        body {
            background: #f8f9ff;
            font-family: 'Inter', sans-serif;
            color: #1a1b23;
        }

        .detail-container {
            max-width: 1280px;
            margin: 90px auto 60px;
            padding: 0 24px;
            display: grid;
            grid-template-columns: 1fr 280px;
            gap: 24px;
        }

        @media (max-width: 860px) {
            .detail-container {
                grid-template-columns: 1fr;
            }
        }

        .doc-viewer {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, .07);
            overflow: hidden;
        }

        .viewer-toolbar {
            background: #f5f6fa;
            border-bottom: 1px solid #eaeaf0;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .viewer-toolbar .ext-badge {
            background: #0040ab;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 6px;
            letter-spacing: .5px;
        }

        .viewer-toolbar .doc-title-bar {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .doc-preview-area {
            min-height: 500px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 12px;
            background: #f0f2f8;
        }

        .doc-preview-area iframe {
            width: 100%;
            height: calc(85vh - 100px);
            min-height: 540px;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, .12);
        }

        .file-icon-preview {
            text-align: center;
        }

        .file-icon-preview .material-symbols-outlined {
            font-size: 96px;
            color: #0040ab;
        }

        .file-icon-preview p {
            color: #555;
            margin-top: 12px;
            font-size: 15px;
        }

        .doc-meta-section {
            padding: 28px;
        }

        .doc-meta-section h1 {
            font-family: 'Manrope', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: #0a0b14;
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .tag-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 16px;
        }

        .tag-chip {
            background: #eef2ff;
            color: #0040ab;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .description-text {
            color: #555;
            font-size: 15px;
            line-height: 1.7;
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, .07);
            padding: 24px;
        }

        .btn-download {
            width: 100%;
            background: linear-gradient(135deg, #0040ab, #0055e6);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 14px 20px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: transform .15s, opacity .15s;
            text-decoration: none;
        }

        .btn-download:hover {
            opacity: .92;
            transform: translateY(-1px);
        }

        .stat-row {
            display: flex;
            justify-content: space-around;
            margin-top: 16px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item .material-symbols-outlined {
            font-size: 20px;
            color: #888;
        }

        .stat-item span.val {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .stat-item span.lbl {
            display: block;
            font-size: 11px;
            color: #aaa;
        }

        .info-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .info-list li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f2f2f8;
            font-size: 14px;
        }

        .info-list li:last-child {
            border-bottom: none;
        }

        .info-list li .lbl {
            color: #888;
        }

        .info-list li .val {
            font-weight: 600;
            color: #222;
        }

        .ext-val {
            background: #eef2ff;
            color: #0040ab;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        .uploader-card {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0040ab, #5c8aff);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 20px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .uploader-name {
            font-weight: 700;
            font-size: 15px;
        }

        .uploader-sub {
            color: #888;
            font-size: 13px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #888;
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: #0040ab;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<jsp:include page="/common/header.jsp"/>
<div class="detail-container">
    <div style="grid-column: 1 / -1;">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span class="material-symbols-outlined" style="font-size:16px;">chevron_right</span>
            <a href="${pageContext.request.contextPath}/page/user/documents.jsp">Tài liệu</a>
            <span class="material-symbols-outlined" style="font-size:16px;">chevron_right</span>
            <span><%= doc.getTitle() %></span>
        </nav>
    </div>
    <div>
        <div class="doc-viewer">
            <div class="viewer-toolbar">
                <span class="ext-badge"><%= ext %></span>
                <span class="doc-title-bar"><%= doc.getTitle() %></span>
            </div>
            <div class="doc-preview-area" id="previewArea">
                <% if ("pdf".equalsIgnoreCase(doc.getFileExtension())) { %>
                <iframe src="<%= fileUrl %>" title="Xem tài liệu PDF"
                        style="width:100%;height:calc(85vh - 100px);min-height:540px;border:none;border-radius:8px;"></iframe>
                <% } else if (doc.getFileType() != null && doc.getFileType().startsWith("image/")) { %>
                <img src="<%= fileUrl %>" alt="<%= doc.getTitle() %>"
                     style="max-width:100%;max-height:620px;border-radius:8px;box-shadow:0 4px 20px rgba(0,0,0,.12);">
                <% } else if ("docx".equalsIgnoreCase(doc.getFileExtension()) || "doc".equalsIgnoreCase(doc.getFileExtension())) { %>
                <div id="docxViewer"
                     style="width:100%;min-height:calc(85vh - 100px);background:#fff;border-radius:8px;padding:40px 48px;box-shadow:0 2px 12px rgba(0,0,0,.08);text-align:left;font-size:15px;line-height:1.9;overflow-y:auto;">
                    <div style="text-align:center;padding:40px;color:#888;">
                        <span class="material-symbols-outlined"
                              style="font-size:48px;color:#0040ab;">hourglass_top</span>
                        <p>Đang tải nội dung tài liệu...</p>
                    </div>
                </div>
                <script>window._docxUrl = '<%= fileUrl %>';</script>
                <% } else if ("xlsx".equalsIgnoreCase(doc.getFileExtension()) || "xls".equalsIgnoreCase(doc.getFileExtension())) { %>
                <div id="xlsxViewer"
                     style="width:100%;min-height:400px;overflow-x:auto;background:#fff;border-radius:8px;padding:16px;box-shadow:0 2px 12px rgba(0,0,0,.08);">
                    <div style="text-align:center;padding:40px;color:#888;">
                        <span class="material-symbols-outlined"
                              style="font-size:48px;color:#28a745;">hourglass_top</span>
                        <p>Đang tải bảng tính...</p>
                    </div>
                </div>
                <script>window._xlsxUrl = '<%= fileUrl %>';</script>
                <% } else if ("txt".equalsIgnoreCase(doc.getFileExtension())) { %>
                <iframe src="<%= fileUrl %>"
                        style="width:100%;height:calc(85vh - 100px);min-height:540px;border:none;border-radius:8px;background:#fff;"></iframe>
                <% } else { %>
                <div style="text-align:center;padding:48px;">
                    <span class="material-symbols-outlined" style="font-size:80px;color:#0040ab;">description</span>
                    <p style="color:#555;margin-top:12px;font-size:15px;">Định dạng <strong><%= ext %>
                    </strong> không hỗ trợ xem trực tiếp.</p>
                    <a href="<%= fileUrl %>" download="<%= doc.getFileName() %>" class="btn-download"
                       style="max-width:260px;margin:16px auto 0;text-decoration:none;">
                        <span class="material-symbols-outlined">download</span> Tải xuống để xem
                    </a>
                </div>
                <% } %>
            </div>
            <div class="doc-meta-section">
                <h1><%= doc.getTitle() %>
                </h1>
                <div class="tag-row">
                    <span class="tag-chip"><%= categoryName %></span>
                    <span class="tag-chip"><%= ext %></span>
                </div>
                <p class="description-text"><%= description %>
                </p>
            </div>
        </div>
    </div>
    <div class="sidebar">
        <div class="card">
            <a href="<%= fileUrl %>" download="<%= doc.getFileName() %>" class="btn-download">
                <span class="material-symbols-outlined">download</span>
                Tải xuống ngay
            </a>
            <div class="stat-row">
                <div class="stat-item">
                    <span class="material-symbols-outlined">visibility</span>
                    <span class="val"><%= doc.getViewCount() %></span>
                    <span class="lbl">Lượt xem</span>
                </div>
                <div class="stat-item">
                    <span class="material-symbols-outlined">download</span>
                    <span class="val"><%= doc.getDownloadCount() %></span>
                    <span class="lbl">Lượt tải</span>
                </div>
            </div>
        </div>
        <div class="card">
            <h3 style="font-family:'Manrope',sans-serif;font-size:16px;font-weight:700;margin:0 0 16px;">Thông tin tệp
                tin</h3>
            <ul class="info-list">
                <li><span class="lbl">Định dạng</span> <span class="ext-val"><%= ext %></span></li>
                <li><span class="lbl">Kích thước</span> <span class="val"><%= sizeDisplay %></span></li>
                <li><span class="lbl">Danh mục</span> <span class="val"><%= categoryName %></span></li>
                <li><span class="lbl">Ngày đăng</span> <span class="val"><%= uploadDate %></span></li>
                <li><span class="lbl">Tên tệp</span> <span class="val"
                                                           style="font-size:12px;word-break:break-all;"><%= doc.getFileName() %></span>
                </li>
            </ul>
        </div>
        <div class="card">
            <div class="uploader-card">
                <div class="avatar"><%= uploaderName.charAt(0) %>
                </div>
                <div>
                    <div class="uploader-name"><%= uploaderName %>
                    </div>
                    <div class="uploader-sub">Người đăng tải</div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/mammoth@1.8.0/mammoth.browser.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
<script>
    if (window._docxUrl) {
        fetch(window._docxUrl)
            .then(r => r.arrayBuffer())
            .then(buf => mammoth.convertToHtml({arrayBuffer: buf}))
            .then(result => {
                const viewer = document.getElementById('docxViewer');
                if (viewer) viewer.innerHTML = result.value || '<p>Không thể đọc nội dung.</p>';
            })
            .catch(() => {
                const viewer = document.getElementById('docxViewer');
                if (viewer) viewer.innerHTML = '<p style="color:red;text-align:center">Không thể tải tài liệu. Vui lòng tải xuống để xem.</p>';
            });
    }
    if (window._xlsxUrl) {
        fetch(window._xlsxUrl)
            .then(r => r.arrayBuffer())
            .then(buf => {
                const wb = XLSX.read(buf, {type: 'array'});
                const ws = wb.Sheets[wb.SheetNames[0]];
                const html = XLSX.utils.sheet_to_html(ws, {id: 'xlsxTable'});
                const viewer = document.getElementById('xlsxViewer');
                if (viewer) {
                    viewer.innerHTML = html;
                    const tbl = document.getElementById('xlsxTable');
                    if (tbl) {
                        tbl.style.cssText = 'border-collapse:collapse;width:100%;font-size:13px;';
                        tbl.querySelectorAll('td,th').forEach(cell => {
                            cell.style.cssText = 'border:1px solid #dde;padding:6px 10px;';
                        });
                    }
                }
            })
            .catch(() => {
                const viewer = document.getElementById('xlsxViewer');
                if (viewer) viewer.innerHTML = '<p style="color:red;text-align:center">Không thể tải bảng tính. Vui lòng tải xuống để xem.</p>';
            });
    }
</script>
</body>
</html>
