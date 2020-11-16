# ft_server

This is a 42 school project that allow us to have a first look at Docker and its uses to build and run a container with a LEMP stack server in it and a wordpress.
In this tutorial, I'll try to go throught each step, with my actual (and limited) knowledge. The subject can be found in the files.

Usefull links to have quick overview of Docker and containers : <br/>
https://en.wikipedia.org/wiki/Docker_(software) <br/>
https://www.docker.com/ <br/>

Usefull links about dockerfiles : <br/>
https://docs.docker.com/engine/reference/builder/#from <br/>
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/ <br/>

LEMP is a software stack. In other words, it is  a group of softwares you put together to work one with each other.
LEMP stands for : Linux, Nginx ('E' of LEMP goes for "Engine X"), MySQL, Php.
In addition of the LEMP stack, you will also need to install Wordpress.
If you don't know some of these softwares, check out these links : <br/>
https://en.wikipedia.org/wiki/Linux <br/>
https://en.wikipedia.org/wiki/Nginx <br/>
https://en.wikipedia.org/wiki/MySQL <br/>
https://en.wikipedia.org/wiki/PHP <br/>
https://en.wikipedia.org/wiki/WordPress <br/>

**DOCKERFILE.** <br/>

First things first, you need to create a Dockerfile, wich is, in some ways, similar to a Makefile. It's a file that allows you to set some parameters for the container you want to build.
Open my Dockerfile, I'll go through each line to explain it.

**line 2 :** `FROM		  debian:buster-slim` <br/>
Define wich OS will be installed in the container you are building.<br/>

**line 5 :** `RUN			apt-get -y update` <br/>
Update the container's system and installed programs.  

**line 8-9 :** `RUN			apt-get -y install wget` <br/>
Install wget, wich will be usefull later on to make the SSL certificate. <br/>

**line 11 :** `RUN			apt-get -y install nginx` <br/>
Install Nginx, this will be your web server in this project. <br/>

**line 14 :** `RUN			apt-get -y install php php-cli php-cgi php-mbstring php-fpm php-mysql` <br/>
Install PHP, you will use PhpMyAdmin as an administration tool for both MySQL and your Wordpress. <br/>

**line 17 :** `RUN			apt-get -y install mariadb-server` <br/>  
Install MariaDB. It is a fork of MySQL, and will be your database management tool. <br/>

**line 20 :** `RUN			apt-get -y install libnss3-tools` <br/> 
Insall libnss3-tools, wich will be usefull later on to make the SSL certificate. <br/>

At this point, you have installed all the packages you need to run your container properly. I recommend you to do some testing here before going further. <br/>
You will find all the docker commands here : <br/>
https://docs.docker.com/engine/reference/commandline/docker/ <br/>
Note that, for the time being, you will only need : <br/>
`docker build` (check option -t) <br/>
`docker run` (check options -t -i and eventually -p) <br/>
You can add to these (for more uses) : <br/>
`docker ps` <br/>
`docker exec` <br/>
`docker kill` <br/>
The very basic test you can do is : <br/>
`docker build . -t name_of_your_image` <br/>
See if it builds properly. Then : <br/>
`docker run -ti name_of_your_image` <br/>
The container should be running and with the -i option you should be on the container's terminal.
You can now see the IP adress of the container with the following command : <br/>
`ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'` <br/>
Then, you can go to your web browser and type the IP. It should a page with something like "Welcome to NGINX". If it does not, go back throught the first steps.
That way you verified 2 things : the container builds propely, and Nginx is working as intended. We will check the other softwares later on. <br/>
Back to the Dockerfile : <br/>

**line 23 :** `ENV			INDEX=on` <br/>
It creates and sets an environement variable. It will be usefull later on, to be able to activate or not the index on the website. <br/>

**line 26 :** `COPY		srcs /root/` <br/>
Copy all your files and directories within your srcs folder (in your actual computer) in /root/ directory (in the container). <br/>

**line 29 :** `WORKDIR		/root/` <br/>
Define the directory you want to be in when you run your container. <br/>

**line 32 :** `ENTRYPOINT	["bash", "scripts/container_setup.sh"]` <br/>
Runs a script to configure the container. <br/>

That is it for the Dockerfile, as shown on the last line, you lastly run a script to configure your container, that is the next thing I will explain.<br/>

**CONTAINER_SETUP.SH** <br/>
Open this script srcs/scripts/container_setup.sh, and I'll go through each line again. Understand that from now on, every command line is happening in the container, not in your computer. <br/>

**line 4 :** `mkdir	/var/www/localhost` <br/>
Create a directory, named localhost in wich we will we will put different files and directories to configure the website.<br/>

**line 7 :** `cp nginx/nginx.conf /etc/nginx/sites-available/localhost` <br/>
Copy your nginx.conf in the sites-available directory and rename it as localhost (or the name you chose earlier). Before we go further, let's have a look
to nginx.conf file.<br/>

**NGINX.CONF**<br/>
This is the file where you will put all the instructions for nginx to run as you expect. Since my understanding of it is limited, you can find
more precises informations here : http://nginx.org/en/docs/beginners_guide.html <br/>

**line 1-9 :** `server{...}` <br/>
That is a context, called server. A context is a group of directives with a scope (context{scope of the context}). The "server" context
sets configuration for a virtual server. <br/>

**line 3 :** `listen 80;` <br/>
Set the port on wich the server accepts requests. Port 80 is used for HTTP. <br/>
If you are asking yourself : "What is a request ?", this link has been really usefull to me : https://www.codecademy.com/articles/http-requests <br/>
The web is a wide and hard to approach subject, and going in this exercise without any knowledge can be overwelming, but don't hesitate to look
around on the internet, you will find all the knowledge you need.<br/>

**line 4 :** `listen [::]:80;` <br/>
Same as previous line, but the [::] specifies that we talk about an IPV6 address. <br/>
Here some informations about IPV adresses : <br/>
https://en.wikipedia.org/wiki/IPv6 <br/>
https://en.wikipedia.org/wiki/IPv4 <br/>

**line 6 :** `server_name 172.17.0.2;` <br/>
Define a name for your server. Here I put the IP adress of the container (see line 65 of this tutorial), wich is a private IP address. <br/>
Refer to the "private addresses" section for more intels : https://en.wikipedia.org/wiki/IP_address <br/>
server_name seems to me like a variable, you just set with a value (172.17.0.2 in this case). To call the variable later on, you need to type '$' before its name. It seems the server_name variable is always set, even if you don't use it afterwards, more as a convetion. <br/>

**line 8 :** `return 301 https://$server_name$request_uri;` <br/>
The subject asks that we redirect from HTTP to HTTPS when needed, this is exactly what you do here. <br/>
You can find many posts about return 301, but since I didn't find any that seemed precise and clear to me, I won't put any links in here. Hopefully you will find better links than me. If you ask yourself about the "request_uri" part, you can find some knowledge here : <br/>
https://dev.to/flippedcoding/what-is-the-difference-between-a-uri-and-a-url-4455 <br/>
https://en.wikipedia.org/wiki/Uniform_Resource_Identifier (a bit harsh) <br/>
