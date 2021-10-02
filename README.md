# Ansible Client and Server Lab

Ansible is an open-source, powerful, and simple tool for client-server and network device automation. To Installing Ansible, no special server or workstation is required. The only requirement is Python and SSH installed on the control node. Ansible is agent-less, which means nothing to install on a client only Python is installed and SSH is enabled on remote host. Ansible every time use SSH or in some cases API and paramiko, what it does on manage nodes. For manage nodes, in the case of networking devices python is not required in all cases.

## Ansible Installation

### Control node requirement

For the control node, you can use any machine with Python 2.7 or Python 3.5 (or higher) installed. The Ansible installation is simple and depends on the OS of your control node, see [Ansible document](https://docs.ansible.com/ansible/2.9/installation_guide/index.html) for installation.

### Managed node requirement

For managed nodes, Ansible makes a connection over SSH, Python and SSH client is required.

### Requirements of this lab

1. VMware or Virtual box
2. Vagrant

### Lab set-up

I'm using Vagrant for my lab set-up, the process is simple as below:

1. Go to the [Vagrant website](https://www.vagrantup.com/) and download vagrant and install it on your machine. For more details see [Quick Start Guide](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index?in=vagrant/getting-started).

2. [Virtual box](https://www.virtualbox.org/wiki/Downloads).

3. [Vagrant file](https://github.com/sydasif/ansible-lab/blob/master/Vagrantfile).

Create a directory in your machine and copy the vagrant file from the repo. In my case, I, create a directory in Document, named vagrant (name can be anything). Open Powershell/Bash and navigate to the concerning directory and boot the Vagrant.

### To boot the vagrant devices

```vagrant up``` will create and boot the below device's.

1. ubuntu
2. centos

Command after booting to check the status of devices:

```console
vagrant status
```

Use ```vagrant ssh ubuntu-64``` command to ssh into a device and check ping to the other device. If any error with Vagrant ssh connection see this [Permission denied](https://stackoverflow.com/questions/36300446/ssh-permission-denied-publickey-gssapi-with-mic).

### Configuring Ansible Client

I have two Vagrant hosts ubuntu-64, centos-7 and Ansible control node(my own pc). On the control node (Ubuntu), edit the host's file for IP to name resolution.

```console
sudo nano /etc/hosts
```

After opening the file add below IP and host-name.

```console
192.168.200.10  centos-7
192.168.200.11  ubuntu-64
```

Create SSH key on Ansible control node (Ubuntu) with below and accept the defaults.

```console
ssh-keygen
```

list the keys to verify with the *ls .ssh* command, and copy the key to the client's machine.

```console
ssh-copy-id -i .ssh/id_rsa.pub ubuntu-64
ssh-copy-id -i .ssh/id_rsa.pub centos-7
```

Now ssh to Ubuntu-64, and configure the manage host, so that it doesn't require a password to get *sudo* level access.

```console
ssh ubuntu
sudo visudo
```

Go to the bottom of the file and add this line as below:

```console
vagrant ALL=(ALL) NOPASSWD: ALL
```

Also, configure centos so that it doesn't require a password to get root-level access.

```console
ssh centos-7
su - 
sudo visudo
```

Go to the bottom of the file and add this line as below:

```console
vagrant ALL=(ALL) NOPASSWD: ALL
```

### Ansible installation on Ubuntu

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

To test Ansible Installation, run the below commands:

```console
ansible --version
ansible localhost -m ping
```
### Inventory Set-Up

Ansible inventory files define managed nodes that ad-hoc command/playbooks can be run against. I'm creating inventory in the ansible default location (/etc/ansible/hosts).

```console
sudo nano /etc/ansible/hosts
```

Create groups and add hosts to the group.

```console
[ubuntu]
ubuntu-64  

[centos]
centos-7

[linux:children]
ubuntu
centos
```

The lab setup is now completed.

### [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)

An Ansible ad hoc command is a command-line tool to automate a single task on one or more managed nodes. Ad hoc commands are quick and easy, but they are not reusable. Ad hoc commands demonstrate the simplicity and power of Ansible. Ad-hoc system interaction is a powerful and useful tool but some limitations exist.

```console
ansible -m ping all
ansible all -a 'whoami'
```

Elevate to root with -b for become. Why? Because Ansible doesn't elevate the *sudo* privilege by default.

```console
ansible all -b -a 'whoami'
```

Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the ***-m (module)***, the default ***command*** module will run.

```console
ansible all -m command -a 'echo Ansible is fun'
```

```JSON
ubuntu-64 | CHANGED | rc=0 >>
Ansible is fun
centos-7 | CHANGED | rc=0 >>
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

#### Command 

The command will not be processed through the shell. Don't support pipes and redirects. After running the below command if you check the managed node home directory to see the hello.txt file, it will not create the file.

```console
ansible all -b -m command -a 'echo "Hello" > /home/vagrant/hello.txt'
```

```JSON
ubuntu-64 | CHANGED | rc=0 >>
Hello > /root/hello.txt
centos | CHANGED | rc=0 >>
Hello > /root/hello.txt
```

#### shell

It is almost exactly like the command module but runs the command through a shell (/bin/sh) on the remote node. Support pips and redirection. After running the below command the hello.txt file is created.

```console
ansible all -m shell -a 'echo "Hello" > /home/vagrant/hello.txt'

```JSON
ubuntu-64 | CHANGED | rc=0 >>

centos-7 | CHANGED | rc=0 >>
```

```console
syd@ubuntu:~$ ssh centos-7
Last login: Tue Sep 21 06:15:04 2021 from 192.168.200.11
[vagrant@centos-7 ~]$ ls
hello.txt
[vagrant@centos-7 ~]$
```

#### raw

The raw module uses SSH to executes commands on remote devices and doesn't require python, we use the raw module, for example, any devices such as routers that do not have any Python installed. It also supports pips and redirection.

```console
ansible all -m raw -a 'echo "Hello" >> /home/vagrant/hello.txt'
```

```JSON
ubuntu-64 | CHANGED | rc=0 >>
Shared connection to debian closed.

centos-7 | CHANGED | rc=0 >>
Shared connection to centos closed.
```

```console
syd@ubuntu:~$ ssh centos-7
Last login: Tue Sep 21 06:40:27 2021 from 192.168.200.11
[vagrant@centos-7 ~]$ ls
hello.txt
[vagrant@centos-7 ~]$ cat hello.txt
Hello
Hello
[vagrant@centos-7 ~]$
```

Summarizes the difference between the three modules

| Action | command | shell | raw |
| ---	 | ---     | ---   | --- |  
Run simple commands | yes | yes | yes
Run commands with pip/redirection | no | yes | yes
Run commands without Python | no | no | yes

### Ansible Modules Documentation

If you want to how to use a specific module, then you can check with the ***ansible-doc*** command followed by a module name.

```console
syd@ubuntu:~$ ansible-doc ping

> PING    (/path/to/module/lib/python3.8/site-packages/ansible/modules/system/ping.py)

        A trivial test module, this module always returns `pong' on successful contact. It does
        not make sense in playbooks, but it is useful from `/usr/bin/ansible' to verify the
        ability to login and that a usable Python is configured. This is NOT ICMP ping, this is
        just a trivial test module that requires Python on the remote-node. For Windows targets,
        use the [win_ping] module instead. For Network targets, use the [net_ping] module
        instead.

  * This module is maintained by The Ansible Core Team
OPTIONS (= is mandatory):

- data
        Data to return for the `ping' return value.
        If this parameter is set to `crash', the module will cause an exception.
        [Default: pong]
        type: str


SEE ALSO:
      * Module net_ping
           The official documentation on the net_ping module.
           https://docs.ansible.com/ansible/2.9/modules/net_ping_module.html
      * Module win_ping
           The official documentation on the win_ping module.
           https://docs.ansible.com/ansible/2.9/modules/win_ping_module.html


AUTHOR: Ansible Core Team, Michael DeHaan
        METADATA:
          status:
          - stableinterface
          supported_by: core


EXAMPLES:

# Test we can logon to 'webservers' and execute python with json lib.
# ansible webservers -m ping

# Example from an Ansible Playbook
- ping:

# Induce an exception to see what happens
- ping:
    data: crash


RETURN VALUES:

ping:
    description: value provided with the data parameter
    returned: success
    type: str
    sample: pong

(END)
```

### Playbook

A playbook defines a list of 'tasks' that will be executed against managed nodes. Each playbook contains one or more tasks that will be executed against the defined host's group. Playbooks are written in [YAML](https://yaml.org/) which is easy to read and write key/value data serialization language. YAML basic data types syntax as below:

```YAML
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

```YAML
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

```YAML
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

Using variables in the playbook as below:

```YAML
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

### Running Multiple Plays

A playbook can have multiple plays and each play can in turn contains multiple tasks.

```yml
---
- name: Play-book to install packages 
  hosts: ubuntu
  become: true
  tasks: 
    - name: Install git on ubuntu
      apt:
        name: git
        state: present


- name: Play-2....
  hosts: centos
  become: true
  tasks:
    - name: Install git on centos
      yum:
        name: git
        state: present
```

```JSON
ansible-playbook playbook-4.yml

PLAY [Play-1....] *****************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [ubuntu-64]

TASK [Install git on ubuntu] ******************************************************************************************
ok: [ubuntu-64]

PLAY [Play-2....] *****************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [centos-7]

TASK [Install git on centos] ******************************************************************************************
ok: [centos-7]

PLAY RECAP ************************************************************************************************************
centos-7                   : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu-64                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### The When Statement

Sometimes you will want to skip a particular step on a particular host. This is an easy task to do in Ansible with the *when* statement. To check ansible built-in variables use the *gather_facts* module. The ad-hoc command is below.

```console
ansible all -m gather_facts --limit centos | grep ansible_distribution
```

```JSON
        "ansible_distribution": "CentOS",
        "ansible_distribution_file_parsed": true,
        "ansible_distribution_file_path": "/etc/redhat-release",
        "ansible_distribution_file_variety": "RedHat",
        "ansible_distribution_major_version": "7",
        "ansible_distribution_release": "Core",
        "ansible_distribution_version": "7.8",
```

```yml
---
- name: Play-book with when a statement
  hosts: linux
  become: true
  tasks:

    - name: Install git on ubuntu
      apt:
        name: git
        state: latest
      when: ansible_distribution == "Ubuntu"

    - name: Install git on centos
      yum:
        name: git
        state: latest
      when: ansible_distribution == "CentOS"
```

```JSON
PLAY [Play-book with when statement] *******************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [centos-7]
ok: [ubuntu-64]

TASK [Install git on ubuntu] ***************************************************************************************************
skipping: [centos-7]
ok: [ubuntu-64]

TASK [Install git on centos] ***************************************************************************************************
skipping: [ubuntu-64]
ok: [centos-7]

PLAY RECAP *********************************************************************************************************************
centos-7                   : ok=2    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
ubuntu-64                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
```
