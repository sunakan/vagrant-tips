export DOCKER_RUBY_TAG=2.7-slim
export DOCKER_RUBY_HOST=ruby-app
export DOCKER_REPOSITORY_NAME=ruby-app
export DOCKER_NETWORK_NAME=ruby-network
export MYSQL_HOST=`cat /etc/hosts | grep 'db1' | awk '{ print $$1 }'`
export MYSQL_DB=hoge-db
export MYSQL_USER=hoge-user
export MYSQL_PASSWORD=hoge-pass

define ruby-app
	docker run \
		--detach \
		--rm \
		--interactive \
		--tty \
		--hostname ${DOCKER_RUBY_HOST} \
		--name ${DOCKER_RUBY_HOST} \
		--network ${DOCKER_NETWORK_NAME} \
		--publish 4567:4567 \
		--mount type=bind,source=${PWD}/app/,target=/var/local/app/ \
		--workdir /var/local/app/ \
		--env MYSQL_HOST=${MYSQL_HOST} \
		--env MYSQL_DB=${MYSQL_DB} \
		--env MYSQL_USER=${MYSQL_USER} \
		--env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
		${DOCKER_REPOSITORY_NAME}:dev-latest
endef

build:
	docker build . \
		--build-arg DOCKER_RUBY_TAG=${DOCKER_RUBY_TAG} \
		--tag ${DOCKER_REPOSITORY_NAME}:dev-latest

network:
	( docker network ls | grep ${DOCKER_NETWORK_NAME} ) \
		|| docker network create ${DOCKER_NETWORK_NAME}

up: network
	$(call ruby-app)

bash: network
	$(call ruby-app) bash

clean:
	docker container ls --quiet --filter='name=${DOCKER_RUBY_HOST}' | xargs -I {} docker container stop {}
	docker network rm ${DOCKER_NETWORK_NAME} || echo ok
