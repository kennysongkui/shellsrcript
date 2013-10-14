#/bin/sh
PATH=/bin:/usr/bin:/usr/sbin:/sbin:/usr/local/bin
export PATH
TDY=`date '+%d'`
MONTH=`date '+%m'`
if [ $MONTH -gt "06" ]; then
  MONTH='0'`expr $MONTH - 6`
fi
sync


cd /var/log

# add by Kenny ,for awstats
cat messages> ./messages.daily ; cat /dev/null > messages
cat secure > ./secure.daily; cat /dev/null > secure
cd /var/log/httpd
cat access_log> ./access_log.daily ; cat /dev/null > access_log
cat error_log> ./error_log.daily ; cat /dev/null > error_log
cd /var/log/squid
cat access.log> ./access.log.daily ; cat /dev/null > access.log
sync


# rotate spamlogs
cd /var/log
rm -f messages.$TDY.gz ; cp messages.daily messages.$TDY ; gzip messages.$TDY
cp messages.$TDY.gz $MONTH/
rm -f secure.$TDY.gz ; mv secure.daily secure.$TDY ; gzip secure.$TDY
cp secure.$TDY.gz $MONTH/
cd /var/log/httpd
rm -f access_log.$TDY.gz ; mv access_log.daily access_log.$TDY ; gzip access_log.$TDY
cp access_log.$TDY.gz /var/log/$MONTH/
rm -f error_log.$TDY.gz ; mv error_log.daily error_log.$TDY ; gzip error_log.$TDY
cp error_log.$TDY.gz /var/log/$MONTH/
cd /var/log/squid
rm -f access.log.$TDY.gz ; mv access.log.daily access.log.$TDY ; gzip access.log.$TDY
cp access.log.$TDY.gz /var/log/$MONTH/
sync

