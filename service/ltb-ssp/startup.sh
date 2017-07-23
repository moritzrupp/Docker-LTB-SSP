#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-ltb-ssp-first-start-done"

log-helper info "Set nginx http config..."
ln -sf ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/nginx/ltb-ssp.conf /etc/nginx/conf.d/

#
# LTB SSP directory is empty, we use the bootstrap
#
if [ ! "$(ls -A -I lost+found /var/www/ltb-ssp)" ]; then

  log-helper info "Bootstrap LTB Self-Service Password..."

  cp -R /var/www/ltb-ssp_bootstrap/* /var/www/ltb-ssp
  rm -rf /var/www/ltb-ssp_bootstrap
  rm -f /var/www/ltb-ssp/config/config.inc.php
fi

# if there is no config
if [ ! -e "/var/www/ltb-ssp/config/config.inc.php" ]; then

	# on container first start customize the container config file
	if [ ! -e "$FIRST_START_DONE" ]; then
		log-helper info "Creating config file..."

		# keyphrase
		get_salt() {
	    	salt=$(</dev/urandom tr -dc '1324567890#<>,()*.^@$% =-_~;:/{}[]+!`azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN' | head -c64 | tr -d '\\')
	    }
		sed -i "s|{{ LTBSSP_KEYPHRASE }}|${salt}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php

		####
		## Set all relevant configs from ENV
		####
		
		# LDAP Server
		sed -i "s|{{ LTBSSP_LDAP_URL }}|ldap://${LTBSSP_LDAP_URL}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php

		# Authentication
		binddn="cn=${LTBSSP_USER},${LTBSSP_BASE}"
		sed -i "s|{{ LTBSSP_USER }}|${binddn}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php
		sed -i "s|{{ LTBSSP_BASE }}|${LTBSSP_BASE}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php
		sed -i "s|{{ LTBSSP_PASSWORD }}|${LTBSSP_PASSWORD}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php

		# Configuration
		sed -i "s|{{ LTBSSP_SHADOW_LAST_CHANGE }}|${LTBSSP_SHADOW_LAST_CHANGE}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php
		sed -i "s|{{ LTBSSP_HASH }}|${LTBSSP_HASH}|g" ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php

		touch $FIRST_START_DONE
	fi

	log-helper debug "link ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php to /var/www/ltb-ssp/conf/config.inc.php"
	cp -f ${CONTAINER_SERVICE_DIR}/ltb-ssp/assets/config.inc.php /var/www/ltb-ssp/conf/config.inc.php
fi

# fix file permission
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;
chown www-data:www-data -R /var/www

# symlinks special (chown -R don't follow symlinks)
chown www-data:www-data /var/www/ltb-ssp/conf/config.inc.php
chmod 400 /var/www/ltb-ssp/conf/config.inc.php

exit 0
