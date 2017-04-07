#!/bin/bash
#
# Obtains an SSL certificate & private key using
# LetsEncrypt. If the certificate is already present, then
# just checks for an update instead of applying for a new one.
#
FQDN="{{ machine_names }}-{{ project_id }}.{{ project_domain }}"
CERT_SRC_DIR="/etc/letsencrypt/live/${FQDN}"

if [ -d "$CERT_SRC_DIR" ]; then
	/usr/bin/certbot renew --quiet >> /var/log/le-renew.log
   	if [ "$?" -eq 1 ]; then
   		# An updated cert was received, so restart nginx
   		systemctl restart nginx
   	fi
else
   	/usr/bin/certbot certonly --standalone --agree-tos --email "{{ ssl_email }}" -d "${FQDN}"
fi
