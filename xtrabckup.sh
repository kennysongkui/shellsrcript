#!/bin/bash

#PATH=/usr/local/xtrabackup/bin:$PATH
#export PATHa
source /etc/profile
MYSQLUSER=root
MYSQLPASSWORD=password
USER=user
IP=ipaddress
BACKUPDIR=/mnt/backup
REMOTEDIR=/data/backup_mysql


/usr/local/xtrabackup/bin/innobackupex --user=$MYSQLUSER --password=$MYSQLPASSWORD
--defaults-file=/usr/local/mysql-5.6.14/my.cnf $BACKUPDIR

cd $BACKUPDIR
FILENAME=`ls -l |grep -v total |awk '{print $9}'`
#echo $FILENAME
tar zcvf $FILENAME.tar.gz ./$FILENAME
scp $FILENAME.tar.gz $USER@$IP:$REMOTEDIR
rm -fr $FILENAME.tar.gz
rm -fr $FILENAME

