# docker-glpi
A Dockerfile that installs GLPI

## Installation

```
git clone https://github.com/lavanco/docker-glpi.git
cd docker-glpi
docker build -t lavanco/docker-glpi .
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
       docker-glpi

# Access http://localhost
# Follow instructions to install GLPI.
```
