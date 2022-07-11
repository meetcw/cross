#!/bin/bash

rm -r /opt/trojan-go
rm /usr/lib/systemd/system/trojan-go.service

if [ -f "/etc/nginx/nginx.conf.backup" ];then mv /etc/nginx/nginx.conf.backup /etc/nginx/nginx.conf; else rm /etc/nginx/nginx.conf; fi
if [ -f "/etc/nginx/sites-available/default.backup" ];then mv /etc/nginx/sites-available/default.backup /etc/nginx/sites-available/default; else rm /etc/nginx/sites-available/default; fi

rm -r /var/www/cross-site

echo "Done!"
