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

# Copy SSL Certificates in certs/live to /ssl.
LIVE="$CONFIG_DIR/certs/live";
if [[ -d "$LIVE" ]]; then
	[[ -d "$CONFIG_DIR/ssl" ]] || mkdir "$CONFIG_DIR/ssl";
	
	# Loop through each directory in /certs/live
	for DIRECTORY in $(ls -Al "$LIVE" | sed -ne '/^d.*/p' | sed -Ee 's/^.* (.*)$/\1/'); do
		[[ -d "CONFIG_DIR/ssl/$DIRECTORY" ]] || mkdir "CONFIG_DIR/ssl/$DIRECTORY";
		
		# Loop through each symbolic link in directory
		for LINK in $(ls -Al "$LIVE/$DIRECTORY" | sed -ne '/^l.*/p' | sed -Ee 's/^.* (.*) -> (.*)$/\1;\2/'); do		
			NAME=$(echo $LINK | sed -Ee 's/^(.*);.*$/\1/');
			LOCATION=$(echo $LINK | sed -Ee 's/^.*;\.\.\/\.\.\/(.*)$/\1/');
			cp "$CONFIG_DIR/certs/$LOCATION" "$CONFIG_DIR/ssl/$DIRECTORY/$NAME";
		done;
	done;
fi
