# Plan for tomorrow

1. how to manage users
2. how to manage SSH keys (and is it possible to keep in sync with github??) [DONE]
3. how to install neovim & tmux (and setup configurations)
4. what is this os, understand UBUNTU's way of doing things
5. Install golang
6. tailscale setup (temporary)
7. how to safely expose to internet
8. configure ufw (allow all ssh connections tho) - if you've configured samba, those things will get blocked too


# In couple of days
0. read the best practices (managing volume network and blah blah)
1. install canonical k8s
2. bring in the watgbridge bot here
3. Only 100G is used. plan for the remaining storage...
4. flash bios 

# Telegram helper
Controling system with the help of telegram bot?? (umm)

0. notify when the system is up or shutdown
1. run a local telegram bot server? 

## Doubts
1. what are those numbers in conf.d files?? should it always start with numbers?

## Basics
- SSH keys setup with github [docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases) 
- look more at netplan and it's capabilities
- network bonding

## automation?? (server chores): 

sudo apt install unattended-upgades
sudo apt install update-notifier-common

then check /etc/apt/apt.conf.d ?? and uncomment auto reboot and specify reboot time??

## Advanced Fancy Stuffs
- [2FA](https://ubuntu.com/server/docs/openssh-server) login on root accounts only

####################
# Add user
a user with no admin permissions
sudo add user <newusername>
sudo del user <newusername>
sudo passwd root

- to make the password expire
sudo passwd -l root

- to add permissions add them to the wheel
sudo usermod -a -G sudo <newusername>
TODO: learn more things

su - newusername
sudo su -
(risky)

# Change hostname
- if you change your hostname, also update your hosts file


# Generic add a disk
- Find whether LVM affects this procedure
... if LVM simply extends based on usage, then simple mounting will not work...
- wipefs (and path) - nahhh
- gdisk (to create a volume from a old drive)
- mkfs to format
/dev/sda1
        ^ partition number!!

Create a new dir in /mnt
(make the folder we created inside /mnt immutable)
sudo chattr +i newdrive

- get the UUID of the drive partition, then add it to fstab file
- check if there are any fdisk errors by trying to mount all partitions in fdisk. 
1. (mounts all partitions in fstab) `sudo mount -a`
2. df -h newdrive

this newly mounted drive is owned by root, so change owner
sudo chown -R username /mnt/newdrive/
(look at Octal Notation) look! look at the forward slash at the end
sudo chmod -R 750 /mnt/newdrive/

## Simple disk related cmds
- pvdisplay
- vgdisplay
- lvdisplay
- lvextend -L+100G /dev/ubuntu-vg/ubuntu-lv
- hdparam
- tune2fs -l /dev/sda5
- hdparm -I /dev/sda

## simple mount
- `sudo mount -o ro src dest`

## raid
- use mdadm to create.


# Generic File Sharing!!! - but interesting!
- use nfs tho
- install samba, add a new user, set password
- add [share] section in /etc/samba/samba.conf. Also mention valid username?
-     ^^^^^^ it can be anything!! our-ip/path -> asks for prompt -> access the files


# how to auth for github
- change remote url
`git remote set-url origin git@github.com:username/repository.git`
