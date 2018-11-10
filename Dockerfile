FROM golang:alpine as build

RUN cd \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        git \
        curl \
        wget \
        xz \
        sed \
    && UPX_VERSION=$(curl -sS --fail https://github.com/upx/upx/releases | \
        grep -o '/upx-[a-zA-Z0-9.]*-amd64_linux[.]tar[.]xz' | \
        sed -e 's~^/upx-~~' -e 's~\-amd64_linux\.tar\.xz$~~' | \
        sed '/alpha.*/Id' | \
        sed '/beta.*/Id' | \
        sed '/rc.*/Id' | \
        sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -g | \
        tail -n 1) \
    && wget --no-check-certificate https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-amd64_linux.tar.xz \
    && xz -d upx-${UPX_VERSION}-amd64_linux.tar.xz \
    && tar -xvf upx-${UPX_VERSION}-amd64_linux.tar \
    && cp -f upx-${UPX_VERSION}-amd64_linux/upx /bin \
    && CGO_ENABLED=0 \
    && go get -u -v \
        -ldflags "-s -w -X main.version=$(curl -sSL https://api.github.com/repos/chenhw2/aliyun-ddns-cli/commits/master | \
        sed -n '1,9{/sha/p; /date/p}' | sed 's/.* \"//g' | cut -c1-10 | tr [a-z] [A-Z] | sed 'N;s/\n/@/g')" \
        github.com/chenhw2/aliyun-ddns-cli \
    && find /go/bin -type f | \
        xargs upx \
    && apk del .build-deps \
    && rm -rf \
        $HOME/* \
        /bin/upx \
        /go/src/* \
        /go/pkg/*

FROM alpine:latest

COPY --from=build /go/bin /usr/bin

RUN apk upgrade --no-cache \
    && apk add --no-cache tzdata \
    && wget --no-check-certificate -O /usr/bin/Run.sh https://raw.githubusercontent.com/Xaster/docker-aliddns-alpine/master/Run.sh \
    && chmod +x /usr/bin/Run.sh

ENV AKID="" \
    AKSCT="" \
    DOMAIN="" \
    IPAPI=[IPAPI-GROUP] \
    REDO=600 \
    TIMEZONE=""

CMD "/usr/bin/Run.sh"
