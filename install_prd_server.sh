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
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/$ser_version.repo
yum clean all
yum makecache
yum -y update
yum -y groupinstall "Development tools" "Perl Support"
yum -y install pam-devel
yum -y install tcp_wrappers tcp_wrappers-devel
yum -y install pcre-devel

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
rm /etc/ld.so.cache
/sbin/ldconfig
cd $soft_dir
rm -fr zlib
ln -s $zlib zlib
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
