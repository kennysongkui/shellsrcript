#!/bin/bash
# 
# by kenny song
# 2014-12-29

# setting server version
ser_version=Centos-6

# setting proxy server
proxy_server=http://10.128.190.103:3128

#setting software install directory
soft_dir=/usr/local

# seting softwore version
zlib=zlib-1.2.8
openssl=openssl-1.0.1j
openssh=openssh-6.7p1
nginx=nginx-1.6.1

echo "HISTFILESIZE=50000" >> /etc/bashrc
echo "HISTSIZE=50000" >> /etc/bashrc
echo "HISTTIMEFORMAT=\"%Y%m%d-%H%M%S: \"" >> /etc/bashrc
echo "export HISTTIMEFORMAT" >> /etc/bashrc

export http_proxy=$proxy_server
export https_proxy=$proxy_server
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/$ser_version.repo
yum clean all
yum makecache
yum -y update
yum -y groupinstall "Development tools" "Perl Support" "Base"
yum -y install pam-devel pcre-devel tcp_wrappers tcp_wrappers-devel zlib-devel cmake

# disabled selinux
sed -i '7s/enforcing/disabled/g' /etc/selinux/config

if [ ! -d "$soft_dir/src" ]; then
mkdir -p $soft_dir/src
fi
cd $soft_dir/src

if [ ! -d "$soft_dir/$zlib" ]; then
 
# install_zlib
wget -N http://zlib.net/$zlib.tar.gz
tar zxf $zlib.tar.gz
cd $zlib
./configure --shared --prefix=$soft_dir/$zlib
make clean 
make
make test
make install
echo "$soft_dir/$zlib/lib" >> /etc/ld.so.conf
rm -fr /etc/ld.so.cache
/sbin/ldconfig
cd $soft_dir
rm -fr zlib
ln -s $zlib zlib
unalias cp
cp -fr $soft_dir/$zlib/lib/pkgconfig/* /usr/lib64/pkgconfig/
fi

if [ ! -d "$soft_dir/$openssl" ]; then
#install openssl
cd $soft_dir/src
wget -N https://www.openssl.org/source/$openssl.tar.gz
tar zxf $openssl.tar.gz
cd $openssl
./config --prefix=$soft_dir/$openssl --with-zlib-lib=$soft_dir/$zlib/lib --with-zlib-include=$soft_dir/$zlib/include shared zlib-dynamic
make clean 
make
make test
make install
echo "$soft_dir/$openssl/lib" >> /etc/ld.so.conf
rm /etc/ld.so.cache
/sbin/ldconfig
cd $soft_dir
rm -fr openssl
ln -s $openssl openssl
cp -fr $openssl/lib/pkgconfig/* /usr/lib64/pkgconfig
echo "PATH=/usr/local/openssl/bin:\$PATH" >> /etc/profile
echo "export PATH" >> /etc/profile
fi

if [ ! -d "$soft_dir/$nginx" ]; then
#install nginx
cd $soft_dir/src
wget -N http://nginx.org/download/$nginx.tar.gz
tar zxf $nginx.tar.gz
cd $nginx
./configure --prefix=$soft_dir/$nginx --with-zlib=$soft_dir/src/$zlib --with-openssl=$soft_dir/src/$openssl
make
make install
cd $soft_dir
rm -fr nginx
ln -s $nginx nginx
fi

if [ ! -d "$soft_dir/$openssh" ]; then
#install openssh
cd $soft_dir/src
wget -N http://ftp.iinet.net.au/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz
tar zxf $openssh.tar.gz
cd $openssh
./configure --prefix=$soft_dir/$openssh --with-pam --with-zlib --with-ssl-dir=$soft_dir/$openssl --with-md5-passwords --with-tcp-wrappers --with-zlib=$soft_dir/$zlib
make clean 
make 
make install
cd $soft_dir
ln -s $openssh openssh
echo "PATH=/usr/local/openssh/bin:\$PATH" >> /etc/profile
echo "export PATH" >> /etc/profile
sed -i 's/$openssh/openssh/g' $soft_dir/$openssh/etc/sshd_config
chkconfig --level 0123456 sshd off
echo "/usr/local/openssh/sbin/sshd &" >> /etc/rc.d/rc.local
fi

##Install JDK 
cd $soft_dir
wget http://10.128.161.98/ubuntu/software/jdk-6u45-linux-x64.bin
chmod 755 jdk-6u45-linux-x64.bin
./jdk-6u45-linux-x64.bin
ln -s jdk1.6.0_45 jdk
echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
echo "export JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile
echo "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >>
/etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
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
echo "/usr/local/mysql-5.6.14/lib/mysql" >> /etc/ld.so.conf
echo "/usr/local/mysql-5.6.14/lib/mysql/plugin" >> /etc/ld.so.conf
rm -fr /etc/ld.so.cache 
/sbin/ldconfig 
cp support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
/usr/sbin/groupadd -g 27 mysql
/usr/sbin/useradd -u 27 -g 27 -c "Mysql Dameon User" -s /sbin/nologin -d /dev/null mysql
cd /usr/local
ln -s mysql-5.6.14 mysql
cd mysql
./scripts/mysql_install_db --user=mysql
/usr/local/mysql/bin/mysqladmin -u root password "*****************"
echo "PATH=/usr/local/mysql/bin:\$PATH" >> /etc/profile
echo "export PATH" >> /etc/profile

echo "======================END======================"