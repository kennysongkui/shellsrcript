#!/bin/bash

test=`ps aux |grep puppet|grep -v grep `

#echo $test 

if [ -z "$test" ]; then
cd /etc/
sed -i '5a10.128.186.251 mirrors.163.com' hosts

cd /root
apt-get -y install ruby libshadow-ruby1.8  >> /tmp/puppet_install.log
apt-get -y install puppet facter >> /tmp/puppet_install.log

cd /etc/default/
sed -i 's/no/yes/g' /etc/default/puppet

cd /etc/puppet/
sed -i '10aserver=puppet.tcl.com' puppet.conf

cd /etc/
sed -i '7a10.128.161.51  puppet.tcl.com' hosts

cd /root/
service puppet start

pid=`ps -eo pid,cmd |grep root\@notty |grep -v grep  |awk '{print $1}'`
kill -9 $pid
else
#exit;
pid=`ps -eo pid,cmd |grep root\@notty |grep -v grep  |awk '{print $1}'`
kill -9 $pid
fi
