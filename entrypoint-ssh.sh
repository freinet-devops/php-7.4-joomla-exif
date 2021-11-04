#!/bin/bash

# create public dir if not existent
chown www-data:www-data /var/www

echo "chown working directory to www-data"
chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /var/www/logs
[ -d $WEBROOT ] || mkdir $WEBROOT
chown -R www-data:www-data $WEBROOT

if [ -z "${SSH_USER}" ]; then
  echo "Need username as SSH_USER env variable.. Abnormal exit ..."
  exit 1
else
  echo "Create user ${SSH_USER}"
  getent passwd $SSH_USER || echo "${SSH_USER}:x:82:82:Linux User,,,:/var/www:/bin/bash" >> /etc/passwd
fi

if [ ! -z "${AUTHORIZED_KEYS}" ]; then
  echo "Populating /var/www/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
  [ -d /var/www/.ssh] || mkdir /var/www/.ssh
  echo "${AUTHORIZED_KEYS}" > /var/www/.ssh/authorized_keys
fi
if [ ! -z "${SSH_PASSWORD}" ]; then
  echo "Set password for ${SSH_USER} from SSH_PASSWORD env variable ..."
  echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd
fi

# Execute the CMD from the Dockerfile:
exec "$@"

# Drop root privileges and invoke the entrypoint
#--------------------------------------
#su - "$SSH_USER" -- "$@"