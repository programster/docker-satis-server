FROM debian:12

# Set to noninteractive script
ARG DEBIAN_FRONTEND=noninteractive

# Set timezone to prevent possible issues
ENV TZ=utc
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update the image
RUN apt-get update && apt-get dist-upgrade -y

# Install the relevant packages
RUN apt-get install -y \
    vim expect apache2 cron supervisor curl libapache2-mod-php8.2 php8.2-cli php8.2-zip php8.2-curl composer  \
    subversion git

# install satis through composer
RUN chown $USER:www-data /var/www \
    && cd /root \
    && composer create-project --keep-vcs --no-dev composer/satis:dev-main

# expose port 80 for sure. User can directly map 443 if they wish to.
EXPOSE 80

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"
ENV APACHE_LOCK_DIR="/var/lock/apache2"
ENV APACHE_PID_FILE="/var/run/apache2/apache2.pid"

RUN a2enmod rewrite headers

# replace the apache config
COPY apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Add our site configuration files to apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY apache-ssl-config.conf /etc/apache2/sites-available/apache-ssl-config.conf

# Set the crons.
COPY crons.conf /root/crons.conf
RUN crontab /root/crons.conf && rm /root/crons.conf

COPY --chown=root:root update-satis.sh /root/update-satis.sh
COPY --chown=root:root update-satis.tcl /root/update-satis.tcl

# Add supervisor config
COPY --chown=root:root supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# set /root to the workdir so if user enters container they will land there.
WORKDIR /root

# Add the startup file and use it on startup.
COPY --chown=root:root startup.sh /root/startup.sh
CMD ["/bin/bash", "/root/startup.sh"]
