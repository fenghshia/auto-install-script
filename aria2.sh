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
touch ./aria2cctl
chmod 777 ./aria2cctl
echo "case \"\$1\" in
    start)
        \`nohup aria2c --conf-path=/etc/aria2/aria2.conf >> /opt/dataroot/fenghshia/files/log/aria2.log 2>&1 &\`
        ;;
    stop)
        \`nohup ps aux | grep aria2c | awk '{print \$2}' | xargs kill -9 2>&1 &\`
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    *)
        echo \"Usage: \$0 {start|stop|restart}\"
        exit 1
        ;;
esac" > ./aria2cctl
./aria2cctl start
