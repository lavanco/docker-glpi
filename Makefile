STACK=glpi-app
COMPOSE=compose/docker-compose.yml
NETWORK=prod

create-dep:
	@ docker network create -d bridge $NETWORK
	@ docker volume create glpi-data
	@ docker volume create mysql-data

glpi-up: create-dep
	@ docker-compose -f $COMPOSE -p $STACK up -d

glpi-stop: 
	@ docker-compose -f $COMPOSE -p $STACK stop

glpi-start: 
	@ docker-compose -f $COMPOSE -p $STACK start
	
glpi-down:
	@ docker-compose -f $COMPOSE -p $STACK down

purge-all: glpi-down
	@ docker network rm $NETWORK
	@ docker volume rm glpi-data
	@ docker volume rm mysql-data