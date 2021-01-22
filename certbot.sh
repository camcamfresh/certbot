#!/bin/sh

if [[ ! $EMAIL ]]; then
	echo 'Enviroment Variable "EMAIL" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! $CONFIG_DIR ]]; then
	echo 'Enviroment Variable "CONFIG_DIR" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! -r $LUADNS_PATH ]]; then
	echo "Credential file $LUADNS_PATH was not found." > /dev/stderr;
	exit 1;
fi

for SUBDOMAINS in $DOMAIN1 $DOMAIN2 $DOMAIN3 $DOMAIN4 $DOMAIN5; do
	if [[ $SUBDOMAINS ]]; then
		certbot certonly \
			--agree-tos \
			--config-dir $CONFIG_DIR \
			--dns-luadns \
			--dns-luadns-credentials $LUADNS_PATH \
			-d $SUBDOMAINS \
			-m $EMAIL \
			-n;
	fi
done;