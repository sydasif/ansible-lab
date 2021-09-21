# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. To Installing Ansible, no special server or workstation is required. The only requirement is Python and SSH installed on the control node. Ansible is agent-less, which means nothing to install on a client only Python is installed and SSH is enabled. Ansible every time use SSH, what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

## Ansible Installation

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed. The Ansible installation is simple and depends on the OS of your control node, see [Ansible document](https://docs.ansible.com/ansible/2.9/installation_guide/index.html) for installation.

### Managed node Requirement

For managed nodes, Ansible makes a connection over SSH, Python and SSH is required.

### Requirements of lab

1. VMware or Virtual box
2. Vagrant

### Lab Set up in Windows 10

I'm using Vagrant for my lab set-up, the process is shown below.

1. Go to the [Vagrant](https://www.vagrantup.com/) website and download vagrant and install it on your machine. For more details see [Quick Start Guide](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index?in=vagrant/getting-started) on website.

2. [Virtual box](https://www.virtualbox.org/wiki/Downloads) for Windows 10.

3. [Vagrant file](https://github.com/sydasif/ansible-lab/blob/master/Vagrantfile) from github repo.

Create a directory where you want it in your machine and copy vagrant file from the repo. In my case, I, create a directory in Document named vagrant (name can be anything). Open Powershell and navigate to the concerning directory.

### To boot the vagrant devices

```vagrant up```  will create and boot the below device's.

1. ubuntu
2. centos
3. debian

Command after booting to check the status of devices

```con 
vagrant status
```

Use ```vagrant ssh ubuntu``` command to ssh into a device and check ping to other two devices.

### Ansible installation on ubuntu vagrant box

```con
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible-2.9
sudo apt install ansible -y
```

### Installing Ansible with pip

```con
sudo apt update
sudo apt install python3 python3-pip git
pip3 install ansible
```

### Confirm working by running below commands

```con 
ansible --version
ansible localhost -m ping
```

### Configuring Ansible Client

I have three Linux hosts ubuntu, centos and debian. On the control node (ubuntu) edit hosts file for ip to name resolution.

```con
sudo nano /etc/hosts
```

After opening the file add below IP and host-name.

```con
192.168.200.10  centos
192.168.200.12  debian
```

Create SSH key on ansible control node (ubuntu) and accept the defaults.

```con
ssh-keygen
```

list the keys to verify with the *ls .ssh* command, and copy the key to the client's machine.

```con
ssh-copy-id -i .ssh/id_rsa.pub debian
ssh-copy-id -i .ssh/id_rsa.pub centos
```

Now ssh to debian and configure debian so that it doesn't require a password to get sudo level access.

```con
ssh debian
sudo visudo
```

Go to the bottom of the file and add this line as below:

```con
vagrant ALL=(ALL) NOPASSWD: ALL
```

Now configure centos so that it doesn't require a password to get root-level access.

```con
ssh centos
su - 
sudo visudo
```

Go to the bottom of the file and add this line as below:

```con
vagrant ALL=(ALL) NOPASSWD: ALL
```

### Inventory Set Up

I'm creating inventory in the ansible default location.

```con
sudo nano /etc/ansible/hosts
```

Create groups and add hosts to the group.

```con
[deb]
debian  

[cent]
centos
```

At this point my lab setup is complete.

### [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)

An Ansible ad hoc command is a command-line tool to automate a single task on one or more managed nodes. Ad hoc commands are quick and easy, but they are not reusable. Ad hoc commands demonstrate the simplicity and power of Ansible. Ad-hoc system interaction is a powerful and useful tool but some limitations exist.

**Ad-hoc command to check Ansible is working**

```con
ansible -m ping all
ansible all -a 'whoami'
```

Elevate to root with -b for become. Why? Because Ansible doesn't elevate the sudo privilege by default.

```con
ansible all -b -a 'whoami'
```

Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the, ***-m (module)***, the default ***command*** module will run.

```com 
ansible all -m command -a 'echo Ansible is fun'

[WARNING]: Platform linux on host debian is using the discovered Python interpreter at /usr/bin/python, but future installation of
another Python interpreter could change this. See
https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information.
debian | CHANGED | rc=0 >>
Ansible is fun
centos | CHANGED | rc=0 >>
Ansible is fun
```

It’s a basic command, but a little to explain, the command does the following:

• First, we specify all, so the command will be run across all the inventory we list.

• The -m option is then provided to allow us to specify a module we can use.

• Finally, we specify the -a option allows us to provide arguments to the shell module, 
we are simply running an echo command to print the output “Ansible is fun”

If I, remove the ***-m command*** from the above ad-hoc command it will also work, because ansible uses the ***command*** module by default.
