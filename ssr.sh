wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod 777 shadowsocks-all.sh
./shadowsocks-all.sh
rm -rf shadowsocks-all.sh
chmod 777 shadowsocks_r_qr.png
mv shadowsocks_r_qr.png /opt/dataroot/fenghshia/files