#!/bin/bash
#
# Obtains an SSL certificate & private key using
# LetsEncrypt. If the certificate is already present, then
# just checks for an update instead of applying for a new one.
#
FQDN="{{ machine_names }}-{{ project_id }}.{{ project_domain }}"
CERT_SRC_DIR="/etc/letsencrypt/live/${FQDN}"
CERT_DEST_DIR="{{ jenkins_home }}/ssl"

copy2jenkins () {
	mkdir -p ${CERT_DEST_DIR}
	/usr/bin/openssl rsa -in "${CERT_SRC_DIR}/privkey.pem" -out "${CERT_DEST_DIR}/privkey-rsa.pem"
	cp "${CERT_SRC_DIR}/fullchain.pem" ${CERT_DEST_DIR}
}

if [ -d "$CERT_SRC_DIR" ]; then
	/usr/bin/certbot renew --quiet >> /var/log/le-renew.log
   	if [ "$?" -eq 1 ]; then
		copy2jenkins
		docker stop jenkins
		docker start jenkins
   	fi
else
   	/usr/bin/certbot certonly --standalone --agree-tos --email "{{ ssl_email }}" -d "${FQDN}"
	copy2jenkins
fi
