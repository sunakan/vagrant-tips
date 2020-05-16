export ANSIBLE_IP=192.168.3.123
export WEB1_IP=192.168.3.11
export WEB2_IP=192.168.3.12
export DB1_IP=192.168.3.21

################################################################################
# それぞれにもしかしたら結構時間がかかるかもしれないので、1行ずつ打ったほうが良いかも
################################################################################
all:
	vagrant up
	make provision-each-vm
	make setup-full

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
	ssh $(call ssh-option,ansible,${ANSIBLE_IP}) \
		'cd ansible && make provision'

################################################################################
# Host側で全部できるようにするためにsshでコマンドを送る
################################################################################
setup-db1: chmod
	ssh $(call ssh-option,db1,${DB1_IP}) \
		"cd db && make setup-full"

clean-db1: chmod
	ssh $(call ssh-option,db1,${DB1_IP}) \
		"cd db && make clean"

setup-web1: chmod
	ssh $(call ssh-option,web1,${WEB1_IP}) \
		"cd web && make setup-full"

clean-web1: chmod
	ssh $(call ssh-option,web1,${WEB1_IP}) \
		"cd web && make clean"

setup-full: chmod
	make setup-db1
	make setup-web1

clean-full: chmod
	make clean-web1
	make clean-db1
