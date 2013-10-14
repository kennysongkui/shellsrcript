#!/bin/sh

PATH=/bin:/usr/bin:/usr/sbin:/sbin
export PATH

rm -f /tmp/service_chck.log
if !(ps -ef | grep -v grep | grep sshd);then
echo "SSHD stop" >> /tmp/service_chck.log
killall -9 sshd
/usr/local/openssh/sbin/sshd
fi

if !(ps -ef | grep -v grep | grep squid);then
echo "Squid stop" >> /tmp/service_chck.log
killall -9 squid
/usr/local/squid/sbin/squid -s
fi

if !(ps -ef | grep -v grep | grep httpd);then
echo "Httpd stop" >> /tmp/service_chck.log
/usr/local/apache/bin/apachectl stop
/usr/local/apache/bin/apachectl start
fi

if !(ps -ef | grep -v grep | grep mysqld);then
echo "Mysql stop" >> /tmp/service_chck.log
/etc/init.d/mysqld restart
fi

if [ -f /tmp/service_chck.log ]; then
(echo "From: Squid_Tclcom@Squid_Tclcom.localhost";echo "Subject: Some Service down on Squid_Tclcom,please check";cat /tmp/service_chck.log) | /usr/sbin/sendmail kui.song@tcl.com
fi

rm /tmp/service_chck.log
