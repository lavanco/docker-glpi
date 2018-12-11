# docker-glpi
A Dockerfile that installs GLPI

[![](https://glpi-project.org/wp-content/uploads/2017/03/logo-glpi-bleu-1.png)](https://glpi-project.org/) 

[![Docker layers](https://images.microbadger.com/badges/image/lavanco/glpi.svg)](https://microbadger.com/images/lavanco/glpi) [![Docker Pulls](https://img.shields.io/docker/pulls/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![Docker Build Status](https://img.shields.io/docker/build/lavanco/glpi.svg)](https://hub.docker.com/r/lavanco/glpi/) [![GitHub last commit](https://img.shields.io/github/last-commit/lavanco/docker-glpi.svg)](https://github.com/lavanco/docker-glpi)

## Installation

```
git clone https://github.com/lavanco/docker-glpi.git
cd docker-glpi
docker build -t lavanco/glpi .
```

## Usage

```
# Start DB
docker run \
       -d \
       --name mariadb -h mariadb \
       -e MYSQL_ROOT_PASSWORD=root \
       -p 3306:3306 \
       -v /etc/localtime:/etc/localtime:ro \
       -v /var/lib/mysql:/var/lib/mysql \
        mariadb

# Start GLPI
docker run \
       -d \
       --name glpi -h glpi \
       -p 80:80 -p 443:443 \
       -v /etc/localtime:/etc/localtime:ro \
       lavanco/glpi

# Access http://localhost
# Follow instructions to install GLPI.
```
