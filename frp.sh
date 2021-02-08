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
sed -i "s/token = 12345678/token = xuan89948632./g" ./frp/frps_full.ini
sed -i "s/allow_ports = 2000-3000,3001,3003,4000-50000/allow_ports = 6000-7000/g" ./frp/frps_full.ini

echo "set frpctl"
touch ./frpctl
chmod 777 ./frpctl
echo "case \"\$1\" in
    start)
        \`nohup ./frp/frps -c ./frp/frps_full.ini >> /dev/null 2>&1 &\`
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