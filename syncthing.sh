curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing
apt-get install -y apt-transport-https syncthing
touch ./syncthingctl
chmod 777 ./syncthingctl
echo "case \"\$1\" in
    start)
        \`nohup syncthing -gui-address=0.0.0.0:8300 >> /opt/dataroot/fenghshia/files/log/syncthing.log 2>&1 &\`
        ;;
    stop)
        \`nohup ps aux | grep syncthing | awk '{print \$2}' | xargs kill -9 2>&1 &\`
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    *)
        echo \"Usage: \$0 {start|stop|restart}\"
        exit 1
        ;;
esac" > ./syncthingctl
./syncthingctl start
