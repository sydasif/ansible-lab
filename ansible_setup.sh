######INSTALL AND CONFIG#######
#Ansible installation
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

#####ansible######
cd /etc/ansible

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
ansible all -a 'whoami'

#elevate to root with -b for become. Why? Because ansible doesnt elevate to sudo by default
ansible all -b -a 'whoami'
