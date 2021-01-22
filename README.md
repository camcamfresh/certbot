# camcamfresh/certbot

A docker image for an Unraid Server that retrieves and renews SSL certificates for multiple top level domains (TLDs).

Currently, up to 5 TLDs can be specified via enviroment variable.
```dockerfile
ENV DOMAIN1="example.com,*.example.com"
ENV DOMAIN2="example.org,*.example.org"
...
ENV DOMAIN5="example.net,*.example.net"
```

In addition to TLDs, other enviroment variables must be set to execute certbot properly.
```dockerfile
ENV EMAIL="email@example.com"
ENV CONFIG_DIR="/config/certs"
ENV LUADNS_PATH="/config/luadns.ini"
```

These enviroment variables should be set prior to testing this container. `example.com` is a reserved TLD, and is automatically rejected by certbot.

```bash
docker run -e DOMAIN1='example.com,*.example.com' DOMAIN1='example.org,*.example.org' -e EMAIL='email@example.com' -v /luadns.ini:/config/luadns.ini camcamfresh/certbot
```