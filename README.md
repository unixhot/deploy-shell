# deploy-shell
自动化部署脚本

## 应用服务器设置

```
 [root@linux-node2 ~]# groupadd -g 601 www
 [root@linux-node2 ~]# useradd -u 601 -g 601 www
 [root@linux-node2 ~]# passwd www
 [root@linux-node2 ~]# mkdir /app-data /app-root 
 [root@linux-node2 ~]# touch /app-root/webroot
 [root@linux-node2 ~]# chown -R www:www /app-data && chown -R www:www /app-root
```
 
