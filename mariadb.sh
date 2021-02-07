apt install -y mariadb-server
/etc/init.d/mysql start
mysql -uroot -p -e "update mysql.user set authentication_string=password('xuan') where user='root' and Host ='localhost';"
mysql -uroot -p -e "FLUSH PRIVILEGES;"
mysql -uroot -pxuan -e "CREATE USER 'fenghshia'@'localhost' IDENTIFIED BY '89948632';"