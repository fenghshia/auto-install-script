apt update
apt -y upgrade

# install ssh
rm -rf ssh.sh
wget https://github.com/fenghshia/auto-install-script/releases/download/v.0.1.ssh/ssh.sh
sed -i 's/\r//' ssh.sh
chmod +x ssh.sh
./ssh.sh
rm -rf ssh.sh

# install mariadb
rm -rf mariadb.sh
wget https://github.com/fenghshia/auto-install-script/releases/download/v.0.1.mariadb/mariadb.sh
sed -i 's/\r//' mariadb.sh
chmod +x mariadb.sh
./mariadb.sh
rm -rf mariadb.sh

# install nextcloud
rm -rf nextcloud.sh
wget https://github.com/fenghshia/auto-install-script/releases/download/v.0.1.nextcloud/nextcloud.sh
sed -i 's/\r//' nextcloud.sh
chmod +x nextcloud.sh
./nextcloud.sh
rm -rf nextcloud.sh

# install anaconda3
apt autoremove -y python3
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
chmod 777 Anaconda3-2020.11-Linux-x86_64.sh
./Anaconda3-2020.11-Linux-x86_64.sh -b -p /root/anaconda3
cat /root/.bashrc > /root/.bashrc.backup
echo "export PATH=\"/root/anaconda3/bin:\$PATH\"" >> /root/.bashrc
source ~/.bashrc

# install jupyterlab
python -m pip install -U jupyterlab
python -m jupyter notebook --generate-config
sed -i "s/# c.NotebookApp.allow_origin = ''/c.NotebookApp.allow_origin = '*'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.allow_root = False/c.NotebookApp.allow_root = True/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.port = 8888/c.NotebookApp.port = 8000/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '\/opt\/dataroot\/fenghshia\/files\/jupyter-space'/g" /root/.jupyter/jupyter_notebook_config.py
# from notebook.auth import passwd; passwd()
sed -i "s/# c.NotebookApp.password = ''/c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$uvElaY9qR78b86aAgVldgA\$gaZzeZ8fZzIYg6BiShCvag'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/# c.NotebookApp.token = '<generated>'/c.NotebookApp.token = 'ylsn74229986.'/g" /root/.jupyter/jupyter_notebook_config.py

touch jupyterctl
chmod 777 jupyterctl
echo "case \"\$1\" in
    start)
        \`nohup python -m jupyterlab >> /opt/dataroot/fenghshia/files/log/jupyter.log 2>&1 &\`
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
./jupyterctl start

# install wiki.js
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

sed -i "s/  type: postgres/  type: mysql/g" config.yml
sed -i "s/  port: 5432/  port: 8100/g" config.yml
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

# install bbr
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod 777 bbr.sh
./bbr.sh
rm -rf bbr.sh
# echo "是否重启系统: 1. 重启 2.不重启"
# read -p "Enter your name age id_card address:" n
# case $n in
# (1)
#     reboot
# esac

# install ssr
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod 777 shadowsocks-all.sh
./shadowsocks-all.sh
rm -rf shadowsocks-all.sh
chmod 777 shadowsocks_r_qr.png
mv shadowsocks_r_qr.png /opt/dataroot/fenghshia/files

# install syncthing
curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing
apt-get install -y apt-transport-https syncthing
syncthing -gui-address=0.0.0.0:8300

# install frp
wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
tar -xvmzf frp_0.20.0_linux_amd64.tar.gz
rm -rf frp_0.20.0_linux_amd64.tar.gz
mv frp_0.20.0_linux_amd64 frp
sed -i "s/bind_port = 7000/bind_port = 8400/g" ./frp/frps_full.ini
sed -i "s/kcp_bind_port = 7000/kcp_bind_port = 8400/g" ./frp/frps_full.ini
sed -i "s/bind_udp_port = 7001/kcp_bind_port = 8410/g" ./frp/frps_full.ini
sed -i "s/vhost_http_port = 80/vhost_http_port = 8480/g" ./frp/frps_full.ini
sed -i "s/vhost_https_port = 443/vhost_https_port = 8443/g" ./frp/frps_full.ini
sed -i "s/dashboard_port = 7500/dashboard_port = 8450/g" ./frp/frps_full.ini
sed -i "s/dashboard_user = admin/dashboard_user = fenghshia/g" ./frp/frps_full.ini
sed -i "s/dashboard_pwd = admin/dashboard_pwd = xuan89948632./g" ./frp/frps_full.ini
sed -i "s/log_file = ./frps.log/log_file = /opt/dataroot/fenghshia/files/log/frps.log/g" ./frp/frps_full.ini
touch /opt/dataroot/fenghshia/files/log/frps.log
sed -i "s/token = 12345678/token = xuan89948632./g" ./frp/frps_full.ini
sed -i "s/allow_ports = 2000-3000,3001,3003,4000-50000/allow_ports = 6000-7000/g" ./frp/frps_full.ini

echo "set frpctl"
touch ./frpctl
chmod 777 ./frpctl
echo "case \"\$1\" in
    start)
        \`nohup ./frp/frps -c ./frp/frps_full.ini > ./connect.log 2>&1 &\`
        ;;
    stop)
        \`nohup ps aux | grep frps | awk '{print \$2}' | xargs kill -9 2>&1 &\`
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    *)
        echo \"Usage: \$0 {start|stop|restart}\"
        exit 1
        ;;
esac" > ./frpctl
./frpctl start

# install aria2
apt-get install -y aria2
mkdir /etc/aria2
touch /etc/aria2/aria2.session
chmod 777 /etc/aria2/aria2.session
touch /etc/aria2/aria2.conf
echo "dir=/opt/dataroot/fenghshia/files/downloads
disable-ipv6=true

#打开rpc的目的是为了给web管理端用
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=8500
#断点续传
continue=true
input-file=/etc/aria2/aria2.session
save-session=/etc/aria2/aria2.session

#最大同时下载任务数
max-concurrent-downloads=20
save-session-interval=120

# Http/FTP 相关
connect-timeout=120
#lowest-speed-limit=10K
#同服务器连接数
max-connection-per-server=10
#max-file-not-found=2
#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=10M

#单文件最大线程数, 路由建议值: 5
split=10
check-certificate=false
#http-no-cache=true
" > /etc/aria2/aria2.conf
aria2c --conf-path=/etc/aria2/aria2.conf -D

# auto backup database
touch sqlautobackup.cron
sudo -u www-data touch /opt/dataroot/fenghshia/files/wikijs.sql
echo "0 21 * * * mysqldump -uroot -pxuan wikijs > /opt/dataroot/fenghshia/files/wikijs.sql" > sqlautobackup.cron
crontab sqlautobackup.cron
# crontab -l # 查看配置结果

# end
echo "nextcloud: 80/nextcloud
jupyterlab: 8000/
wiki.js: 8100/
shadowsocksr: 8200/
syncthing: 8300/
frp: 8400/
aria2: 8500/"
