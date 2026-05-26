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
        input.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    function clearErrors() {
        form.querySelectorAll('.js-error').forEach(el => el.remove());
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));
    }

    function setLoadingState(loading) {
        if (!btnSave) return;
        btnSave.disabled = loading;
        const btnSaveIcon = document.getElementById('btnSaveIcon');
        const btnSaveText = document.getElementById('btnSaveText');
        if (btnSaveIcon) btnSaveIcon.textContent = loading ? 'hourglass_empty' : 'save';
        if (btnSaveText) btnSaveText.textContent  = loading ? 'Đang lưu...' : 'Lưu thay đổi';
    }

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