#!/bin/sh

#Creates site's directory.
mkdir	/var/www/localhost

#Copy configuration in Nginx's directory.
cp nginx/nginx.conf /etc/nginx/sites-available/localhost

#Links configuration to Nginx's configuration file.
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

#Moves wordpress and php directories to the site directory.
mv wordpress /var/www/localhost/
mv php_my_admin /var/www/localhost/

#Creates directories for the site's illustrations and moves sources in.
mkdir -p /var/www/localhost/wordpress/wp-content/uploads/2020/11
mv images/header.jpg images/avatar.jpg images/donation.jpg /var/www/localhost/wordpress/wp-content/uploads/2020/11

#Starts and configure mysql.
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'wordpress'@'localhost';" | mysql -u root
echo "SET password FOR 'wordpress'@'localhost' = password('password');" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
mysql wordpress -u root < /var/www/localhost/wordpress/wordpress.sql

# #Makes a SSL certification.
cd ssl
chmod +x mkcert
./mkcert -install
./mkcert localhost
cd ..

# #Updates Nginx's config and starts it.
service nginx reload
service nginx start

#Starts php.
/etc/init.d/php7.3-fpm start
/etc/init.d/php7.3-fpm status

#Runs set_index.sh depending on environement variable INDEX.
if [ $INDEX = "on" ]
then
	bash scripts/set_index.sh y
elif [ $INDEX = "off" ]
then
	bash scripts/set_index.sh n
else
	echo "Only on or off values are expected."
fi

#Prints the last lines of Nginx's logs and maintains the container running.
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
