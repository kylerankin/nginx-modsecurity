#!/bin/bash

# To build RPM packages install this package:
# rpm-build
#
# To get nginx build dependencies install:
# GeoIP-devel gd-devel gperftools-devel libxslt-devel openssl-devel perl\(ExtUtils::Embed\) perl-devel
#
# ModSecurity needs these additional packages:
# automake libtool httpd-devel pcre pcre-devel libxml2-devel systemd-devel lua-devel yajl-devel

# get the modsecurity module and build it
pushd .
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security
cd mod_security
./autogen.sh
CFLAGS='-fPIC' ./configure --enable-standalone-module --disable-mlogc
make
popd

yum download --source nginx
rpm -i nginx*.src.rpm

cd ~/rpmbuild/SPECS

# add mod_security as the first module in common
sed -i -e 's/--conf-path=%{nginx_confdir}\/nginx.conf \\/--conf-path=%{nginx_confdir}\/nginx.conf \\\n    --add-module=..\/..\/..\/mod_security\/nginx\/modsecurity \\/' nginx.spec

rpmbuild -ba nginx.spec
