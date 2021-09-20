# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. To Installing Ansible on PC or laptop, no special server or workstation is required. The only requirement is Python and SSH on the control node. Ansible is agent-less, means nothing to install on a client only Python installed and SSH is enable. Ansible every time use SSH, what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

## Ansible Installation

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed. The Ansible installation is simple and depend on your OS of your control node, see [Ansible document](https://docs.ansible.com/ansible/2.9/installation_guide/index.html) for installation.

### Managed node Requirement

For managed nodes, Ansible makes a connection over SSH, Python and SSH are required.

### Requirements of lab

1. VMware or Virtual box
2. Vagrant

### Ansible Client Configuration

1. static IP addressing (best practice)
2. sudo level access
3. open ssh-server install on client

### Lab Set up in Windows 10

I'm using Vagrant for my lab set-up, the process is shown below.

1. Go to the [Vagrant](https://www.vagrantup.com/) website and download vagrant and install on your machine. For more details see [Quick Start Guide](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index?in=vagrant/getting-started)

2. [Virtual box](https://www.virtualbox.org/wiki/Downloads) for Windows 10

3. [Vagrant file](https://github.com/sydasif/ansible-lab/blob/master/Vagrantfile)

Create a directory where you want in your machine and copy my vagrant file from the repo. In my case I, create a directory in Document named vagrant (name can anything). Open powershell and navigate to the concern directory.

### To boot the vagrant devices

```vagrant up```  will create and boot the below device's.

1. ubuntu
2. centos
3. debian

command after booting to check the status of devices

```con 
vagrant status
```

Use ```vagrant ssh ubuntu``` command to ssh into a device and check ping to other two devices.

### Ansible installation on ubuntu vagrant box

```sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible-2.9
sudo apt install ansible -y
```

### Installing Ansible with pip

```sudo apt-get update
sudo apt-get install python3 python3-pip git
pip3 install ansible
```

### confirm working by running below commands

```ansible --version
ansible localhost -m ping
```

### Configuring Ansible Client

We Have three linux hosts ubuntu, centos and debian, on control node (ubuntu) edit hosts file for IP to name resolution.

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

list the keys to verify with *ls .ssh* command, and copy the key to the clients machine.

```con
ssh-copy-id -i .ssh/id_rsa.pub debian
ssh-copy-id -i .ssh/id_rsa.pub centos
```

Now ssh to debian and configure debian so that it doesn't require a password to get sudo level access.

```con
ssh debian
sudo visudo
```

Go to bottom of file and add this line as below:

```con
vagrant ALL=(ALL) NOPASSWD: ALL
```

Now configure centos so that it doesn't require a password to get root level access.

```con
ssh centos
su - 
sudo visudo
```

Go to bottom of file and add this line as below:

```con
vagrant ALL=(ALL) NOPASSWD: ALL
```

### Inventory Set Up

I'm creating inventory in the ansible default location

```con
sudo nano /etc/ansible/hosts
```

Create groups and add host to the group.

```con
[deb]
debian  

[cent]
centos
```

At this point my lab setup is complete.

### Adhoc command to check connection

```con
ansible -m ping all
ansible -m raw -a '/usr/bin/uptime' all
ansible all -a 'whoami'
```

Elevate to root with -b for become. Why? Because ansible doesn't elevate the sudo privilege by default.

```con
ansible all -b -a 'whoami'
```

Ad-hoc system interaction is powerful and useful tool but with some limitations exist. Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the, -m (module), the default command module will run.

### Explanation of Ad-hoc command

```con
ansible all -i "localhost," -m shell -a 'echo Ansible is fun'

localhost | SUCCESS | rc=0 >>
Ansible is fun
```

It’s a basic command, but a little to explain, the command does the following:

• First, we specify all, so the command will be run across all the inventory we list.

• We then make a list of inventory with the -i option, but we only have our localhost listed,
so this will be the only host the ansible command is run over.

• The -m option is then provided to allow us to specify a module we can use.

• Finally, we specify the -a option allows us to provide arguments to the shell module,
we are simply running an echo command to print the output “Ansible is fun”
