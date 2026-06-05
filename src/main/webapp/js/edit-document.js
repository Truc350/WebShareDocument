/**
 * edit-document.js – Logic xử lý giao diện chỉnh sửa thông tin tài liệu (UC15)
 */
(function () {
    'use strict';

    // Các thành phần DOM trên Form
    const form         = document.getElementById('editDocumentForm');
    const btnSave      = document.getElementById('btnSave');
    const btnCancel    = document.getElementById('btnCancel');
    
    // Các phần hiển thị đếm ký tự
    const titleInput   = document.getElementById('title');
    const titleLen     = document.getElementById('titleLen');
    const descInput    = document.getElementById('description');
    const descLen      = document.getElementById('descLen');

    // Các thành phần UI thay thế tệp tin
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

    // Các phần hiển thị tiến trình tải tệp (Progress Bar)
    const progressContainer = document.getElementById('progressContainer');
    const progressBarFill = document.getElementById('progressBarFill');
    const progressText = document.getElementById('progressText');
    const progressStatus = document.getElementById('progressStatus');
    const cancelUploadBtn = document.getElementById('cancelUpload');

    // Các ràng buộc tệp tin
    const maxSize = 50 * 1024 * 1024; // Giới hạn kích thước tệp là 50MB
    const allowedExtensions = ["pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt", "png", "jpg", "jpeg"];
    let currentXhr = null;

    // Các thành phần hiển thị trên Live Preview Card
    const previewTitle = document.getElementById('previewTitle');
    const previewCategory = document.getElementById('previewCategory');
    const previewTagsContainer = document.getElementById('previewTagsContainer');
    const previewDescription = document.getElementById('previewDescription');
    const previewPrivacyBadge = document.getElementById('previewPrivacyBadge');
    const previewFileName = document.getElementById('previewFileName');
    const previewFileSize = document.getElementById('previewFileSize');
    const previewFileExt = document.getElementById('previewFileExt');

    // Lưu trữ siêu dữ liệu tệp gốc để khôi phục khi hủy thay thế
    const originalFileName = previewFileName ? previewFileName.textContent.trim() : '';
    const originalFileSize = previewFileSize ? previewFileSize.textContent.trim() : '';
    const originalFileExt = previewFileExt ? previewFileExt.textContent.trim() : '';

    // ── HÀM ĐẾM KÝ TỰ CHO CÁC TRƯỜNG NHẬP LIỆU ────────────────────────────────
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

    // ── LOGIC XỬ LÝ GIAO DIỆN THAY THẾ FILE ───────────────────────────────────
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

    // Hàm xóa tệp mới đã chọn và khôi phục thông tin tệp cũ
    function clearNewFile() {
        if (fileInput) fileInput.value = '';
        if (filePreview) filePreview.classList.add('hidden');
        if (dropzone) dropzone.classList.remove('hidden');
        clearErrors();

        // Khôi phục thông tin tệp gốc trên Live Preview Card
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

    // Hiển thị thông tin tệp mới được chọn lên giao diện và Live Preview
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

        // Cập nhật thông tin file mới lên Live Preview Card
        if (previewFileName) previewFileName.textContent = file.name;
        if (previewFileSize) previewFileSize.textContent = formatSize(file.size);
        if (previewFileExt) previewFileExt.textContent = extension.toUpperCase();
    }

    // Xử lý kéo thả tệp tin (Drag & Drop)
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

    // ── UC15.1.7 / UC15.1.8 / UC15.2.2: SUBMIT FORM & KIỂM TRA HỢP LỆ (VALIDATION) ──
    if (form) {
        // UC15.1.7: User nhấp nút "Lưu thay đổi" để xác nhận cập nhật thông tin tài liệu
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            clearErrors();
            
            // UC15.1.8 & UC15.2.2.1: Hệ thống kiểm tra tính hợp lệ của dữ liệu nhập
            // Kiểm tra Tiêu đề tài liệu
            const title = titleInput ? titleInput.value.trim() : '';
            if (!title) {
                // UC15.2.2.1: Phát hiện lỗi tên tài liệu để trống -> highlight và hiện thông báo lỗi
                showError('title', 'Tên tài liệu không được để trống.');
                return;
            }
            if (title.length > 255) {
                // UC15.2.2.1: Phát hiện tên tài liệu vượt quá giới hạn ký tự
                showError('title', 'Tên tài liệu không được vượt quá 255 ký tự.');
                return;
            }

            // Kiểm tra Mô tả tài liệu
            const description = descInput ? descInput.value.trim() : '';
            if (description.length > 2000) {
                // UC15.2.2.1: Phát hiện lỗi mô tả vượt quá giới hạn ký tự
                showError('description', 'Mô tả không được vượt quá 2000 ký tự.');
                return;
            }

            // Kiểm tra Định dạng các thẻ Tags
            const tagsInput = document.getElementById('tags');
            if (tagsInput) {
                const tagsVal = tagsInput.value.trim();
                if (tagsVal) {
                    const tagsArr = tagsVal.split(',')
                        .map(t => t.trim())
                        .filter(t => t !== '');
                    const tagRegex = /^[a-zA-Z0-9\sÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐđ\-]+$/;
                    for (let tag of tagsArr) {
                        if (tag.length > 50) {
                            // UC15.2.2.1: Phát hiện tag dài quá 50 ký tự
                            showError('tags', 'Mỗi thẻ không được vượt quá 50 ký tự.');
                            return;
                        }
                        if (!tagRegex.test(tag)) {
                            // UC15.2.2.1: Phát hiện tag chứa ký tự đặc biệt không được phép
                            showError('tags', 'Thẻ chứa ký tự không hợp lệ. Chỉ cho phép chữ, số, khoảng trắng và dấu gạch ngang.');
                            return;
                        }
                    }
                }
            }

            const fileToUpload = fileInput && fileInput.files.length > 0 ? fileInput.files[0] : null;
            
            // Nếu có tệp mới được chọn thay thế, upload lên Supabase Storage trước
            if (fileToUpload && !newFileSection.classList.contains('hidden')) {
                uploadToSupabaseAndSubmit(fileToUpload);
            } else {
                // Nếu không có tệp mới, tiến hành gửi Form cập nhật thông tin trực tiếp (UC15.1.9)
                setLoadingState(true);
                form.submit();
            }
        });
    }

    // Hàm tải tệp lên Supabase Storage qua Ajax
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
                
                // Thiết lập các giá trị ẩn để gửi lên Servlet
                document.getElementById('secureUrl').value = publicUrl;
                document.getElementById('newFileNameInput').value = file.name;
                document.getElementById('newFileSizeInput').value = file.size;
                document.getElementById('newExtensionInput').value = getExtension(file.name);
                
                // Gửi form lưu thông tin tài liệu lên DB (UC15.1.9)
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

    // ── UC15.2.3: ALTERNATE FLOW - USER HUỶ THAO TÁC CHỈNH SỬA ────────────────
    if (btnCancel) {
        // UC15.2.3.1: User nhấp nút "Huỷ"
        btnCancel.addEventListener('click', function () {
            // UC15.2.3.2: Hệ thống hủy thao tác, không lưu gì và chuyển hướng về Trang cá nhân
            const context = window.originalDocInfo ? window.originalDocInfo.contextPath : '';
            window.location.href = context + '/profile';
        });
    }

    // Hàm hiển thị lỗi validation trên giao diện và đánh dấu đỏ bên Live Preview
    function showError(fieldId, message) {
        const input = document.getElementById(fieldId);
        if (!input) return;
        
        // Highlight đỏ trường nhập liệu bị lỗi (UC15.2.2.1)
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

        // UC15.2.2.1: Live Preview Card đánh dấu viền đỏ các trường không hợp lệ trong thẻ xem trước
        if (fieldId === 'title' && previewTitle) {
            previewTitle.classList.add('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
        } else if (fieldId === 'tags' && previewTagsContainer) {
            previewTagsContainer.classList.add('border', 'border-red-200', 'p-1', 'rounded');
        } else if (fieldId === 'description' && previewDescription) {
            previewDescription.classList.add('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
        }

        // Cuộn màn hình đến phần tử bị lỗi để người dùng dễ nhìn thấy
        input.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // Xóa các vết đỏ và thông báo lỗi cũ
    function clearErrors() {
        form.querySelectorAll('.js-error').forEach(el => el.remove());
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));

        // Xóa đánh dấu đỏ trên Live Preview Card
        if (previewTitle) {
            previewTitle.classList.remove('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
        }
        if (previewTagsContainer) {
            previewTagsContainer.classList.remove('border', 'border-red-200', 'p-1', 'rounded');
        }
        if (previewDescription) {
            previewDescription.classList.remove('text-red-500', 'border', 'border-red-200', 'p-1', 'rounded');
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

    // ── UC15.1.6: CẬP NHẬT LIVE PREVIEW CARD THEO THỜI GIAN THỰC (REAL-TIME) ──
    function updateLivePreview() {
        // Cập nhật Tiêu đề lên Live Preview Card
        if (titleInput && previewTitle) {
            const titleVal = titleInput.value.trim();
            previewTitle.textContent = titleVal || 'Chưa đặt tên tài liệu';
        }

        // Cập nhật Mô tả lên Live Preview Card
        if (descInput && previewDescription) {
            const descVal = descInput.value.trim();
            previewDescription.textContent = descVal || 'Chưa có mô tả nào cho tài liệu này.';
        }

        // Cập nhật Tên danh mục lên Live Preview Card
        const categorySelect = document.getElementById('categoryId');
        if (categorySelect && previewCategory) {
            const selectedOption = categorySelect.options[categorySelect.selectedIndex];
            const catName = selectedOption && categorySelect.value ? selectedOption.textContent.trim() : 'Chưa chọn danh mục';
            previewCategory.textContent = catName;
        }

        // Cập nhật Trạng thái hiển thị (Công khai / Nháp) lên Live Preview Card
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

        // Cập nhật các Thẻ Tags lên Live Preview Card
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

    // Lắng nghe sự kiện thay đổi dữ liệu để cập nhật Live Preview tức thì (UC15.1.6)
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

    // ========================================================================
    // UC15.1.4 & UC15.1.5: XỬ LÝ PANEL XEM TRƯỚC NỘI DUNG TỆP (FILE PREVIEW)
    // ========================================================================
    const btnViewFile = document.getElementById('btnViewFile');
    const btnViewNewFile = document.getElementById('btnViewNewFile');
    const filePreviewPanel = document.getElementById('filePreviewPanel');
    const btnClosePreviewPanel = document.getElementById('btnClosePreviewPanel');
    const panelBody = document.getElementById('panelBody');
    const panelFileName = document.getElementById('panelFileName');
    const panelFileExtBadge = document.getElementById('panelFileExtBadge');
    const panelFileIcon = document.getElementById('panelFileIcon');

    // Hàm mở modal panel
    function openPreviewModal() {
        if (!filePreviewPanel) return;
        filePreviewPanel.classList.remove('hidden');
        filePreviewPanel.classList.add('flex');
        filePreviewPanel.offsetHeight; // Force reflow
        filePreviewPanel.classList.add('modal-active');
    }

    // Hàm đóng modal panel
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

    // UC15.1.5: Hàm hiển thị nội dung tệp theo định dạng
    function renderPreview(fileName, extension, source) {
        if (!panelBody || !panelFileName || !panelFileExtBadge || !panelFileIcon) return;

        // Thiết lập tiêu đề và icon trên thanh tiêu đề của panel
        panelFileName.textContent = fileName;
        panelFileExtBadge.textContent = extension.toUpperCase();
        panelFileIcon.textContent = getMaterialIconByExt(extension);

        openPreviewModal();
        showPanelLoading();

        const ext = extension.toLowerCase();

        // 1. Đối với file Ảnh (png, jpg, jpeg) hiển thị trực tiếp
        if (ext === 'png' || ext === 'jpg' || ext === 'jpeg') {
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
        // 2. Đối với file PDF hiển thị dạng trang cuộn được qua iframe
        else if (ext === 'pdf') {
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
        // 3. Đối với file văn bản mới .docx: chuyển đổi HTML hiển thị dạng text định dạng (Mammoth.js)
        else if (ext === 'docx') {
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
                // Tải file docx trực tuyến và convert sang HTML
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
                                loadOfficeAppsFallback(source);
                            });
                    })
                    .catch(err => {
                        console.warn('Mammoth fetch/parse failed. Falling back to Office Viewer:', err);
                        loadOfficeAppsFallback(source);
                    });
            }
        }
        // 4. Đối với các tệp Office cũ (.doc, .xls, .ppt): sử dụng nhúng Office Online Viewer
        else if (ext === 'doc' || ext === 'xls' || ext === 'xlsx' || ext === 'ppt' || ext === 'pptx') {
            if (source instanceof File) {
                showPanelError(`Định dạng tệp .${ext} không hỗ trợ xem trước trực tiếp khi chưa lưu. Vui lòng sử dụng tệp dạng .docx, .pdf hoặc hình ảnh.`);
            } else {
                loadOfficeAppsFallback(source);
            }
        }
        // 5. Đối với tệp văn bản thô (.txt) hiển thị trong thẻ pre
        else if (ext === 'txt') {
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

    // UC15.1.4: Lắng nghe sự kiện bấm nút “Xem nội dung file” trên tệp hiện tại
    if (btnViewFile) {
        btnViewFile.addEventListener('click', () => {
            if (!window.originalDocInfo || !window.originalDocInfo.viewUrl) {
                alert('Tài liệu hiện tại chưa được lưu tệp tin.');
                return;
            }

            const info = window.originalDocInfo;
            let fileUrl = info.viewUrl;
            if (fileUrl && !fileUrl.startsWith('http')) {
                const context = info.contextPath || '';
                if (context && !fileUrl.startsWith(context)) {
                    fileUrl = context + fileUrl;
                }
            }

            renderPreview(info.fileName || 'Tài liệu gốc', info.fileExtension || 'docx', fileUrl);
        });
    }

    // UC15.1.4: Lắng nghe sự kiện bấm nút “Xem nội dung file” cho tệp mới tải lên ở dropzone
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

    // Khởi tạo hiển thị Live Preview lần đầu khi vừa tải trang
    updateLivePreview();

    // Tự động ẩn các Flash Message sau 5 giây
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