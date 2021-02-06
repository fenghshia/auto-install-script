# install bbr
sudo mkdir dataroot
sudo wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
sudo chmod 777 bbr.sh
sudo ./bbr.sh
sudo rm -rf bbr.sh
sudo mv install_bbr.log dataroot
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
sudo mv shadowsocks_r_qr.png dataroot

sudo chmod -R 777 dataroot

