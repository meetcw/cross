#!/bin/sh
export $(grep -v '^#' .env | xargs)

mkdir -p /etc/nginx
envsubst < ./nginx/nginx.conf > /etc/nginx/nginx.conf
mkdir -p /etc/nginx/sites-available
envsubst < ./nginx/sites-available/default > /etc/nginx/sites-available/default

cp -r ./nginx/mask /var/www/
envsubst < ./nginx/mask/index.html > /var/www/mask/index.html
envsubst < ./nginx/mask/api/cross.yaml > /var/www/mask/api/cross

mkdir -p /etc/trojan-go
envsubst < ./config.yaml > /etc/trojan-go/config.yaml

cp ./trojan-go.service /etc/systemd/system/trojan-go.service

