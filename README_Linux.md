# batch_download.sh 使用说明

批量下载镜像，方便离线网络环境的镜像导入使用。

## 快速上手

```bash
# 1. 编辑 `images.txt` ，添加需要下载的镜像名称和版本号。

# 2. 设置成可用的 docker 镜像加速器
export DOCKER_MIRROR="docker.1ms.run"

# 3. 执行批处理脚本。
bash batch_download.sh

# 4. 下载【检查确认】完毕后，手动将镜像 mv 到 docker/images 目录下
mv *.tar docker/images/
```

```
#（可选步骤）
# nginx 反向代理配置文件代码片段
server {
	listen 80 default_server;
	listen [::]:80 default_server;

    # 当前仓库代码的本地工作目录 /mnt/vdb/docker-images/docker-pull-tar
	root /mnt/vdb/docker-images/docker-pull-tar/images;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	location /docker {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		autoindex on;
		try_files $uri $uri/ =404;
	}

}
```
