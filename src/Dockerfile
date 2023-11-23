FROM debian:12

# Fix timezone issue
ENV TZ=utc
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt dist-upgrade -y

# Add a volume to hold SVN/GIT repo configs
RUN mkdir /config
VOLUME /config

# Install the relevant packages
RUN apt-get install -y vim git expect cron apache2 curl libapache2-mod-php php8.2-cli php8.2-yaml php8.2-zip php8.2-dom \
    subversion composer

# install satis through composer
WORKDIR /root
RUN composer create-project composer/satis --stability=dev --keep-vcs


# expose port 80 and 443 (ssl) for the web requests
EXPOSE 80
EXPOSE 443

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# It appears that the new apache requires these env vars as well
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV COMPOSER_HOME /root/.config/composer

# Add files as late as possible (docker caches)
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD apache-ssl-config.conf /etc/apache2/sites-available/default-ssl.conf
ADD startup.sh /root/docker-satis/startup.sh
ADD crons.conf /root/docker-satis/crons.conf
ADD update-satis.sh /root/docker-satis/update-satis.sh
ADD update-satis.tcl /root/docker-satis/update-satis.tcl

# Use the crontab file we just added.
RUN crontab /root/docker-satis/crons.conf

# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
CMD ["/bin/bash", "/root/docker-satis/startup.sh"]
