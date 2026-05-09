(function () {
  const grid = document.querySelector("#documentsGrid");
  let cards = Array.from(document.querySelectorAll(".doc-card"));
  const headerSearchForm = document.querySelector("#headerSearch");
  const headerSearchInput = headerSearchForm ? headerSearchForm.querySelector("input") : null;
  const filterInputs = Array.from(document.querySelectorAll(".filter-sidebar input[type='checkbox']"));
  const clearButton = document.querySelector("#clearFilters");
  const resultCount = document.querySelector("#resultCount");
  const emptyState = document.querySelector("#emptyState");
  const sortSelect = document.querySelector("#sortDocuments");
  const viewButtons = document.querySelectorAll(".view-toggle");

  function selectedValues(name) {
    return filterInputs
      .filter(function (input) {
        return input.name === name && input.checked;
      })
      .map(function (input) {
        return input.value.toLowerCase();
      });
  }

  function matchesSelected(value, selected) {
    return selected.length === 0 || selected.includes(value.toLowerCase());
  }

  function applyFilters() {
    const categories = selectedValues("category");
    const subjects = selectedValues("subject");
    const formats = selectedValues("format");
    let visibleCount = 0;

    cards.forEach(function (card) {
      const category = card.dataset.category || "";
      const subject = card.dataset.subject || "";
      const format = card.dataset.format || "";
      const isVisible =
        matchesSelected(category, categories) &&
        matchesSelected(subject, subjects) &&
        matchesSelected(format, formats);

      card.classList.toggle("hidden", !isVisible);
      if (isVisible) {
        visibleCount += 1;
      }
    });

    if (resultCount) {
      resultCount.textContent = String(visibleCount);
    }

    if (emptyState) {
      emptyState.classList.toggle("visible", visibleCount === 0);
    }
  }

  function sortCards(value) {
    const sortedCards = cards.slice().sort(function (a, b) {
      if (value === "popular") {
        return Number(b.dataset.downloads) - Number(a.dataset.downloads);
      }

      if (value === "title") {
        return a.dataset.title.localeCompare(b.dataset.title, "vi");
      }

      return new Date(b.dataset.date) - new Date(a.dataset.date);
    });

    sortedCards.forEach(function (card) {
      grid.appendChild(card);
    });
  }

  function highlightKeyword(text, keyword) {
    if (!keyword) return text || "";
    const regex = new RegExp(`(${keyword})`, 'gi');
    return (text || "").replace(regex, '<mark style="background-color: #fde047; padding: 0 2px; border-radius: 2px;">$1</mark>');
  }

  function renderResults(results, q) {
    grid.innerHTML = "";
    if (results.length === 0) {
      // UC11.2.4.2 showNotFound(q)
      // UC11.2.4.3 showSuggestions()
      if (emptyState) {
        emptyState.innerHTML = `Không tìm thấy tài liệu nào cho '<b>${q}</b>'. Vui lòng thử lại với từ khóa khác.<br><br><small>Gợi ý: giải tích, lập trình java, kinh tế vi mô...</small>`;
        emptyState.classList.add("visible");
      }
      if (resultCount) resultCount.textContent = "0";
      cards = [];
      return;
    }

    if (emptyState) emptyState.classList.remove("visible");

    results.forEach(function (doc) {
      const article = document.createElement("article");
      article.className = "doc-card";
      article.style.cursor = "pointer";
      article.onclick = function() { window.location.href = `${window.CONTEXT_PATH || ""}/document-detail?id=${doc.id}`; };
      
      article.dataset.title = doc.title || "";
      article.dataset.category = doc.categoryName || "";
      article.dataset.subject = doc.categoryName || "";
      article.dataset.format = (doc.fileExtension || "").toUpperCase();
      article.dataset.downloads = doc.downloadCount || 0;
      article.dataset.date = doc.createdAt ? `${doc.createdAt.date.year}-${doc.createdAt.date.month}-${doc.createdAt.date.day}` : "";

      const titleHtml = highlightKeyword(doc.title, q);
      const descHtml = highlightKeyword(doc.description, q);
      const format = article.dataset.format || "PDF";
      
      let previewClass = "preview-blue";
      if (format === "DOCX") previewClass = "preview-green";
      if (format === "PPTX") previewClass = "preview-orange";
      if (format === "PDF") previewClass = "preview-red";

      article.innerHTML = `
        <div class="doc-preview ${previewClass}"><span class="doc-format">${format}</span><span class="material-symbols-outlined">description</span></div>
        <div class="doc-body">
            <p class="doc-file"><span class="material-symbols-outlined">article</span> ${doc.fileName || ""}</p>
            <h3>${titleHtml}</h3>
            <p class="doc-desc">${descHtml}</p>
            <div class="doc-author"><span>${(doc.uploaderName||"U")[0].toUpperCase()}</span><div><strong>${doc.uploaderName || "User"}</strong><small>${article.dataset.date}</small></div></div>
            <div class="doc-stats"><span><span class="material-symbols-outlined">visibility</span>${doc.viewCount || 0}</span><span><span class="material-symbols-outlined">download</span>${doc.downloadCount || 0}</span></div>
            <button type="button" onclick="event.stopPropagation(); window.location.href='${window.CONTEXT_PATH || ""}/document-detail?id=${doc.id}';">Xem chi tiết</button>
        </div>
      `;
      grid.appendChild(article);
    });

    cards = Array.from(document.querySelectorAll(".doc-card"));
    
    // Apply local filters after fetching
    applyFilters();
  }

  function fetchSearchResults() {
    const urlParams = new URLSearchParams(window.location.search);
    const q = urlParams.get("q") || "";
    
    // UC11.1.5 fullTextSearch(q)
    fetch(`${window.CONTEXT_PATH || ""}/api/search?q=${encodeURIComponent(q)}`)
      .then(res => res.json())
      .then(data => {
        // UC11.1.8 renderResults(results) + highlightKeyword(q)
        renderResults(data.results || [], q);
      })
      .catch(err => console.error("Search error:", err));
  }

  if (headerSearchForm && headerSearchInput) {
    // We removed the submit event here because home.js handles it globally
    // We listen to the custom event instead
  }

  document.addEventListener("applyFilters", function () {
    fetchSearchResults();
  });

  filterInputs.forEach(function (input) {
    input.addEventListener("change", applyFilters);
  });

  if (clearButton) {
    clearButton.addEventListener("click", function () {
      filterInputs.forEach(function (input) {
        input.checked = false;
      });
      if (headerSearchInput) {
        headerSearchInput.value = "";
      }
      // UC11.2.3.1 xóa từ khóa -> resetSearch -> renderFullList
      const url = new URL(window.location.href);
      url.searchParams.delete("q");
      window.history.pushState({}, "", url);
      fetchSearchResults();
    });
  }

  if (sortSelect) {
    sortSelect.addEventListener("change", function () {
      sortCards(sortSelect.value);
      applyFilters();
    });
  }

  viewButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      viewButtons.forEach(function (item) {
        item.classList.remove("active");
      });
      button.classList.add("active");
      grid.classList.toggle("list-view", button.dataset.view === "list");
    });
  });

  // Initial fetch on load
  window.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has("q") && headerSearchInput) {
      headerSearchInput.value = urlParams.get("q");
    }
    fetchSearchResults();
  });
})();
