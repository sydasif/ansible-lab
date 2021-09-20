# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. Install Ansible on PC or laptop, no special server or workstation is required. The only requirement is Python and SSH to install on the control node. Ansible is agent-less, means nothing to install on a client only Python, and SSH are enable. Ansible every time use SSH what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

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

3. [Vagrant file]()

Create a directory where you want in your machine and copy my vagrant file from the repo. In my case I, create a directory in Document named vagrant (name can anything). Open powershell and navigate to the concern directory.

### To boot the vagrant devices

```vagrant up```  will create and boot the below devices in my case

1. ubuntu
2. centos
3. debian

```vagrant status```  after booting check the status of devices

use ```vagrant ssh ubuntu``` command to ssh into device and ping other two device.
