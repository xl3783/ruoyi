# RuoYi-Vue Docker 部署指南

## 项目概述

RuoYi-Vue 是一个基于Spring Boot和Vue.js的前后端分离管理系统。本项目提供了Docker容器化部署方案。

## 目录结构

```
.
├── Dockerfile              # 后端应用Dockerfile
├── nginx.Dockerfile        # 前端Nginx服务Dockerfile
├── docker-compose.yml      # 完整版docker-compose（含前端、后端、数据库、Redis）
├── docker-compose-simple.yml # 简化版docker-compose（仅后端、数据库、Redis）
├── build.sh               # 项目构建脚本
├── conf/                  # 配置文件目录
│   ├── mysql/
│   └── redis/
└── application-docker.yml # Docker环境Spring Boot配置
```

## 快速部署

### 1. 构建项目

首先构建项目（需要安装Maven和Node.js）：

```bash
chmod +x build.sh
./build.sh
```

或者手动构建：

```bash
# 构建后端
mvn clean package -DskipTests

# 构建前端（可选）
cd ruoyi-ui && npm install && npm run build:prod && cd ..
```

### 2. 使用Docker Compose启动

#### 方式一：使用完整版（推荐）

```bash
# 构建并启动所有服务
docker-compose -f docker-compose.yml up -d --build
```

#### 方式二：使用简化版（仅后端）

```bash
# 构建并启动后端服务
docker-compose -f docker-compose-simple.yml up -d --build
```

## 服务说明

- **Backend (Spring Boot)**: `http://localhost:8080`
- **Frontend (Nginx)**: `http://localhost` (需要使用完整版)
- **MySQL**: `localhost:3306` (用户名: ruoyi, 密码: ruoyi123, 数据库: ruoyi)
- **Redis**: `localhost:6379`

## 环境变量

可以在 `.env` 文件中自定义环境变量：

```bash
# 数据库配置
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=ruoyi
MYSQL_USER=ruoyi
MYSQL_PASSWORD=ruoyi123

# 应用配置
SPRING_PROFILES_ACTIVE=docker
SERVER_PORT=8080
```

## 自定义配置

### MySQL配置

MySQL配置文件位于 `conf/mysql/conf.d/mysql.cnf`，可以根据需要调整参数。

### Redis配置

Redis配置文件位于 `conf/redis/redis.conf`，可以根据需要调整参数。

## 数据持久化

- MySQL数据存储在 `mysql_data` volume中
- Redis数据存储在 `redis_data` volume中

## 注意事项

1. 首次启动时，MySQL会自动执行 `sql/ry_20250522.sql` 初始化数据库
2. 确保服务器有足够的内存和磁盘空间
3. 生产环境中请修改默认密码
4. 可根据实际需求调整各服务的资源配置

## 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs -f

# 停止所有服务
docker-compose down

# 重新构建并启动
docker-compose up -d --build

# 清理数据卷（警告：这将删除所有数据）
docker-compose down -v
```

## 故障排除

如果遇到问题，可以检查以下几点：

1. 确认端口未被占用
2. 确认Docker和Docker Compose已正确安装
3. 检查日志输出：`docker-compose logs -f <service-name>`
4. 确认项目已正确构建