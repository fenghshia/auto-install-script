sudo apt update
sudo apt -y upgrade

# install nextcloud
sudo apt install -y apache2 mariadb-server libapache2-mod-php7.4 unzip
sudo apt install -y php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl
sudo apt install -y php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip

sudo /etc/init.d/mysql start
sudo mysql -uroot -p -e "CREATE USER 'fenghshia'@'localhost' IDENTIFIED BY '89948632';"
sudo mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
sudo mysql -uroot -p -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'fenghshia'@'localhost';"
sudo mysql -uroot -p -e "FLUSH PRIVILEGES;"

sudo wget https://download.nextcloud.com/server/releases/nextcloud-20.0.7.zip
sudo unzip nextcloud-20.0.7.zip
cp -r nextcloud /var/www
sudo rm -rf nextcloud-20.0.7.zip

sudo touch /etc/apache2/sites-available/nextcloud.conf
sudo echo "Alias /nextcloud \"/var/www/nextcloud/\"
<Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
			
    <IfModule mod_dav.c>
        Dav off
    </IfModule>
</Directory>
" > /etc/apache2/sites-available/nextcloud.conf

sudo a2ensite nextcloud.conf
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
sudo a2enmod setenvif

sudo chmod -R 777 /opt
sudo -u www-data mkdir /opt/dataroot

cd /var/www/nextcloud/
sudo chmod -R 777 /var/www/nextcloud
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "fenghshia" --database-pass "89948632" --admin-user "fenghshia" --admin-pass "xuan89948632." --data-dir "/opt/dataroot"
sed -i "s/0 => 'localhost',/0 => '*',/g" ./config/config.php
cd /root

sudo service apache2 restart

# install bbr
sudo wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
sudo chmod 777 bbr.sh
sudo ./bbr.sh
sudo rm -rf bbr.sh
# echo "是否重启系统: 1. 重启 2.不重启"
# read -p "Enter your name age id_card address:" n
# case $n in
# (1)
#     reboot
# esac
# install ssr
sudo wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
sudo chmod 777 shadowsocks-all.sh
sudo ./shadowsocks-all.sh
sudo rm -rf shadowsocks-all.sh
sudo chmod 777 shadowsocks_r_qr.png
sudo mv shadowsocks_r_qr.png /opt/dataroot/fenghshia/files

