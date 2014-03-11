#!/usr/bin/env bash



# Path variables
NGX_HOME=/usr/local/nginx
NGX_EXEC=/usr/sbin/nginx
NGX_PID=/var/run/nginx.pid


if ! type "nginx" > /dev/null; then

# Software versions
NGX_VERSION=1.4.6
#PCRE_VERSION=8.34
#ZLIB_VERSION=1.2.8
#OSSL_VERSION=0.9.8o

# Setup source folder
mkdir /tmp/nginx-build
cd /tmp/nginx-build


# Down Nginx source
wget http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz
tar xvfz nginx-${NGX_VERSION}.tar.gz
cd nginx-${NGX_VERSION}



# Create user
sudo adduser --system --no-create-home --disabled-login --disabled-password --group nginx
sudo mkdir -p /var/lib/nginx/tmp/client_body
sudo mkdir -p /var/log/nginx/
sudo touch /var/log/nginx/error.log


# Install Nginx dependencies
if type "yum" > /dev/null; then
  sudo yum install -y httpd-devel pcre perl pcre-devel zlib zlib-devel GeoIP GeoIP-devel

  #wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz
  #tar -xvf pcre-${PCRE_VERSION}.tar.gz

  #wget ftp://ftp.openssl.org/source/openssl-${OSSL_VERSION}.tar.gz
  #tar -xvf openssl-${OSSL_VERSION}.tar.gz

  #wget http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz
  #tar -xvf zlib-${ZLIB_VERSION}.tar.gz


  # Configure & Install Nginx
  #./configure --user=nginx --group=nginx --sbin-path=${NGX_EXEC} --conf-path=${NGX_HOME}/nginx.conf --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --pid-path=${NGX_PID} --with-http_ssl_module --with-pcre=../pcre-${PCRE_VERSION} --with-zlib=../zlib-${ZLIB_VERSION}

else
  sudo apt-get -q -y install zlib1g-dev libpcre3 libpcre3-dev libssl-dev
  sudo apt-get -q -y install libc6 libexpat1 libgd2-xpm libgd2-xpm-dev libgeoip1 libgeoip-dev libpam0g libssl1.0.0 libxml2 libxslt1.1 libxslt-dev zlib1g libperl5.14 perl perlapi-5.14.2 openssl

fi

# Configure & Install Nginx
./configure --prefix=${NGX_HOME} --sbin-path=${NGX_EXEC} --conf-path=${NGX_HOME}/nginx.conf --user=nginx --group=nginx --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --with-pcre-jit --with-debug --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --with-ipv6 --with-mail --with-mail_ssl_module

make
make install






# Copy configuration file
sudo cp /resources/nginx/mime.types ${NGX_HOME}/mime.types
sudo cp /resources/nginx/nginx.conf ${NGX_HOME}/nginx.conf

if type "chkconfig" > /dev/null; then
  sudo chkconfig nginx on
fi

sudo chown nginx:nginx ${NGX_HOME}/logs


# Remove tmp src folder
cd /tmp
rm -rf /tmp/nginx-build

fi


# Create sites folder
sudo mkdir -p ${NGX_HOME}/sites-available
sudo mkdir -p ${NGX_HOME}/sites-enabled
sudo cp /resources/nginx/no-default ${NGX_HOME}/sites-available/no-default
if ! [ -a "${NGX_HOME}/sites-enabled/no-default" ]; then
  sudo ln -s ${NGX_HOME}/sites-available/no-default ${NGX_HOME}/sites-enabled/no-default
fi



# Copy SSL certificates
if ! [ -d "/ssl-certs" ]; then
  sudo mkdir /ssl-certs
fi
sudo cp /resources/ssl-certs/* /ssl-certs
sudo chmod 600 /ssl-certs/*.key





UPSTART_CONF="start on (vagrant-mounted)
stop on shutdown

script
  sudo nginx
end script"


# Create upstart script
if [ -a "/etc/init/nginx.conf" ]; then
  sudo rm /etc/init/nginx.conf
fi
sudo echo -e "$UPSTART_CONF" >> /etc/init/nginx.conf

# Start Nginx server
if [ -a /var/run/nginx.pid ]; then
  sudo nginx -s reload
else
  sudo start nginx
fi
