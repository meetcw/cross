#!/bin/bash

set -o allexport
source ./environment
set +o allexport


if [ ! -f "/opt/trojan-go/trojan-go" ];
then
    echo "Download trojan-go..."
    wget -O trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip > /dev/null
    rm -r /tmp/trojan-go &>/dev/null
    unzip trojan-go.zip -d /tmp/trojan-go > /dev/null

    mkdir -p /opt/trojan-go
    cp /tmp/trojan-go/trojan-go /opt/trojan-go/trojan-go
    rm trojan-go.zip &>/dev/null
fi
envsubst < ./templates/config.yaml > /opt/trojan-go/config.yaml
cp ./templates/trojan-go.service /usr/lib/systemd/system/trojan-go.service

echo "Applying config..."
mkdir -p /etc/nginx
if [ ! -f "/etc/nginx/nginx.conf" ];then mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup; fi
if [ ! -f "/etc/nginx/sites-available/default" ];then mv ./etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup; fi
envsubst < ./templates/nginx/nginx.conf | sed -e 's/§/$/g' > /etc/nginx/nginx.conf
mkdir -p /etc/nginx/sites-available
envsubst < ./templates/nginx/sites-available/default | sed -e 's/§/$/g' > /etc/nginx/sites-available/default

mkdir -p /var/www/cross-site
cp ./templates/cross-site/favicon.png /var/www/cross-site/favicon.png
cp ./templates/cross-site/robots.txt /var/www/cross-site/robots.txt
envsubst < ./templates/cross-site/index.html > /var/www/cross-site/index.html

mkdir -p /var/www/cross-site/${PASSWORD}
envsubst < ./templates/cross-site/default.yaml > /var/www/cross-site/${PASSWORD}/${NAME}

echo "Done!"
