(function () {
  const menuButton = document.querySelector(".menu-toggle");
  const mainNav = document.querySelector(".main-nav");
  const authActions = document.querySelector(".auth-actions");
  const searchForm = document.querySelector("#homeSearch");
  const headerSearchForm = document.querySelector("#headerSearch");
  const searchInput = document.querySelector("#searchInput");
  const headerSearchInput = headerSearchForm ? headerSearchForm.querySelector("input") : null;
  const tags = document.querySelectorAll(".tag");
  const cards = document.querySelectorAll(".document-card");
  const backToTop = document.querySelector(".back-to-top");

  function applyFilter(topic, keyword) {
    const normalizedTopic = topic && topic !== "all" ? topic.toLowerCase() : "";
    const normalizedKeyword = (keyword || "").trim().toLowerCase();

    cards.forEach(function (card) {
      const title = card.dataset.title.toLowerCase();
      const category = card.dataset.category.toLowerCase();
      const matchesTopic = !normalizedTopic || category === normalizedTopic;
      const matchesKeyword = !normalizedKeyword || title.includes(normalizedKeyword) || category.includes(normalizedKeyword);
      card.classList.toggle("hidden", !(matchesTopic && matchesKeyword));
    });
  }

  if (menuButton && mainNav && authActions) {
    menuButton.addEventListener("click", function () {
      const isOpen = mainNav.classList.toggle("open");
      authActions.classList.toggle("open", isOpen);
      menuButton.setAttribute("aria-expanded", String(isOpen));
      menuButton.querySelector(".material-symbols-outlined").textContent = isOpen ? "close" : "menu";
    });
  }

  tags.forEach(function (tag) {
    tag.addEventListener("click", function () {
      tags.forEach(function (item) {
        item.classList.remove("active");
      });
      tag.classList.add("active");
      applyFilter(tag.dataset.topic, searchInput ? searchInput.value : "");
    });
  });

  if (searchForm && searchInput) {
    searchForm.addEventListener("submit", function (event) {
      event.preventDefault();
      const activeTag = document.querySelector(".tag.active");
      applyFilter(activeTag ? activeTag.dataset.topic : "all", searchInput.value);
      document.querySelector("#documentGrid").scrollIntoView({behavior: "smooth", block: "start"});
    });

    searchInput.addEventListener("input", function () {
      const activeTag = document.querySelector(".tag.active");
      applyFilter(activeTag ? activeTag.dataset.topic : "all", searchInput.value);
    });
    if (headerSearchForm && headerSearchInput) {
      headerSearchForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const activeTag = document.querySelector(".tag.active");
        applyFilter(activeTag ? activeTag.dataset.topic : "all", headerSearchInput.value);
        document.querySelector("#documentGrid").scrollIntoView({ behavior: "smooth", block: "start" });
      });

      headerSearchInput.addEventListener("input", function () {
        const activeTag = document.querySelector(".tag.active");
        applyFilter(activeTag ? activeTag.dataset.topic : "all", headerSearchInput.value);
      });
    }
  }


  if (backToTop) {
    window.addEventListener("scroll", function () {
      backToTop.classList.toggle("visible", window.scrollY > 420);
    });

    backToTop.addEventListener("click", function () {
      window.scrollTo({top: 0, behavior: "smooth"});
    });
  }
})();
