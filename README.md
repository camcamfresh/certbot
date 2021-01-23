# Dockerfile & Shell Script for Certbot
Some simple code that retrieves and renews SSL certificates for multiple top level domains (TLDs).

The Dockerfile pulls from `alpine:latest` and installs the required dependencies for certbot & certbot's luadns plugin which is used for DNS authentication. 

Certbot is set to run every 6 hours (4 times/day) using cron. However, it can manually be run by running the following shell script found within the container: `/bin/certbot/certbot.sh`.

Currently, up to 5 TLDs can be specified via enviroment variable.
```dockerfile
ENV DOMAIN1="example.com,*.example.com"
ENV DOMAIN2="example.org,*.example.org"
...
ENV DOMAIN5="example.net,*.example.net"
```

In addition to the TLD(s), other enviroment variables must be set for certbot to execute properly.
```dockerfile
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config/certs"
ENV LUADNS_PATH="/config/luadns.ini"
```
 - EMAIL - a single email for certbot to use when requesting certificates.
 - CONFIG_DIR - the container, folder path where certbot should save it's work.
 - LUADNS_PATH - the container, file path where luadns.ini file can be found.

These enviroment variables should be set prior to testing this container. `example.com` is a reserved TLD, and is automatically rejected by certbot.

```bash
docker run -e DOMAIN1='example.com,*.example.com' DOMAIN1='example.org,*.example.org' -e EMAIL='email@example.com' -v /luadns.ini:/config/luadns.ini camcamfresh/certbot
```

