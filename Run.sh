#!/bin/sh
if [ $TIMEZONE ]; then
  rm -rf /etc/localtime
  echo "${TIMEZONE}" > /etc/TZ
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
fi
aliyun-ddns-cli \
  --ipapi ${IPAPI} \
  auto-update \
  --domain ${DOMAIN} \
  --redo ${REDO}
