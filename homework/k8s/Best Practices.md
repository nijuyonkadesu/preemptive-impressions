## App Dev
- *Health Checks*: Containers have Readiness probes/ Liveness Probes
- Run more than one replica for your Deployment
- Avoid Pods being placed into a single node
- Set Resource Limits - CPU/Mem
- Resources have labels enabled - Technical/Business/Security
- The application logs to stdout and stderr (Passive Logging) 
- Containers do not store any state in their local filesystem
- Use the Horizontal Pod Autoscaler for apps with variable usage patterns
- Use the Cluster Autoscaler if you have highly varying workloads
- Externalise all configuration
- Mount Secrets as volumes, not enviroment variables
## Governance
- Namespaces have ResourceQuotas
- Enable Pod Security Policies
- Enable network policies
- Prevent containers from running as root
- RBAC policies are set to the least amount of privileges necessary
- Allow deploying containers only from known registries
- *Logging*:
	- There's a retention and archival strategy for logs
	- Logs are collected from Nodes, Control Plane, Auditing 
	- Prefer a daemon on each node to collect the logs instead of sidecars (Applications should log to `stdout` rather than to files.)