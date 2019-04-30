#!/bin/bash
#####	一键安装Aria2 + AriaNg		#####
#####	作者：fenghshia						#####
#####	更新时间：2019-04-29				#####

#导入环境变量
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH

#安装Aria2
function install_aria2(){
	#更新软件
	#pacman -SYu
	pacman -SY curl
	pacman -SY aria2
}
#配置文件
function dealconf(){
	#创建目录和文件
	mkdir -p /srv/MAA/
	touch /srv/MAA/aria2.session
	touch /srv/MAA/aria2.log
	cp aria2.conf /srv/MAA/
	cp upbt.sh /srv/MAA/
	chmod +x /srv/MAA/upbt.sh
	chmod +x ccaa
	cp ccaa /usr/sbin
}
#设置账号密码
function setting(){
	echo '-------------------------------------------------------------'
	read -p "设置下载路径（请填写绝对地址，默认/srv/aria2download/）:" downpath
	read -p "Aria2 RPC 密钥:(字母或数字组合，不要含有特殊字符):" secret
	#如果Aria2密钥为空
	while [ -z "${secret}" ]
	do
		read -p "Aria2 RPC 密钥:(字母或数字组合，不要含有特殊字符):" secret
	done

	#如果下载路径为空，设置默认下载路径
	if [ -z "${downpath}" ]
	then
		downpath='/srv/aria2download/'
	fi

	#执行替换操作 sed执行替换的用法:sed 's/要被取代的字串/新的字串/g'
	mkdir -p ${downpath}
	sed -i "s%dir=%dir=${downpath}%g" /srv/MAA/aria2.conf
	sed -i "s/rpc-secret=/rpc-secret=${secret}/g" /srv/MAA/aria2.conf
	#更新tracker
	bash ./upbt.sh

	#安装AriaNg
	wget https://github.com/mayswind/AriaNg-DailyBuild/archive/master.zip
	unzip master.zip
	cp -a AriaNg-DailyBuild-master /srv/MAA/AriaNg

	#启动服务
	nohup aria2c --conf-path=/srv/MAA/aria2.conf > /srv/MAA/aria2.log 2>&1 &
	nohup caddy -conf="/etc/ccaa/caddy.conf" > /etc/ccaa/caddy.log 2>&1 &

	#获取ip
	osip=$(curl -4s https://api.ip.sb/ip)

	echo '-------------------------------------------------------------'
	echo "大功告成，请访问: http://${osip}:6080/"
	echo '用户名:' ${caddyuser}
	echo '密码:' ${caddypass}
	echo 'Aria2 RPC 密钥:' ${secret}
	echo '-------------------------------------------------------------'
}
