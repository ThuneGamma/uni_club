# 社团系统项目文档

## 系统启动步骤

### 1. 环境检查与配置
- 确保 MySQL、Redis 服务已启动
- 执行根目录下的 SQL 脚本初始化数据库
- 配置 Nginx 文件服务器：
  - 下载并安装 Nginx
  - 修改 Nginx 配置文件，参考路径：`/doc/nginx_config/dev/nginx.conf`，配置修改至
  - 访问 `http://127.0.0.1:8013/fileServer/` 验证文件服务器配置是否有效

### 2. 代码获取与配置
- 从 GitHub 下载项目代码
- 在 application-dev.properties、application-test.properties 修改 MySQL、Redis 数据库连接的用户名和密码配置

### 3. 后端启动

#### 方式一：使用 IDEA 启动
1. 使用 IDEA 导入 association 代码
2. 启动管理端接口：
   - 模块：`association-adminAPI`
   - 启动类：`AssociationAdminApplication` → `main` 方法
3. 启动客户端接口：
   - 模块：`association-restAPI`
   - 启动对应启动类

#### 方式二：使用 Maven 打包启动
```bash
# 进入项目根目录
mvn package
# 参考 deployment 文件夹进行部署
```

### 4. 前端启动
```bash
# 进入 club 或 club-admin 根目录（包含 package.json 的目录）
npm run dev
```

## 访问地址

### 系统页面
- 前台页面：http://127.0.0.1:80/
- 后台页面：http://127.0.0.1:8080/

### API 文档
- 前台接口文档：http://127.0.0.1:8081/club/api/swagger-ui.html
- 后台接口文档：http://127.0.0.1:8082/club/admin/swagger-ui.html
