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
});
