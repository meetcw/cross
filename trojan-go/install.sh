#!/bin/bash

set -o allexport
source ./.env
set +o allexport


if ! command -v trojan-go &> /dev/null;
then
    echo "trojan-go not found, downloading..."
    wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
    unzip trojan-go-linux-amd64.zip -d /tmp/trojan-go
    cp /tmp/trojan-go/trojan-go /usr/bin/
    rm trojan-go-linux-amd64.zip
fi

echo "applying config..."
mkdir -p /etc/nginx
envsubst < ./nginx/nginx.conf | sed -e 's/§/$/g' > /etc/nginx/nginx.conf
mkdir -p /etc/nginx/sites-available
envsubst < ./nginx/sites-available/default | sed -e 's/§/$/g' > /etc/nginx/sites-available/default

mkdir -p /var/www
cp -r ./virtual-site /var/www/virtual-site
envsubst < ./virtual-site/index.html > /var/www/virtual-site/index.html

mkdir -p /etc/trojan-go
envsubst < ./config.yaml > /etc/trojan-go/config.yaml

cp ./trojan-go.service /etc/systemd/system/trojan-go.service

echo "install complete"
