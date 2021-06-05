## kube-dashboard yaml


### 启动kube-dashboard
```
kubectl create -f deploy/kube-dashboard.yaml 
```

### 开启kubectl proxy

```
kubectl proxy
```

### 创建admin账户
```
 kubectl apply -f deploy/create-admin.yaml
```

### 获取admin账户token
```
kubectl -n ops describe secret $(kubectl -n kubernetes-dashboard get secret | grep kubernetes-dashboard-admin | awk '{print $1}')
```

### 打开kube-dashboard 页面
http://localhost:8001/api/v1/namespaces/ops/services/https:kubernetes-dashboard:/proxy/