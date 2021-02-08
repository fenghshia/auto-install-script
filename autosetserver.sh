apt update
apt -y upgrade

runscript(){
    rm -rf $2.sh
    wget https://github.com/fenghshia/auto-install-script/releases/download/v.$1.$2/$2.sh
    sed -i 's/\r//' $2.sh
    chmod +x $2.sh
    ./$2.sh
    rm -rf $2.sh
}

# install mariadb
runscript "0.1" "mariadb"

# install ssh
runscript "0.1" "ssh"

# install nextcloud
runscript "0.1" "nextcloud"

# install anaconda3
runscript "0.1" "anaconda3"

# install jupyterlab
runscript "0.1" "jupyter"

# install wiki.js
rm -rf wiki.js.sh;
wget https://github.com/fenghshia/auto-install-script/releases/download/v.0.1.wikijs/wiki.js.sh;
chmod +x wiki.js.sh;
sed -i 's/\r//' wiki.js.sh;
./wiki.js.sh;
rm -rf wiki.js.sh;

# install syncthing
runscript "0.1" "syncthing"

# install frp
runscript "0.1" "frp"

# install aria2
runscript "0.1" "aria2"

# install bbr
runscript "0.1" "bbr"

# install ssr
runscript "0.1" "ssr"

# end
echo "---------------------------------------------
nextcloud:       80/nextcloud
---------------------------------------------
jupyterlab:      8000/
---------------------------------------------
wiki.js:         8100/
---------------------------------------------
shadowsocksr:    8200/
---------------------------------------------
syncthing:       8300/
---------------------------------------------
frp:             8400/
---------------------------------------------
aria2:           8500/
---------------------------------------------"
