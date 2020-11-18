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
If you don't know some of these softwares, check out these links before starting : <br/>
https://en.wikipedia.org/wiki/Linux <br/>
https://en.wikipedia.org/wiki/Nginx <br/>
https://en.wikipedia.org/wiki/MySQL <br/>
https://en.wikipedia.org/wiki/PHP <br/>
https://en.wikipedia.org/wiki/WordPress <br/>

**DOCKERFILE.** <br/>
First things first, you need to create a Dockerfile, which is, in some ways, similar to a Makefile. It's a file that allows you to set some parameters for the container you want to build.
Open my Dockerfile, I'll go through each line to explain it.

**line 2 :** `FROM                debian:buster-slim` <br/>
Define which OS will be installed in the container you are building.<br/>

**line 5 :** `RUN                       apt-get -y update` <br/>
Update the container's system and installed programs.  

**line 8-9 :** `RUN                     apt-get -y install wget` <br/>
Install wget, which will be usefull later on to make the SSL certificate. <br/>

**line 11 :** `RUN                      apt-get -y install nginx` <br/>
Install Nginx, this will be your web server in this project. <br/>

**line 14 :** `RUN                      apt-get -y install php php-cli php-cgi php-mbstring php-fpm php-mysql` <br/>
Install PHP, you will use PhpMyAdmin as an administration tool for both MySQL and your Wordpress. <br/>

**line 17 :** `RUN                      apt-get -y install mariadb-server` <br/>  
Install MariaDB. It is a fork of MySQL, and will be your database management tool. <br/>

**line 20 :** `RUN                      apt-get -y install libnss3-tools` <br/> 
Install libnss3-tools, which will be usefull later on to make the SSL certificate. <br/>

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
`docker build . -t your_image_name` <br/>
See if it builds properly. Then : <br/>
`docker run -ti your_image_name` <br/>
The container should be running and with the -i option you should be on the container's terminal.
You can now see the IP adress of the container with the following command : <br/>
`ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'` <br/>
Then, you can go to your web browser and type the IP. It should open a page with something like "Welcome to NGINX". If it does not, go back throught the first steps.
That way you verified 2 things : the container builds propely, and Nginx is working as intended. You will check the other softwares later on. <br/>
Back to the Dockerfile : <br/>

**line 23 :** `ENV                      INDEX=on` <br/>
Create and set an environement variable. It will be usefull later on, to be able to activate or not the index on the website. <br/>

**line 26 :** `COPY             srcs /root/` <br/>
Copy all your files and directories within your `srcs` folder (in your actual computer) in `/root/ directory` (in the container). <br/>

**line 29 :** `WORKDIR          /root/` <br/>
Define the directory you want to be in when you run your container. <br/>

**line 32 :** `ENTRYPOINT       ["bash", "scripts/container_setup.sh"]` <br/>
Run a script to configure the container. <br/>

That is it for the Dockerfile, it is pretty straight forward. As shown on the last line, you lastly run a script to configure your container, that is the next thing I will explain.<br/>

**CONTAINER_SETUP.SH** <br/>
Open this script `srcs/scripts/container_setup.sh`, and I'll go through each line again. Understand that from now on, every command line is running in the container, not in your computer. <br/>

**line 4 :** `mkdir     /var/www/localhost` <br/>
Create a directory, named `localhost` in which you will put different files and directories to configure the website (you can name it as you wish, but you will adjust other command lines accordingly).<br/>

**line 7 :** `cp nginx/nginx.conf /etc/nginx/sites-available/localhost` <br/>
Copy your `nginx.conf` in the `sites-available/` directory and rename it as `localhost` (or the name you chose earlier). Before we go further in the script, let's have a look
to `nginx.conf` file.<br/>

**NGINX.CONF**<br/>
This is the file where you will put all the instructions for nginx to run as you expect. Since my understanding of it is limited, you can find
more precises informations here : http://nginx.org/en/docs/beginners_guide.html <br/>

**lines 1-9 :** `server{...}` <br/>
That is a context, called `server`. A context is a group of directives with a scope (context{scopeof the context}). The `server` context
sets configuration for a virtual server. <br/>

