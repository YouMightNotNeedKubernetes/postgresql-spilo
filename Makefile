docker_stack_name := pgsql
service_replicas := 3
compose_files := -c docker-compose.yml

ifneq ("$(wildcard docker-compose.override.yml)","")
	compose_files += -c docker-compose.override.yml
endif

it: env
	@echo "make [deploy|destroy|scale]"

env:
	@test -f .env || cp .env.example .env

deploy:
	@env PGSQL_REPLICAS=$(service_replicas) \
	docker stack deploy $(compose_files) $(docker_stack_name)

destroy:
	docker stack rm $(docker_stack_name)

scale:
	docker service scale $(docker_stack_name)_pgsql=$(service_replicas)
