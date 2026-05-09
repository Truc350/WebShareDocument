(function () {
    /**
     * Đăng tải tài liệu
     */
    const maxSize = 50 * 1024 * 1024;
    const allowedExtensions = ["pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt", "png", "jpg", "jpeg"];
    const form = document.querySelector("#uploadForm");
    const dropzone = document.querySelector("#dropzone");
    const fileInput = document.querySelector("#documentFile");
    const preview = document.querySelector("#filePreview");
    const fileName = document.querySelector("#fileName");
    const fileMeta = document.querySelector("#fileMeta");
    const removeFile = document.querySelector("#removeFile");
    const formError = document.querySelector("#formError");
    const submitButton = document.querySelector("#submitUpload");
    // Các phần tử hiển thị tiến trình (UC5.1.8)
    const progressContainer = document.querySelector("#progressContainer");
    const progressBarFill = document.querySelector("#progressBarFill");
    const progressText = document.querySelector("#progressText");
    const cancelUploadBtn = document.querySelector("#cancelUpload");
    const cancelFormBtn = document.querySelector("#cancelForm");
    let currentXhr = null; // Để xử lý UC5.2.3 (Hủy trong khi đang tải lên)
    function setError(message) {
        if (formError) {
            formError.textContent = message || "";
            if (message) {
                formError.classList.add("shake");
                setTimeout(() => formError.classList.remove("shake"), 500);
            }
        }
    }

    const modal = document.querySelector("#customModal");
    const modalTitle = document.querySelector("#modalTitle");
    const modalMessage = document.querySelector("#modalMessage");
    const modalConfirmBtn = document.querySelector("#modalConfirm");
    const modalCancelBtn = document.querySelector("#modalCancel");
    const persistentFields = ["title", "description", "category", "subject"];

    function saveFormState() {
        const state = {};
        persistentFields.forEach(id => {
            const el = document.getElementById(id);
            if (el) state[id] = el.value;
        });
        sessionStorage.setItem("uploadFormState", JSON.stringify(state));
    }

    function loadFormState() {
        const saved = sessionStorage.getItem("uploadFormState");
        if (saved) {
            try {
                const state = JSON.parse(saved);
                persistentFields.forEach(id => {
                    const el = document.getElementById(id);
                    if (el && state[id]) el.value = state[id];
                });
            } catch (e) {
                console.error("Error loading state", e);
            }
        }
    }

    persistentFields.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener("input", saveFormState);
    });
    loadFormState();

    function showModal(title, message, type = 'confirm', onConfirm = null) {
        if (!modal) {
            if (type === 'confirm') {
                if (confirm(message) && onConfirm) onConfirm();
            } else {
                alert(message);
                if (onConfirm) onConfirm();
            }
            return;
        }
        modalTitle.textContent = title;
        modalMessage.textContent = message;
        // Cấu hình Icon và Nút dựa trên type
        const modalIcon = document.querySelector("#modalIcon");
        if (type === 'success') {
            modalIcon.textContent = "check_circle";
            modalIcon.parentElement.style.background = "rgba(40, 167, 69, 0.1)";
            modalIcon.style.color = "#28a745";
            modalCancelBtn.hidden = true;
            modalConfirmBtn.textContent = "OK";
        } else if (type === 'cancel-success') {
            modalIcon.textContent = "info";
            modalIcon.parentElement.style.background = "rgba(0, 64, 171, 0.1)";
            modalIcon.style.color = "#0040ab";
            modalCancelBtn.hidden = true;
            modalConfirmBtn.textContent = "OK";
        } else {
            modalIcon.textContent = "warning";
            modalIcon.parentElement.style.background = "rgba(255, 152, 0, 0.1)";
            modalIcon.style.color = "#ff9800";
            modalCancelBtn.hidden = false;
            modalConfirmBtn.textContent = "Đồng ý";
        }
        modal.hidden = false;
        const cleanup = () => {
            modalConfirmBtn.removeEventListener("click", handleConfirm);
            modalCancelBtn.removeEventListener("click", handleCancel);
            modal.hidden = true;
        };
        const handleConfirm = () => {
            cleanup();
            if (onConfirm) onConfirm();
        };
        const handleCancel = () => {
            cleanup();
        };
        modalConfirmBtn.addEventListener("click", handleConfirm);
        modalCancelBtn.addEventListener("click", handleCancel);
    }

    function getExtension(name) {
        const parts = name.split(".");
        return parts.length > 1 ? parts.pop().toLowerCase() : "";
    }

    function formatSize(bytes) {
        if (bytes >= 1024 * 1024) {
            return (bytes / (1024 * 1024)).toFixed(2) + " MB";
        }
        return (bytes / 1024).toFixed(1) + " KB";
    }

    /**
     * UC5.1.5: Hệ thống kiểm tra sơ bộ phía client
     */
    function validateFile(file) {
        if (!file) {
            return "Vui lòng chọn file tài liệu.";
        }
        const extension = getExtension(file.name);
        if (!allowedExtensions.includes(extension)) {
            return "Định dạng tệp không được hỗ trợ. Chỉ chấp nhận PDF, DOCX, PPTX, XLSX, TXT, PNG, JPG.";
        }
        if (file.size > maxSize) {
            return "Tệp vượt quá kích thước tối đa cho phép (50MB). Vui lòng chọn tệp nhỏ hơn.";
        }
        return "";
    }

    /**
     * UC5.1.5: Hệ thống hiển thị tên tệp, định dạng và kích thước tệp được chọn.
     */
    function showFile(file) {
        const error = validateFile(file);
        if (error) {
            setError(error);
            fileInput.value = "";
            preview.hidden = true;
            return;
        }
        setError("");
        preview.hidden = false;
        fileName.textContent = file.name;
        fileMeta.textContent = formatSize(file.size) + " · " + getExtension(file.name).toUpperCase();
    }

    if (dropzone && fileInput) {
        ["dragenter", "dragover"].forEach(function (eventName) {
            dropzone.addEventListener(eventName, function (event) {
                event.preventDefault();
                dropzone.classList.add("dragover");
            });
        });
        ["dragleave", "drop"].forEach(function (eventName) {
            dropzone.addEventListener(eventName, function (event) {
                event.preventDefault();
                dropzone.classList.remove("dragover");
            });
        });
        dropzone.addEventListener("drop", function (event) {
            const file = event.dataTransfer.files[0];
            if (!file) return;
            const transfer = new DataTransfer();
            transfer.items.add(file);
            fileInput.files = transfer.files;
            showFile(file);
        });
        fileInput.addEventListener("change", function () {
            if (fileInput.files.length > 0) {
                showFile(fileInput.files[0]);
            }
        });
    }
    /**
     * UC5.2.4: Người dùng chọn lại tệp
     */
    if (removeFile && fileInput) {
        removeFile.addEventListener("click", function () {
            // UC5.2.4.2: Hệ thống xóa tệp đã chọn trước đó
            fileInput.value = "";
            preview.hidden = true;
            setError("");
        });
    }
    /**
     * UC5.2.2: Người dùng nhấn nút 'Hủy' khi đang điền form
     */
    if (cancelFormBtn) {
        cancelFormBtn.addEventListener("click", function () {
            const homeUrl = cancelFormBtn.getAttribute("data-home") || "/";
            // UC5.2.2.2: Hệ thống hiển thị hộp thoại xác nhận
            showModal("Hủy đăng tải?", "Bạn có chắc chắn muốn hủy quá trình đăng tải? Mọi thông tin đã nhập sẽ bị mất.", 'confirm', function () {
                // UC5.2.2.4: Chuyển người dùng về trang chủ
                window.location.href = homeUrl;
            });
        });
    }
    /**
     * UC5.1.6: Người dùng nhấn nút 'Đăng tải'
     */
    if (form) {
        form.addEventListener("submit", function (event) {
            event.preventDefault(); // UC5.1.8: Ngăn chặn reload trang
            try {
                setError("");
                // UC5.1.7: Hệ thống kiểm tra tính hợp lệ của toàn bộ form
                const file = fileInput.files[0];
                const fileError = validateFile(file);
                if (fileError) {
                    setError(fileError);
                    return;
                }
                if (!form.checkValidity()) {
                    setError("Vui lòng điền đầy đủ các thông tin bắt buộc (*).");
                    form.reportValidity();
                    return;
                }
                // Bắt đầu quá trình tải lên
                uploadFile(new FormData(form));
            } catch (e) {
                setError("Lỗi khởi tạo tải lên. Dữ liệu form vẫn được giữ nguyên.");
            }
        });
    }

    /**
     * UC5.1.8: Hệ thống hiển thị thanh tiến trình thời gian thực và bắt đầu truyền tệp lên File Storage System
     */
    function uploadFile(formData) {
        currentXhr = new XMLHttpRequest();
        setError("");
        submitButton.innerHTML = '<span class="material-symbols-outlined rotating">sync</span> Đang chuẩn bị...';
        progressContainer.hidden = false;
        let progress = 0;
        let isCancelled = false;
        let isConfirmingCancel = false;
        let uploadFinished = false;
        let lastResult = null;

        const startTime = Date.now();
        const minDuration = 3000;

        function animateProgress() {
            if (isCancelled) return;
            const elapsed = Date.now() - startTime;
            const timePercent = Math.min((elapsed / minDuration) * 100, 100);
            const visiblePercent = Math.max(progress, timePercent);
            progressBarFill.style.width = visiblePercent.toFixed(1) + "%";
            progressText.textContent = Math.round(visiblePercent) + "%";

            if (visiblePercent < 100 || !uploadFinished) {
                requestAnimationFrame(animateProgress);
            } else {
                finalizeUploadUI(lastResult);
            }
        }

        function finalizeUploadUI(result) {
            if (isCancelled || isConfirmingCancel) return;
            progressContainer.hidden = true;
            submitButton.disabled = false;
            submitButton.innerHTML = '<span class="material-symbols-outlined">publish</span> Đăng tải ngay';
            if (result && result.status === "success") {
                sessionStorage.removeItem("uploadFormState");
                const contextPath = form.getAttribute("data-context") || "";
                const detailUrl = contextPath + "/page/user/profile.jsp";
                showModal("Thành công ✓", "Đăng tải tài liệu thành công!", "success", function () {
                    window.location.href = detailUrl;
                });
            } else if (result && result.status === "reload") {
                sessionStorage.removeItem("uploadFormState");
                showModal("Thành công", "Đăng tải tài liệu thành công!", "success", function () {
                    window.location.reload();
                });
            } else {
                const msg = (result && result.message) ? result.message : "Có lỗi xảy ra. Vui lòng thử lại.";
                setError(msg);
            }
        }

        const cancelBtn = document.querySelector("#cancelUpload");
        cancelBtn.onclick = () => {
            isConfirmingCancel = true;
            showModal("Dừng tải lên?", "Bạn có chắc chắn muốn dừng quá trình tải tài liệu lên hệ thống? Dữ liệu đã nhập sẽ được giữ lại hoàn toàn.", 'confirm', function () {
                isConfirmingCancel = false;
                isCancelled = true;
                if (currentXhr) {
                    currentXhr.abort();
                    currentXhr = null;
                }
                progressContainer.hidden = true;
                submitButton.disabled = false;
                submitButton.innerHTML = '<span class="material-symbols-outlined">publish</span> Đăng tải ngay';
                if (fileInput.files.length > 0) {
                    preview.hidden = false;
                }
                setTimeout(() => {
                    showModal("Đã dừng tải lên", "Quá trình tải lên đã được dừng lại.", "cancel-success");
                    setError("Đã hủy tải lên thành công.");
                }, 300);
            }, function () {
                isConfirmingCancel = false;
                if (uploadFinished) finalizeUploadUI(lastResult);
            });
        };

        requestAnimationFrame(animateProgress);

        const file = fileInput.files[0];
        const contextPath = form.getAttribute("data-context") || "";

        progressStatus.textContent = "Đang truyền tải lên Supabase Storage...";
        
        // Cấu hình Supabase
        const supabaseUrl = "https://tlbznphszzpondlykmst.supabase.co";
        const supabaseKey = "sb_publishable_3IaZByYoSWSHakJqFMOifQ_ud2mNCpg";
        const bucketName = "documents"; // Lưu ý: Cần tạo bucket 'documents' (Public) trên Supabase
        
        // Tạo tên file an toàn
        const safeFileName = file.name.replace(/[^a-zA-Z0-9.\-_]/g, '_');
        const filePath = `uploads/${Date.now()}_${safeFileName}`;
        const uploadUrl = `${supabaseUrl}/storage/v1/object/${bucketName}/${filePath}`;

        currentXhr.upload.addEventListener("progress", function (e) {
            if (e.lengthComputable) {
                progress = (e.loaded / e.total) * 100 * 0.85; // 85% cho quá trình lên Cloud
            }
        });

        currentXhr.addEventListener("load", function () {
            if (isCancelled) return;
            if (currentXhr.status >= 200 && currentXhr.status < 300) {
                progress = 90;
                progressStatus.textContent = "Đang lưu dữ liệu vào hệ thống...";
                
                // Lấy URL Public từ Supabase
                const publicUrl = `${supabaseUrl}/storage/v1/object/public/${bucketName}/${filePath}`;
                
                // Bước 2: Gửi URL lên Server nội bộ
                const serverData = new FormData();
                serverData.append("title", form.title.value);
                serverData.append("category", form.category.value);
                serverData.append("subject", form.subject.value);
                serverData.append("description", form.description.value);
                serverData.append("secureUrl", publicUrl);
                serverData.append("fileName", file.name);
                serverData.append("fileSize", file.size);
                serverData.append("extension", getExtension(file.name));

                fetch(form.action, {
                    method: "POST",
                    body: serverData
                })
                .then(r => r.json())
                .then(serverResult => {
                    if (isCancelled) return;
                    progress = 100;
                    uploadFinished = true;
                    lastResult = serverResult;
                })
                .catch(e => {
                    uploadFinished = true;
                    lastResult = {status: "error", message: "Lỗi lưu DB: " + e.message};
                });
            } else {
                uploadFinished = true;
                let errorMsg = "Supabase error";
                try {
                    const result = JSON.parse(currentXhr.responseText);
                    errorMsg += ": " + (result.message || result.error || currentXhr.status);
                } catch(e) {}
                lastResult = {status: "error", message: errorMsg};
            }
        });

        currentXhr.addEventListener("error", function () {
            if (isCancelled) return;
            uploadFinished = true;
            lastResult = {status: "error", message: "Lỗi kết nối mạng khi tải lên Supabase."};
        });

        currentXhr.open("POST", uploadUrl, true);
        currentXhr.setRequestHeader("Authorization", "Bearer " + supabaseKey);
        currentXhr.setRequestHeader("apikey", supabaseKey);
        currentXhr.setRequestHeader("Content-Type", file.type || "application/octet-stream");
        currentXhr.send(file); // Gửi trực tiếp tệp nhị phân
    }

    function handleUploadError(message) {
        progressContainer.hidden = true;
        submitButton.disabled = false;
        submitButton.innerHTML = '<span class="material-symbols-outlined">publish</span> Đăng tải ngay';
        setError(message);
    }
    // Tối ưu hóa: "Đánh thức" server ngay khi trang vừa load xong
    (function () {
        const contextPath = form.getAttribute("data-context") || "";
        const uploadUrl = contextPath + "/upload";
        // Gửi request HEAD nhẹ để khởi động Servlet và DB connection sẵn sàng
        fetch(uploadUrl, {method: 'HEAD'}).then(() => {
            console.log("Upload Servlet warmed up and ready.");
        }).catch(() => {});
    })();
})();