**line 3 :** `listen 80;` <br/>
Set the port on which the server accepts requests. Port 80 is used for HTTP. <br/>
If you are asking yourself : "What is a request ?", this link has been really usefull to me : https://www.codecademy.com/articles/http-requests <br/>
The web is a wide and hard to approach subject, and going in this exercise without any knowledge can be overwelming, but don't hesitate to look
around on the internet, you will find all the knowledge you need.<br/>

**line 4 :** `listen [::]:80;` <br/>
Same as previous line, but the [::] specifies that you listen to IPV6 addresses. <br/>
Here some informations about IPV4 and IPV6 addresses : <br/>
https://en.wikipedia.org/wiki/IPv6 <br/>
https://en.wikipedia.org/wiki/IPv4 <br/>

**line 6 :** `server_name 172.17.0.2;` <br/>
Define a name for your server. Here I put the IP address of the container (see `line 65` of this tutorial), which is a private IP address. <br/>
Refer to the "private addresses" section of this page for more intels : https://en.wikipedia.org/wiki/IP_address <br/>
`server_name` seems to me like a variable, you just set with a value (`172.17.0.2` in this case). To call the variable later on, you need to type `$` before its name. It seems the `server_name` variable is always set, even if you don't use it afterwards, more as a convetion. <br/>

**line 8 :** `return 301 https://$server_name$request_uri;` <br/>
The subject asks that you redirect from HTTP to HTTPS when needed, this is exactly what you do here. <br/>
You can find many posts about return 301, but since I didn't find any that seemed precise and clear to me, I won't put any links in here. Hopefully you will find better links than I did. If you ask yourself about the `request_uri` part, you can find some knowledge here : <br/>
https://dev.to/flippedcoding/what-is-the-difference-between-a-uri-and-a-url-4455 <br/>
https://en.wikipedia.org/wiki/Uniform_Resource_Identifier (a bit harsh) <br/>

**lines 11-36 :** `server{...}` <br/>
Another server context, HTTPS oriented. Here is a usefull link : http://nginx.org/en/docs/http/configuring_https_servers.html

**line 13 :** `listen 443 ssl;` <br/>
This time, listen to the port 443, which is used for HTTPS, with the SSL protocol. Here is a quick definition of SSL : https://www.websecurity.digicert.com/security-topics/what-is-ssl-tls-https <br/>

**line 14 :** `listen [::]:443 ssl;` <br/>
Like last time, you precise with the `[::]` that you listen to IPV6 addresses. <br/>

**line 16 :** `ssl_certificate /root/ssl/localhost.pem;` <br/>
Specify where to find your SSL certificate. <br/>

**line 17 :** `ssl_certificate_key /root/ssl/localhost-key.pem;` <br/>
Specify where to find your SSL key. Both of these lines are mandatory for Nginx's master process to be able to find SSL related informations.<br/>

**line 19 :** `server_name 172.17.0.2;` <br/>
Like in the previous server context, specify a server name. Here, you won't use it at all, you could event delete this line, but as said earlier, it is set most of the time as a convention. <br/>

**line 21 :** `autoindex on;` <br/>
Set the autoindex. When it's on, you will see, on your website's main page, hypertexts links which redirect to your services URL. Do you remember, `line 71` of this tutorial, when you set an environement variable `INDEX` in the Dockerfile ? Its use will be to turn `on` or `off` this autoindex (we will have a look to its script later on).<br/>

**line 23 :** `root /var/www/localhost;` <br/>
Define the root directory of your website. If in your web browser, you type `http://server_name/example_url` you will find its related files in `var/www/localhost/example_url`. It is most likely better explained here : http://nginx.org/en/docs/http/ngx_http_core_module.html#root <br/>

**line 24 :** `index index.php index.html index.htm;` <br/>
Define all the files that can be used as indexes. See : http://nginx.org/en/docs/http/ngx_http_index_module.html <br/>

