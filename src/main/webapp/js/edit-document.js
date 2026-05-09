/**
 * edit-document.js – UC-15: Chỉnh sửa thông tin tài liệu
 * Xử lý client-side: character counter, validation, UX.
 */
(function () {
    'use strict';

    // ── UC15.1.3: Khởi tạo counter ký tự khi form load ─────────────────────
    const titleInput   = document.getElementById('title');
    const titleLen     = document.getElementById('titleLen');
    const descInput    = document.getElementById('description');
    const descLen      = document.getElementById('descLen');
    const form         = document.getElementById('editDocumentForm');
    const btnSave      = document.getElementById('btnSave');
    const btnSaveIcon  = document.getElementById('btnSaveIcon');
    const btnSaveText  = document.getElementById('btnSaveText');
    const btnCancel    = document.getElementById('btnCancel');

    // ── UC15.1.3: Counter ký tự – phản hồi tức thì ──────────────────────────
    function updateCounter(input, display, max) {
        const len = input.value.length;
        display.textContent = len;
        // Đổi màu khi gần giới hạn (> 90%)
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

    // ── UC15.2.2: Client-side validation trước khi submit ───────────────────
    // (Bổ sung cho server-side UC15.1.6 – không thay thế)
    if (form) {
        form.addEventListener('submit', function (e) {
            clearErrors();
            const title = titleInput ? titleInput.value.trim() : '';
            const desc  = descInput  ? descInput.value.trim()  : '';
            const tags  = document.getElementById('tags');
            const tagsVal = tags ? tags.value.trim() : '';
            let hasError  = false;

            // UC15.1.6 – Tên tài liệu không được để trống (Special Req 1)
            if (!title) {
                showError('title', 'Tên tài liệu không được để trống.');
                hasError = true;
            } else if (title.length > 255) {
                // UC15.1.6 – Không vượt quá 255 ký tự
                showError('title', 'Tên tài liệu không được vượt quá 255 ký tự.');
                hasError = true;
            }

            // UC15.1.6 – Mô tả không vượt quá 2000 ký tự (Special Req 2)
            if (desc.length > 2000) {
                showError('description', 'Mô tả không được vượt quá 2000 ký tự.');
                hasError = true;
            }

            // UC15.1.6 – Định dạng tags hợp lệ
            if (tagsVal && !/^[\p{L}\p{N}\s,._-]+$/u.test(tagsVal)) {
                showError('tags', 'Tags chỉ được chứa chữ cái, số và dấu phẩy.');
                hasError = true;
            }

            if (hasError) {
                e.preventDefault();
                // UC15.2.2.1: Scroll đến lỗi đầu tiên
                const firstError = form.querySelector('.field-error');
                if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                return;
            }

            // UC15.1.5: Loading state khi submit
            setLoadingState(true);
        });
    }

    // ── UC15.2.3: Nút Huỷ – quay về trang trước ─────────────────────────────
    // UC15.2.3.1: User nhấp "Huỷ" trước khi lưu
    // UC15.2.3.2: Không lưu thay đổi, quay về trang chi tiết
    if (btnCancel) {
        btnCancel.addEventListener('click', function () {
            if (isFormDirty()) {
                const confirmed = confirm(
                    'Bạn có thay đổi chưa được lưu. Bạn có chắc muốn rời khỏi trang này không?'
                );
                if (!confirmed) return;
            }
            history.back();
        });
    }

    // ── UC15.1.8: Auto-dismiss flash messages sau 5 giây ───────────────────
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

    // ── Helpers ─────────────────────────────────────────────────────────────

    /** UC15.2.2.2: Hiển thị thông báo lỗi ngay bên dưới trường nhập liệu */
    function showError(fieldId, message) {
        const input = document.getElementById(fieldId);
        if (!input) return;
        input.classList.add('field-error');

        // Kiểm tra đã có error-msg chưa (từ server-side)
        const parent = input.closest('.space-y-1\\.5') || input.parentElement;
        let errP = parent.querySelector('.error-msg.js-error');
        if (!errP) {
            errP = document.createElement('p');
            errP.className = 'error-msg flex items-center gap-1 js-error';
            errP.innerHTML = `<span class="material-symbols-outlined text-[14px]">error</span> ${message}`;
            input.insertAdjacentElement('afterend', errP);
        } else {
            errP.querySelector('span:last-child') ?
                (errP.lastChild.textContent = ' ' + message) :
                (errP.textContent = message);
        }
    }

    /** Xóa tất cả lỗi client-side trước khi validate lại */
    function clearErrors() {
        form.querySelectorAll('.js-error').forEach(el => el.remove());
        form.querySelectorAll('.field-error').forEach(el => el.classList.remove('field-error'));
    }

    /** UC15 Special Req 4: Hiển thị loading khi đang lưu (≤3 giây) */
    function setLoadingState(loading) {
        if (!btnSave) return;
        btnSave.disabled = loading;
        if (btnSaveIcon) btnSaveIcon.textContent = loading ? 'hourglass_empty' : 'save';
        if (btnSaveText) btnSaveText.textContent  = loading ? 'Đang lưu...'    : 'Lưu thay đổi';
    }

    /** UC15.2.3: Kiểm tra form có bị thay đổi không (dirty check) */
    function isFormDirty() {
        const inputs = form.querySelectorAll('input:not([type=hidden]):not([type=radio]), textarea, select');
        for (const input of inputs) {
            if (input.type === 'radio') continue;
            if (input.value !== input.defaultValue) return true;
        }
        const radios = form.querySelectorAll('input[type=radio]');
        for (const radio of radios) {
            if (radio.checked !== radio.defaultChecked) return true;
        }
        return false;
    }
})();