# Stage 1: Build file WAR bằng Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml và tải các dependency (để cache lớp này nếu pom.xml không đổi)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy toàn bộ mã nguồn và build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Chạy ứng dụng bằng Tomcat
FROM tomcat:10.1-jdk21
WORKDIR /usr/local/tomcat

# Xóa app mặc định của Tomcat
RUN rm -rf webapps/*

# Tắt cổng shutdown của Tomcat (8005) để tránh Render gửi nhầm HTTP health check vào cổng này
RUN sed -i 's/port="8005"/port="-1"/g' conf/server.xml

# Copy file WAR đã được build từ Stage 1 sang Stage 2
COPY --from=build /app/target/*.war webapps/ROOT.war

# Mở port (có thể không cần thiết nếu platform tự động set biến PORT)
EXPOSE 8080

# Thay đổi port 8080 mặc định thành biến môi trường PORT (Render, Heroku...) trước khi chạy Tomcat
CMD sed -i -e "s/port=\"8080\"/port=\"${PORT:-8080}\"/g" conf/server.xml && catalina.sh run