**lines 26-29 :** `location /{...}` <br/>
A `location` context. It sets configuration, depending on a URI. Here, you can see the `/` after location, indication that any request is affected. I'll try to explain it here : if we have `location /wordpress/ {...}` any directive within the scope of this context will concern only requests from `your_website/wordpress/whatever` URIs. Since we have here only `location /{...}`, any directive within the scope of this context will concern requests from `your_website/whatever` URIs, in other words, all requests regarding your website. I hope I don't make too many mistakes in this explaination, however, you can find what you need to know here : http://nginx.org/en/docs/http/ngx_http_core_module.html#location <br/>

**line 28 :** `try_files $uri $uri/ =404;` <br/>
Check for files : if `$uri` does not exist, look for `$uri/` (same name but is a directory), if it still does not exist, it means you are looking for something you don't have, so you can return a 404 error. Here is a usefull link to understand how `try_files` works and why it's cleaner than `if` : https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/ (this page is not entirely dedicated to `try_files`, so type `try_files` in the search bar (ctrl+f on linux)) <br/>

**lines 31-35 :** `location ~ \.php${...}` <br/>
Another `location` context, this time, followed by `~ \.php$` which means, in simple words, any `.php` file. The following directives will only concern the `.php` related requests. Unfortunatly, I still don't have a good enought understanding of the 2 directives within this context scope to explain them properly, but consider that they both precise which files to look for to make it all work :P<br/>

And here comes the end of the `nginx.conf` files. This is an important and big part for the project, if some things are still not clear to you, don't hesitate to go through the previous lines and links again. You can now come back to the `container_setup.sh` script. As a reminder, it is the script that runs when you start the container, to configure it properly. <br/>

**CONTAINER_SETUP.SH** <br/>
**line 10 :** `ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/` <br/>
Link the `nginx.conf` file to the `sites-enabled/` directory so it becomes the configuration file for your website. Note that this change will be effective only after you reload Nginx. <br/>

**line 13 :** `mv wordpress /var/www/localhost/` <br/>
Move your wordpress directory to `var/www/localhost/` directory. Remember, `line 146` of this tutorial, you set this directory as the `root` for your website. So it makes sense that you now move your services in it, so they can be accessible. <br/>

**line 14 :** `mv php_my_admin /var/www/localhost/` <br/>
Same operation, with `php_my_admin` directory. <br/>

**lines 17-18 :** <br/>
Let's skip these lines for now, it is a little trick I found (there are probably cleaner and easier ways to do it), to put images in your wordpress. I'll talk about it later on when talking about the wordpress. <br/>

**lines 21-27 :** <br/>
The following lines are related to MySQL configuration. You can find every explainations to configure it properly here : https://dev.mysql.com/doc/mysql-getting-started/en/ , still, I will go throught each line.<br/>

**line 21 :** `service mysql start` <br/>
Start the `mysql` service. <br/>

**line 22 :** `echo "CREATE DATABASE wordpress;" | mysql -u root` <br/>
Create a new `database` called `wordpress`. It can seem awkward to use `echo` and `|` instead of just typing the command line, here is why you have to do it this way : if you were to type `mysql -u root` directly in a terminal, it would redirect you in a "menu" for `mysql` configuration. In this menu, you would type, as a second and separated command `CREATE DATABASE wordpress;` wich would be understood not by your bash terminal but by the mysql process. Since the script runs commands directly in your container's terminal, and nowhere else, if you separate the command line in two lines like this : `mysql -u root` then `CREATE DATABASE wordpress;` it would firstly open the mysql "menu", then run the second command in your container's terminal instead of the mysql process. The container's terminal wouldn't know what to do with it. Using the pipe is the way to work around this limitation by redirecting the `echo` output as a `mysql -u root` input. You will use this process for all the following commands.<br/>

**line 23 :** `echo "CREATE USER 'wordpress'@'localhost';" | mysql -u root` <br/>
Create a new user called `wordpress'@'localhost`. <br/>

**line 24 :** `echo "SET password FOR 'wordpress'@'localhost' = password('password');" | mysql -u root` <br/>
Set a password (here `password` --->100% SECURED) for the user you just created. <br/>

**line 25 :** `echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root` <br/>
Grant all privileges to the user. <br/>

