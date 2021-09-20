# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. Install Ansible on PC or laptop, no special server or workstation is required. The only requirement is Python and SSH to install on the control node. Ansible is agentless, means nothing to install on a client only Python, and SSH are enable. Ansible every time use SSH what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed.

### Managed node Requirement

For managed nodes, Ansible makes a connection over SSH and Python are required.

### Requirements of lab

1. Vmware or Virtual box
2. Vagrant

### Ansible Client Configuration

1. static IP addressing (best practice)
2. sudo level access
3. open ssh-server install on client
4. 
