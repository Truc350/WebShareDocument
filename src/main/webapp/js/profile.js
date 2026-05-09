document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.max-w-\\[1280px\\] > .flex.border-b button');
    const personalInfoSection = document.getElementById('personal-info-section');
    const myDocumentsSection = document.getElementById('my-documents-section');

    if(tabButtons.length >= 2) {
        tabButtons[0].addEventListener('click', function() {
            // "Thông tin cá nhân" tab
            tabButtons[0].className = 'px-6 py-4 text-sm transition-all active-tab';
            tabButtons[1].className = 'px-6 py-4 text-sm transition-all inactive-tab';
            
            // Show left column (info)
            if (personalInfoSection) personalInfoSection.style.display = 'block';
            
            // Resize right column to default
            if (myDocumentsSection) {
                myDocumentsSection.classList.remove('lg:col-span-3');
                myDocumentsSection.classList.add('lg:col-span-2');
            }
        });

        tabButtons[1].addEventListener('click', function() {
            // "Tài liệu của tôi" tab
            tabButtons[1].className = 'px-6 py-4 text-sm transition-all active-tab';
            tabButtons[0].className = 'px-6 py-4 text-sm transition-all inactive-tab';

            // Hide info section
            if (personalInfoSection) personalInfoSection.style.display = 'none';
            
            // Expand documents section to full width
            if (myDocumentsSection) {
                myDocumentsSection.classList.remove('lg:col-span-2');
                myDocumentsSection.classList.add('lg:col-span-3');
            }
        });
    }

    // --- Delete Document Logic ---
    const deleteBtns = document.querySelectorAll('.btn-delete-doc');
    const deleteModal = document.getElementById('deleteModal');
    const deleteModalContent = document.getElementById('deleteModalContent');
    const btnCancelDelete = document.getElementById('btnCancelDelete');
    const btnConfirmDelete = document.getElementById('btnConfirmDelete');
    const deleteSpinner = document.getElementById('deleteSpinner');
    const deleteBtnText = document.getElementById('deleteBtnText');
    const contextPath = document.getElementById('contextPath') ? document.getElementById('contextPath').value : '';
    
    let currentDocIdToDelete = null;
    let currentRowToDelete = null;

    if (deleteBtns && deleteModal) {
        deleteBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                currentDocIdToDelete = this.getAttribute('data-id');
                currentRowToDelete = this.closest('tr');
                
                // Show modal
                deleteModal.classList.remove('hidden');
                deleteModal.classList.add('flex');
                
                // Animate in
                setTimeout(() => {
                    deleteModalContent.classList.remove('scale-95', 'opacity-0');
                    deleteModalContent.classList.add('scale-100', 'opacity-100');
                }, 10);
            });
        });

        const closeModal = () => {
            deleteModalContent.classList.remove('scale-100', 'opacity-100');
            deleteModalContent.classList.add('scale-95', 'opacity-0');
            setTimeout(() => {
                deleteModal.classList.add('hidden');
                deleteModal.classList.remove('flex');
                currentDocIdToDelete = null;
                currentRowToDelete = null;
            }, 200);
        };

        if (btnCancelDelete) {
            btnCancelDelete.addEventListener('click', closeModal);
        }

        if (btnConfirmDelete) {
            btnConfirmDelete.addEventListener('click', function() {
                if (!currentDocIdToDelete) return;
                
                // Show loading
                btnConfirmDelete.disabled = true;
                deleteSpinner.classList.remove('hidden');
                deleteBtnText.textContent = 'Đang xóa...';
                
                // Make API call
                fetch(contextPath + '/delete-document', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + currentDocIdToDelete
                })
                .then(response => response.json())
                .then(data => {
                    btnConfirmDelete.disabled = false;
                    deleteSpinner.classList.add('hidden');
                    deleteBtnText.textContent = 'Xóa tài liệu';
                    
                    if (data.success) {
                        // Remove row from DOM
                        if (currentRowToDelete) {
                            currentRowToDelete.remove();
                        }
                        closeModal();
                        
                        // Show success flash
                        showFlashMsg('success', data.message || 'Đã xóa tài liệu thành công.');
                        
                        // Optionally update count
                        const docCountElement = document.querySelector('span.block.text-2xl.font-bold');
                        if (docCountElement) {
                            let count = parseInt(docCountElement.textContent) || 0;
                            if (count > 0) docCountElement.textContent = count - 1;
                        }
                    } else {
                        alert(data.message || 'Có lỗi xảy ra khi xóa.');
                        closeModal();
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert('Lỗi kết nối tới máy chủ.');
                    btnConfirmDelete.disabled = false;
                    deleteSpinner.classList.add('hidden');
                    deleteBtnText.textContent = 'Xóa tài liệu';
                    closeModal();
                });
            });
        }
    }
    
    function showFlashMsg(type, msg) {
        // Simple flash message builder matching existing UI
        const flashDiv = document.createElement('div');
        const isSuccess = type === 'success';
        
        flashDiv.className = `fixed top-4 right-4 z-50 flex items-center gap-3 px-5 py-3 rounded-xl shadow-lg transition-all transform translate-y-[-20px] opacity-0 ${
            isSuccess ? 'bg-green-50 border border-green-200 text-green-800' : 'bg-red-50 border border-red-200 text-red-800'
        }`;
        
        flashDiv.innerHTML = `
            <span class="material-symbols-outlined ${isSuccess ? 'text-green-600' : 'text-red-500'}">
                ${isSuccess ? 'check_circle' : 'error'}
            </span>
            <span class="text-sm font-medium">${msg}</span>
            <button onclick="this.parentElement.remove()" class="ml-2 ${isSuccess ? 'text-green-600 hover:text-green-800' : 'text-red-500 hover:text-red-700'}">
                <span class="material-symbols-outlined text-[18px]">close</span>
            </button>
        `;
        
        document.body.appendChild(flashDiv);
        
        // Animate in
        setTimeout(() => {
            flashDiv.classList.remove('translate-y-[-20px]', 'opacity-0');
        }, 10);
        
        // Auto remove
        setTimeout(() => {
            flashDiv.style.transition = 'opacity 0.5s';
            flashDiv.style.opacity = '0';
            setTimeout(() => flashDiv.remove(), 500);
        }, 5000);
    }
});
