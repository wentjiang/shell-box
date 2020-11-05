## k8s 基本操作

创建namespace
```
kubectl create namespace local
```

代理转发service端口
```
kubectl --namespace ops port-forward svc/ops-prometheus-kube-promet-prometheus 9090
```

查看容器日志
```
kubectl logs -f prometheus-test-sm
```

查看某个标签的pod
```
kubectl --namespace monitoring get pods -l "release=ops-prometheus"
```
