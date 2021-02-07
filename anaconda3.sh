apt autoremove -y python3
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
chmod 777 Anaconda3-2020.11-Linux-x86_64.sh
./Anaconda3-2020.11-Linux-x86_64.sh -b -p /root/anaconda3
cat /root/.bashrc > /root/.bashrc.backup
echo "export PATH=\"/root/anaconda3/bin:\$PATH\"" >> /root/.bashrc
source ~/.bashrc