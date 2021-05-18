#INSTALL AND CONFIG
#Remove sudo when use in NetworkAutomation docker in GNS3
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y

#Installing Ansible with pip
sudo apt-get update
sudo apt-get install python3 python3-pip git
pip3 install ansible

#confirm working by running below commands: 
ansible --version
ansible localhost -m ping

######## PASSWORD LESS KEYS ###########
#Create SSH key on ansible server and accept the defaults
ssh-keygen -t rsa
sudo apt-get install openssh-server -y

#Now copy the keys to your host
ssh-copy-id localhost
#Now you are allow to connect to your localhost via SSH
ssh localhost
#accept fingerprint
exit
# it’s time to run our first Ansible command
ansible all -i "localhost," -m shell -a 'echo Ansible is fun'
#list the keys to verify and copy the key to other machines
ls .ssh
ssh-copy-id -i .ssh/id_rsa.pub ubuntu@192.168.100.10
ssh-copy-id -i .ssh/id_rsa.pub centos@192.168.100.20
#accept fingerprint
#note if refused, run:
sudo apt install openssh-server # replace apt with yum in centos7

#Now configure ubuntu so that it doesn't require a password
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
[defaults]
inventory =./hosts
host_key_checking =False # for network dvice
deprecation_warnings=False # for older version of Python
timeout=30

###### INVENTORY #######
sudo nano hosts
#create groups:-
[ubuntu20]
ubuntu ansible_host=192.168.100.10 ansible_user=ubuntu 

[centos7]
centos ansible_host=192.168.100.20 ansible_user=centos

## Adhoc command to check connection
ansible -m ping all
ansible -m raw -a '/usr/bin/uptime' all
ansible -m shell -a 'python3 -V' ubuntu20
ansible -m shell -a 'python -V' centos7
ansible all -a 'whoami'

#elevate to root with -b for become. Why? Because ansible doesnt elevate to sudo by default
ansible all -b -a 'whoami'