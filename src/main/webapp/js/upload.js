(function () {
  const maxSize = 50 * 1024 * 1024;
  const allowedExtensions = ["pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "txt"];
  const form = document.querySelector("#uploadForm");
  const dropzone = document.querySelector("#dropzone");
  const fileInput = document.querySelector("#documentFile");
  const preview = document.querySelector("#filePreview");
  const fileName = document.querySelector("#fileName");
  const fileMeta = document.querySelector("#fileMeta");
  const removeFile = document.querySelector("#removeFile");
  const formError = document.querySelector("#formError");
  const submitButton = document.querySelector("#submitUpload");

  function setError(message) {
    if (formError) {
      formError.textContent = message || "";
    }
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

  function validateFile(file) {
    if (!file) {
      return "Vui lòng chọn file tài liệu.";
    }

    const extension = getExtension(file.name);
    if (!allowedExtensions.includes(extension)) {
      return "Định dạng file không được hỗ trợ.";
    }

    if (file.size > maxSize) {
      return "File vượt quá dung lượng tối đa 50MB.";
    }

    return "";
  }

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
      if (!file) {
        return;
      }

      const transfer = new DataTransfer();
      transfer.items.add(file);
      fileInput.files = transfer.files;
      showFile(file);
    });

    fileInput.addEventListener("change", function () {
      showFile(fileInput.files[0]);
    });
  }

  if (removeFile && fileInput) {
    removeFile.addEventListener("click", function () {
      fileInput.value = "";
      preview.hidden = true;
      setError("");
    });
  }

  if (form) {
    form.addEventListener("reset", function () {
      preview.hidden = true;
      setError("");
    });

    form.addEventListener("submit", function (event) {
      const fileError = validateFile(fileInput.files[0]);
      if (fileError) {
        event.preventDefault();
        setError(fileError);
        return;
      }

      if (!form.checkValidity()) {
        event.preventDefault();
        setError("Vui lòng nhập đầy đủ các trường bắt buộc và đồng ý điều khoản.");
        form.reportValidity();
        return;
      }

      setError("");
      submitButton.classList.add("is-loading");
      submitButton.innerHTML = '<span class="material-symbols-outlined">sync</span> Đang đăng tải...';
    });
  }
})();
