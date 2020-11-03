## 本地helm安装prometheus

在ops namespace下 安装release name为ops-prometheus 的prometheus
```
$ helm install ops-prometheus prometheus-community/kube-prometheus-stack -n ops
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
manifest_sorter.go:192: info: skipping unknown hook: "crd-install"
NAME: ops-prometheus
LAST DEPLOYED: Mon Nov  2 09:45:11 2020
NAMESPACE: ops
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace ops get pods -l "release=ops-prometheus"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
```

## 访问prometheus
see [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)

```
kubectl --namespace ops port-forward svc/prometheus-k8s 9090
```