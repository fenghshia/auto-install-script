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
