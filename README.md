# Dockerfile & Shell Script for Certbot
Some simple code that retrieves and renews SSL certificates for multiple domains authenticated with LuaDNS.

The Dockerfile pulls from `alpine:latest` and installs the required dependencies for certbot & certbot's luadns plugin which is used for DNS authentication. 

Certbot is set to run every 6 hours (4 times/day) using cron. However, it can manually be run by running the following shell script found within the container: `/bin/certbot/certbot.sh`.

There are 3 environment variables that must be set in order for certbot to execute properly.
```dockerfile
ENV DOMAINS="example.com,*example.com example.org,*example.org vpn.example.org"
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config"
```


 - DOMAINS - a string of domains to obtain certificates.
   - Comma-delineated domains will create a single certificate
   - Space-delineated domains create separate certificates.
   - The `DOMAINS` value above would result in three separate certificates (two encompassing multiple domains).
 - EMAIL - a single email for certbot to use when requesting each certificate.
 - CONFIG_DIR - the container, folder path for configuration.
   - `luadns.ini` must have the domain's luadns email & api token.
   - `certs/` contains the SSL certificate files. (Note: These are not symbolic links and should prevent any Docker volume mapping issues.)
   - `data/` contains certbot's pervious work and archives.

It is highly recommended that one map the configuration directory when running the container; this will save certbot's previous work in the event of failure. In doing so, we decrease the chances of ever reaching the request rate limit for let's encrypt.

Enviroment variables should be set prior to testing this container. 
`example.com` is a reserved TLD and will be automatically rejected by certbot.

```bash
docker run -e DOMAINS='example.com,*.example.com example.org,*.example.org vpn.example.org' -e EMAIL='email@example.com' -v /config/:/config/ camcamfresh/certbot
```

Using this current code requires the use of LuaDNS as a DNS provider. However it can quickly be changed to another DNS provider by forking the code and changing the dns-plugin to another supported DNS provider (see Certbot's website for available providers).
