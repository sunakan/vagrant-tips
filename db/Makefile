################################################################################
# DB
################################################################################
export DOCKER_MYSQL_TAG=5.6
export DOCKER_MYSQL_HOST=mysql
export DOCKER_NETWORK_NAME=mysql-network
export DOCKER_VOLUME_NAME=mysql-volume
export MYSQL_DATABASE=hoge-db
export MYSQL_USER=hoge-user
export MYSQL_PASSWORD=hoge-pass

.PHONY: network volume up down clean migrate-up create-migration-files select-all

network:
	docker network ls | grep ${DOCKER_NETWORK_NAME} \
		|| docker network create ${DOCKER_NETWORK_NAME}

volume:
	docker volume ls | grep ${DOCKER_VOLUME_NAME} \
		|| docker volume create ${DOCKER_VOLUME_NAME}

up: volume network
	( docker container ls | grep ${DOCKER_MYSQL_HOST} ) \
		|| docker run \
			--detach \
			--rm \
			--interactive \
			--tty \
			--network ${DOCKER_NETWORK_NAME} \
			--hostname ${DOCKER_MYSQL_HOST} \
			--name ${DOCKER_MYSQL_HOST} \
			--publish 3306:3306 \
			--mount type=volume,source=${DOCKER_VOLUME_NAME},target=/var/lib/mysql/ \
			--env MYSQL_ROOT_PASSWORD=root \
			--env MYSQL_DATABASE=${MYSQL_DATABASE} \
			--env MYSQL_USER=${MYSQL_USER} \
			--env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
			--env LANG=C.UTF-8 \
			--env TZ=Asia/Tokyo \
			mysql:${DOCKER_MYSQL_TAG} \
				--character-set-server=utf8mb4 \
				--collation-server=utf8mb4_unicode_ci

down:
	docker container ls --quiet --filter "name=mysql" | xargs -I {} docker stop {}
	docker network   ls --quiet --filter "name=${DOCKER_NETWORK_NAME}" | xargs -I {} docker network rm {}

clean: down
	docker volume ls --quiet --filter "name=${DOCKER_VOLUME_NAME}" | xargs -I {} docker volume rm {}

################################################################################
# Migration
################################################################################
export DOCKER_MIGRATE_TAG=v4.11.0
export MYSQL_URL='mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@tcp(${DOCKER_MYSQL_HOST}:3306)/${MYSQL_DATABASE}'

define docker-migrate
	docker run \
		--rm \
		--tty \
		--network ${DOCKER_NETWORK_NAME} \
		--hostname migrate \
		--name migrate \
		--user `id --user`:`id --group` \
		--mount type=bind,source=${PWD}/sql-migrations/,target=/home/migrate/sql-migrations/ \
		--workdir /home/migrate/ \
		migrate/migrate:${DOCKER_MIGRATE_TAG}
endef

migrate-up: up
	$(call docker-migrate) \
		-database ${MYSQL_URL} \
		-path ./sql-migrations/ up

migrate-down: up
	$(call docker-migrate) \
		-database ${MYSQL_URL} \
		-path ./sql-migrations/ down -all

# 1度やったら不要
create-migration-files:
	$(call docker-migrate) \
		create \
		-ext sql \
		-dir  ./sql-migrations/ \
		-seq create_publisher_table

################################################################################
# After migration
################################################################################
define mysql-client
	docker run \
		--rm \
		--tty \
		--user `id -u`:`id -g` \
		--network ${DOCKER_NETWORK_NAME} \
		--env LANG=C.UTF-8 \
		--env TZ=Asia/Tokyo \
		mysql:${DOCKER_MYSQL_TAG}
endef

define mysql-connection
	mysql \
		--host ${DOCKER_MYSQL_HOST} \
		--user ${MYSQL_USER} \
		-p${MYSQL_PASSWORD} \
		${MYSQL_DATABASE}
endef

init-records:
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"技術評論社\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"OREILLY\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"Ohmsha\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"日経BP\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"SESHOEISHA\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"マイナビ\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"秀和システム\");' | $(call mysql-connection)"
	$(call mysql-client) bash -c "echo 'INSERT INTO publisher (name) VALUES (\"impress\");' | $(call mysql-connection)"

select-all:
	$(call mysql-client) bash -c "echo 'SELECT * FROM publisher;' | $(call mysql-connection)"

truncate:
	$(call mysql-client) bash -c "echo 'TRUNCATE TABLE publisher;' | $(call mysql-connection)"

################################################################################
# 全自動セットアップ
################################################################################
setup-full:
	make up
	sleep 10
	make migrate-up
	make init-records
