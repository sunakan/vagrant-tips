export DOCKER_NETWORK_NAME=web-network

network:
	( docker network ls | grep ${DOCKER_NETWORK_NAME} ) \
		|| docker network create ${DOCKER_NETWORK_NAME}

up: network
	make up-nginx
	make up-ruby-app

up-nginx: network
	cd nginx && make up DOCKER_NETWORK_NAME=${DOCKER_NETWORK_NAME}

build-ruby-app:
	cd ruby && make build

up-ruby-app: network
	cd ruby && make up DOCKER_NETWORK_NAME=${DOCKER_NETWORK_NAME}

clean:
	cd nginx && make clean
	cd ruby  && make clean
	docker network ls --quiet --filter 'name=${DOCKER_NETWORK_NAME}' | xargs -I {} docker network rm {}

################################################################################
# 全自動セットアップ
################################################################################
setup-full:
	make build-ruby-app
	make up
