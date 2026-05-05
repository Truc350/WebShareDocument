(function () {
  const grid = document.querySelector("#documentsGrid");
  const cards = Array.from(document.querySelectorAll(".doc-card"));
  const searchForm = document.querySelector("#documentsSearch");
  const keywordInput = document.querySelector("#documentKeyword");
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
    const keyword = (keywordInput ? keywordInput.value : "").trim().toLowerCase();
    const categories = selectedValues("category");
    const subjects = selectedValues("subject");
    const formats = selectedValues("format");
    let visibleCount = 0;

    cards.forEach(function (card) {
      const title = card.dataset.title.toLowerCase();
      const category = card.dataset.category;
      const subject = card.dataset.subject;
      const format = card.dataset.format;
      const isVisible =
        (!keyword || title.includes(keyword) || category.toLowerCase().includes(keyword) || subject.toLowerCase().includes(keyword)) &&
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

  if (searchForm) {
    searchForm.addEventListener("submit", function (event) {
      event.preventDefault();
      applyFilters();
    });
  }

  if (keywordInput) {
    keywordInput.addEventListener("input", applyFilters);
  }

  filterInputs.forEach(function (input) {
    input.addEventListener("change", applyFilters);
  });

  if (clearButton) {
    clearButton.addEventListener("click", function () {
      filterInputs.forEach(function (input) {
        input.checked = false;
      });
      if (keywordInput) {
        keywordInput.value = "";
      }
      applyFilters();
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
})();
