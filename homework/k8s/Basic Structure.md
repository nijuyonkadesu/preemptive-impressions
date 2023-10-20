Deployment > Pod > container
### Cluster
cli serves the control plane: 
`{ [Control plane -> xNodes], ... } <- a cluster`

CLI modes
1. imperative Interaction
2. declarative Interaction `[Manifests / yaml]`
### Controller & Node Structure
`{ [worker-node [runtime [pod [container]]]], ... } <- 👀 by controller(loop)` - tries to keep the node state closer to the desired state 
### 1. Control Plane
contains `[API Server, etcd, controller manager, scheduler]`
etcd: all info about the server `[k-v pairs]`

Managing overall health of *a cluster*. 
- pod `[new / scale / expose / destroy / manage]`
### 2. Worker Node
contains `[kube-proxy, kubelet, container runtime]`
[[#Controller & Node Structure]]
- kubectl - follows the order from scheduler. whines back to control plane if it can't do the job it was given with. 

> [!todo]- Pending concepts to look at
> - [ ] Istio
> - [ ] Kiali UI
> - [ ] Tracing with Jaeger
> For complete k8s understanding read ~
> - [ ] Core DNS
> - [ ] Daemon Set
> - [ ] Namespaces
> - [ ] Selectors
> - [ ] Services
> - [ ] Objects in general
> - [ ] Networking [VPC - Network Interface, Rules]
> - [ ] Roles [Role Binding, Authentication -> Authorization (role scoping)]
## Tipss

- Try [monokle](https://monokle.io/)
- Use [k8s Lens IDE](https://k8slens.dev/)
- Refresh CIDR / IP masking
