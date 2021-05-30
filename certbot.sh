#!/bin/sh

# Check for Enviroment Variables
if [[ ! "$CONFIG_DIR" ]]; then
	echo 'Enviroment Variable "CONFIG_DIR" is not set.' > /dev/stderr;
	exit 1
elif [[ ! "$EMAIL" ]]; then
	echo 'Enviroment Variable "EMAIL" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! "$DOMAINS" ]]; then
	echo 'Environment Variable "DOMAINS" is not set.' > /dev/stderr;
	exit 1;
elif [[ ! -r "$CONFIG_DIR/luadns.ini" ]]; then
	echo "Credential file luadns.ini was not found in $CONFIG_DIR." > /dev/stderr;
	exit 1;
fi

# Run Certbot for Each Domain.
for CERT_DOMAIN in $DOMAINS; do
	if [[ $CERT_DOMAIN ]]; then
		certbot certonly \
			--agree-tos \
			--expand \
			--config-dir "$CONFIG_DIR/data" \
			--dns-luadns \
			--dns-luadns-credentials "$CONFIG_DIR/luadns.ini" \
			-d "$CERT_DOMAIN" \
			-m "$EMAIL" \
			-n;
	fi
done;

# Copy SSL Certificates in data/live to /certs.
LIVE="$CONFIG_DIR/data/live";
if [[ -d "$LIVE" ]]; then
	[[ -d "$CONFIG_DIR/certs" ]] || mkdir "$CONFIG_DIR/certs";
	
	# Loop through each directory in /data/live
	for DIRECTORY in $(ls -Al "$LIVE" | sed -ne '/^d.*/p' | sed -Ee 's/^.* (.*)$/\1/'); do
		[[ -d "$CONFIG_DIR/certs/$DIRECTORY" ]] || mkdir "$CONFIG_DIR/certs/$DIRECTORY";
		
		# Loop through each symbolic link in directory
		for LINK in $(ls -Al "$LIVE/$DIRECTORY" | sed -ne '/^l.*/p' | sed -Ee 's/^.* (.*) -> (.*)$/\1;\2/'); do		
			NAME=$(echo $LINK | sed -Ee 's/^(.*);.*$/\1/');
			LOCATION=$(echo $LINK | sed -Ee 's/^.*;\.\.\/\.\.\/(.*)$/\1/');
			cp "$CONFIG_DIR/data/$LOCATION" "$CONFIG_DIR/certs/$DIRECTORY/$NAME";
		done;
	done;
fi
