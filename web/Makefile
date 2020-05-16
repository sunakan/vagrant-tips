export DOCKER_NETWORK_NAME=web-network

network:
	( docker network ls | grep ${DOCKER_NETWORK_NAME} ) \
		|| docker network create ${DOCKER_NETWORK_NAME}

up: network
	make nginx-up
	make ruby-app-up

nginx-up: network
	cd nginx && make up DOCKER_NETWORK_NAME=${DOCKER_NETWORK_NAME}

ruby-app-up: network
	cd ruby && make up DOCKER_NETWORK_NAME=${DOCKER_NETWORK_NAME}

clean:
	cd nginx && make clean
	cd ruby  && make clean
	docker network ls --quiet --filter 'name=${DOCKER_NETWORK_NAME}' | xargs -I {} docker network rm {}
