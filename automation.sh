sudo apt update -y

ps cax | grep httpd
if [ $? -eq 0 ]; then
 echo "Process is running."
else
 systemctl start apache2.service

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo "$service is running!!!"
else
/etc/init.d/$service start
fi

SERVICE_NAME="httpd"

if ! systemctl is-enabled $SERVICE_NAME >/dev/null 2>&1; then
   
    systemctl enable $SERVICE_NAME
fi

if ! systemctl is-active $SERVICE_NAME >/dev/null 2>&1; then
   
    systemctl start $SERVICE_NAME
fi

if [ ! -f /var/www/html/inventory.html ]; then
  
    cat > /var/www/html/inventory.html <<EOF
<!DOCTYPE html>
<html>
<head>
	<title>Archived Logs Inventory</title>
</head>
<body>
	<h1>Archived Logs Inventory</h1>
	<p>Metadata of the archived logs will be listed here.</p>
</body>
</html>
EOF
fi

cd /var/log/apache2

timestamp=$(date '+%d%m%Y-%H%M%S')

sudo tar -cvzf bharath-httpd-logs-$timestamp.tar.gz access.log error.log other_vhosts_access.log

aws s3 cp bharath-httpd-logs-$timestamp.tar.gz s3://s3newubuntu/bharath-httpd-logs-${timestamp}.tar
