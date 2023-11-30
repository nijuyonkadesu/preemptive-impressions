```sh
# to create a basic helm chart template
helm create blog
helm install blog-realease-1 /blog --set service.name=LoadBalancer ...

# there's also helm command for rollback, upgrade
```
[101](http://justinbois.github.io/bootcamp/2020_fsri/lessons/l00_configuring_your_computer.html)
1. create templates
2. populate values using [godoc template](https://pkg.go.dev/text/template)
3. use macros from `.tpl` file
4. create chart and link all values to all kuber resource yaml
5. edit notes
6. install chart
# Chart
![[Pasted image 20231130165530.png]]


