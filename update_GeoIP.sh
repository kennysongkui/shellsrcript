#!/bin/sh
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin
cd /tmp
wget http://www.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz
mv GeoLiteCity.dat /usr/local/GeoIP/share/GeoIP/
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz -O GeoIP.dat.gz
gunzip GeoIP.dat.gz
mv GeoIP.dat /usr/local/GeoIP/share/GeoIP/GeoIP.dat
