export DOCKER_NGINX_HOST=nginx

up:
	docker run \
		--detach \
		--rm \
		--interactive \
		--tty \
		--hostname ${DOCKER_NGINX_HOST} \
		--name ${DOCKER_NGINX_HOST} \
		--network ${DOCKER_NETWORK_NAME} \
		--publish 80:80 \
		--mount type=bind,source=${PWD}/conf.d/,target=/etc/nginx/conf.d/ \
		--mount type=bind,source=${PWD}/html/,target=/usr/share/nginx/html/ \
		nginx:stable

clean:
	docker container ls --quiet --filter 'name=${DOCKER_NGINX_HOST}' | xargs -I {} docker container stop {}
