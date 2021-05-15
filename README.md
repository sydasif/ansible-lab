# Ansible Client and Server Lab

Ansible is an open source, powerful and simple tool for client-server and networking device automation. Install ansible on PC, laptop or workstation, no special server or workstation is required. The only requirment is SSH and Python to install on control node. Also nothing to install on client, only Python and SSH. Ansible every time use SSH what it does on manage nodes. SSH use usernsme and password (root or sudo level) to change configuration of remote device. For manage node, incase of networking device python is not required in all case.

### Requirments of lab

1. Ubuntu installed on Vmware
2. Centos 7 installed on Vmware
3. GNS3 and NetworkAutomation Docker
4. Nat Cloud (not neccessary)

### Ansible Client Configuration

1. Static IP addressing (best practice)
2. Sudo level access
3. Open ssh-server install on client
