# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for
client-server and network device automation. Install Ansible on PC, laptop, or
workstation, no special server or workstation is required. The only requirement
is SSH and Python to install on the control node. Also, nothing to install on a
client, only Python, and SSH. Ansible every time use SSH what it does on manage
nodes. SSH uses a username and password (root or sudo level) to change the configuration
of a remote device. For manage nodes, in the case of networking devices python
is not required in all cases.

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed.

### Managed node Requirement

For managed nodes, Ansible makes a connection over SSH and Python.

### Requirements of lab

1. Ubuntu installed in Vmware
2. Centos 7 installed in Vmware
3. Centos 7 minimal in Vmware

### Ansible Client Configuration

1. Static IP addressing (best practice)
2. Sudo level access
3. Open ssh-server install on client

### Ad-hoc Commands

Ad-hoc system interaction is powerful and useful too but
some limitations exist. Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the, -m (module), the default command
module will run.
