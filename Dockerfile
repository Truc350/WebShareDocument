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

# Copy file WAR đã được build từ Stage 1 sang Stage 2
COPY --from=build /app/target/*.war webapps/ROOT.war

# Mở port
EXPOSE 8080

# Chạy Tomcat
CMD ["catalina.sh", "run"]
