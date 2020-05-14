export ANSIBLE_IP=192.168.3.123
export WEB1_IP=192.168.3.11
export WEB2_IP=192.168.3.12
export DB1_IP=192.168.3.21

plugin:
	vagrant plugin install vagrant-hosts

up: plugin
	vagrant up

chmod:
	chmod 600 .vagrant/machines/*/virtualbox/private_key

# SSHのオプションとSSH先
# $1：VMマシン名
# $2：VM側のIP
define ssh-option
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	-i .vagrant/machines/$1/virtualbox/private_key \
	vagrant@$2
endef
ansible: chmod
	ssh $(call ssh-option,ansible,${ANSIBLE_IP})
web1: chmod
	ssh $(call ssh-option,web1,${WEB1_IP})
db1: chmod
	ssh $(call ssh-option,db1,${DB1_IP})

################################################################################
# Ansible
################################################################################
provision-each-vm:
	vagrant ssh ansible --command 'cd ./ansible/ && make provision'
