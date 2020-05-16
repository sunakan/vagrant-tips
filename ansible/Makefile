export ENVIRONMENT=vagrant

version:
	~/.local/bin/ansible-playbook --version

dry-provision:
	~/.local/bin/ansible-playbook  \
		--inventory ./inventories/${ENVIRONMENT}/hosts \
		--check \
		./main.yml

provision:
	~/.local/bin/ansible-playbook \
		--inventory ./inventories/${ENVIRONMENT}/hosts \
		./main.yml
