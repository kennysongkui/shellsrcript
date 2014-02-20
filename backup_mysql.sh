#!/bin/bash
 

MYSQLDUMP=/usr/bin/mysqldump
GZIP=/bin/gzip
BACKUP_PATH=/data/mysql_backup
 
MYSQL_HOST="*.*.*.*"
MYSQL_USER="user"
MYSQL_PASSWORD="password"
 
 
date=`date +%Y%m%d` 
del=` date -d "180 days ago" +%Y%m%d `

rm $BACKUP_PATH/backup.${del}.sql.gz


cd ${BACKUP_PATH}


$MYSQLDUMP -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} --all-databases > backup.${date}.sql
$GZIP backup.${date}.sql
