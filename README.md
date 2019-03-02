# deploy-shell
- Bash Shell编写的自动化部署脚本
- 部署方式：整包部署

## 标准化

- 1.所有节点上创建www用户。
- 2.部署节点和被部署节点的www用户使用密钥验证。
- 3.所有应用程序均使用www用户启动。

## 部署服务器准备工作

1.准备部署用户
   生产统一使用www用户运行应用，同样使用该用户进行部署

```
[root@linux-node1 ~]# groupadd -g 601 www
[root@linux-node1 ~]# useradd -u 601 -g 601 www
[root@linux-node1 ~]# passwd www
[root@linux-node1 ~]# su - www

[www@linux-node1 ~]$ ssh-keygen -t rsa
[www@linux-node1 ~]$ ssh-copy-id 192.168.56.11
[www@linux-node1 ~]$ ssh-copy-id 192.168.56.12
[www@linux-node1 ~]$ ssh 192.168.56.12
```

2.初始化部署服务器目录,仅首次使用需要执行。
```
[root@linux-node1 ~]# mkdir -p /data/deploy/{code,config,tmp,pkg}
```

3.制品库模拟
```
[www@linux-node1 ~]$ mkdir /data/pkg/devops-demo
```

4.项目准备
```
[www@linux-node1 ~]$ mkdir -p /data/deploy/{code,config,tmp,pkg}/devops-demo

部署脚本 deploy.sh
制品包   devops-demo.tar.gz 请放置在/data/pkg/devops-demo
```

## 应用服务器准备

1.准备应用运行用户
```
[root@linux-node2 ~]# groupadd -g 601 www
[root@linux-node2 ~]# useradd -u 601 -g 601 www
[root@linux-node2 ~]# passwd www
[root@linux-node2 ~]# mkdir -p /app-data/init
[root@linux-node2 ~]# echo "v1" > /app-data/init/index.html
[root@linux-node2 ~]# chown -R www:www /app-data
```

2.准备应用环境
```
[root@linux-node2 ~]# yum install -y httpd
[root@linux-node2 ~]# vim /etc/httpd/conf/httpd.conf
User www
Group www
[root@linux-node2 ~]# rm -rf /var/www/html/
[root@linux-node2 ~]# ln -s /app-data/init /var/www/html
[root@linux-node2 ~]# systemctl start httpd
```

3.测试访问
```
[root@linux-node2 ~]# curl http://192.168.56.12
v1
```

## 自动部署执行
  默认直接拉取最新代码
  
```
  [www@linux-node1 ~]$ ./deploy.sh SIT deploy
```

## 回滚时请注意，版本输入不需要带.tar.gz
 
 ```
  [www@linux-node1 ~]$ ./deploy.sh SIT rollback /app-data/demo-2018-10-05-17-31

 ```
