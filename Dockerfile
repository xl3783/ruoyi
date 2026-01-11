# 使用官方OpenJDK运行时作为基础镜像
FROM docker.m.daocloud.io/openjdk:21-ea-23-jdk-bullseye

RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash curl tar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=docker"]