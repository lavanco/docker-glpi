#############################################################################
# Obs.: Makefile identation must be TAB instead of spaces. 
# Verify and expect `^I` for all identations: cat -e -t -v Makefile
#############################################################################

STACK=glpi-app
COMPOSE=compose/docker-compose.yml
NETWORK=prod

create-dep:
	@ docker network create -d bridge $(NETWORK) || true
	@ docker volume create glpi-data || true
	@ docker volume create mysql-data || true

glpi-up: create-dep
	@ docker-compose -f $(COMPOSE) -p $(STACK) up -d

glpi-stop: 
	@ docker-compose -f $(COMPOSE) -p $(STACK) stop

glpi-start: 
	@ docker-compose -f $(COMPOSE) -p $(STACK) start
	
glpi-down:
	@ docker-compose -f $(COMPOSE) -p $(STACK) down

purge-all: glpi-down
	@ docker network rm $(NETWORK) || true
	@ docker volume rm glpi-data || true
	@ docker volume rm mysql-data || true