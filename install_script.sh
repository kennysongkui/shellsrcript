#!/bin/bash 
#
#
#

ZLIB=zlib-1.2.7
OPENSSL=openssl-1.0.1g
OPENSSH=openssh-6.2p2

export http_proxy=http://10.128.190.103:3128
export https_proxy=http://10.128.190.103:3128

yum -y update
yum -y groupinstall "Development tools" "Base"
yum -y install vim pam-devel zlib-devel tcp_wrappers-devel wget cmake
ncurses-devel

##Install Zlib
cd /usr/local/src
wget http://10.128.161.98/ubuntu/software/zlib-1.2.7.tar.gz
tar zxvf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --shared --prefix=/usr/local/zlib-1.2.7
make clean
make
make test
make install
echo "/usr/local/zlib-1.2.7/lib" >> /etc/ld.so.conf
rm -fr /etc/ld.so.cache
/sbin/ldconfig
cd /usr/local
ln -s zlib-1.2.7 zlib
unalias cp
cp -fr /usr/local/zlib-1.2.7/lib/pkgconfig/* /usr/lib64/pkgconfig/

## Install Openssl the new version
cd /usr/local/src
wget http://10.128.161.98/ubuntu/software/openssl-1.0.1g.tar.gz
tar zxvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config --prefix=/usr/local/openssl-1.0.1g
--with-zlib-lib=/usr/local/zlib-1.2.7/lib
--with-zlib-include=/usr/local/zlib-1.2.7/include shared zlib-dynamic
make clean
make
make test
make install
echo "/usr/local/openssl-1.0.1g/lib" >> /etc/ld.so.conf
rm -fr /etc/ld.so.cache
/sbin/ldconfig
cd /usr/local
ln -s openssl-1.0.1g openssl
cp -fr /usr/local/openssl-1.0.1g/lib/pkgconfig/* /usr/lib64/pkgconfig/
echo "PATH=/usr/local/openssl/bin:$PATH" >> /etc/profile
echo "export PATH" >> /etc/profile
source /etc/profile

##Install Openssh the new version
cd /usr/local/src
wget http://10.128.161.98/ubuntu/software/openssh-6.2p2.tar.gz
tar zxvf openssh-6.2p2.tar.gz
cd openssh-6.2p2
./configure --prefix=/usr/local/openssh-6.2p2 --with-pam --with-zlib
--with-ssl-dir=/usr/local/openssl-1.0.1g --with-md5-passwords
--with-tcp-wrappers --with-zlib=/usr/local/zlib-1.2.7
make clean 
make
make install
cd /usr/local
ln -s openssh-6.2p2 openssh
echo "PATH=/usr/local/openssh/bin:$PATH" >> /etc/profile
echo "export PATH" >> /etc/profile
chkconfig --level 0123456 sshd off
echo "/usr/local/openssh/sbin/sshd &" >> /etc/rc.d/rc.local
sed -i '7s/enforcing/disabled/g' /etc/selinux/config
sed -i 's/openssh-6.2p2/openssh/g' /usr/local/openssh/etc/sshd_config
SSHDPID=` ps aux |grep sshd |grep usr |awk '{print $2}'`
kill -9 $SSHDPID
/usr/local/openssh/sbin/sshd &

##Install JDK 
cd /usr/local
wget http://10.128.161.98/ubuntu/software/jdk-6u45-linux-x64.bin
chmod 755 jdk-6u45-linux-x64.bin
./jdk-6u45-linux-x64.bin
ln -s jdk1.6.0_45 jdk
echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
echo "export JRE_HOME=$JAVA_HOME/jre" >> /etc/profile
echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >>
/etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile

##Install Tomcat 
cd /usr/local
wget http://10.128.161.98/ubuntu/software/apache-tomcat-7.0.26.tar.gz
tar zxvf apache-tomcat-7.0.26.tar.gz
ln -s apache-tomcat-7.0.26 tomcat
cd tomcat
mv webapps webapps.bak
mkdir webapps
echo "source /etc/profile" >> /etc/rc.d/rc.local
echo "/usr/local/tomcat/bin/startup.sh" >> /etc/rc.d/rc.local

##Install Mysql
cd /usr/local/src
wget http://10.128.161.98/ubuntu/software/mysql-5.6.14.tar.gz
tar zxvf mysql-5.6.14.tar.gz
cd mysql-5.6.14
./BUILD/autorun.sh
./configure --prefix=/usr/local/mysql-5.6.14 --enable-assembler --without-isam
--enable-thread-safe-client --with-client-ldflags=-all-static
--with-mysqld-ldflags=-all-static --with-plugins=partition,innobase
--with-charset=all --with-collation=utf8_general_ci --with-extra-charsets=all
--with-big-tables --without-debug
make clean
make
make test
make install



