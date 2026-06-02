/**
 * edit-document.js – Chỉnh sửa thông tin và thay thế file tài liệu
 */
(function () {
    'use strict';

    const form         = document.getElementById('editDocumentForm');
    const btnSave      = document.getElementById('btnSave');
    const btnCancel    = document.getElementById('btnCancel');
    
    // Counter elements
    const titleInput   = document.getElementById('title');
    const titleLen     = document.getElementById('titleLen');
    const descInput    = document.getElementById('description');
    const descLen      = document.getElementById('descLen');

    // Replace File UI elements
    const currentFileBox = document.getElementById('currentFileBox');
    const newFileSection = document.getElementById('newFileSection');
    const btnReplaceFile = document.getElementById('btnReplaceFile');
    const btnCancelReplace = document.getElementById('btnCancelReplace');
    
    const fileInput = document.getElementById('documentFile');
    const dropzone = document.getElementById('dropzone');
    const filePreview = document.getElementById('filePreview');
    const newFileNameDisplay = document.getElementById('newFileNameDisplay');
    const newFileMetaDisplay = document.getElementById('newFileMetaDisplay');
    const removeFileBtn = document.getElementById('removeFile');

    // Progress elements
    const progressContainer = document.getElementById('progressContainer');
    const progressBarFill = document.getElementById('progressBarFill');
    const progressText = document.getElementById('progressText');
    const progressStatus = document.getElementById('progressStatus');
    const cancelUploadBtn = document.getElementById('cancelUpload');

    const maxSize = 50 * 1024 * 1024;
    const allowedExtensions = ["pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt", "png", "jpg", "jpeg"];
    let currentXhr = null;

    // Live Preview elements
    const previewTitle = document.getElementById('previewTitle');
    const previewCategory = document.getElementById('previewCategory');
    const previewTagsContainer = document.getElementById('previewTagsContainer');
    const previewDescription = document.getElementById('previewDescription');
    const previewPrivacyBadge = document.getElementById('previewPrivacyBadge');
    const previewFileName = document.getElementById('previewFileName');
    const previewFileSize = document.getElementById('previewFileSize');
    const previewFileExt = document.getElementById('previewFileExt');

    // Store original file info
    const originalFileName = previewFileName ? previewFileName.textContent.trim() : '';
    const originalFileSize = previewFileSize ? previewFileSize.textContent.trim() : '';
    const originalFileExt = previewFileExt ? previewFileExt.textContent.trim() : '';

    // ── Counters ────────────────────────────────────────────────────────
    function updateCounter(input, display, max) {
        const len = input.value.length;
        display.textContent = len;
        display.className = len > max * 0.9 ? 'text-red-500 font-medium' : '';
    }

    if (titleInput && titleLen) {
        updateCounter(titleInput, titleLen, 255);
        titleInput.addEventListener('input', () => updateCounter(titleInput, titleLen, 255));
    }
    if (descInput && descLen) {
        updateCounter(descInput, descLen, 2000);
        descInput.addEventListener('input', () => updateCounter(descInput, descLen, 2000));
    }

    // ── Replace File UI Logic ───────────────────────────────────────────
    if (btnReplaceFile) {
        btnReplaceFile.addEventListener('click', () => {
            currentFileBox.classList.add('hidden');
            newFileSection.classList.remove('hidden');
        });
    }

    if (btnCancelReplace) {
        btnCancelReplace.addEventListener('click', () => {
            newFileSection.classList.add('hidden');
            currentFileBox.classList.remove('hidden');
            clearNewFile();
        });
    }

    function clearNewFile() {
        if (fileInput) fileInput.value = '';
        if (filePreview) filePreview.classList.add('hidden');
        if (dropzone) dropzone.classList.remove('hidden');
        clearErrors();

        // Restore original file info on Preview Card
        if (previewFileName) previewFileName.textContent = originalFileName;
        if (previewFileSize) previewFileSize.textContent = originalFileSize;
        if (previewFileExt) previewFileExt.textContent = originalFileExt;
    }

    if (removeFileBtn) {
        removeFileBtn.addEventListener('click', clearNewFile);
    }

    function getExtension(name) {
        const parts = name.split(".");
        return parts.length > 1 ? parts.pop().toLowerCase() : "";
    }

    function formatSize(bytes) {
        if (bytes >= 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(2) + " MB";
        return (bytes / 1024).toFixed(1) + " KB";
    }

    function showFile(file) {
        clearErrors();
        const extension = getExtension(file.name);
        if (!allowedExtensions.includes(extension)) {
            alert("Định dạng tệp không được hỗ trợ.");
            clearNewFile();
            return;
        }
        if (file.size > maxSize) {
            alert("Tệp vượt quá kích thước 50MB.");
            clearNewFile();
            return;
        }
        dropzone.classList.add('hidden');
        filePreview.classList.remove('hidden');
        newFileNameDisplay.textContent = file.name;
        newFileMetaDisplay.textContent = formatSize(file.size) + " · " + extension.toUpperCase();

        // Update file info on Preview Card
        if (previewFileName) previewFileName.textContent = file.name;
        if (previewFileSize) previewFileSize.textContent = formatSize(file.size);
        if (previewFileExt) previewFileExt.textContent = extension.toUpperCase();
    }

    if (dropzone && fileInput) {
        ['dragenter', 'dragover'].forEach(eventName => {
            dropzone.addEventListener(eventName, e => {
                e.preventDefault();
                dropzone.classList.add('border-[#0555dd]', 'bg-blue-50');
            });
        });
        ['dragleave', 'drop'].forEach(eventName => {
            dropzone.addEventListener(eventName, e => {
                e.preventDefault();
                dropzone.classList.remove('border-[#0555dd]', 'bg-blue-50');
            });
        });
        dropzone.addEventListener('drop', e => {
            const file = e.dataTransfer.files[0];
            if (!file) return;
            const transfer = new DataTransfer();
            transfer.items.add(file);
            fileInput.files = transfer.files;
            showFile(file);
        });
        fileInput.addEventListener('change', () => {
            if (fileInput.files.length > 0) showFile(fileInput.files[0]);
        });
    }

    // ── UC15.1.5 / UC15.1.6: Form Submit & Validation ───────────────────
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            clearErrors();
            
            // UC15.1.6 & UC15.2.2.1: Hệ thống phát hiện lỗi validation (tên tài liệu để trống)
            const title = titleInput ? titleInput.value.trim() : '';
            if (!title) {
                // UC15.2.2.2: Hệ thống highlight trường nhập liệu bị lỗi và hiển thị thông báo lỗi
                // UC15.2.2.3: User sửa lại thông tin không hợp lệ trên form và nhấp lại nút “Lưu thay đổi” (chờ user thao tác lại)
                showError('title', 'Tên tài liệu không được để trống.');
                return;
            }

            const fileToUpload = fileInput && fileInput.files.length > 0 ? fileInput.files[0] : null;
            
            // Nếu có file mới, upload lên Supabase trước
            if (fileToUpload && !newFileSection.classList.contains('hidden')) {
                uploadToSupabaseAndSubmit(fileToUpload);
            } else {
                // Nếu không có file mới, submit form bình thường
                setLoadingState(true);
                form.submit();
            }
        });
    }

    function uploadToSupabaseAndSubmit(file) {
        currentXhr = new XMLHttpRequest();
        progressContainer.classList.remove('hidden');
        progressContainer.classList.add('flex');
        setLoadingState(true);

        const supabaseUrl = "https://tlbznphszzpondlykmst.supabase.co";
        const supabaseKey = "sb_publishable_3IaZByYoSWSHakJqFMOifQ_ud2mNCpg";
        const bucketName = "documents"; 
        
        const safeFileName = file.name.replace(/[^a-zA-Z0-9.\-_]/g, '_');
        const filePath = `uploads/${Date.now()}_${safeFileName}`;
        const uploadUrl = `${supabaseUrl}/storage/v1/object/${bucketName}/${filePath}`;

        currentXhr.upload.addEventListener("progress", function (e) {
            if (e.lengthComputable) {
                let percent = (e.loaded / e.total) * 100 * 0.9;
                progressBarFill.style.width = percent + "%";
                progressText.textContent = Math.round(percent) + "%";
            }
        });

        currentXhr.addEventListener("load", function () {
            if (currentXhr.status >= 200 && currentXhr.status < 300) {
                progressStatus.textContent = "Đang lưu thông tin...";
                progressBarFill.style.width = "100%";
                progressText.textContent = "100%";

                const publicUrl = `${supabaseUrl}/storage/v1/object/public/${bucketName}/${filePath}`;
                
                // Set hidden inputs
                document.getElementById('secureUrl').value = publicUrl;
                document.getElementById('newFileNameInput').value = file.name;
                document.getElementById('newFileSizeInput').value = file.size;
                document.getElementById('newExtensionInput').value = getExtension(file.name);
                
                // Submit form
                form.submit();
            } else {
                alert("Lỗi tải lên: " + currentXhr.responseText);
                cancelUpload();
            }
        });

        currentXhr.addEventListener("error", function () {
            alert("Lỗi kết nối khi tải tệp.");
            cancelUpload();
        });

        currentXhr.open("POST", uploadUrl, true);
        currentXhr.setRequestHeader("Authorization", "Bearer " + supabaseKey);
        currentXhr.setRequestHeader("apikey", supabaseKey);
        currentXhr.setRequestHeader("Content-Type", file.type || "application/octet-stream");
        currentXhr.send(file);
    }

    if (cancelUploadBtn) {
        cancelUploadBtn.addEventListener('click', cancelUpload);
    }

    function cancelUpload() {
        if (currentXhr) {
            currentXhr.abort();
            currentXhr = null;
        }
        progressContainer.classList.add('hidden');
        progressContainer.classList.remove('flex');
        setLoadingState(false);
    }

    // UC15.2.3: Alternate Flow - User huỷ thao tác chỉnh sửa
    if (btnCancel) {
        btnCancel.addEventListener('click', function () {
            // UC15.2.3.1: User nhấp nút “Huỷ”
            // UC15.2.3.2: Hệ thống không lưu bất kỳ thay đổi nào và chuyển hướng User về trang chi tiết tài liệu với dữ liệu cũ còn nguyên
            history.back();
        });
    }

    function showError(fieldId, message) {
        const input = document.getElementById(fieldId);
        if (!input) return;
        input.classList.add('field-error');
        const parent = input.closest('.space-y-1\\.5') || input.parentElement;
        let errP = parent.querySelector('.js-error');
        if (!errP) {
            errP = document.createElement('p');
            errP.className = 'error-msg flex items-center gap-1 js-error text-red-500 text-xs mt-1';
            errP.innerHTML = `<span class="material-symbols-outlined text-[14px]">error</span> ${message}`;
            input.insertAdjacentElement('afterend', errP);
        } else {
            errP.innerHTML = `<span class="material-symbols-outlined text-[14px]">error</span> ${message}`;
        }

        // Highlight corresponding preview card elements
        if (fieldId === 'title' && previewTitle) {
            previewTitle.classList.add('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
        } else if (fieldId === 'tags' && previewTagsContainer) {
            previewTagsContainer.classList.add('border', 'border-red-200', 'p-1', 'rounded');
        }

        input.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    function clearErrors() {
        form.querySelectorAll('.js-error').forEach(el => el.remove());
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));

        // Clear preview highlights
        if (previewTitle) {
            previewTitle.classList.remove('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
        }
        if (previewTagsContainer) {
            previewTagsContainer.classList.remove('border', 'border-red-200', 'p-1', 'rounded');
        }
    }

    function setLoadingState(loading) {
        if (!btnSave) return;
        btnSave.disabled = loading;
        const btnSaveIcon = document.getElementById('btnSaveIcon');
        const btnSaveText = document.getElementById('btnSaveText');
        if (btnSaveIcon) btnSaveIcon.textContent = loading ? 'hourglass_empty' : 'save';
        if (btnSaveText) btnSaveText.textContent  = loading ? 'Đang lưu...' : 'Lưu thay đổi';
    }

    // ── Live Preview Logic ────────────────────────────────────────────────
    function updateLivePreview() {
        // Title
        if (titleInput && previewTitle) {
            const titleVal = titleInput.value.trim();
            previewTitle.textContent = titleVal || 'Chưa đặt tên tài liệu';
        }

        // Description
        if (descInput && previewDescription) {
            const descVal = descInput.value.trim();
            previewDescription.textContent = descVal || 'Chưa có mô tả nào cho tài liệu này.';
        }

        // Category
        const categorySelect = document.getElementById('categoryId');
        if (categorySelect && previewCategory) {
            const selectedOption = categorySelect.options[categorySelect.selectedIndex];
            const catName = selectedOption && categorySelect.value ? selectedOption.textContent.trim() : 'Chưa chọn danh mục';
            previewCategory.textContent = catName;
        }

        // Privacy Badge
        if (previewPrivacyBadge) {
            const checkedRadio = document.querySelector('input[name="privacy"]:checked');
            const isPublic = checkedRadio && checkedRadio.value === 'public';
            previewPrivacyBadge.textContent = isPublic ? 'Công khai' : 'Nháp';
            if (isPublic) {
                previewPrivacyBadge.className = 'px-2.5 py-1 text-xs font-semibold rounded-full border bg-emerald-50 text-emerald-700 border-emerald-100 transition-all duration-300';
            } else {
                previewPrivacyBadge.className = 'px-2.5 py-1 text-xs font-semibold rounded-full border bg-slate-50 text-slate-600 border-slate-100 transition-all duration-300';
            }
        }

        // Tags
        const tagsInput = document.getElementById('tags');
        if (tagsInput && previewTagsContainer) {
            const tagsVal = tagsInput.value.trim();
            previewTagsContainer.innerHTML = '';
            if (tagsVal) {
                const tagsArr = tagsVal.split(',')
                    .map(t => t.trim())
                    .filter(t => t !== '');
                if (tagsArr.length > 0) {
                    tagsArr.forEach(tag => {
                        const span = document.createElement('span');
                        span.className = 'px-2 py-0.5 bg-slate-100 text-slate-600 rounded text-xs';
                        span.textContent = tag;
                        previewTagsContainer.appendChild(span);
                    });
                } else {
                    showEmptyTagsPlaceholder();
                }
            } else {
                showEmptyTagsPlaceholder();
            }
        }
    }

    function showEmptyTagsPlaceholder() {
        if (!previewTagsContainer) return;
        const span = document.createElement('span');
        span.className = 'text-xs text-slate-400';
        span.textContent = 'Chưa có tag nào';
        previewTagsContainer.appendChild(span);
    }

    // Setup Preview Event Listeners
    if (titleInput) {
        titleInput.addEventListener('input', updateLivePreview);
    }
    if (descInput) {
        descInput.addEventListener('input', updateLivePreview);
    }
    const categorySelect = document.getElementById('categoryId');
    if (categorySelect) {
        categorySelect.addEventListener('change', updateLivePreview);
    }
    const tagsInput = document.getElementById('tags');
    if (tagsInput) {
        tagsInput.addEventListener('input', updateLivePreview);
    }
    document.querySelectorAll('input[name="privacy"]').forEach(radio => {
        radio.addEventListener('change', updateLivePreview);
    });

    // ==========================================
    // DOCUMENT PREVIEW PANEL LOGIC (UC15.1.5)
    // ==========================================
    const btnViewFile = document.getElementById('btnViewFile');
    const btnViewNewFile = document.getElementById('btnViewNewFile');
    const filePreviewPanel = document.getElementById('filePreviewPanel');
    const btnClosePreviewPanel = document.getElementById('btnClosePreviewPanel');
    const panelBody = document.getElementById('panelBody');
    const panelFileName = document.getElementById('panelFileName');
    const panelFileExtBadge = document.getElementById('panelFileExtBadge');
    const panelFileIcon = document.getElementById('panelFileIcon');

    function openPreviewModal() {
        if (!filePreviewPanel) return;
        filePreviewPanel.classList.remove('hidden');
        filePreviewPanel.classList.add('flex');
        // Force reflow for CSS transitions
        filePreviewPanel.offsetHeight;
        filePreviewPanel.classList.add('modal-active');
    }

    function closePreviewModal() {
        if (!filePreviewPanel) return;
        filePreviewPanel.classList.remove('modal-active');
        setTimeout(() => {
            filePreviewPanel.classList.remove('flex');
            filePreviewPanel.classList.add('hidden');
            if (panelBody) panelBody.innerHTML = '';
        }, 300);
    }

    if (btnClosePreviewPanel) {
        btnClosePreviewPanel.addEventListener('click', closePreviewModal);
    }
    if (filePreviewPanel) {
        filePreviewPanel.addEventListener('click', (e) => {
            if (e.target === filePreviewPanel) closePreviewModal();
        });
    }

    // Dynamic loader spinner
    function showPanelLoading() {
        if (!panelBody) return;
        panelBody.innerHTML = `
            <div class="flex flex-col items-center justify-center py-12">
                <span class="material-symbols-outlined text-4xl text-[#0555dd] animate-spin">sync</span>
                <p class="text-sm text-slate-500 mt-3 font-medium">Đang tải và chuẩn bị nội dung tài liệu...</p>
            </div>
        `;
    }

    function showPanelError(message) {
        if (!panelBody) return;
        panelBody.innerHTML = `
            <div class="flex flex-col items-center justify-center py-12 text-center max-w-md px-4">
                <span class="material-symbols-outlined text-4xl text-red-500 mb-2">error</span>
                <h3 class="text-sm font-bold text-slate-800">Không thể xem trực tiếp</h3>
                <p class="text-xs text-slate-500 mt-1">${message}</p>
            </div>
        `;
    }

    function getMaterialIconByExt(ext) {
        switch (ext.toLowerCase()) {
            case 'pdf': return 'picture_as_pdf';
            case 'png':
            case 'jpg':
            case 'jpeg': return 'image';
            case 'doc':
            case 'docx': return 'article';
            case 'xls':
            case 'xlsx': return 'table_chart';
            case 'ppt':
            case 'pptx': return 'present_to_all';
            case 'txt': return 'text_snippet';
            default: return 'description';
        }
    }

    function renderPreview(fileName, extension, source) {
        if (!panelBody || !panelFileName || !panelFileExtBadge || !panelFileIcon) return;

        // Set metadata on header
        panelFileName.textContent = fileName;
        panelFileExtBadge.textContent = extension.toUpperCase();
        panelFileIcon.textContent = getMaterialIconByExt(extension);

        openPreviewModal();
        showPanelLoading();

        const ext = extension.toLowerCase();

        if (ext === 'png' || ext === 'jpg' || ext === 'jpeg') {
            // Render Image
            const img = document.createElement('img');
            img.className = 'max-w-full max-h-[70vh] rounded-lg shadow-md object-contain transition-all duration-300';
            img.alt = fileName;
            
            if (source instanceof File) {
                img.src = URL.createObjectURL(source);
                img.onload = () => URL.revokeObjectURL(img.src);
            } else {
                img.src = source;
            }
            
            panelBody.innerHTML = '';
            panelBody.appendChild(img);
        }
        else if (ext === 'pdf') {
            // Render PDF in standard scrollable iframe (natively supported by all browsers)
            let pdfUrl = '';
            if (source instanceof File) {
                pdfUrl = URL.createObjectURL(source);
            } else {
                pdfUrl = source;
            }

            panelBody.innerHTML = `
                <iframe src="${pdfUrl}" class="w-full h-[70vh] border border-slate-200/60 rounded-xl bg-white shadow-sm" title="Preview PDF"></iframe>
            `;
        }
        else if (ext === 'docx') {
            // Render DOCX utilizing Mammoth.js
            if (source instanceof File) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const arrayBuffer = e.target.result;
                    mammoth.convertToHtml({ arrayBuffer: arrayBuffer })
                        .then(result => {
                            panelBody.innerHTML = `
                                <div class="w-full overflow-y-auto max-h-[70vh] py-4">
                                    <div class="docx-paper docx-preview-content">
                                        ${result.value || '<p class="text-slate-400 text-center py-8">Tài liệu không có nội dung văn bản.</p>'}
                                    </div>
                                </div>
                            `;
                        })
                        .catch(err => {
                            console.error(err);
                            showPanelError('Không thể chuyển đổi nội dung tệp DOCX này. Vui lòng thử lại.');
                        });
                };
                reader.onerror = () => showPanelError('Không thể đọc dữ liệu tệp từ máy tính.');
                reader.readAsArrayBuffer(source);
            } else {
                // Fetch the remote/online DOCX and render
                fetch(source)
                    .then(response => {
                        if (!response.ok) throw new Error('Không thể tải tệp từ máy chủ.');
                        return response.arrayBuffer();
                    })
                    .then(arrayBuffer => {
                        mammoth.convertToHtml({ arrayBuffer: arrayBuffer })
                            .then(result => {
                                panelBody.innerHTML = `
                                    <div class="w-full overflow-y-auto max-h-[70vh] py-4">
                                        <div class="docx-paper docx-preview-content">
                                            ${result.value || '<p class="text-slate-400 text-center py-8">Tài liệu không có nội dung văn bản.</p>'}
                                        </div>
                                    </div>
                                `;
                            })
                            .catch(err => {
                                console.error(err);
                                // Fallback to office apps live preview if mammoth fails (e.g. file protected or complex formatting)
                                loadOfficeAppsFallback(source);
                            });
                    })
                    .catch(err => {
                        console.warn('Mammoth fetch/parse failed. Falling back to Office Viewer:', err);
                        loadOfficeAppsFallback(source);
                    });
            }
        }
        else if (ext === 'doc' || ext === 'xls' || ext === 'xlsx' || ext === 'ppt' || ext === 'pptx') {
            // Older Word or Spreadsheet format: use Office Online embed if remote, or show instruction if local
            if (source instanceof File) {
                showPanelError(`Định dạng tệp .${ext} không hỗ trợ xem trước trực tiếp khi chưa lưu. Vui lòng sử dụng tệp dạng .docx, .pdf hoặc hình ảnh.`);
            } else {
                loadOfficeAppsFallback(source);
            }
        }
        else if (ext === 'txt') {
            // Text file
            if (source instanceof File) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const text = e.target.result;
                    panelBody.innerHTML = `
                        <div class="w-full overflow-y-auto max-h-[70vh] py-4">
                            <div class="docx-paper docx-preview-content">
                                <pre class="whitespace-pre-wrap font-mono text-xs leading-relaxed">${escapeHtml(text)}</pre>
                            </div>
                        </div>
                    `;
                };
                reader.readAsText(source);
            } else {
                fetch(source)
                    .then(res => res.text())
                    .then(text => {
                        panelBody.innerHTML = `
                            <div class="w-full overflow-y-auto max-h-[70vh] py-4">
                                <div class="docx-paper docx-preview-content">
                                    <pre class="whitespace-pre-wrap font-mono text-xs leading-relaxed">${escapeHtml(text)}</pre>
                                </div>
                            </div>
                        `;
                    })
                    .catch(() => showPanelError('Không thể tải tệp văn bản này.'));
            }
        }
        else {
            showPanelError(`Định dạng .${ext} chưa được hỗ trợ xem trước trực tiếp.`);
        }
    }

    function loadOfficeAppsFallback(fileUrl) {
        if (!panelBody) return;
        // Office Online requires an absolute URL.
        let absoluteUrl = fileUrl;
        if (!fileUrl.startsWith('http')) {
            absoluteUrl = window.location.origin + fileUrl;
        }
        const encodedUrl = encodeURIComponent(absoluteUrl);
        panelBody.innerHTML = `
            <iframe src="https://view.officeapps.live.com/op/embed.aspx?src=${encodedUrl}" class="w-full h-[70vh] border border-slate-200/60 rounded-xl bg-white shadow-sm" title="Office Apps Preview"></iframe>
        `;
    }

    function escapeHtml(text) {
        return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // Bind original file preview button
    if (btnViewFile) {
        btnViewFile.addEventListener('click', () => {
            if (!window.originalDocInfo || !window.originalDocInfo.viewUrl) {
                alert('Tài liệu hiện tại chưa được lưu tệp tin.');
                return;
            }

            const info = window.originalDocInfo;
            // Resolve fileUrl correctly taking contextPath into account
            let fileUrl = info.viewUrl;
            if (fileUrl && !fileUrl.startsWith('http')) {
                // If it doesn't already start with the contextPath, prepend it
                const context = info.contextPath || '';
                if (context && !fileUrl.startsWith(context)) {
                    fileUrl = context + fileUrl;
                }
            }

            renderPreview(info.fileName || 'Tài liệu gốc', info.fileExtension || 'docx', fileUrl);
        });
    }

    // Bind newly selected local file preview button
    if (btnViewNewFile) {
        btnViewNewFile.addEventListener('click', () => {
            if (!fileInput || fileInput.files.length === 0) {
                alert('Vui lòng chọn tệp tin trước.');
                return;
            }
            const file = fileInput.files[0];
            const ext = getExtension(file.name);
            renderPreview(file.name, ext, file);
        });
    }

    // Initialize preview on page load
    updateLivePreview();

    setTimeout(() => {
        ['flash-success', 'flash-error'].forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.style.transition = 'opacity 0.5s';
                el.style.opacity = '0';
                setTimeout(() => el.remove(), 500);
            }
        });
    }, 5000);
})();