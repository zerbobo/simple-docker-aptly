# 说明

该工程用来构建一个docker的容器环境，以便快速部署和应用aptly。

关于aptly的介绍，可查阅官网介绍：https://www.aptly.info/

关于docker的基础软件和环境构建，可查阅官网介绍：https://www.docker.com/ ，中国大陆可参考国内镜像文档：https://mirror.tuna.tsinghua.edu.cn/help/docker-ce/

# 获取或构建Docker镜像

## hub获取镜像

```
docker pull zerbobo/simple-docker-aptly:latest
```

## 源码构建镜像

下载源码后，直接使用docker指令构建：

```
git clone https://github.com/zerbobo/simple-docker-aptly.git
cd simple-docker-aptly
docker build . -t zerbobo/simple-docker-aptly:latest
```

# 使用镜像

## 1. 运行 simple-docker-aptly 容器

```
sudo docker run \
    --name "my-aptly" \
    --restart always \
    --detach \
    -e GPG_NAME="MY-APTLY" \
    -e GPG_COMMENT="repo published by BB" \
    -e GPG_EMAIL="BB@example.com" \
    -e GPG_PASSPHRASE="Mo0nlightLy!ngFrontOfBed" \
    -p 8080:80 \
    -v '/var/aptly-repo:/var/aptly' \
    zerbobo/simple-docker-aptly:latest
```

其中的参数可以自行指定，或者直接运行：

```
./run-my-aptly-docker.sh
```

## 2. 配置 aptly 源和发布

1）登陆容器环境

```
docker exec -it my-aptly bash
```

2）创建源

```
aptly repo create -comment="example repo" -component="main" -distribution="my-basic" my-basic-repo
```

3) 添加软件包

将预先准备的软件包拷贝到容器环境，参考`docker cp`

```
aptly repo add --remove-files --force-replace my-basic-repo <目标文件夹>/*  
```

4) 创建快照

```
aptly snapshot create first-snapshot from repo my-basic-repo
```

5) 发布源

```
aptly publish snapshot --batch --passphrase="Mo0nlightLy!ngFrontOfBed" first-snapshot
```

## 3. 客户端使用

1) 添加gpg的key：

```
curl http://<server_ip>:8080/pubkey.txt | sudo apt-key add -
```

2) 添加源：

添加如下源设置到 `/etc/apt/sources.list.d/my-repo.list`

```
deb http://<server_ip>:8080/ my-basic main
```

3) 安装软件包

```
sudo apt-get update && sudo apt-get install <package_name>
```