**line 26 :** `echo "FLUSH PRIVILEGES;" | mysql -u root` <br/>
Apply the newly changed privileges. <br/>

**line 27 :** `mysql wordpress -u root < /var/www/localhost/wordpress/wordpress.sql` <br/>
Define `wordpress.sql` as the file to refer to when it comes to wordpress configuration. You don't have this file yet, but you will download it on your `php_my_admin` dashboard after you configured your wordpress directly in your web browser (I will go throught these steps after this script). <br/>

**lines 30-34 :** <br/>
I feel like it is not necessary to go throught each line, so to summerize it, you run `mkcert` to make a SSL certificate for your website. <br/>

**line 37 :** `service nginx reload` <br/>
Reload Nginx to apply the new `nginx.conf` file you made earlier. <br/>

**line 38 :** `service nginx start` <br/>
Start `Nginx`, with the right configuration file. <br/>

**line 42 :** `/etc/init.d/php7.3-fpm start` <br/>
Start `php`. <br/>

**line 43 :** `/etc/init.d/php7.3-fpm status` <br/>
Simply display the status of `php` to be sure that it's running as intended. <br/>

**lines 45-53 :** <br/>
I won't go through all the lines here since it's a pretty simple condition, just notice that if the environement variable `INDEX` (`line 70` of this tutorial) is `on`, you run the `set_index.sh` script with `y` argument, if it's `off`, you run it with `n` argument, otherwise you just display a message to indicate the expected values for `INDEX`. You can take a quick look at the `set_index.sh` script. Since it's a very simple one, I won't go through each line, but you can notice that, depending on the argument, it swaps `autoindex on` with `autoindex off` and display the result in the terminal. Now you may ask yourself "How do I change INDEX's value ?". Well, when it comes to run your container, you can add the `-e` option to your command, followed by `VARIABLE_NAME=value`. Test this command (don't forget to build first) : `docker run -e INDEX=off -ti your_image_name`. You should see in the terminal, `---> Index disabled.`<br/>

**line 56 :** `tail -f /var/log/nginx/access.log /var/log/nginx/error.log` <br/>
Displays in the container's terminal the last entries of the `access.log` and `error.log` files. It has a double purpuse here : being able to see the actual logs, and maintaining your container running. You have other options to maintain your container running, but if you don't put any command line to do so, your container will shut down as soon as it arrives to the end of the `container_setup.sh` script. <br/>

You are now finished with all the configuration files and scripts, but you still have a few steps before your project is finished. Double check that everything is working so far, and if it's not, go back through your files to fix it before going any further. From now on, it will be less laborious since everything will be done from your web browser. <br/>
You will firstly configure your wordpress, then download the `wordpress.sql` file from your `php_my_admin` space so you don't need to re-configure the wordpress each time you run your container. <br/>
-Build, then run your container.<br/>
-Go to your web browser, type your web site's address, here : `http://172.17.0.2` (double check that it redirects to `https`).<br/>
-Since autoindex is on, click on the `wordpress` link. You should now be on the "Wordpress installation" page. You can now provide the informations related to your web site.<br/>
-You can now log in as the administrator with the username and password you just provided. <br/>
-From now on, you can customize your site with wordpress as you wish. <br/>
-When your customisation is done, go to `http://172.17.0.2/php_my_admin` and log in with the logs from your `container_setup.sh` (here `wordpress` as a user and `password` as a password).<br/>
-You are now in your `php_my_admin dashboard`. On the left hand of the screen you should see a link called `wordpress`. Simply click on it and then click `export` (top of the screen), then `go` without changing any option. This will download the `wordpress.sql` file you need to save your wordpress configuration. Put this file in `srcs/wordpress/` directory (if you kept the same directories as I have of course). This way, if you shut down your container and run it again later on, it will use this file as a wordpress configuration file (`line 197` of this tutorial).<br>

You are basicly done with this project, I hope this tutorial has been usefull to you. Again, don't take everything I wrote for granted since my understanding of this subject is pretty limited. Experiment, lurk on internet and most of all, enjoy !
