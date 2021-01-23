#!/bin/sh

# Check for Enviroment Variables
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

# Run Certbot for Each Domain.
for SUBDOMAINS in $DOMAIN1 $DOMAIN2 $DOMAIN3 $DOMAIN4 $DOMAIN5; do
	if [[ $SUBDOMAINS ]]; then
		certbot certonly \
			--agree-tos \
			--expand \
			--config-dir $CONFIG_DIR \
			--dns-luadns \
			--dns-luadns-credentials $LUADNS_PATH \
			-d $SUBDOMAINS \
			-m $EMAIL \
			-n;
	fi
done;

# Change Replace Symbolic Links with Original File (fix docker path mapping problems)
cd $CONFIG_DIR/live
for DIRECTORY in $(ls -Al | sed -ne '/^d.*/p' | sed -Ee 's/^.* (.*)$/\1/'); do
	cd $DIRECTORY;
	for LINK in $(ls -Al | sed -ne '/^l.*/p' | sed -Ee 's/^.* (.*) -> (.*)$/\1%%\2/'); do
		NAME=$(echo $LINK | sed -Ee 's/^(.*)%%.*$/\1/');
		LOCATION=$(echo $LINK | sed -Ee 's/^.*%%(.*)$/\1/');
		mv $LOCATION $NAME;
	done;
	cd ..;
done;
