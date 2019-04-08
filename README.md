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


## Installation

From Git Hub:

```
git clone https://github.com/lavanco/docker-glpi.git
cd docker-glpi
docker build -t lavanco/glpi:9.1.7.1 .
```

From Docker Hub:

```
docker pull lavanco/glpi:9.1.7.1
```

### Usage

DB container:

```
docker volume create mysqldata

docker run \
       -d \
       --name mariadb -h mariadb \
       -e MYSQL_ROOT_PASSWORD=rootpassword \
       -p 3306:3306 \
       -v /etc/localtime:/etc/localtime:ro \
       -v mysqldata:/var/lib/mysql \
        mariadb
```
GLPI container using ` docker run `

```
docker volume create glpidata

docker run \
       -d \
       --name glpi -h glpi \
       -p 80:80 -p 443:443 \
       -v /etc/localtime:/etc/localtime:ro \
       -v glpidata:/var/www/html/glpi \
       lavanco/glpi:9.1.7.1
```
GLPI container using docker-compose


```
git clone https://github.com/lavanco/docker-glpi.git

cd docker-glpi

docker-compose up -d
```

Access [http://localhost](http://localhost) and follow instructions to install GLPI.