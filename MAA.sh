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
	#pacman -Syu
	pacman -S curl
	pacman -S epel-release
	pacman -S aria2
	#验证aria2是否安装成功，如果没有换rpm安装
	if [ ! -f "/usr/bin/aria2c" ];then
		wget -c http://soft.xiaoz.org/linux/aria2-1.34.0-linux-gnu-64bit-build1.tar.bz2
		tar jxvf aria2-1.34.0-linux-gnu-64bit-build1.tar.bz2
		cd aria2-1.34.0-linux-gnu-64bit-build1
		make install
		cd ..
	fi
}
