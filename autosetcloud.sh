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
# 需要人工介入的放置在最前面
# install mariadb
runscript "0.1" "mariadb"

# install gitlab
runscript "0.1" "gitlab"

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

# install frp
runscript "0.1" "frp"

# install aria2
runscript "0.1" "aria2"

# setup cron
runscript "0.1" "cron"

# end
echo "---------------------------------------------
nextcloud:       80/nextcloud
---------------------------------------------
jupyterlab:      8000/
---------------------------------------------
wiki.js:         8100/
---------------------------------------------
gitlab:          8200/
---------------------------------------------
frp:             8300/
---------------------------------------------
aria2:           8400/
---------------------------------------------"
