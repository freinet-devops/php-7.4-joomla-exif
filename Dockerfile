FROM joomla:php7.4-fpm-alpine

LABEL summary="joomla-ready fpm image with exif extension" \
      version="php7.4" \
      name="freinet/joomla-exif:php7.4-fpm-alpine" \
      maintainer="Sebastian Pitsch <pitsch@freinet.de>"

# add sshd (see https://github.com/Praqma/alpine-sshd)

USER root

RUN apk add exiftool\
    && docker-php-ext-configure exif\
    && docker-php-ext-install exif\
    && docker-php-ext-enable exif

RUN apk add --no-cache openssh rsync busybox-suid mysql-client\
    && ssh-keygen -A && echo 'StrictModes no' >> /etc/ssh/sshd_config \
    && echo 'Welcome to Alpine' > /etc/motd \
    && echo '--------------------------------------------------------------------------------' >> /etc/motd \
    && php -v >> /etc/motd \
    && echo -e '--------------------------------------------------------------------------------\n' >> /etc/motd

COPY entrypoint-ssh.sh /entrypoint-ssh.sh
RUN chmod +x /entrypoint-ssh.sh
