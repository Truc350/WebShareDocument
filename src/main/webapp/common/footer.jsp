<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-col">
        <a class="brand" href="${pageContext.request.contextPath}/page/home.jsp">
          <span class="material-symbols-outlined">description</span>
          <strong>DocShare</strong>
        </a>
        <p>Nền tảng chia sẻ và lưu trữ tài liệu học thuật hàng đầu cho sinh viên Việt Nam. Chúng tôi tin vào sức mạnh của kiến thức mở.</p>
        <div class="social-links">
          <a href="#" aria-label="Website"><span class="material-symbols-outlined">public</span></a>
          <a href="#" aria-label="Email"><span class="material-symbols-outlined">mail</span></a>
        </div>
      </div>

      <div class="footer-col">
        <h3>Tài liệu</h3>
        <ul>
          <li><a href="${pageContext.request.contextPath}/page/documents.jsp">Mới nhất</a></li>
          <li><a href="${pageContext.request.contextPath}/page/documents.jsp">Tải nhiều nhất</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h3>Hỗ trợ</h3>
        <ul>
          <li><a href="#">Hướng dẫn tải</a></li>
          <li><a href="#">Điều khoản sử dụng</a></li>
          <li><a href="#">Liên hệ</a></li>
        </ul>
      </div>

      <div class="footer-col newsletter">
        <h3>Newsletter</h3>
        <p>Nhận thông báo khi có tài liệu mới về môn học của bạn.</p>
        <div class="input-group">
          <input type="email" placeholder="Email của bạn">
          <button class="btn-send" type="button" aria-label="Gửi email">
            <span class="material-symbols-outlined">send</span>
          </button>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <p>© 2024 DocShare. Professional Document Repository.</p>
      <div class="footer-links">
        <a href="#">Privacy Policy</a>
        <a href="#">Sitemap</a>
        <a href="#">Help Center</a>
      </div>
    </div>
  </div>
</footer>
