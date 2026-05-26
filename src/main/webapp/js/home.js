(function () {
  const menuButton = document.querySelector(".menu-toggle");
  const mainNav = document.querySelector(".main-nav");
  const authActions = document.querySelector(".auth-actions");
  const headerSearchForm = document.querySelector("#headerSearch");
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
      applyFilter(tag.dataset.topic, headerSearchInput ? headerSearchInput.value : "");
    });
  });



  const contextPath = typeof window.CONTEXT_PATH !== 'undefined' ? window.CONTEXT_PATH : "/WebShareDocument";

  if (headerSearchForm && headerSearchInput) {
      const suggestionsBox = document.querySelector("#searchSuggestions");
      const suggestionsList = suggestionsBox ? suggestionsBox.querySelector("ul") : null;
      let debounceTimer;

      headerSearchForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const activeTag = document.querySelector(".tag.active");
        const q = headerSearchInput.value.trim();
        // UC11.1.10 Lưu từ khóa vừa tìm kiếm vào lịch sử tìm kiếm
        saveSearchHistory(q);
        // UC11.1.4 nhấn Enter / nhấp nút Tìm kiếm
        if (window.location.pathname.endsWith("search.jsp") || window.location.pathname.endsWith("documents.jsp")) {
          // Allow documents.js to handle or just update URL
          const url = new URL(window.location.href);
          url.searchParams.set("q", q);
          url.searchParams.set("page", "1");
          // UC11.1.7 updateURL(?q=...&page=1)
          window.history.pushState({}, "", url);
          const applyFiltersEvent = new CustomEvent("applyFilters");
          document.dispatchEvent(applyFiltersEvent);
        } else {
          // UC11.1.7 updateURL(?q=...&page=1)
          window.location.href = `${contextPath}/page/user/search.jsp?q=${encodeURIComponent(q)}&page=1`;
        }
      });

      headerSearchInput.addEventListener("input", function () {
        const q = headerSearchInput.value.trim();
        clearTimeout(debounceTimer);

        if (q.length < 2) {
          if (suggestionsBox) suggestionsBox.style.display = "none";
          // UC11.2.3.1 xóa từ khóa (Backspace hoặc X) -> hideDropdown
          return;
        }

        // UC11.1.2 chờ debounce (300ms) rồi gửi yêu cầu autocomplete
        debounceTimer = setTimeout(() => {
          fetch(`${contextPath}/api/suggestions?q=${encodeURIComponent(q)}`)
            .then(res => res.json())
            .then(data => {
              if (data && data.length > 0 && suggestionsList) {
                suggestionsList.innerHTML = "";
                // UC11.1.3 trả về tối đa 5 gợi ý
                data.slice(0, 5).forEach(item => {
                  const li = document.createElement("li");
                  li.style.padding = "10px 16px";
                  li.style.cursor = "pointer";
                  li.style.borderBottom = "1px solid #f3f4f6";
                  li.style.color = "#1f2937";
                  li.style.fontSize = "14px";
                  // UC11.1.11 Highlight từ khóa trong danh sách gợi ý
                  const regex = new RegExp(`(${q})`, 'gi');
                  const highlighted = item.replace(regex, '<mark style="background-color: #fde047; padding: 0 2px; border-radius: 2px;">$1</mark>');
                  li.innerHTML = highlighted;
                  
                  li.addEventListener("mouseenter", () => li.style.background = "#f9fafb");
                  li.addEventListener("mouseleave", () => li.style.background = "transparent");
                  
                  // UC11.2.2.1 nhấp chọn gợi ý
                  li.addEventListener("click", () => {
                    headerSearchInput.value = item;
                    suggestionsBox.style.display = "none";
                    // UC11.1.10 Lưu từ khóa vừa tìm kiếm vào lịch sử tìm kiếm
                    saveSearchHistory(item);
                    // UC11.2.2.2 search(q), bỏ qua nhấn Enter
                    if (window.location.pathname.endsWith("search.jsp") || window.location.pathname.endsWith("documents.jsp")) {
                      const url = new URL(window.location.href);
                      url.searchParams.set("q", item);
                      url.searchParams.set("page", "1");
                      window.history.pushState({}, "", url);
                      const applyFiltersEvent = new CustomEvent("applyFilters");
                      document.dispatchEvent(applyFiltersEvent);
                    } else {
                      window.location.href = `${contextPath}/page/user/search.jsp?q=${encodeURIComponent(item)}&page=1`;
                    }
                  });
                  suggestionsList.appendChild(li);
                });
                suggestionsBox.style.display = "block";
              } else {
                if (suggestionsBox) suggestionsBox.style.display = "none";
              }
            }).catch(err => console.error("Autocomplete error:", err));
        }, 300);
      });

      // UC11.2.5 Người dùng sử dụng lịch sử tìm kiếm
      headerSearchInput.addEventListener("focus", function() {
          const q = headerSearchInput.value.trim();
          if (q.length === 0) {
              renderSearchHistory();
          }
      });
      function getHistoryKey() {
          // Lưu riêng theo user đăng nhập, nếu chưa đăng nhập thì lưu chung dưới dạng khách
          return window.LOGGED_IN_USER_ID ? `search_history_${window.LOGGED_IN_USER_ID}` : "search_history_guest";
      }
      function saveSearchHistory(keyword) {
          if (!keyword) return;
          const key = getHistoryKey();
          if (!key) return;
          let history = JSON.parse(localStorage.getItem(key) || "[]");
          // Xóa nếu đã tồn tại để đưa lên đầu
          history = history.filter(item => item !== keyword);
          history.unshift(keyword);
          // Giữ tối đa 10 mục
          if (history.length > 10) {
              history = history.slice(0, 10);
          }
          localStorage.setItem(key, JSON.stringify(history));
      }
      function removeSearchHistory(keyword) {
          const key = getHistoryKey();
          if (!key) return;
          let history = JSON.parse(localStorage.getItem(key) || "[]");
          history = history.filter(item => item !== keyword);
          localStorage.setItem(key, JSON.stringify(history));
          renderSearchHistory();
      }
      function clearAllSearchHistory() {
          const key = getHistoryKey();
          if (!key) return;
          localStorage.removeItem(key);
          renderSearchHistory();
      }
      function renderSearchHistory() {
          // UC11.2.5.1 Hiển thị danh sách lịch sử tìm kiếm
          const key = getHistoryKey();
          if (!key) return;
          const history = JSON.parse(localStorage.getItem(key) || "[]");
          if (history.length === 0) {
              if (suggestionsBox) suggestionsBox.style.display = "none";
              return;
          }
          if (suggestionsList) {
              suggestionsList.innerHTML = "";
              const headerLi = document.createElement("li");
              headerLi.style.padding = "10px 16px";
              headerLi.style.fontSize = "12px";
              headerLi.style.color = "#6b7280";
              headerLi.style.display = "flex";
              headerLi.style.justifyContent = "space-between";
              headerLi.style.alignItems = "center";
              headerLi.style.borderBottom = "1px solid #f3f4f6";
              headerLi.innerHTML = `<span>Lịch sử tìm kiếm</span> <span class="clear-history" style="cursor:pointer; color:#dc2626; font-weight:bold;">Xóa tất cả</span>`;
              headerLi.querySelector(".clear-history").addEventListener("click", (e) => {
                  e.stopPropagation();
                  // UC11.2.5.3 Xóa toàn bộ lịch sử
                  clearAllSearchHistory();
              });
              suggestionsList.appendChild(headerLi);
              history.forEach(item => {
                  const li = document.createElement("li");
                  li.style.padding = "10px 16px";
                  li.style.cursor = "pointer";
                  li.style.borderBottom = "1px solid #f3f4f6";
                  li.style.color = "#1f2937";
                  li.style.fontSize = "14px";
                  li.style.display = "flex";
                  li.style.justifyContent = "space-between";
                  li.style.alignItems = "center";
                  const textSpan = document.createElement("span");
                  textSpan.textContent = item;
                  const delBtn = document.createElement("span");
                  delBtn.innerHTML = "&times;";
                  delBtn.style.color = "#9ca3af";
                  delBtn.style.fontSize = "18px";
                  delBtn.style.padding = "0 5px";
                  delBtn.addEventListener("mouseenter", () => delBtn.style.color = "#dc2626");
                  delBtn.addEventListener("mouseleave", () => delBtn.style.color = "#9ca3af");
                  // UC11.2.5.3 Xóa mục riêng lẻ
                  delBtn.addEventListener("click", (e) => {
                      e.stopPropagation();
                      removeSearchHistory(item);
                  });
                  li.appendChild(textSpan);
                  li.appendChild(delBtn);
                  li.addEventListener("mouseenter", () => li.style.background = "#f9fafb");
                  li.addEventListener("mouseleave", () => li.style.background = "transparent");
                  // UC11.2.5.2 Nhấp vào mục lịch sử
                  li.addEventListener("click", () => {
                      headerSearchInput.value = item;
                      suggestionsBox.style.display = "none";
                      saveSearchHistory(item);
                      if (window.location.pathname.endsWith("search.jsp") || window.location.pathname.endsWith("documents.jsp")) {
                          const url = new URL(window.location.href);
                          url.searchParams.set("q", item);
                          url.searchParams.set("page", "1");
                          window.history.pushState({}, "", url);
                          const applyFiltersEvent = new CustomEvent("applyFilters");
                          document.dispatchEvent(applyFiltersEvent);
                      } else {
                          window.location.href = `${contextPath}/page/user/search.jsp?q=${encodeURIComponent(item)}&page=1`;
                      }
                  });
                  suggestionsList.appendChild(li);
              });
              suggestionsBox.style.display = "block";
          }
      }
      // Hide dropdown when clicking outside
      document.addEventListener("click", (e) => {
        if (!headerSearchForm.contains(e.target) && suggestionsBox) {
          // UC11.2.3.2 hideDropdown()
          suggestionsBox.style.display = "none";
        }
      });
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
