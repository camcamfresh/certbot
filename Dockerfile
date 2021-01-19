FROM alpine:latest

ENV DOMAINS="*.example.com"
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config/certs"
ENV LUADNS_PATH="/config/luadns.ini"

VOLUME ["config"]

COPY certbot.sh /certbot.sh
RUN chmod +x /certbot.sh &&\
	echo "0 0 * * * /certbot.sh" | crontab - &&\
	apk update &&\
	apk add gcc g++ libffi-dev openssl-dev py3-pip python3-dev &&\
	pip3 install -U pip &&\
	pip3 install -U certbot certbot-dns-luadns

CMD ["crond", "-f"]