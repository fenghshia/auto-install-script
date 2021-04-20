# auto backup database
touch schedule.cron
sudo -u www-data touch /opt/dataroot/fenghshia/files/wikijs.sql
echo "0 21 * * * mysqldump -uroot -pxuan wikijs > /opt/dataroot/fenghshia/files/wikijs.sql
0 21 * * * cd /var/www/nextcloud && sudo -u www-data php occ files:scan --all
0 21 * * * gitlab-rake gitlab:backup:create && mv /var/opt/gitlab/backups/* /opt/dataroot/fenghshia/files/GitlabBackup/" > schedule.cron
crontab schedule.cron
# crontab -l # 查看配置结果