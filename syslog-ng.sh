#!/bin/sh

TDY=`date '+%d'`
MONTH=`date '+%m'`
if [ $MONTH -gt "06" ]; then
  MONTH='0'`expr $MONTH - 6`
fi
sync

DATE=`/bin/date +%d`

cd /var/log/syslog-ng
rm -f teleweb-local.log.$DATE.gz
rm -f teleweb-web.log.$DATE.gz

for i in `ls /var/log/syslog-ng/*log`; do
cp $i $i.today
mv $i $i.$DATE
done
killall -HUP syslog-ng

cd /var/log/syslog-ng
for i in `ls ./*log.$DATE`; do
rm $i.gz
gzip $i
done
chgrp kennys ./*
chmod g+r ./*

cp teleweb-local.log.$DATE.gz $MONTH/
cp teleweb-web.log.$DATE.gz $MONTH/
