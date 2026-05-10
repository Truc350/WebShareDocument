FROM tomcat:10.1-jdk21

# Xóa app mặc định của Tomcat để tránh đụng độ
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ Maven build vào thư mục gốc của Tomcat
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Mở port 8080 cho ứng dụng
EXPOSE 8080

# Chạy Tomcat
CMD ["catalina.sh", "run"]
