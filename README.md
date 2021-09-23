# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. To Installing Ansible, no special server or workstation is required. The only requirement is Python and SSH installed on the control node. Ansible is agent-less, which means nothing to install on a client only Python is installed and SSH is enabled. Ansible every time use SSH or paramiko, what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

## Ansible Installation

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed. The Ansible installation is simple and depends on the OS of your control node, see [Ansible document](https://docs.ansible.com/ansible/2.9/installation_guide/index.html) for installation.

### Managed node Requirement

For managed nodes, Ansible makes a connection over SSH, Python and SSH is required.

### Requirements of this lab

1. VMware or Virtual box
2. Vagrant

### Lab Set up on Windows 10

I'm using Vagrant for my lab set-up, the process is simple as below.

1. Go to the [Vagrant website](https://www.vagrantup.com/) and download vagrant and install it on your machine. For more details see [Quick Start Guide](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index?in=vagrant/getting-started).

2. [Virtual box](https://www.virtualbox.org/wiki/Downloads) for Windows 10.

3. [Vagrant file](https://github.com/sydasif/ansible-lab/blob/master/Vagrantfile).

Create a directory where you want it in your machine and copy vagrant file from the repo. In my case, I, create a directory in Document named vagrant (name can be anything). Open Powershell and navigate to the concerning directory.

### To boot the vagrant devices

```vagrant up```  will create and boot the below device's.

1. ubuntu
2. centos
3. debian

Command after booting to check the status of devices

```console
vagrant status
```

Use ```vagrant ssh ubuntu``` command to ssh into a device and check ping to other two devices.

### Ansible installation on ubuntu vagrant box

```console
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible-2.9
sudo apt install ansible -y
```

### Installing Ansible with pip

```console
sudo apt update
sudo apt install python3 python3-pip git
pip3 install ansible
```

### Confirm working by running below commands

```console
ansible --version
ansible localhost -m ping
```

### Configuring Ansible Client

I have three Linux hosts ubuntu, centos and debian. On the control node (ubuntu) edit hosts file for ip to name resolution.

```console
sudo nano /etc/hosts
```

After opening the file add below IP and host-name.

```console
192.168.200.10  centos
192.168.200.12  debian
```

Create SSH key on ansible control node (ubuntu) and accept the defaults.

```console
ssh-keygen
```

list the keys to verify with the *ls .ssh* command, and copy the key to the client's machine.

```console
ssh-copy-id -i .ssh/id_rsa.pub debian
ssh-copy-id -i .ssh/id_rsa.pub centos
```

Now ssh to debian and configure debian so that it doesn't require a password to get sudo level access.

```console
ssh debian
sudo visudo
```

Go to the bottom of the file and add this line as below:

```console
vagrant ALL=(ALL) NOPASSWD: ALL
```

Now configure centos so that it doesn't require a password to get root-level access.

```console
ssh centos
su - 
sudo visudo
```

Go to the bottom of the file and add this line as below:

```console
vagrant ALL=(ALL) NOPASSWD: ALL
```

### Inventory Set Up

Ansible inventory files define managed nodes that ad-hoc/playbooks can be run against. I'm creating inventory in the ansible default location (/etc/ansible/hosts).

```console
sudo nano /etc/ansible/hosts
```

Create groups and add hosts to the group.

```console
[deb]
debian  

[cen]
centos

[linux:children]
deb
cen
```

At this point my lab setup is complete.

### [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)

An Ansible ad hoc command is a command-line tool to automate a single task on one or more managed nodes. Ad hoc commands are quick and easy, but they are not reusable. Ad hoc commands demonstrate the simplicity and power of Ansible. Ad-hoc system interaction is a powerful and useful tool but some limitations exist.

```console
ansible -m ping all
ansible all -a 'whoami'
```

Elevate to root with -b for become. Why? Because Ansible doesn't elevate the sudo privilege by default.

```console
ansible all -b -a 'whoami'
```

Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the, ***-m (module)***, the default ***command*** module will run.

```console
ansible all -m command -a 'echo Ansible is fun'

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

### Modules

Modules are like the different tools, discrete units of code happen in ansible. Modules are invoked with tasks in playbooks or with the ansible ad hoc command -m argument.

*command* The command will not be processed through the shell. Don't support pipes and redirects. After running the below command if you check the managed node home directory to see the hello.txt file, it will not create the file.

```console
ansible all -b -m command -a 'echo "Hello" > /home/vagrant/hello.txt'

debian | CHANGED | rc=0 >>
Hello > /root/hello.txt
centos | CHANGED | rc=0 >>
Hello > /root/hello.txt
```

***shell*** It is almost exactly like the command module but runs the command through a shell (/bin/sh) on the remote node. Support pips and redirection. After running the below command the hello.txt file is created.

```console
ansible all -m shell -a 'echo "Hello" > /home/vagrant/hello.txt'

debian | CHANGED | rc=0 >>

centos | CHANGED | rc=0 >>
```

```console
vagrant@ubuntu:~$ ssh centos
Last login: Tue Sep 21 06:15:04 2021 from 192.168.200.11
[vagrant@centos ~]$ ls
hello.txt
[vagrant@centos ~]$
```

***raw*** raw module use SSH to executes commands on remote devices and doesn't require python, we use the raw module, for example, any devices such as routers that do not have any Python installed. It also Support pips and redirection.

```console
ansible all -m raw -a 'echo "Hello" >> /home/vagrant/hello.txt'
debian | CHANGED | rc=0 >>
Shared connection to debian closed.

centos | CHANGED | rc=0 >>
Shared connection to centos closed.
```

```console
vagrant@ubuntu:~$ ssh centos
Last login: Tue Sep 21 06:40:27 2021 from 192.168.200.11
[vagrant@centos ~]$ ls
hello.txt
[vagrant@centos ~]$ cat hello.txt
Hello
Hello
[vagrant@centos ~]$
```

### Playbook

A playbook defines a list of 'tasks' that will be executed against managed nodes. Each playbook contains one or more tasks which will be executed against the defined hosts group. Playbooks are written in [YAML](https://yaml.org/) which is an easy to read and write key/value data serialization language. YAML basic data types syntax as below:

```yaml
# scalars/variables
max_retry: 10
database: user

# mapping/dictionary
animals:
  name: cat
  age: 4
  
# sequence/list
employee:
  - age: 26
    name: Joe
  - age: 34
    name: Tim    
```  

### Playbook Examples

```yaml
---
- name: PLAYBOOK-1        
  hosts: linux
  tasks:
    - name: A UNAME???
      shell: uname -a > /home/vagrant/res.txt

    - name: A WHOAMI???
      shell: whoami >> /home/vagrant/res.txt
```

```JSON
ansible-playbook playbook-1.yaml

PLAY [linux] ************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [centos]
ok: [debian]

TASK [A UNAME???] *******************************************************************************************************************
changed: [debian]
changed: [centos]

TASK [A WHOAMI???] ******************************************************************************************************************
changed: [debian]
changed: [centos]

PLAY RECAP **************************************************************************************************************************
centos                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
debian                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

```yaml
---
- name: PLAYBOOK-2
  hosts: linux
  tasks:
    - name: REMOVE RES.TXT???
      file: path=/home/vagrant/res.txt state=absent
```

```JSON
ansible-playbook playbook-2.yaml

PLAY [linux] ************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [debian]
ok: [centos]

TASK [REMOVE RES.TXT???] *******************************************************************************************************************
changed: [debian]
changed: [centos]

PLAY RECAP **************************************************************************************************************************
centos                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
debian                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

```yaml
---
- hosts: linux
  vars:
    - my_var: some thing
  tasks:
    - name: print on terminal
      command: echo "I want to print {{ my_var }} on screen"
      register: result

    - name: show result
      debug: msg={{ result.stdout_lines }}
```

```JSON
ansible-playbook playbook-3.yml

PLAY [linux] ************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [ubuntu]
ok: [centos]

TASK [print on terminal] ************************************************************************************************************
changed: [ubuntu]
changed: [centos]

TASK [show result] ******************************************************************************************************************
ok: [ubuntu] => {
    "msg": [
        "I want to print some thing on screen"
    ]
}
ok: [centos] => {
    "msg": [
        "I want to print some thing on screen"
    ]
}

PLAY RECAP **************************************************************************************************************************
centos                     : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
