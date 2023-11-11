Deployment > Pod > container
### Cluster
cli serves the control plane: 
`{ [Control plane -> xNodes], ... } <- a cluster`

### Kubectl
uses Kubernetes API to interact with the cluster. Basic structure:`kubectl <action> resource`
action: [get, create, describe, delete, config, logs, exec, expose, scale, rollout {status, undo}]
resource: [deployments, node, pods, events, services]

CLI modes
1. imperative Interaction
2. declarative Interaction `[Manifests / yaml]`
### Controller & Node Structure
`{ [worker-node [runtime [pod [container]]]], ... } <- 👀 by controller(loop)` - tries to keep the node state closer to the desired state 
### 1. Control Plane
contains `[API Server, etcd, controller manager, scheduler]`
etcd: all info about the server `[k-v pairs]`

Managing overall health of *a cluster*. 
### 2. Worker Node
contains `[kube-proxy, kubelet, container runtime]`
[[#Controller & Node Structure]]
- kubectl - follows the order from scheduler. whines back to control plane if it can't do the job it was given with. 
- kubelet - a process that communicates b/w [[#1. Control Plane|control plane]] and [[#2. Worker Node|worker node]] - manages [[#3. Pods|pods]]
![[module_03_nodes.svg]]
### 3. Pods
pods can be`[new / scale / expose / destroy / manage]`
Pods = Resources + [[Docker]] containers
Resources: [Shared volumes, networking, commands to start a container, port informations]
![[module_03_pods.svg]]
#### Lifecycle
pod phases        :`pending -> running -> succeed / failure`
container states : `waiting -> running / terminated` k8s support [hooking](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks) these states to fire events
pod [readiness](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-readiness-gate) - state more pod *conditions* to declare the pod is ready. 
## Tipss

- Try [monokle](https://monokle.io/)
- Use [k8s Lens IDE](https://k8slens.dev/)
- Refresh CIDR / IP masking
- [kubeshop](https://kubeshop.io/) - debug / maintain huge yaml configs
- [datree](https://www.datree.io/) - find misconfiguration in security rules

---

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