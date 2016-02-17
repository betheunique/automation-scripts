#!/bin/bash
#set -ex
#Script Developed by--- Abhishek Rai (2015/01/03)
sudo yum install expect
#IPADDRESS="$1"
temp=`pwd`
MYSQL_VERSION=5.1
MYSQL_VERSION_RELNUM=34
MYSQL_VERSION_RELEASE=${MYSQL_VERSION}.${MYSQL_VERSION_RELNUM}
REDHAT_RELEASE=5
BINARY_VERSION=x86_64
PERL_LOCATION=ftp://ftp.de.netclusive.de/pub/parallels/Plesk/Expand/2.3.1/packages
PERL_FILE=perl-DBI-1.53-2.fc7.x86_64.rpm
PERL_URL=${PERL_LOCATION}/${PERL_FILE}
MYSQL_MIRROR_INDEX=0
MYSQL_SHARE2_LIB=MySQL-shared-compat-${MYSQL_VERSION_RELEASE}-${MYSQL_MIRROR_INDEX}.rhel${REDHAT_RELEASE}.${BINARY_VERSION}.rpm
MYSQL_SHARED_LIB=MySQL-shared-community-${MYSQL_VERSION_RELEASE}-${MYSQL_MIRROR_INDEX}.rhel${REDHAT_RELEASE}.${BINARY_VERSION}.rpm
MYSQL_DEVEL__LIB=MySQL-devel-community-${MYSQL_VERSION_RELEASE}-${MYSQL_MIRROR_INDEX}.rhel${REDHAT_RELEASE}.${BINARY_VERSION}.rpm
MYSQL_CLIENT_LIB=MySQL-client-community-${MYSQL_VERSION_RELEASE}-${MYSQL_MIRROR_INDEX}.rhel${REDHAT_RELEASE}.${BINARY_VERSION}.rpm
MYSQL_SERVER_LIB=MySQL-server-community-${MYSQL_VERSION_RELEASE}-${MYSQL_MIRROR_INDEX}.rhel${REDHAT_RELEASE}.${BINARY_VERSION}.rpm
MYSQL_SHARE2_URL="http://downloads.mysql.com/archives/mysql-${MYSQL_VERSION}/${MYSQL_SHARE2_LIB}"
MYSQL_SHARED_URL="http://downloads.mysql.com/archives/mysql-${MYSQL_VERSION}/${MYSQL_SHARED_LIB}"
MYSQL_DEVEL__URL="http://downloads.mysql.com/archives/mysql-${MYSQL_VERSION}/${MYSQL_DEVEL__LIB}"
MYSQL_CLIENT_URL="http://downloads.mysql.com/archives/mysql-${MYSQL_VERSION}/${MYSQL_CLIENT_LIB}"
MYSQL_SERVER_URL="http://downloads.mysql.com/archives/mysql-${MYSQL_VERSION}/${MYSQL_SERVER_LIB}"
rm -rf MySQLInstall  #if any such directory exsists it will remove it
mkdir  MySQLInstall # it will create a mysql directory
chmod 777 ${temp}/MySQLInstall # it will allow to change mode for the created directory
cd MySQLInstall # it will change the current directory to created directory
myphp() {                # this function is fpr phpmyadmin installation
sudo yum -y install php php-mysql php-gd php-imap php-ldap php-mbstring php-odbc php-pear php-xml php-xmlrpc php-pecl-apc php-soap
sudo rpm -iUvh --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum -y update
#rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
sudo yum -y install phpmyadmin
}
phpconfig() { # this function will configure phpmyadmin for collected ipadress
sudo chmod 666 /etc/httpd/conf.d/phpMyAdmin.conf
sudo sed -i 's/127.0.0.1/ip_address_for_the_server/g' /etc/httpd/conf.d/phpMyAdmin.conf
sudo sed -i '/AddDefaultCharset /a allow from all' /etc/httpd/conf.d/phpMyAdmin.conf
sudo sed -i '/AddDefaultCharset /a order allow,deny' /etc/httpd/conf.d/phpMyAdmin.conf
sudo chmod 644 /etc/httpd/conf.d/phpMyAdmin.conf
}
mysqlinstall() { # this function is for mysqlinstallation
sudo yum install wget
wget ${PERL_URL}
sudo yum install wget
wget ${MYSQL_SHARE2_URL}
sudo yum install wget
wget ${MYSQL_SHARED_URL}
sudo yum install wget
wget ${MYSQL_DEVEL__URL}
sudo yum install wget
wget ${MYSQL_CLIENT_URL}
sudo yum install wget
wget ${MYSQL_SERVER_URL}
pwd
ls -lFa
download  # it will call download function to install all downloaded repositeries collected by mysqlinstall function
}
download() { # for installation of sql repositories
sudo rpm -Uvh --force ${PERL_FILE}
sudo rpm -Uvh --force ${MYSQL_SHARE2_LIB}
sudo rpm -Uvh --force ${MYSQL_SHARED_LIB}
sudo rpm -Uvh --force ${MYSQL_DEVEL_LIB}
sudo rpm -Uvh --force ${MYSQL_CLIENT_LIB}
sudo rpm -Uvh --force ${MYSQL_SERVER_LIB}
phpconfig # after installing all mysql requirements it will call phpconfig function
}
myphp # first php will called by this command
mysqlinstall # after myphp installation it will call mysqlinstall function
chmod 777 /home/username/EXPECT_MYSQL.exp
sudo expect /home/username/EXPECT_MYSQL.exp
sudo service mysqld start # mysql service will be started
sudo service httpd start # phpmyadmin will be start
