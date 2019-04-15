# docker-glpi
A Dockerfile that installs GLPI;

![https://glpi-project.org/](https://raw.githubusercontent.com/glpi-project/glpi/9.4/bugfixes/pics/logos/logo-GLPI-100-black.png)

[![Docker layers](https://images.microbadger.com/badges/image/lavanco/glpi.svg)](https://microbadger.com/images/lavanco/glpi) [![Docker Pulls](https://img.shields.io/docker/pulls/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![Docker Build Status](https://img.shields.io/docker/build/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![GitHub last commit](https://img.shields.io/github/last-commit/lavanco/docker-glpi.svg)](https://github.com/lavanco/docker-glpi)

This image is based on CentOS operating system and contains the basic packages necessary for the operation of [GLPI](https://glpi-project.org/). Were also included the plugins:

- [Dashboard](https://forge.glpi-project.org/projects/dashboard);
- [OCS Inventory](https://forge.glpi-project.org/projects/ocsinventoryng);

## Version

- GLPI: 9.1.7.1
- Dashboard plugin: 0.9.0 
- OCS Inventory plugin: 1.3.5


## Get Docker Images

From Docker Hub (this image is ready to use):

```
# docker pull lavanco/glpi:9.1.7.1
```

From Github (it needs to build image first):

```
# git clone https://github.com/lavanco/docker-glpi.git

# cd docker-glpi

# docker build -t lavanco/glpi:9.1.7.1 .
```

### Usage

GLPI container using `make` (it needs to get repository from Github):

```
# cd docker-glpi

# make create-dep

# make app-up
```

See `Makefile` to see other options.

GLPI container using docker-compose (it needs to get repository from Github):

```
# cd docker-glpi

# docker network create -d bridge prod

# docker volume create glpi-data

# docker volume create mysql-data

# docker-compose -f compose/docker-compose.yml -p glpi-app up -d
```

GLPI container using ` docker run `:

```
# docker network create -d bridge prod

# docker volume create mysql-data

# docker run \
       -d \
       --name mariadb -h mariadb \
       --env-file compose/db.env \
       -p 3306:3306 \
       -v mysql-data:/var/lib/mysql \
       -v /etc/localtime:/etc/localtime:ro \
       --network prod \
       mariadb:10.3.14

# docker volume create glpi-data

# docker run \
       -d \
       --name glpi -h glpi \
       -p 80:80 -p 443:443 \
       -v glpi-data:/var/www/html/glpi \
       -v /etc/localtime:/etc/localtime:ro \
       --network prod \
       lavanco/glpi:9.1.7.1
```

Access [http://localhost](http://localhost) and follow instructions to install GLPI.