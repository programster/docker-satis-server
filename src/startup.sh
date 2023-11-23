# Please do not manually call this file!
# This script is run by the docker container when it is "run"

if [ "$SSL_ENABLED" = true ] ; then
    a2enmod ssl
    a2ensite default-ssl
else
    a2dissite default-ssl
    a2dismod ssl
fi

# Make sure apache is not running
service apache2 stop

# Run the apache process in the background
source /etc/apache2/envvars
/usr/sbin/apache2 -D APACHE_PROCESS &

# update satis right off the bat
cd /root/docker-satis
/bin/bash update-satis.sh

# Start the cron service in the foreground
# We dont run apache in the FG, so that we can restart apache without container
# exiting.
cron -f
