docker_stack_name := pgsql
service_replicas := 3

loadbalancer := false
pgbouncer := false
compose_files := -c docker-compose.yml

ifeq ($(pgbouncer),true)
	compose_files += -c docker-compose.pgbouncer.yml
endif

ifneq ("$(wildcard docker-compose.override.yml)","")
	compose_files += -c docker-compose.override.yml
endif

it: env
	@echo "make [deploy|destroy|scale]"

env:
	@test -f .env || cp .env.example .env

plan:
	docker stack config $(compose_files)

deploy:
	@env \
		DOCKER_STACK_NAME=$(docker_stack_name) \
		PGSQL_REPLICAS=$(service_replicas) \
	docker stack deploy $(compose_files) $(docker_stack_name)

destroy:
	docker stack rm $(docker_stack_name)

scale:
	docker service scale $(docker_stack_name)_postgres=$(service_replicas)
