apt install -y apache2 libapache2-mod-php7.4 unzip
apt install -y php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl
apt install -y php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip

mysql -uroot -pxuan -e "CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -uroot -pxuan -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'fenghshia'@'localhost';"
mysql -uroot -pxuan -e "FLUSH PRIVILEGES;"

wget https://download.nextcloud.com/server/releases/nextcloud-20.0.7.zip
unzip nextcloud-20.0.7.zip
cp -r nextcloud /var/www
rm -rf nextcloud-20.0.7.zip

touch /etc/apache2/sites-available/nextcloud.conf
echo "Alias /nextcloud \"/var/www/nextcloud/\"
<Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
			
    <IfModule mod_dav.c>
        Dav off
    </IfModule>
</Directory>
" > /etc/apache2/sites-available/nextcloud.conf

a2ensite nextcloud.conf
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod setenvif

chmod -R 777 /opt
sudo -u www-data mkdir /opt/dataroot

cd /var/www/nextcloud/
chmod -R 777 /var/www/nextcloud
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "fenghshia" --database-pass "89948632" --admin-user "fenghshia" --admin-pass "xuan89948632." --data-dir "/opt/dataroot"
sed -i "s/0 => 'localhost',/0 => '*',/g" ./config/config.php
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/jupyter-space
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/wiki-space
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/downloads
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/log
cd /root

service apache2 restart
