#!/bin/bash
# Please do not manually call this file!
# This script is run by the docker container when it starts.

# Stop if anything fails
set -e

# Ensure apache is not running
service apache2 stop

# If SSL is enabled, then check the certs have been provided as expected and enable SSL in apache.
if [[ -n ${SSL_ENABLED} && "${SSL_ENABLED}" -eq 1 ]]; then

    if ! [ -f "/etc/apache2/ssl/cert.pem" ]; then
        echo "SSL is enabled, but no cert.pem file was provided!"
        exit 1
    fi

    if ! [ -f "/etc/apache2/ssl/privkey.pem" ]; then
        echo "SSL is enabled, but no privkey.pem file was provided!"
        exit 1
    fi

    if ! [ -f "/etc/apache2/ssl/chain.pem" ]; then
        echo "SSL is enabled, but no chain.pem file was provided!"
        exit 1
    fi

    a2enmod ssl
    a2ensite apache-ssl-config
fi

# update satis right off the bat
/bin/bash /root/update-satis.sh 0

# Start the cron service in the foreground
# We dont run apache in the FG, so that we can restart apache without container
# exiting.
service cron start

# Start supervisord to manage all processes
/usr/bin/supervisord
