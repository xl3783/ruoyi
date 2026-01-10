#!/bin/bash

echo "开始构建RuoYi-Vue项目..."

# 检查是否已安装Maven
if ! command -v mvn &> /dev/null; then
    echo "错误: Maven未安装，请先安装Maven"
    exit 1
fi

# 检查是否已安装Node.js
if ! command -v node &> /dev/null; then
    echo "警告: Node.js未安装，将跳过前端构建"
else
    echo "检测到Node.js，开始构建前端..."
    cd ruoyi-ui
    npm install
    npm run build:prod
    cd ..
fi

echo "开始构建后端应用..."
# 构建后端应用
mvn clean package -DskipTests

echo "项目构建完成!"
echo "后端JAR文件位置: ruoyi-admin/target/ruoyi-admin.jar"

# 提供Docker构建和运行说明
echo ""
echo "使用以下命令来构建和运行Docker容器:"
echo "docker build -t ruoyi-backend ."
echo "docker-compose -f docker-compose-simple.yml up -d"