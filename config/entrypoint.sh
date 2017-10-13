#!/bin/bash
set -e

##################################################################
# Check if the ENV variable has been defined otherwise fallback on
# a default value. This value belongs to the first user created on
# the system
##################################################################
if [ "$UID" == 0 ]; then
    uid=1000;
else
    uid=${UID};
fi

if [ -z "${GID}" ]; then
    gid=1000;
else
    gid=${GID};
fi

echo "UID: $uid"
echo "GID: $gid"

##################################################################
# Setup permissions
##################################################################
data_dir="/var/www"

if [ ! -d "$data_dir" ]; then
  mkdir -p "$data_dir"
  echo 'Directory has been created'
fi

usermod -u "$uid" www-data && groupmod -g "$gid" www-data
chown -R www-data:root "$data_dir"

if  [ -d "$data_dir" ]; then
    chgrp -RH www-data "$data_dir"
    chmod -R g+w "$data_dir"
    find "$data_dir" -type d -exec chmod 2775 {} +
    find "$data_dir" -type f -exec chmod ug+rw {} +
fi

##################################################################
# Setup permissions for composer
##################################################################
composer_cache_dir="/var/www/.composer"
mkdir -p "$composer_cache_dir"
chown -R www-data:root "$composer_cache_dir"

if  [ -d "$composer_cache_dir" ]; then
    chgrp -R www-data "$composer_cache_dir"
    chmod -R g+w "$composer_cache_dir"
fi

composer_cache_dir="/var/www/.composer"
mkdir -p "$composer_cache_dir"
chown -R www-data:root "$composer_cache_dir"

if  [ -d "$composer_cache_dir" ]; then
    chgrp -R www-data "$composer_cache_dir"
    chmod -R g+w "$composer_cache_dir"
fi

# Keep PHP running
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

exec "$@"
