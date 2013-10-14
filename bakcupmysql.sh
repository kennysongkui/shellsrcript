#!/bin/bash
PATH=/bin:/usr/bin:/usr/sbin:/sbin:/usr/local/bin
export PATH
DATE=`date +%d`
MONTH=`date '+%m'`
if [ $MONTH -gt "06" ]; then
  MONTH='0'`expr $MONTH - 6`
fi

cd /usr/local/mysql
rm -f mysql.$DATA.tar.gz
tar -zvcf ./backup/mysql.$DATE.tar.gz ./var/  > /dev/null 2>1
cp ./backup/mysql.$DATE.tar.gz ./backup/mysql.today.tar.gz
cd /usr/local/mysql/backup
cp mysql.$DATE.tar.gz $MONTH/
