# 使用Node.js环境构建前端
FROM docker.m.daocloud.io/node:16-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制前端项目文件
COPY ruoyi-ui/ .

# 安装依赖
RUN npm install --registry https://registry.npm.taobao.org

# 构建生产版本
RUN npm run build:prod

# 使用Nginx提供静态文件服务
FROM docker.m.daocloud.io/nginx:alpine

# 复制构建好的前端文件到nginx目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制nginx配置文件
COPY ruoyi-ui/nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1