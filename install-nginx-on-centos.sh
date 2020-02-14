#!/bin/bash

yum -y install epel-release

yum -y install wget make gcc gcc-c++ automake gd-devel pcre pcre-devel openssl openssl-devel zlib zlib-devel vim

cd /usr/local/src

wget https://nginx.org/download/nginx-1.16.1.tar.gz

tar xzvf nginx-1.16.1.tar.gz

cd /usr/local/src/nginx-1.16.1

# 创建php-fpm组
# -g 代表直接指定group ID，可以省略
# -r 代表为系统账号
groupadd -r www-data

# 创建php-fpm用户
# -u 表示直接指定user ID
# -M 表示不创建用户目录，需要显示指定
useradd -g www-data www-data -M

./configure \
--user=www-data \
--group=www-data \
--prefix=/usr/local/nginx \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-mail \
--with-mail_ssl_module \
--with-file-aio \
--with-threads

make

make install

#nginx 主配置文件
wget https://github.com/techstore1970/install-nginx-on-centos/raw/master/nginx.conf
rm -rf /usr/local/nginx/conf/nginx.conf
cp nginx.conf /usr/local/nginx/conf/

# nginx 虚拟服务配置文件
wget https://github.com/techstore1970/install-nginx-on-centos/raw/master/server.conf
mkdir /usr/local/nginx/vhost
cp server.conf /usr/local/nginx/vhost/

# 注册系统服务
wget https://github.com/techstore1970/install-nginx-on-centos/raw/master/nginx.service
cp nginx.service /usr/lib/systemd/system/

# 更新系统配置
sudo systemctl daemon-reload

# 配置开机启动
sudo systemctl enable nginx

# 启动 nginx.service
sudo systemctl start nginx
