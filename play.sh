#!/usr/bin/env bash
PLAYBOOK="$1"

if [[ -z $PLAYBOOK ]]; then
  echo "You need to pass a playbook as argument to this script."
  exit 1
fi

export SSL_CERT_FILE=$(pwd)/common_files/cacert.pem
export ANSIBLE_HOST_KEY_CHECKING=False

if [[ ! -f "$SSL_CERT_FILE" ]]; then
  curl -O http://curl.haxx.se/ca/cacert.pem
fi

ansible-playbook -vvv "$PLAYBOOK"