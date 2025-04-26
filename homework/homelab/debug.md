# Network

ping google.com
ping github.com 

ping 8.8.8.8

If none of these works, then check:

ip a

Check for default route
ip route

if it doesn't exist, gateway is not set!
so add a default route to `/etc/netplan/50-cloud-init.yaml` file

dig @1.1.1.1 github.com

# storage 
do manual fschk

# network debuggin
- sudo apt install net-tools
- sudo netstat -tulpn

# System information
hostnamectl
lshw

