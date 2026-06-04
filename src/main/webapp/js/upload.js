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
    // Các phần tử hiển thị tiến trình
    const progressContainer = document.querySelector("#progressContainer");
    const progressBarFill = document.querySelector("#progressBarFill");
    const progressText = document.querySelector("#progressText");
    const cancelUploadBtn = document.querySelector("#cancelUpload");
    const cancelFormBtn = document.querySelector("#cancelForm");
    let currentXhr = null;

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

    // UC5.2.5.1: Người dùng quay lại trang upload sau khi bị F5 hoặc trình duyệt bị đóng đột ngột.
    persistentFields.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener("input", saveFormState);
    });
    // UC5.2.5.2: Hệ thống kiểm tra dữ liệu trong sessionStorage.
    // UC5.2.5.3: Hệ thống tự động điền các thông tin (Tiêu đề, Danh mục, Môn học, Mô tả) đã nhập trước đó.
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
     * UC5.1.5: Hệ thống kiểm tra sơ bộ định dạng/kích thước và hiển thị Preview
     */
    function validateFile(file) {
        if (!file) return "Vui lòng chọn file tài liệu.";
        const extension = getExtension(file.name);
        if (!allowedExtensions.includes(extension)) {
            return "Định dạng tệp không được hỗ trợ. Chỉ chấp nhận PDF, DOCX, PPTX, XLSX, TXT, PNG, JPG.";
        }
        if (file.size > maxSize) {
            return "Tệp vượt quá kích thước tối đa cho phép (50MB).";
        }
        return "";
    }

    function showFile(file) {
        // UC5.1.5: Hệ thống kiểm tra định dạng/kích thước và hiển thị Preview kèm thông tin tệp.
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

        const ext = getExtension(file.name).toLowerCase();
        fileMeta.textContent = formatSize(file.size) + " . " + ext.toUpperCase();

        // Hiển thị Thumbnail nếu là ảnh
        const fileThumbnail = document.querySelector("#fileThumbnail");
        const fileIcon = document.querySelector("#fileIcon");

        if (fileThumbnail && fileIcon) {
            if (fileThumbnail.src && fileThumbnail.src.startsWith('blob:')) {
                URL.revokeObjectURL(fileThumbnail.src);
            }

            if (file.type.startsWith("image/")) {
                // Nếu là ảnh thì tạo URl để hiển thị thumbnail
                fileThumbnail.src = URL.createObjectURL(file);
                fileThumbnail.style.display = "block";
                fileIcon.style.display = "none";
            } else {
                // Nếu không phải ảnh thì tắt thumbnail, bật icon
                fileThumbnail.style.display = "none";
                fileIcon.style.display = "block";

                if (ext === 'pdf') {
                    fileIcon.textContent = "picture_as_pdf";
                    fileIcon.style.color = "#dc2626";
                }
                else if (['doc', 'docx']. includes(ext)) {
                    fileIcon.textContent = "description";
                    fileIcon.style.color = "#2563eb";
                }
                else if (['xls', 'xlsx'].includes(ext)) {
                    fileIcon.textContent = "table_chart";
                    fileIcon.style.color = "#16a34a";
                }
                else if (['ppt', 'pptx'].includes(ext)) {
                    fileIcon.textContent = "slideshow";
                    fileIcon.style.color = "#ea580c";
                }
                else {
                    fileIcon.textContent = "draft";
                    fileIcon.style.color = "#0555dd";
                }
            }
        }
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
     * UC5.2.4: Người dùng thay đổi hoặc chọn lại tệp tài liệu
     */
    if (removeFile && fileInput) {
        removeFile.addEventListener("click", function () {
            // UC5.2.4.1: Người dùng đã chọn tệp nhưng muốn thay đổi, nhấn vào nút "Xóa"(icon X) trên vùng Preview.
            // UC5.2.4.2: Hệ thống reset giá trị tệp tin, ẩn vùng xem trước (Preview) và hiển thị lại khu vực kéo-thả (Dropzone).
            fileInput.value = "";
            preview.hidden = true;
            setError("");

            // Dọn dẹp URL ảnh nếu người dùng xóa file
            const fileThumbnail = document.querySelector("#fileThumbnail");
            if (fileThumbnail && fileThumbnail.src.startsWith('blob:')) {
                URL.revokeObjectURL(fileThumbnail.src);
                fileThumbnail.src = "";
            }
        });
    }
    /**
     * UC5.2.2: Người dùng nhấn "Hủy" trong khi đang điền form
     */
    if (cancelFormBtn) {
        cancelFormBtn.addEventListener("click", function () {
            const homeUrl = cancelFormBtn.getAttribute("data-home") || "/";
            // UC5.2.2.1: Người dùng nhấn nút "Hủy" trên giao diện.
            // UC5.2.2.2: Hệ thống hiển thị Modal xác nhận: "Bạn có chắc chắn muốn hủy? Mọi thông tin đã nhập sẽ bị mất."
            showModal("Hủy đăng tải?", "Bạn có chắc chắn muốn hủy quá trình đăng tải? Mọi thông tin đã nhập sẽ bị mất.", 'confirm', function () {
                // UC5.2.2.3: Người dùng nhấn "Đồng ý" trên Modal.
                // UC5.2.2.4: Hệ thống xóa các dữ liệu tạm thời trong sessionStorage và điều hướng người dùng quay về Trang chủ.
                sessionStorage.removeItem("uploadFormState");
                window.location.href = homeUrl;
            });
        });
    }
    /**
     * UC5.1.6: Người dùng nhấn nút "Đăng tải ngay"
     */
    if (form) {
        form.addEventListener("submit", function (event) {
            event.preventDefault();
            try {
                setError("");
                // UC5.1.7: Hệ thống kiểm tra tính hợp lệ toàn bộ form.
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
     * UC5.1.8: Hệ thống truyền tệp trực tiếp từ trình duyệt lên Supabase Storage; hiển thị tiến trình upload (progress bar).
     */
    async function uploadFile(formData) {
        setError("");
        submitButton.innerHTML = '<span class="material-symbols-outlined rotating">sync</span> Đang chuẩn bị...';
        progressContainer.hidden = false;

        let isCancelled = false;
        let isConfirmingCancel = false;
        let abortController = new AbortController();

        const file = fileInput.files[0];
        const progressBytesEl = document.querySelector("#progressBytes");

        progressBarFill.style.width = "0%";
        progressText.textContent = "0%";
        progressStatus.textContent = "Đang truyền tải lên Supabase Storage... ";
        if (progressBytesEl) progressBytesEl.textContent = "0 MB / " + formatSize(file.size);

        function finalizeUploadUI(result) {
            if (isCancelled || isConfirmingCancel) return;
            progressContainer.hidden = true;
            submitButton.disabled = false;
            submitButton.innerHTML = '<span class="material-symbols-outlined">publish</span> Đăng tải ngay';
            if (result && result.status === "success") {
                // UC5.1.11: Hệ thống lưu dữ liệu vào database, hiển thị thông báo thành công và điều hướng người dùng về Trang cá nhân.
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
            // UC5.2.3.1: Người dùng nhấn nút "Hủy tải lên" trên thanh tiến trình.
            // UC5.2.3.2: Hệ thống hiển thị Modal xác nhận: "Bạn có chắc chắn muốn hủy? Mọi thông tin đã nhập sẽ bị mất."
            showModal("Dừng tải lên?", "Bạn có chắc chắn muốn dừng quá trình tải tài liệu lên hệ thống? Dữ liệu đã nhập sẽ được giữ lại hoàn toàn.", 'confirm', function () {
                // UC5.2.3.3: Người dùng nhấn "Đồng ý" trên Modal.
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
                // UC5.2.3.4: Hệ thống xóa dữ liệu tạm thời trong sessionStorage và điều hướng về Trang chủ.
                setTimeout(() => {
                    showModal("Đã dừng tải lên", "Quá trình tải lên đã được dừng lại.", "cancel-success");
                    setError("Đã hủy tải lên thành công.");
                }, 300);
            }, function () {
                isConfirmingCancel = false;
            });
        };

        // --- BẮT ĐẦU CHIA NHỎ VÀ TẢI LÊN ---
        const CHUNK_SIZE = 5 * 1024 * 1024; // Cắt mỗi phần 5MB
        const totalChunks = Math.ceil(file.size / CHUNK_SIZE);
        const fileId = Date.now() + "_" + file.name.replace(/[^a-zA-Z0-9.\-_]/g, '_');
        let uploadedBytes = 0;

        for (let chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
            if (isCancelled) break;

            const start = chunkIndex * CHUNK_SIZE;
            const end = Math.min(start + CHUNK_SIZE, file.size);
            const chunk = file.slice(start, end);

            const chunkFormData = new FormData();
            chunkFormData.append("fileChunk", chunk);
            chunkFormData.append("chunkIndex", chunkIndex);
            chunkFormData.append("totalChunks", totalChunks);
            chunkFormData.append("fileId", fileId);
            chunkFormData.append("fileName", file.name);

            // UC5.1.10: Gửi Metadata (Tiêu đề, danh mục,...) về Server Servlet cùng với chunk cuối cùng
            if (chunkIndex === totalChunks - 1) {
                chunkFormData.append("title", form.title.value);
                chunkFormData.append("category", form.category.value);
                chunkFormData.append("subject", form.subject.value);
                chunkFormData.append("description", form.description.value);
                chunkFormData.append("fileSize", file.size);
                chunkFormData.append("extension", getExtension(file.name));
            }

            try {
                progressStatus.textContent = `Đang gửi phần ${chunkIndex + 1}/${totalChunks}...`;

                // Fetch API gửi chunk trực tiếp về Server Java thay vì Supabase
                const response = await fetch(form.action, {
                    method: "POST",
                    body: chunkFormData,
                    signal: abortController.signal // Gắn bộ điều khiển hủy vào đây
                });

                const result = await response.json();
                if (result.status === "error") throw new Error(result.message);

                uploadedBytes += chunk.size;
                const percent = (uploadedBytes / file.size) * 100;

                progressBarFill.style.width = percent.toFixed(1) + "%";
                progressText.textContent = Math.round(percent) + "%";
                if (progressBytesEl) {
                    progressBytesEl.textContent = formatSize(uploadedBytes) + " / " + formatSize(file.size);
                }

                // UC5.1.9: Hệ thống nhận trạng thái phản hồi từ Server (Đã nhận xong toàn bộ chunk)
                if (chunkIndex === totalChunks - 1) {
                    progressStatus.textContent = "Hoàn tất! Đang lưu dữ liệu vào hệ thống...";
                    finalizeUploadUI(result);
                }
            } catch (err) {
                // Nếu người dùng bấm Hủy, fetch sẽ văng lỗi có tên là 'AbortError'
                if (err.name === 'AbortError') {
                    console.log("Đã hủy kết nối fetch.");
                    break;
                }

                console.error("Lỗi Upload Chunk:", err);
                finalizeUploadUI({status: "error", message: "Lỗi kết nối mạng khi tải lên Server: " + err.message});
                break;
            }
        }
    }

    function handleUploadError(message) {
        progressContainer.hidden = true;
        submitButton.disabled = false;
        submitButton.innerHTML = '<span class="material-symbols-outlined">publish</span> Đăng tải ngay';
        setError(message);
    }

    (function () {
        const contextPath = form.getAttribute("data-context") || "";
        const uploadUrl = contextPath + "/upload";
        fetch(uploadUrl, {method: 'HEAD'}).then(() => {
            console.log("Upload Servlet warmed up and ready.");
        }).catch(() => {
        });
    })();
})();
