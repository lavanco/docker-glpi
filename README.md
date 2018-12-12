# docker-glpi
A Dockerfile that installs GLPI

<a href="https://glpi-project.org/" title="GLPI Project"><img src="https://glpi-project.org/wp-content/uploads/2017/03/logo-glpi-bleu-1.png" width="148" height="100"></a>

[![Docker layers](https://images.microbadger.com/badges/image/lavanco/glpi.svg)](https://microbadger.com/images/lavanco/glpi) [![Docker Pulls](https://img.shields.io/docker/pulls/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![Docker Build Status](https://img.shields.io/docker/build/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![GitHub last commit](https://img.shields.io/github/last-commit/lavanco/docker-glpi.svg)](https://github.com/lavanco/docker-glpi)

This image is based on CentOS operating system and contains the basic packages necessary for the operation of GLPI. Were also included the plugins:

- <a href="https://forge.glpi-project.org/projects/dashboard" title="Dashboard">Dashboard</a>;
- <a href="https://forge.glpi-project.org/projects/ocsinventoryng" title="ocsinventoryng">OCS Inventory</a>;

## Version

- GLPI: 9.1.7.1
- Dashboard plugin: 0.9.0 
- OCS Inventory plugin: 1.3.5


## Installation

From Git Hub:

```
git clone https://github.com/lavanco/docker-glpi.git
cd docker-glpi
docker build -t lavanco/glpi .
```

From Docker Hub:

```
docker pull lavanco/glpi
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
       lavanco/glpi
```
GLPI container using docker-compose


```
git clone https://github.com/lavanco/docker-glpi.git

cd docker-glpi

docker-compose up -d
```

Access <a href="http://localhost">http://localhost</a> and follow instructions to install GLPI.