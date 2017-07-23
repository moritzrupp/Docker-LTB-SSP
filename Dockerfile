FROM osixia/web-baseimage:1.0.0
MAINTAINER Moritz Rupp <moritz.rupp@gmail.com>

ENV LTBSSP_VERSION 1.0
ENV LTBSSP_SHA256 1de8c652e34633008559054aa2173f3afe3c3ce4

# Download nginx from apt-get and clean apt-get files
# Download nginx from apt-get and clean apt-get files
RUN apt-get -y update \
	&& /container/tool/add-multiple-process-stack \
	&& /container/tool/add-service-available :nginx :php5-fpm \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       php5-ldap \
       php5-mcrypt \
	&& curl -o ltb-ssp.tar.gz -SL http://ltb-project.org/archives/ltb-project-self-service-password-${LTBSSP_VERSION}.tar.gz \
    #&& echo "$LTBSSP_SHA256 *ltb-ssp.tar.gz" | sha1sum -c - \
    && mkdir -p /var/www/ltb-ssp_bootstrap /var/www/ltb-ssp \
    && tar -xzf ltb-ssp.tar.gz --strip 1 -C /var/www/ltb-ssp_bootstrap \
    && apt-get remove -y --purge --auto-remove curl \
    && rm ltb-ssp.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env directory
ADD environment /container/environment/99-default

VOLUME ["/var/www/ltb-ssp"]

# Expose default http and https ports
EXPOSE 80 443