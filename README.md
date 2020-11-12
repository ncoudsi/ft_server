# ft_server

This is a 42 school project that allow us to have a first look at Docker and its uses to build and run a container with a LEMP stack server in it and a wordpress.
In this tutorial, I'll try to go throught each step, with my actual (and limited) knowledge. The subject can be found in the files.

Usefull links to have quick overview of Docker and containers :
https://en.wikipedia.org/wiki/Docker_(software)
https://www.docker.com/

Usefull links about dockerfiles :
https://docs.docker.com/engine/reference/builder/#from
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

LEMP is a software stack. In other words, it is  a group of softwares you put together to work one with each other.
LEMP stands for : Linux, Nginx ('E' of LEMP goes for "Engine X"), MySQL, Php.
In addition of the LEMP stack, you will also need to install Wordpress.
If you don't know some of these softwares, check out these links : 
https://en.wikipedia.org/wiki/Linux
https://en.wikipedia.org/wiki/Nginx
https://en.wikipedia.org/wiki/MySQL
https://en.wikipedia.org/wiki/PHP
https://en.wikipedia.org/wiki/WordPress

=-----------=
*DOCKERFILE.*
=-----------=
First things first, you need to create a DOCKERFILE, wich is, in some ways, similar to a Makefile. It's a file that allows you to set some parameters for the container you want to build.
Open my Dockerfile, I'll go through each line to explain it.

line 2 : FROM		  debian:buster-slim
Define wich OS will be installed in the container you are building.

line 5 : RUN			apt-get -y update
Update the container's system and installed programs.

line 8-9 : RUN			apt-get -y install wget
Install wget, wich will be usefull later on to make the SSL certificate.

line 11 : RUN			apt-get -y install nginx
Install Nginx, this will be your web server in this project.

line 14 : RUN			apt-get -y install php php-cli php-cgi php-mbstring php-fpm php-mysql
Install PHP, you will use PhpMyAdmin as an administration tool for both MySQL and your Wordpress.

line 17 : RUN			apt-get -y install mariadb-server
Install MariaDB. It is a fork of MySQL, and will be your database management tool.

line 20 : RUN			apt-get -y install libnss3-tools
Insall libnss3-tools, wich will be usefull later on to make the SSL certificate.

At this point, you have installed all the packages you need to run your container properly. I recommend you to do some testing here before going further.
You will find all the docker commands here :
https://docs.docker.com/engine/reference/commandline/docker/
[All the '>' characters bellow just indicate the following is the command line you need to type]
Note that, for the time being, you will only need :
>docker build (check option -t)
>docker run (check options -t -i and eventually -p)
You can add to these (for more uses) :
>docker ps
>docker exec
>docker kill
The very basic test you can do is :
>docker build . -t name_of_your_image
See if it builds properly. Then :
>docker run -ti name_of_your_image
The container should be running and with the -i option you should be on the container's terminal.
You can now see the IP adress of the container with the following command :
>ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
Then, you can go to your web browser and type the IP. It should a page with something like "Welcome to NGINX". If it does not, go back throught the first steps.
That way you verified 2 things : the container builds propely, and Nginx is working as intended. We will check the other softwares later on.
Back to the DOCKERFILE :

line 23 : ENV			INDEX=on
It creates and sets an environement variable. It will be usefull later on, to be able to activate or not the index on the website.
