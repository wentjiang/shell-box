# 使用自定义指标进行HPA扩缩容

## 前置条件
- 安装好的k8s集群
- 安装好helm

## 整体流程

- 部署prometheus在k8s上
- 部署prometheus adapter在k8s上
- 在prometheus上配置服务的serviceMonitor
- 配置prometheus的采集规则rule
- service添加HPA配置
- 验证HPA是否生效

## 部署prometheus

[helm 部署](./helm_install_prometheus.md)

## 部署prometheus adapter

[]