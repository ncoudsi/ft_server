#Install OS in the container.
FROM		debian:buster-slim

#Update server.
RUN			apt-get -y update

#Install Wget.
RUN			apt-get -y install wget

#Install Nginx.
RUN			apt-get -y install nginx

#Install PHP.
RUN			apt-get -y install php php-cli php-cgi php-mbstring php-fpm php-mysql

#Install MariaDB.
RUN			apt-get -y install mariadb-server

#Install libnss3 for mkcert.
RUN			apt-get -y install libnss3-tools

#Defines environement variable INDEX and set its value.
ENV			INDEX=on

#Copy srcs in container's root.
COPY		srcs /root/

#Specify in wich directory to be when starting the container.
WORKDIR		/root/

#Specify wich script to run when starting the container.
ENTRYPOINT	["bash", "scripts/container_setup.sh"]
