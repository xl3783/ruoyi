# 使用官方OpenJDK运行时作为基础镜像
FROM openjdk:8-jre-alpine

# 维护者信息
LABEL maintainer="RuoYi-Vue Docker Maintainers"

# 安装必要的工具
RUN apk add --no-cache bash curl tar

# 设置工作目录
WORKDIR /app

# 复制打包好的jar文件到容器中
COPY ruoyi-admin/target/ruoyi-admin.jar app.jar

# 暴露应用运行的端口
EXPOSE 8080

# 定义健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/login || exit 1

# 运行应用程序
ENTRYPOINT ["java", "-jar", "app.jar"]