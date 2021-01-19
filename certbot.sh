#!/bin/sh

if [[ ! $DOMAINS ]]; then
	echo 'Enviroment Variable "DOMAINS" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! $EMAIL ]]; then
	echo 'Enviroment Variable "EMAIL" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! $CONFIG_DIR ]]; then
	echo 'Enviroment Variable "CONFIG_DIR" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! -r $LUADNS_PATH ]]; then
	echo "Credential file $LUADNS_PATH was not found." > /dev/stderr;
	exit 1;
fi

for DOMAIN in $(echo $DOMAINS | sed 's/,/ /g'); do
	certbot certonly \
		--agree-tos \
		--config-dir $CONFIG_DIR \
		--dns-luadns \
		--dns-luadns-credentials $LUADNS_PATH \
		-d $DOMAIN \
		-m $EMAIL \
		-n;
done;