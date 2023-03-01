cd /var/log/apache2

timestamp=$(date '+%d%m%Y-%H%M%S')

sudo tar -cvzf bharath-httpd-logs-$timestamp.tar.gz access.log error.log other_vhosts_access.log

aws s3 cp bharath-httpd-logs-$timestamp.tar.gz s3://s3newubuntu/bharath-httpd-logs-${timestamp}.tar
