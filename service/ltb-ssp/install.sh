#!/bin/bash -e
# this script is run during the image build

mkdir -p /var/www/tmp
chown www-data:www-data /var/www/tmp

# remove nginx default host
#ls -l /etc/nginx/sites-enabled
rm /etc/nginx/conf.d/default.conf
rm -rf /var/www/html

# delete unnecessary files
rm -rf /var/www/ltb-ssp_bootstrap/{LICENCE,README.md}