<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.websharedocument.model.Document" %>
<%@ page import="vn.edu.hcmuaf.fit.websharedocument.model.User" %>
<%
    Document doc = (Document) request.getAttribute("document");
    if (doc == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    // UC15.1.2: Check if the logged in user is the owner of the document
    boolean isOwner = false;
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) {
        authUser = (User) session.getAttribute("adminUser");
    }
    if (authUser != null && authUser.getId() == doc.getUserId()) {
        isOwner = true;
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
    String fileUrl = doc.getFilePath();
    if (fileUrl != null && !fileUrl.startsWith("http")) {
        fileUrl = request.getContextPath() + "/document/uploads/" + fileUrl;
    }
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
            transition: transform .15s, box-shadow .15s, opacity .15s;
            text-decoration: none;
            box-shadow: 0 4px 16px rgba(0,64,171,.35);
        }

        .btn-download:hover {
            opacity: .92;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,64,171,.45);
        }

        .btn-download:disabled,
        .btn-download.loading {
            opacity: .7;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .dl-input {
            width: 100%;
            padding: 10px 14px;
            font-size: 14px;
            border: 1px solid #c3c6d7;
            border-radius: 10px;
            outline: none;
            background: #fff;
            color: #191b23;
            transition: border-color .15s, box-shadow .15s;
            margin-top: 4px;
        }

        .dl-input:focus {
            border-color: #0040ab;
            box-shadow: 0 0 0 3px rgba(0,64,171,.15);
        }

        /* ===== DOWNLOAD MODAL SYSTEM ===== */
        .dl-overlay {
            position: fixed;
            inset: 0;
            background: rgba(10,11,20,.55);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            z-index: 9000;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
            opacity: 0;
            pointer-events: none;
            transition: opacity .25s ease;
        }

        .dl-overlay.active {
            opacity: 1;
            pointer-events: all;
        }

        .dl-modal {
            background: #fff;
            border-radius: 20px;
            padding: 36px 32px 28px;
            max-width: 420px;
            width: 100%;
            box-shadow: 0 24px 64px rgba(0,0,0,.18), 0 4px 16px rgba(0,0,0,.1);
            position: relative;
            transform: scale(.88) translateY(20px);
            transition: transform .3s cubic-bezier(.34,1.56,.64,1), opacity .25s ease;
            opacity: 0;
        }

        .dl-overlay.active .dl-modal {
            transform: scale(1) translateY(0);
            opacity: 1;
        }

        .dl-modal-close {
            position: absolute;
            top: 16px;
            right: 16px;
            background: #f2f3f8;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #888;
            transition: background .15s, color .15s;
        }

        .dl-modal-close:hover {
            background: #e4e6f0;
            color: #333;
        }

        .dl-modal-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 30px;
        }

        .dl-modal-icon.confirm { background: #eef2ff; color: #0040ab; }
        .dl-modal-icon.success { background: #e8faf1; color: #0db36a; }
        .dl-modal-icon.error   { background: #fff0f0; color: #e53e3e; }
        .dl-modal-icon.loading-icon {
            background: #eef2ff;
        }

        .dl-modal h2 {
            font-family: 'Manrope', sans-serif;
            font-size: 20px;
            font-weight: 800;
            color: #0a0b14;
            text-align: center;
            margin: 0 0 8px;
        }

        .dl-modal p {
            font-size: 14px;
            color: #666;
            text-align: center;
            line-height: 1.6;
            margin: 0 0 28px;
        }

        .dl-modal-actions {
            display: flex;
            gap: 10px;
        }

        .dl-modal-actions button {
            flex: 1;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            border: none;
            transition: background .15s, transform .1s, box-shadow .15s;
        }

        .dl-modal-actions button:active { transform: scale(.97); }

        .btn-cancel {
            background: #f2f3f8;
            color: #555;
        }

        .btn-cancel:hover { background: #e4e6f0; }

        .btn-confirm {
            background: linear-gradient(135deg, #0040ab, #0055e6);
            color: #fff;
            box-shadow: 0 4px 14px rgba(0,64,171,.4);
        }

        .btn-confirm:hover { box-shadow: 0 6px 20px rgba(0,64,171,.5); }

        .btn-close-modal {
            background: #f2f3f8;
            color: #555;
        }

        .btn-close-modal:hover { background: #e4e6f0; }

        .btn-retry {
            background: linear-gradient(135deg, #e53e3e, #fc5c5c);
            color: #fff;
            box-shadow: 0 4px 14px rgba(229,62,62,.35);
        }

        .btn-retry:hover { box-shadow: 0 6px 20px rgba(229,62,62,.5); }

        /* Spinner */
        .dl-spinner {
            width: 38px;
            height: 38px;
            border: 4px solid #c7d6ff;
            border-top-color: #0040ab;
            border-radius: 50%;
            animation: dlSpin .75s linear infinite;
        }

        @keyframes dlSpin {
            to { transform: rotate(360deg); }
        }

        /* Progress bar */
        .dl-progress-wrap {
            margin: 20px 0 8px;
        }

        .dl-progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .dl-progress-track {
            width: 100%;
            height: 8px;
            background: #e4e8f5;
            border-radius: 99px;
            overflow: hidden;
        }

        .dl-progress-fill {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #0040ab, #5c8aff);
            border-radius: 99px;
            transition: width .3s ease;
        }

        .dl-progress-fill.indeterminate {
            width: 40%;
            animation: dlIndeterminate 1.4s ease-in-out infinite;
        }

        @keyframes dlIndeterminate {
            0%   { margin-left: -40%; }
            100% { margin-left: 100%; }
        }

        .btn-cancel-dl {
            margin-top: 18px;
            background: transparent;
            border: 1.5px solid #e0e3f0;
            color: #888;
            border-radius: 10px;
            padding: 9px 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: border-color .15s, color .15s, background .15s;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-left: auto;
            margin-right: auto;
        }

        .btn-cancel-dl:hover {
            border-color: #e53e3e;
            color: #e53e3e;
            background: #fff0f0;
        }

        @media (prefers-color-scheme: dark) {
            .dl-progress-track { background: #2a3060; }
            .dl-progress-label { color: #9097b8; }
            .btn-cancel-dl { border-color: #2e3250; color: #9097b8; }
            .btn-cancel-dl:hover { border-color: #e53e3e; color: #fc5c5c; background: #2e1010; }
        }

        /* Dark mode */
        @media (prefers-color-scheme: dark) {
            .dl-overlay { background: rgba(0,0,0,.7); }
            .dl-modal {
                background: #1a1d2e;
                box-shadow: 0 24px 64px rgba(0,0,0,.5), 0 4px 16px rgba(0,0,0,.3);
            }
            .dl-modal h2 { color: #f0f1ff; }
            .dl-modal p  { color: #9097b8; }
            .dl-modal-close { background: #252840; color: #9097b8; }
            .dl-modal-close:hover { background: #2e3250; color: #f0f1ff; }
            .dl-modal-icon.confirm { background: #1a2a55; }
            .dl-modal-icon.success { background: #0d2e1c; }
            .dl-modal-icon.error   { background: #2e1010; }
            .dl-modal-icon.loading-icon { background: #1a2a55; }
            .btn-cancel  { background: #252840; color: #9097b8; }
            .btn-cancel:hover { background: #2e3250; }
            .btn-close-modal { background: #252840; color: #9097b8; }
            .btn-close-modal:hover { background: #2e3250; }
            .dl-spinner { border-color: #2e3a6e; border-top-color: #5c8aff; }
            
            .dl-input {
                background: #252840;
                border-color: #2e3250;
                color: #f0f1ff;
            }
            .dl-input:focus {
                border-color: #5c8aff;
                box-shadow: 0 0 0 3px rgba(92,138,255,.2);
            }
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

<%-- UC15.1.10 / UC15.2.1.2: Hiển thị thông báo flashSuccess hoặc flashError --%>
<%
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError = (String) session.getAttribute("flashError");
    if (flashSuccess != null) {
        session.removeAttribute("flashSuccess");
%>
    <div class="alert-toast" style="position: fixed; top: 24px; right: 24px; z-index: 9999; display: flex; align-items: center; gap: 12px; background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; padding: 16px 24px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); font-size: 14px; font-weight: 500; transition: opacity 0.5s;" id="successAlert">
        <span class="material-symbols-outlined" style="color: #059669;">check_circle</span>
        <span><%= flashSuccess %></span>
        <button onclick="document.getElementById('successAlert').remove()" style="background: none; border: none; cursor: pointer; color: #059669; margin-left: 12px; display: flex; align-items: center;">
            <span class="material-symbols-outlined" style="font-size: 18px;">close</span>
        </button>
    </div>
    <script>
        setTimeout(function() {
            var alert = document.getElementById('successAlert');
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(function() { alert.remove(); }, 500);
            }
        }, 5000);
    </script>
<%
    }
    if (flashError != null) {
        session.removeAttribute("flashError");
%>
    <div class="alert-toast" style="position: fixed; top: 24px; right: 24px; z-index: 9999; display: flex; align-items: center; gap: 12px; background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 16px 24px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); font-size: 14px; font-weight: 500; transition: opacity 0.5s;" id="errorAlert">
        <span class="material-symbols-outlined" style="color: #dc2626;">error</span>
        <span><%= flashError %></span>
        <button onclick="document.getElementById('errorAlert').remove()" style="background: none; border: none; cursor: pointer; color: #dc2626; margin-left: 12px; display: flex; align-items: center;">
            <span class="material-symbols-outlined" style="font-size: 18px;">close</span>
        </button>
    </div>
    <script>
        setTimeout(function() {
            var alert = document.getElementById('errorAlert');
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(function() { alert.remove(); }, 500);
            }
        }, 5000);
    </script>
<%
    }
%>

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
                <iframe src="https://docs.google.com/gview?url=<%= java.net.URLEncoder.encode(fileUrl, "UTF-8") %>&embedded=true" title="Xem tài liệu PDF"
                        style="width:100%;height:calc(85vh - 100px);min-height:540px;border:none;border-radius:8px;background:#fff;"></iframe>
                <% } else if (doc.getFileType() != null && doc.getFileType().startsWith("image/")) { %>
                <img src="<%= fileUrl %>" alt="<%= doc.getTitle() %>"
                     style="max-width:100%;max-height:620px;border-radius:8px;box-shadow:0 4px 20px rgba(0,0,0,.12);">
                <% } else if ("doc".equalsIgnoreCase(doc.getFileExtension()) || "docx".equalsIgnoreCase(doc.getFileExtension()) || 
                              "xls".equalsIgnoreCase(doc.getFileExtension()) || "xlsx".equalsIgnoreCase(doc.getFileExtension()) || 
                              "ppt".equalsIgnoreCase(doc.getFileExtension()) || "pptx".equalsIgnoreCase(doc.getFileExtension())) { %>
                <iframe src="https://view.officeapps.live.com/op/embed.aspx?src=<%= java.net.URLEncoder.encode(fileUrl, "UTF-8") %>" title="Xem tài liệu"
                        style="width:100%;height:calc(85vh - 100px);min-height:540px;border:none;border-radius:8px;background:#fff;box-shadow:0 2px 12px rgba(0,0,0,.08);"></iframe>
                <% } else if ("txt".equalsIgnoreCase(doc.getFileExtension())) { %>
                <iframe src="<%= fileUrl %>" title="Xem tài liệu văn bản"
                        style="width:100%;height:calc(85vh - 100px);min-height:540px;border:none;border-radius:8px;background:#fff;box-shadow:0 2px 12px rgba(0,0,0,.08);"></iframe>
                <% } else { %>
                <div style="text-align:center;padding:48px;">
                    <span class="material-symbols-outlined" style="font-size:80px;color:#0040ab;">description</span>
                    <p style="color:#555;margin-top:12px;font-size:15px;">Định dạng <strong><%= ext %>
                    </strong> không hỗ trợ xem trực tiếp.</p>
                    <button class="btn-download" id="btnDlAlt"
                            onclick="openDownloadConfirm('<%= doc.getId() %>')"
                            style="max-width:260px;margin:16px auto 0;">
                        <span class="material-symbols-outlined">download</span> Tải xuống để xem
                    </button>
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
            <button class="btn-download" id="btnDlMain"
                    onclick="openDownloadConfirm('<%= doc.getId() %>')">
                <span class="material-symbols-outlined">download</span>
                Tải xuống ngay
            </button>
            
            <%-- UC15.1.1: Nút Chỉnh sửa hiển thị nếu User là chủ sở hữu tài liệu --%>
            <% if (isOwner) { %>
            <a href="${pageContext.request.contextPath}/edit-document?id=<%= doc.getId() %>" 
               class="btn-edit" 
               style="display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 12px; width: 100%; padding: 12px; background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 12px; color: #334155; font-size: 14px; font-weight: 600; text-decoration: none; transition: all 0.15s;"
               onmouseover="this.style.background='#f1f5f9'; this.style.color='#0f172a'"
               onmouseout="this.style.background='#f8fafc'; this.style.color='#334155'">
                <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                Chỉnh sửa tài liệu
            </a>
            <% } %>
            
            <div class="stat-row">
                <div class="stat-item">
                    <span class="material-symbols-outlined">visibility</span>
                    <span class="val"><%= doc.getViewCount() %></span>
                    <span class="lbl">Lượt xem</span>
                </div>
                <div class="stat-item">
                    <span class="material-symbols-outlined">download</span>
                    <span class="val" id="dlCountVal"><%= doc.getDownloadCount() %></span>
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

<!-- ========== DOWNLOAD MODAL SYSTEM ========== -->

<!-- 1. Confirm Modal -->
<div class="dl-overlay" id="dlOverlayConfirm" role="dialog" aria-modal="true" aria-labelledby="dlConfirmTitle">
    <div class="dl-modal" id="dlModalConfirm">
        <button class="dl-modal-close" onclick="closeAllModals()" aria-label="Đóng">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
        <div class="dl-modal-icon confirm">
            <span class="material-symbols-outlined">download</span>
        </div>
        <h2 id="dlConfirmTitle">Xác nhận tải xuống</h2>
        <p>Bạn có chắc chắn muốn tải file này không?</p>
        <!-- UC13.2.6.1: Hệ thống hiển thị trường nhập văn bản "Tên tệp khi lưu" -->
        <div style="margin: -12px 0 24px; display: flex; flex-direction: column; gap: 8px; text-align: left;">
            <label for="customFileName" style="font-size: 13px; color: #555; font-weight: 600; cursor: pointer;">Tên tệp khi lưu (không cần nhập đuôi):</label>
            <input type="text" id="customFileName" class="dl-input" placeholder="Nhập tên tệp mới...">
        </div>
        <div class="dl-modal-actions">
            <button class="btn-cancel" onclick="closeAllModals()">Huỷ</button>
            <button class="btn-confirm" id="btnConfirmDownload" onclick="startDownload()">Xác nhận tải</button>
        </div>
    </div>
</div>

<!-- 2. Loading Modal -->
<div class="dl-overlay" id="dlOverlayLoading" role="dialog" aria-modal="true" aria-labelledby="dlLoadingTitle">
    <div class="dl-modal" style="text-align:center;">
        <div class="dl-modal-icon loading-icon">
            <div class="dl-spinner"></div>
        </div>
        <h2 id="dlLoadingTitle">Đang tải xuống...</h2>
        <p id="dlProgressText" style="margin-bottom:0;font-size:13px;color:#888;">Đang chuẩn bị...</p>
        <div class="dl-progress-wrap">
            <div class="dl-progress-label">
                <span id="dlProgressPct">0%</span>
                <span id="dlProgressBytes"></span>
            </div>
            <div class="dl-progress-track">
                <div class="dl-progress-fill indeterminate" id="dlProgressFill"></div>
            </div>
        </div>
        <button class="btn-cancel-dl" id="btnCancelDownload" onclick="cancelDownload()">
            <span class="material-symbols-outlined" style="font-size:16px;">cancel</span>
            Huỷ tải xuống
        </button>
    </div>
</div>

<!-- 3. Success Modal -->
<div class="dl-overlay" id="dlOverlaySuccess" role="dialog" aria-modal="true" aria-labelledby="dlSuccessTitle">
    <div class="dl-modal">
        <button class="dl-modal-close" onclick="closeAllModals()" aria-label="Đóng">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
        <div class="dl-modal-icon success">
            <span class="material-symbols-outlined">check_circle</span>
        </div>
        <h2 id="dlSuccessTitle">Tải thành công</h2>
        <p>File đã được tải xuống thành công.</p>
        <div class="dl-modal-actions">
            <button class="btn-close-modal" style="flex:1;" onclick="closeAllModals()">Đóng</button>
        </div>
    </div>
</div>

<!-- 4. Error Modal -->
<div class="dl-overlay" id="dlOverlayError" role="dialog" aria-modal="true" aria-labelledby="dlErrorTitle">
    <div class="dl-modal">
        <button class="dl-modal-close" onclick="closeAllModals()" aria-label="Đóng">
            <span class="material-symbols-outlined" style="font-size:18px;">close</span>
        </button>
        <div class="dl-modal-icon error">
            <span class="material-symbols-outlined">error</span>
        </div>
        <h2 id="dlErrorTitle">Tải thất bại</h2>
        <p>Tải thất bại, vui lòng thử lại.</p>
        <div class="dl-modal-actions">
            <button class="btn-cancel" onclick="closeAllModals()">Huỷ</button>
            <button class="btn-retry" onclick="startDownload()">Thử lại</button>
        </div>
    </div>
</div>

<script>
    (function () {
        'use strict';

        // ── State ─────────────────────────────────────────────────────────
        var _docId         = null;
        var _isDownloading = false;
        var _successTimer  = null;
        var _abortCtrl     = null;   // AbortController cho fetch hiện tại
        var _downloadUrl   = '${pageContext.request.contextPath}/download?id=';

        // ── DOM refs ──────────────────────────────────────────────────────
        var elFill      = document.getElementById('dlProgressFill');
        var elPct       = document.getElementById('dlProgressPct');
        var elBytes     = document.getElementById('dlProgressBytes');
        var elText      = document.getElementById('dlProgressText');
        var elCancelBtn = document.getElementById('btnCancelDownload');

        // ── Helpers ───────────────────────────────────────────────────────
        // [Nội bộ] Ẩn tất cả overlay, hiển thị overlay được chỉ định
        function showOverlay(id) {
            ['dlOverlayConfirm','dlOverlayLoading','dlOverlaySuccess','dlOverlayError']
                .forEach(function (oid) {
                    var el = document.getElementById(oid);
                    if (el) el.classList.remove('active');
                });
            var target = document.getElementById(id);
            if (target) target.classList.add('active');
        }

        // [UC13.1.2 / UC13.2.1] Reset thanh tiến trình về trạng thái ban đầu
        // → Gọi mỗi lần bắt đầu download mới (trước fetch)
        // → File: document-detail.jsp (JS)
        function resetProgressUI() {
            if (elFill)  { elFill.style.width = '0%'; elFill.classList.add('indeterminate'); }
            if (elPct)   elPct.innerText  = '0%';
            if (elBytes) elBytes.innerText = '';
            if (elText)  elText.innerText  = 'Đang chuẩn bị...';
            if (elCancelBtn) elCancelBtn.disabled = false;
        }

        // [UC13.1.7] Cập nhật thanh tiến trình theo từng chunk nhận được
        // → Gọi trong pump() mỗi khi reader.read() trả về chunk mới
        // → File: document-detail.jsp (JS)
        function setProgress(received, total) {
            if (total > 0) {
                var pct = Math.min(100, Math.round(received / total * 100));
                if (elFill) {
                    elFill.classList.remove('indeterminate');
                    elFill.style.width = pct + '%';
                }
                if (elPct)  elPct.innerText  = pct + '%';
                if (elText) elText.innerText  = 'Đang nhận dữ liệu...';
            }
            if (elBytes) elBytes.innerText = formatBytes(received) + (total > 0 ? ' / ' + formatBytes(total) : '');
        }

        // [Nội bộ] Định dạng byte → KB / MB để hiển thị
        function formatBytes(bytes) {
            if (bytes >= 1048576) return (bytes / 1048576).toFixed(1) + ' MB';
            if (bytes >= 1024)    return (bytes / 1024).toFixed(1) + ' KB';
            return bytes + ' B';
        }

        // [UC13.1.3 / UC13.2.x] Disable/enable nút "Tải xuống ngay" khi đang tải
        // → Ngăn người dùng bấm nhiều lần (chống duplicate request)
        // → File: document-detail.jsp (JS)
        function setDownloadBtnsDisabled(disabled) {
            ['btnDlMain', 'btnDlAlt'].forEach(function (id) {
                var btn = document.getElementById(id);
                if (!btn) return;
                btn.disabled = disabled;
                disabled ? btn.classList.add('loading') : btn.classList.remove('loading');
            });
        }

        // [UC13.2.x.3/4] Dọn dẹp trạng thái sau khi download kết thúc (thành công hoặc thất bại)
        // → _isDownloading=false, _abortCtrl=null, re-enable nút tải
        // → File: document-detail.jsp (JS)
        function onDownloadDone() {
            _isDownloading = false;
            _abortCtrl     = null;
            setDownloadBtnsDisabled(false);
        }

        // ── Public API ────────────────────────────────────────────────────

        // // UC13.1.2: Người dùng xác định tài liệu cần tải và nhấp vào nút "Tải xuống".
        // // Hệ thống hiển thị modal xác nhận tải xuống.
        window.openDownloadConfirm = function (docId) {
            if (_isDownloading) return;
            _docId = docId;
            
            // [UC13.2.6.2]: Hệ thống trích xuất tên gốc của tệp, loại bỏ phần mở rộng và điền sẵn vào ô nhập liệu
            var inputFileName = document.getElementById('customFileName');
            if (inputFileName) {
                var origName = '<%= doc.getFileName() != null ? doc.getFileName().replace("'", "\\'").replace("\"", "\\\"") : "document" %>';
                var lastDot = origName.lastIndexOf('.');
                var nameWithoutExt = lastDot >= 0 ? origName.substring(0, lastDot) : origName;
                inputFileName.value = nameWithoutExt;
            }
            
            showOverlay('dlOverlayConfirm');
        };

        // // UC13.2.1.1: Người dùng nhấn "Huỷ" tại modal xác nhận trước khi gửi yêu cầu.
        // // UC13.2.1.2: Quá trình tải xuống bị hủy trước khi bắt đầu.
        // // UC13.2.1.3: Giao diện đóng modal và trở về trạng thái ban đầu. Use case kết thúc.
        window.closeAllModals = function () {
            if (_isDownloading) return;  // loading modal không thể đóng bằng ngoài
            if (_successTimer) clearTimeout(_successTimer);
            ['dlOverlayConfirm','dlOverlayLoading','dlOverlaySuccess','dlOverlayError']
                .forEach(function (oid) {
                    var el = document.getElementById(oid);
                    if (el) el.classList.remove('active');
                });
        };

        // // UC13.2.4.1: Người dùng nhấn "Huỷ tải xuống" trong khi đang tải stream.
        // // UC13.2.4.2: Quá trình tải xuống bị hủy. Không có tệp nào được lưu.
        window.cancelDownload = function () {
            if (!_isDownloading || !_abortCtrl) return;
            if (elCancelBtn) elCancelBtn.disabled = true;  // UC13.2.4.1: tránh bấm 2 lần
            _abortCtrl.abort();  // kích hoạt AbortSignal → fetch().catch()
        };

        // Xác nhận tải xuống (confirmDownload)
        window.startDownload = function () {
            if (_isDownloading || !_docId) return;
            _isDownloading = true;

            var finalFileName = '';

            // [UC13.1.3] Chuẩn bị UI trước khi gửi request
            resetProgressUI();
            setDownloadBtnsDisabled(true);
            showOverlay('dlOverlayLoading');

            // [UC13.2.4.1] Khởi tạo AbortController để hỗ trợ hủy giữa chừng
            _abortCtrl = new AbortController();
            var signal = _abortCtrl.signal;

            // [UC13.2.6.3]: JavaScript lấy tên tệp tùy chỉnh mới đã nhập và mã hóa URL thông qua customName
            var inputFileName = document.getElementById('customFileName');
            var customNameParam = '';
            if (inputFileName && inputFileName.value.trim()) {
                customNameParam = '&customName=' + encodeURIComponent(inputFileName.value.trim());
            }

            // Gửi GET /download?id= lên DownloadDocumentServlet để khởi chạy UC13.1.4
            fetch(_downloadUrl + _docId + customNameParam, { method: 'GET', credentials: 'same-origin', signal: signal })
                .then(function (res) {
                    // [UC13.2.2 / UC13.2.3] HTTP 403/404 → ném Error → xuống .catch()
                    if (!res.ok) throw new Error('HTTP_' + res.status);

                    // Extract filename from Content-Disposition header
                    var contentDisposition = res.headers.get('Content-Disposition');
                    console.log("Download Content-Disposition header:", contentDisposition);
                    if (contentDisposition) {
                        var filenameStarRegex = /filename\*=UTF-8''([^;\n]*)/i;
                        var matchesStar = filenameStarRegex.exec(contentDisposition);
                        if (matchesStar != null && matchesStar[1]) {
                            try {
                                finalFileName = decodeURIComponent(matchesStar[1]);
                            } catch (e) {
                                console.error("Error decoding filename*:", e);
                            }
                        }
                        if (!finalFileName) {
                            var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                            var matches = filenameRegex.exec(contentDisposition);
                            if (matches != null && matches[1]) { 
                                finalFileName = matches[1].replace(/['"]/g, '');
                                try {
                                    finalFileName = decodeURIComponent(finalFileName);
                                } catch(e) {}
                            }
                        }
                    }
                    console.log("Resolved download filename:", finalFileName);

                    // [UC13.1.7] Đọc Content-Length để tính % tiến trình
                    // → Nếu server không trả → dùng animation indeterminate
                    var contentLength = res.headers.get('Content-Length');
                    var total = contentLength ? parseInt(contentLength, 10) : 0;
                    var received = 0;
                    var chunks  = [];
                    var contentType = res.headers.get('Content-Type') || 'application/octet-stream';

                    if (!total && elFill) elFill.classList.add('indeterminate');

                    // [UC13.1.7] Lấy ReadableStream reader để đọc từng chunk
                    var reader = res.body.getReader();

                    // [UC13.1.7] pump() – đệ quy đọc từng Uint8Array chunk
                    // → Mỗi chunk: cộng dồn received, gọi setProgress()
                    // → Khi AbortController.abort() → reader.read() ném AbortError
                    function pump() {
                        return reader.read().then(function (result) {
                            if (result.done) return;  // stream kết thúc
                            var chunk = result.value;   // Uint8Array
                            chunks.push(chunk);
                            received += chunk.length;
                            setProgress(received, total);  // [UC13.1.7] cập nhật thanh %
                            return pump();
                        });
                    }

                    return pump().then(function () {
                        // // UC13.1.8: Tệp được tải xuống hoàn tất. Trình duyệt ghép các chunks thành Blob...
                        return new Blob(chunks, { type: contentType });
                    });
                })
                .then(function (blob) {
                    // // ...và thanh tiến trình hiển thị 100%.
                    if (elFill)  { elFill.classList.remove('indeterminate'); elFill.style.width = '100%'; }
                    if (elPct)   elPct.innerText  = '100%';
                    if (elText)  elText.innerText  = 'Hoàn tất! Đang mở hộp thoại lưu...';

                    // // ...kích hoạt hộp thoại lưu tệp...
                    var url = URL.createObjectURL(blob);
                    var a   = document.createElement('a');
                    a.href  = url;
                    a.download = finalFileName || '<%= doc.getFileName() != null ? doc.getFileName().replace("'", "\\'").replace("\"", "\\\"") : "document" %>';
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    setTimeout(function () { URL.revokeObjectURL(url); }, 10000);

                    // dlCountVal += 1
                    var counter = document.getElementById('dlCountVal');
                    if (counter) counter.innerText = parseInt(counter.innerText || '0') + 1;

                    // onDownloadDone()
                    onDownloadDone();
                    
                    // // UC13.1.9: Giao diện hiển thị thông báo thành công, tự động đóng sau 4 giây.
                    showOverlay('dlOverlaySuccess');

                    // [UC13.1.9] Tự động đóng modal sau 4 giây
                    _successTimer = setTimeout(function () {
                        var el = document.getElementById('dlOverlaySuccess');
                        if (el) el.classList.remove('active');
                    }, 4000);
                })
                .catch(function (err) {
                    // // UC13.2.4.3: Hệ thống không ghi log sự kiện tải xuống thành công.
                    // // UC13.2.4.4: Giao diện trở về trạng thái ban đầu. Use case kết thúc.
                    // // Hoặc UC13.2.5.3: Trạng thái tải xuống được đặt lại.
                    onDownloadDone();
                    showOverlay('dlOverlayError');
                });
        };

        // Click ngoài overlay để đóng (chỉ confirm / success / error)
        ['dlOverlayConfirm','dlOverlaySuccess','dlOverlayError'].forEach(function (oid) {
            var el = document.getElementById(oid);
            if (!el) return;
            el.addEventListener('click', function (e) {
                if (e.target === el) window.closeAllModals();
            });
        });

        // Phím Escape để đóng
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') window.closeAllModals();
        });
    })();
</script>

<jsp:include page="/common/footer.jsp"/>
</body>
</html>
