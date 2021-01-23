#!/bin/sh

# Check for Enviroment Variables
if [[ ! "$CONFIG_DIR" ]]; then
	echo 'Enviroment Variable "CONFIG_DIR" is not set.' > /dev/stderr;
	exit 1
elif [[ ! "$EMAIL" ]]; then
	echo 'Enviroment Variable "EMAIL" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! -r "$CONFIG_DIR/luadns.ini" ]]; then
	echo "Credential file luadns.ini was not found in $CONFIG_DIR." > /dev/stderr;
	exit 1;
fi

# Run Certbot for Each Domain.
for SUBDOMAINS in $DOMAIN1 $DOMAIN2 $DOMAIN3 $DOMAIN4 $DOMAIN5; do
	if [[ $SUBDOMAINS ]]; then
		certbot certonly \
			--agree-tos \
			--expand \
			--config-dir "$CONFIG_DIR/certs" \
			--dns-luadns \
			--dns-luadns-credentials "$CONFIG_DIR/luadns.ini" \
			-d "$SUBDOMAINS" \
			-m "$EMAIL" \
			-n;
	fi
done;

# Copy live files to ssl.
if [[ -d "$CONFIG_DIR/ssl" ]]; then
	rm -rf "$CONFIG_DIR/ssl";
fi
cd $CONFIG_DIR;
cp -r /certs/live /ssl;
cd /ssl;
# Change Replace Symbolic Links with Original File (fix docker path mapping problems)
for DIRECTORY in $(ls -Al | sed -ne '/^d.*/p' | sed -Ee 's/^.* (.*)$/\1/'); do
	cd $DIRECTORY;
	for LINK in $(ls -Al | sed -ne '/^l.*/p' | sed -Ee 's/^.* (.*) -> (.*)$/\1%%\2/'); do
		NAME=$(echo $LINK | sed -Ee 's/^(.*)%%.*$/\1/');
		LOCATION=$(echo $LINK | sed -Ee 's/^.*%%(.*)$/\1/');
		mv $LOCATION $NAME;
	done;
	cd ..;
done;
