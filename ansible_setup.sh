#1. Have a "username" and "sudo" level access
#2. Setup passwordless keys
#3. Enable SSH on remote hosts:- 
sudo apt install openssh-server

#INSTALL AND CONFIG
#Remove sudo when use in NetworkAutomation docker in GNS3

sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y

#confirm working by running below commands: 
ansible --version
ansible localhost -m ping

######## PASSWORD LESS KEYS ###########
#Create SSH key on ansible server
ssh-keygen
#accept the defaults
#list the keys to verify
ls .ssh

#copy the key to other machines
ssh-copy-id -i .ssh/id_rsa.pub ubuntu@192.168.100.10
ssh-copy-id -i .ssh/id_rsa.pub centos@192.168.100.20
#accept fingerprint
#note if refused, run:
sudo apt install openssh-server # replace apt with yum in centos7

#Now configure ubuntu so that it doesnt require a password
ssh ubuntu@192.168.100.10
sudo visudo
#go to bottom of file add this line:
ubuntu ALL=(ALL) NOPASSWD: ALL
#then save and exit
#exit to close the connection

#Now configure centos so that it doesnt require a password
ssh centos@192.168.100.20
#to get root level access
su -
sudo visudo
#go to bottom of file add this line:
centos ALL=(ALL) NOPASSWD: ALL
#then save and exit
#exit to logout from root
#exit to close the connection

#Create ansible.cfg file docker 
sudo nano ansible.cfg
#Copy and paste
[defaults]
inventory =./hosts
host_key_checking =False
deprecation_warnings=False
timeout=30

###### INVENTORY #######
sudo nano hosts
#create groups:-
[ubuntu20]
ubuntu ansible_host=192.168.100.10 ansible_user=ubuntu 

[centos7]
centos ansible_host=192.168.100.20 ansible_user=centos

## Adhoc command to checking connection
ansible -m ping all
ansible -m raw -a '/usr/bin/uptime' all
ansible -m shell -a 'python3 -V' ubuntu20
ansible -m shell -a 'python -V' centos7
ansible all -a 'whoami'

#elevate to root with -b for become. Why? Because ansible doesnt elevate to sudo by default
ansible all -b -a 'whoami'