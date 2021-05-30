FROM alpine:latest

ENV TLD="example.com,*.example.com example.org,*.example.org"
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config"

VOLUME ["config"]

COPY certbot.sh /bin/certbot/certbot.sh
RUN chmod +x /bin/certbot/certbot.sh &&\
	echo "0 */6 * * * /bin/certbot/certbot.sh" | crontab - &&\
	apk update &&\
	apk add gcc g++ libffi-dev openssl-dev py3-pip python3-dev py-cryptography &&\
	pip3 install -U pip &&\
	pip3 install -U certbot certbot-dns-luadns &&\
	# TODO: Remove Version Lock when certbot-1.16.0 is available
	pip3 install -U dns-lexicon==3.5

CMD ["crond", "-f"]