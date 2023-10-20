### Reason for Containers
- with immutable runtimes, reliability is increased 
- same type of service requiring different versions of dependencies
- multiple services running in same server (with different requirement needs)
- package managers are painful when needed to have duplicate dependencies of different version

> yup, spin up bunch of em into a server, (with OS/packages all packed into it) - *ISOLATED*

wahh, `[backend, frontend, db, nw, queues]` 
problem with this monolithic structure is... even a small change in code, entire container have to be updated... 
if you just want to scale the backend, you're **forced to scale** frontend too ~

> yup, adopt microservices
### Managing Containers
- communication
- fault handling
- kubernetes `[Orchestration - Scheduling, resource limits / instances / shared volume]`
	- Cloud Native applications `[auto scale / heal / rolling updates /..]`
### Sause
[k8](https://www.youtube.com/watch?v=KVBON1lA9N8)
[docker](https://www.youtube.com/watch?v=17Bl31rlnRM&list=PL9gnSGHSqcnoqBXdMwUTRod4Gi3eac2Ak&index=6)
