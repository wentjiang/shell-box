## helm简介
helm是k8s的包管理,类似centos的yum

helm chart 封装了k8s原生应用的一系列yaml,部署应用的时候自定义应用程序的metadata,以便于应用程序的分发

对于应用开发者,不用编写复杂的应用部署文件,简单的在k8s上查找,安装,升级,回滚,卸载应用

### helm的功能

- 创建新的chart
- chart打包成tgz格式
- 上传chart到chart仓库,或从仓库中下载
- k8s集群中安装或者卸载chart
- 管理helm安装chart的发布周期

## 前置条件
安装好k8s集群

## helm下载地址
[国内下载helm地址](https://www.newbe.pro/Mirrors/Mirrors-Helm/)

挑选对应的版本和对应的平台
下载完成之后,解压,将helm放在bin目录下

更新仓库
```
helm repo update
```

## 安装mysql
```
helm install stable/mysql --generate-name
```


 
