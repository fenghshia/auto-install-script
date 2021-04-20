# 由于汉化原因
# 目前只支持12.3.5版本gitlab
# 12.3.5版本gitlab仅最高支持ubuntu 18.04
apt-get install -y curl openssh-server ca-certificates tzdata perl
# 此步需要人工干预
apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
# 取得外网ip
ipaddr=$(curl v4.ident.me)
EXTERNAL_URL="http://${ipaddr}:8600" apt-get install gitlab-ce=12.3.5-ce.0
# 取得当前安装的版本
gitlab_version=$(sudo cat /opt/gitlab/embedded/service/gitlab-rails/VERSION)
git clone https://gitlab.com/xhang/gitlab.git
cd gitlab
git diff v${gitlab_version} v${gitlab_version}-zh > ../${gitlab_version}-zh.diff
cd ..
gitlab-ctl stop
patch -d /opt/gitlab/embedded/service/gitlab-rails -p1 < ${gitlab_version}-zh.diff
gitlab-ctl start
# 调整email发送配置
email_config="gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = \"smtp.qq.com\"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = \"754587525@qq.com\"
gitlab_rails['smtp_password'] = \"ipectiirqutkbefb\"
gitlab_rails['smtp_domain'] = \"smtp.qq.com\"
gitlab_rails['gitlab_email_from'] = \"754587525@qq.com\"
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['smtp_authentication'] = \"login\"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true"
sed -i "s/# gitlab_rails['smtp_tls'] = true/${email_config}/g" /etc/gitlab/gitlab.rb
