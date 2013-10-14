#!/bin/sh
var0=0
#df -k | grep -v "dev" |grep -v "Filesystem" > /tmp/spacecheck.log
df -k |grep -v "Filesystem" > /tmp/spacecheck.log
var1=`wc -l /tmp/spacecheck.log | awk '{print $1}'`

while [ "$var0" -lt $var1 ]
do
var0=$[var0+1]
#echo $var0
LINE=`sed -n $var0'p' /tmp/spacecheck.log`
PERCENT=`echo $LINE | awk '{print $5}' |awk -F'%' '{print $1}'`
DISK=`echo $LINE | awk '{print $5}'`
if [ $PERCENT -ge 90 ];then
(echo "From:Manpower<root@Manpower.local.com>";echo "Subject: $DISK disk space alert !!";echo "";echo "Filesystem           1K-blocks      Used Available Use% Mounted on";cat /tmp/spacecheck.log) | /usr/sbin/sendmail kui.song@tcl.com
fi
done
