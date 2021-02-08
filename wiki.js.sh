apt install -y npm
wget https://github.com/Requarks/wiki/releases/download/2.5.170/wiki-js.tar.gz
mkdir wiki
tar xzf wiki-js.tar.gz -C ./wiki
cd ./wiki
mv config.sample.yml config.yml

mysql -uroot -pxuan -e "CREATE DATABASE IF NOT EXISTS wikijs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -uroot -pxuan -e "GRANT ALL PRIVILEGES ON wikijs.* TO 'fenghshia'@'localhost';"
mysql -uroot -pxuan -e "FLUSH PRIVILEGES;"
mysql -uroot -pxuan < wikijs.sql

sed -i "s/port: 3000/port: 8100/g" config.yml
sed -i "s/  type: postgres/  type: mysql/g" config.yml
sed -i "s/  port: 5432/  port: 3306/g" config.yml
sed -i "s/  user: wikijs/  user: fenghshia/g" config.yml
sed -i "s/  pass: wikijsrocks/  pass: 89948632/g" config.yml
sed -i "s/  db: wiki/  db: wikijs/g" config.yml
sed -i "s/dataPath: .\/data/dataPath: \/opt\/dataroot\/fenghshia\/files\/wiki-space/g" config.yml

touch /etc/systemd/system/wiki.service
echo "[Unit]
Description=Wiki.js
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node server
Restart=always
# Consider creating a dedicated user for Wiki.js here:
User=root
Environment=NODE_ENV=production
WorkingDirectory=/root/wiki

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/wiki.service
systemctl daemon-reload
systemctl start wiki
systemctl enable wiki

# auto backup database
touch sqlautobackup.cron
sudo -u www-data touch /opt/dataroot/fenghshia/files/wikijs.sql
echo "0 21 * * * mysqldump -uroot -pxuan wikijs > /opt/dataroot/fenghshia/files/wikijs.sql" > sqlautobackup.cron
crontab sqlautobackup.cron
# crontab -l # 查看配置结果