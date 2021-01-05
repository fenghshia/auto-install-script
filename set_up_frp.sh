wget https://github.com/fatedier/frp/releases/download/v0.34.3/frp_0.34.3_linux_amd64.tar.gz
echo "unzip frp"
tar -xvmzf frp_0.34.3_linux_amd64.tar.gz
rm -rf frp_0.34.3_linux_amd64.tar.gz
mv frp_0.34.3_linux_amd64 frp
echo "modify config"
sed -i "s/dashboard_pwd = admin/dashboard_pwd = 89948632/g" ./frp/frps_full.ini
sed -i "s/token = 12345678/token = xuan89948632./g" ./frp/frps_full.ini
sed -i "s/allow_ports = 2000-3000,3001,3003,4000-50000/allow_ports = 6000-6999/g" ./frp/frps_full.ini

echo "set frpctl"
touch ./frp/frpctl
chmod 777 ./frp/frpctl
echo "case \"\$1\" in" > ./frp/frpctl
echo "    start)" >> ./frp/frpctl
echo "        \`nohup ./frps -c ./frps_full.ini > ./connect.log 2>&1 &\`" >> ./frp/frpctl
echo "        ;;" >> ./frp/frpctl
echo "    stop)" >> ./frp/frpctl
echo "        \`nohup ps aux | grep frps | awk '{print \$2}' | xargs kill -9 2>&1 &\`" >> ./frp/frpctl
echo "        ;;" >> ./frp/frpctl
echo "    restart)" >> ./frp/frpctl
echo "        \$0 stop" >> ./frp/frpctl
echo "        \$0 start" >> ./frp/frpctl
echo "        ;;" >> ./frp/frpctl
echo "    *)" >> ./frp/frpctl
echo "        echo \"Usage: \$0 {start|stop|restart}\"" >> ./frp/frpctl
echo "        exit 1" >> ./frp/frpctl
echo "        ;;" >> ./frp/frpctl
echo "esac" >> ./frp/frpctl

echo "start frp"
cd frp
./frpctl start
















