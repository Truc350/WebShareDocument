(function () {
  const headerSearchForm = document.querySelector("#headerSearch");
  const headerSearchInput = headerSearchForm ? headerSearchForm.querySelector("input") : null;
  const cards = Array.from(document.querySelectorAll(".category-item-card"));
  const emptyState = document.querySelector("#emptyCategory");
  const fieldGrid = document.querySelector("#fieldGrid");
  const toggleFields = document.querySelector("#toggleFields");

  function applySearch() {
    const keyword = (headerSearchInput ? headerSearchInput.value : "").trim().toLowerCase();
    let visibleCount = 0;

    cards.forEach(function (card) {
      const title = (card.dataset.title || card.textContent).toLowerCase();
      const isVisible = !keyword || title.includes(keyword);
      card.classList.toggle("hidden", !isVisible);
      if (isVisible) {
        visibleCount += 1;
      }
    });

    if (emptyState) {
      emptyState.classList.toggle("visible", visibleCount === 0);
    }
  }

  if (headerSearchForm && headerSearchInput) {
    headerSearchForm.addEventListener("submit", function (event) {
      event.preventDefault();
      applySearch();
    });

    headerSearchInput.addEventListener("input", applySearch);
  }

  if (toggleFields && fieldGrid) {
    toggleFields.addEventListener("click", function () {
      const expanded = fieldGrid.classList.toggle("expanded");
      toggleFields.firstChild.textContent = expanded ? "Thu gọn " : "Xem tất cả khoa/ngành học ";
      toggleFields.querySelector(".material-symbols-outlined").textContent = expanded ? "expand_less" : "expand_more";
    });
  }
})();
