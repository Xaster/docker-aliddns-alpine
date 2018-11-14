FROM golang:alpine AS build

RUN apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        git \
        curl \
    && CGO_ENABLED=0 \
    && go get -u -v \
        -ldflags "-s -w -X main.version=$(curl -sSL https://api.github.com/repos/chenhw2/aliyun-ddns-cli/commits/master | \
        sed -n '1,9{/sha/p; /date/p}' | sed 's/.* \"//g' | cut -c1-10 | tr [a-z] [A-Z] | sed 'N;s/\n/@/g')" \
        github.com/chenhw2/aliyun-ddns-cli \
    && apk del .build-deps \
    && rm -rf \
        /go/src/* \
        /go/pkg/*

FROM alpine:latest

COPY --from=build /go/bin /usr/bin

RUN apk upgrade --no-cache \
    && apk add --no-cache tzdata \
    && wget -O /usr/bin/CMD-Shell https://raw.githubusercontent.com/Xaster/docker-aliddns-alpine/master/CMD-Shell \
    && chmod +x /usr/bin/CMD-Shell

ENV AKID="" \
    AKSCT="" \
    DOMAIN="" \
    IPAPI=[IPAPI-GROUP] \
    REDO=600 \
    TIMEZONE=""

CMD ["CMD-Shell"]
