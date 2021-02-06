echo "start install app..."
sudo yum install -y openssl openssh-server
# sudo vim /etc/ssh/sshd_config
echo "start config ssh..."
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo "restart sshd..."
sudo systemctl restart sshd
echo "sshd install complete"
