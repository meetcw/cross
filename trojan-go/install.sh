#!/bin/sh
export $(grep -v '^#' .env | xargs)

mkdir -p /etc/nginx
envsubst < ./nginx/nginx.conf | sed -e 's/§/$/g' > /etc/nginx/nginx.conf
mkdir -p /etc/nginx/sites-available
envsubst < ./nginx/sites-available/default | sed -e 's/§/$/g' > /etc/nginx/sites-available/default

cp -r ./virtual-site /var/www/virtual-site
envsubst < ./virtual-site/index.html > /var/www/virtual-site/index.html
envsubst < ./virtual-site/api/cross.yaml > /var/www/virtual-site/api/cross

mkdir -p /etc/trojan-go
envsubst < ./config.yaml > /etc/trojan-go/config.yaml

cp ./trojan-go.service /etc/systemd/system/trojan-go.service

