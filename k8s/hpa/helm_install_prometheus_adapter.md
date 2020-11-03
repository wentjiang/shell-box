## helm安装 prometheus adapter
https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-adapter/README.md
查看prometheus-adapter默认的配置项
```
helm show values prometheus-community/prometheus-adapter
```

查找prometheus的url
```
kubectl get svc -n ops
找到ops-prometheus-kube-promet-prometheus 对应的cluster-ip

```

修改上报prometheus的url
```
修改adapter.config的prometheus中的url 为上边的cluster-ip
```

安装时提示,这个方法已经被弃用,参见https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-adapter/README.md
```
helm install ops-prometheus-adapter stable/prometheus-adapter --values adapter.yaml --namespace ops
```

查看是否采集成功
```
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/local/services/*/custom_value"
```

修改rule
```
kubectl edit configmap ops-prometheus-adapter -n ops
```

