### Ad-hoc Commands

Ad-hoc system interaction is powerful and useful tool but with some limitations exist.
Some examples of ad-hoc commands are below:

1. ansible all -a "uptime"
2. ansible all -a "whoami"
3. ansible all -b -a "whoami"

If you do not specify the, -m (module), the default command module will run.

## Explanation of Ad-hoc command

ansible all -i "localhost," -m shell -a 'echo Ansible is fun'

localhost | SUCCESS | rc=0 >>
Ansible is fun

It’s a basic command, but a little to explain:
The command does the following:

• First, we specify all, so the command will be run across all the inventory we list.

• We then make a list of inventory with the -i option, but we only have our localhost listed,
so this will be the only host the ansible command is run over.

• The -m option is then provided to allow us to specify a module we can use.

• Finally, we specify the -a option allows us to provide arguments to the shell module,
we are simply running an echo command to print the output “Ansible is fun”