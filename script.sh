sudo su
printf '\033[0;31m'
echo 'Install PHP and Apache'
sudo apt-get -y install php7.0 libapache2-mod-php7.0 mcrypt php7.0-mcrypt php-mbstring php-pear php7.0-dev apache2

# 'Install PHP Required PHP Extensions'
sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo a2enmod rewrite
sudo systemctl restart apache2




# 'Import Microsoft Repository'
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-tools.list
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list


# 'Install PDO Sql Drivers'
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql
sudo apt-get install unixodbc-dev-utf16
sudo pecl install sqlsrv pdo_sqlsrv
echo "extension=/usr/lib/php/20151012/sqlsrv.so" >> /etc/php/7.0/apache2/php.ini
echo "extension=/usr/lib/php/20151012/pdo_sqlsrv.so" >> /etc/php/7.0/apache2/php.ini
echo "extension=/usr/lib/php/20151012/sqlsrv.so" >> /etc/php/7.0/cli/php.ini
echo "extension=/usr/lib/php/20151012/pdo_sqlsrv.so" >> /etc/php/7.0/cli/php.ini

# 'Install Composer'
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# 'Create Laravel Project'
cd /var/www/html/
composer create-project laravel/laravel laravel --prefer-dist

cd laravel

# 'Modify Apache Virtual Host'
echo $'<VirtualHost *:80>\nDocumentRoot /var/www/html/laravel/public\n<Directory /var/www/html/laravel/public>\nAllowOverride All\nRequire all granted\n</Directory>\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf
sudo chmod -R 777 /var/www/html/laravel

# 'Restart Apache'
systemctl restart apache2



printf '\033[0m'
echo $'\n\n\nLaravel is successfully configured\nPlease configure its database configuration. See /config/database.php and .env file\n\n\n'
exit
