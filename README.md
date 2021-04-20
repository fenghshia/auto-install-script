# 功能
~~根据 Google Cloud Platform 的ubuntu 20.04 LTS 版本设计自动化安装脚本~~  
由于gitlab汉化版本问题, ubuntu版本降低到18.04 LTS 版本  
该仓库代码可能需要重构部分  
1. create_vpc_shell.py->生成配置防火墙策略和vpc实例的脚本
2. autosetssh.sh->自动安装ssh以及配置
3. autosetcloud.sh->自动安装anaconda3、aria2、nextcloud、frp、gitlab、mariadb、jupyterlab、wiki.js以及配置, 且配置自动备份定时任务
4. 由于syncthing同步文件的速度过慢, 且不能透过代理, 表现还没有nextcloud的桌面程序优秀, 因此删除syncthing的相关代码
# 计划脚本
1. surface自动配置软件脚本
2. 台式自动配置软件脚本