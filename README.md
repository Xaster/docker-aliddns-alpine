# docker-aliddns-alpine
Docker: AliDDNS By aliyun-ddns-cli (Based On Alpine)

# Thanks
- https://github.com/chenhw2/aliyun-ddns-cli

# Usage
```
$ docker pull xaster/docker-aliddns-alpine

$ docker run -d \
    --name docker-aliddns-alpine \
    -e AKID=YOUR_ACCESS_KEY_ID \
    -e AKSCT=YOUR_ACCESS_KEY_SECRET \
    -e DOMAIN=YOUR_DOMAIN \
    -e REDO=600 \
    -e TIMEZONE=YOUR_TIME_ZONE \
    xaster/docker-aliddns-alpine
```
