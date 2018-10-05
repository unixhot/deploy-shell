# deploy-shell
- Bash Shell编写的自动化部署脚本
- 部署方式：整包部署

## 标准化

- 1.所有节点上创建www用户。
- 2.部署节点和被部署节点的www用户使用密钥验证。
- 3.所有应用程序均使用www用户启动。

## 应用服务器设置

- 所有部署版本均存放在/app-data目录下。
- 应用的根目录为/app-root/webroot

```
 [root@linux-node2 ~]# groupadd -g 601 www
 [root@linux-node2 ~]# useradd -u 601 -g 601 www
 [root@linux-node2 ~]# passwd www
 [root@linux-node2 ~]# mkdir /app-data /app-root 
 [root@linux-node2 ~]# touch /app-root/webroot
 [root@linux-node2 ~]# chown -R www:www /app-data && chown -R www:www /app-root
```

## 部署执行
  默认直接拉取最新代码
  
```
  [www@linux-node1 ~]$ ./deploy.sh SIT deploy
```

## 回滚时请注意，版本输入不需要带.tar.gz
 
 ```
  [www@linux-node1 ~]$ ./deploy.sh SIT rollback /app-data/demo-2018-10-05-17-31

 ```
