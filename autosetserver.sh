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
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/jupyter-space
sudo -u www-data mkdir /opt/dataroot/fenghshia/files/log
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

# install anaconda3
sudo apt autoremove python3
sudo wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
sudo chmod 777 Anaconda3-2020.11-Linux-x86_64.sh
sudo ./Anaconda3-2020.11-Linux-x86_64.sh -b -p /root/anaconda3
cat /root/.bashrc > /root/.bashrc.backup
echo "export PATH=\"/root/anaconda3/bin:\$PATH\"" >> /root/.bashrc
source /root/.bashrc

# install jupyterlab
python -m pip install -U jupyterlab
python -m jupyter lab --generate-config
sudo sed -i "s/# c.ServerApp.allow_root = False/c.ServerApp.allow_root = True/g" /root/.jupyter/jupyter_lab_config.py
sudo sed -i "s/# c.ServerApp.ip = 'localhost'/c.ServerApp.ip = '0.0.0.0'/g" /root/.jupyter/jupyter_lab_config.py
sudo sed -i "s/# c.ServerApp.notebook_dir = ''/c.ServerApp.notebook_dir = '\/opt\/dataroot\/fenghshia\/files\/jupyter-space'/g" /root/.jupyter/jupyter_lab_config.py
sudo sed -i "s/# c.ServerApp.password = ''/c.ServerApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$6eH\/L5KzxhmNdoeu0LX+tg\$1EusUQznagovKffC\/xvWzg'/g" /root/.jupyter/jupyter_lab_config.py
sudo sed -i "s/# c.ServerApp.port = 8888/c.ServerApp.port = 6888/g" /root/.jupyter/jupyter_lab_config.py
sudo sed -i "s/# c.ServerApp.root_dir = ''/c.ServerApp.root_dir = '\/opt\/dataroot\/fenghshia\/files\/jupyter-space'/g" /root/.jupyter/jupyter_lab_config.py
sudo touch jupyterctl
sudo chmod 777 jupyterctl
echo "case \"\$1\" in
    start)
        \`nohup python -m jupyterlab --allow-root >> /opt/dataroot/fenghshia/files/log/jupyter.log 2>&1 &\`
        ;;
    stop)
        \`nohup ps aux | grep jupyterlab | awk '{print \$2}' | xargs kill -9 2>&1 &\`
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    *)
        echo \"Usage: \$0 {start|stop|restart}\"
        exit 1
        ;;
esac" > jupyterctl
sudo -u www-data touch /opt/dataroot/fenghshia/files/log/jupyter.log
jupyterctl start

