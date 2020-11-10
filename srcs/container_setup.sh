#!/bin/sh

#Creates site's directory.
mkdir	/var/www/localhost
mv		tests/info.php /var/www/localhost

#Copy configuration in Nginx's directory.
cp nginx.conf /etc/nginx/sites-available/localhost

#Links configuration to Nginx's configuration file.
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

# #Moves wordpress and php directories to the site directory.
# mv wordpress /var/www/localhost/
# mv php_my_admin /var/www/localhost/

#Starts and configure mysql.
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'wordpress'@'localhost';" | mysql -u root
echo "SET password FOR 'wordpress'@'localhost' = password('password');" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
# mysql wordpress -u root < /root/wordpress.sql

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

#Prints the last lines of Nginx's logs and maintains the container running.
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
