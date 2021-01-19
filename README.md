# camcamfresh/certbot

A docker image for my unraid server that retrieves and renews wildcard SSL certificates for multiple TLDs.

Environment variables specified in Dockerfile must be set prior to run. `example.com` is reserved and automatically rejected by certbot, so this container will fail without the proper settings.

```bash
docker run -e DOMAINS='*.example.com,*.example.org' -e EMAIL='email@example.com' -v /luadns.ini:/config/luadns.ini camcamfresh/certbot
```