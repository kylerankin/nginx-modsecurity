#!/bin/bash

# To build Debian packages install these packages:
# build-essential devscripts
#
# To get nginx build dependencies run:
# apt-get build-dep nginx
#
# ModSecurity needs these additional packages:
# automake apache2-threaded-dev libxml2-dev liblua5.1-dev libyajl-dev

PACKAGE_NAME=nginx
ITERATION="${1:-1}"

# Erase old working directory
test -d nginx && rm -rf nginx
mkdir nginx && cd nginx

# get the modsecurity module and build it
pushd .
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security
cd mod_security
./autogen.sh
./configure --enable-standalone-module --disable-mlogc
make
popd

apt-get source nginx

DEBIAN_VERSION=`ls -d nginx-* | cut -f2 -d '-'`

cd "${PACKAGE_NAME}-${DEBIAN_VERSION}"

dch -v ${DEBIAN_VERSION}-${ITERATION} "Added ModSecurity module Build ${ITERATION}"

# add mod_security as the first module in common
sed -i -e 's/--conf-path=\/etc\/nginx\/nginx.conf \\/--conf-path=\/etc\/nginx\/nginx.conf \\\n                        --add-module=..\/..\/..\/mod_security\/nginx\/modsecurity \\/' debian/rules

dpkg-buildpackage
