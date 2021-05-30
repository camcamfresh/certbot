# Dockerfile & Shell Script for Certbot
Some simple code that retrieves and renews SSL certificates for multiple domains authenticated with LuaDNS.

The Dockerfile pulls from `alpine:latest` and installs the required dependencies for certbot & certbot's luadns plugin which is used for DNS authentication. 

Certbot is set to run every 6 hours (4 times/day) using cron. However, it can manually be run by running the following shell script found within the container: `/bin/certbot/certbot.sh`.

Certificates are obtained via a 'DOMAINS' environment variable. Comma-delineated domains will create a single certificate, whereas space-delineated domains create separate certificates.
The following values would result in three separate certificates with two encompassing multiple domains.
```dockerfile
ENV DOMAINS="example.com,*example.com example.org,*example.org vpn.example.org"
```

In addition to DOMAINS, other enviroment variables must be set for certbot to execute properly.
```dockerfile
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config"
```
 - EMAIL - a single email for certbot to use when requesting each certificate.
 - CONFIG_DIR - the container, folder path for configuration.
   - `luadns.ini` must have the domain's luadns email & api token.
   - `certbot/` contains certbot's pervious work and archives.
   - `certs/` contains the SSL certificate files. (Note: These are not symbolic links and should prevent any Docker volume mapping issues.)

It is highly recommended that one map the configuration directory when running the container; this will save certbot's previous work in the event of failure. In doing so, we decrease the chances of ever reaching the request rate limit for let's encrypt.

Enviroment variables should be set prior to even testing this container. 
`example.com` is a reserved TLD, and is automatically rejected by certbot.

```bash
docker run -e DOMAINS='example.com,*.example.com example.org,*.example.org vpn.example.org' -e EMAIL='email@example.com' -v /config/:/config/ camcamfresh/certbot
```

Using this current code requires the use of LuaDNS as a DNS provider. However it can quickly be changed to another DNS provider by forking the code and changing the dns-plugin to another supported DNS provider (see Certbot's website for available providers).
