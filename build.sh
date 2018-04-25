#!/bin/sh
OTP_VERSION=20
CI_PROJECT_DIR=$(pwd)
ERL_LIBS=/usr/local/Cellar/erlang/20.3.2/lib
OPENSSL_LIB=/usr/local/Cellar//openssl/1.0.2j/lib
export ERL_LIBS="${CI_PROJECT_DIR}/.build/otp-${OTP_VERSION}/lib"
export ERLANG_INSTALL_LIB_DIR=${ERL_LIBS}
aclocal
autoheader
autoconf
libtoolize --automake
automake --add-missing
rm -rf .build/otp-$OTP_VERSION
mkdir -p .build/otp-$OTP_VERSION/lib
mkdir -p .build/otp-$OTP_VERSION/ocs
cd .build/otp-$OTP_VERSION/
echo "Install mochiweb"
git clone https://github.com/mochi/mochiweb.git
cd mochiweb
make all
MOCHIWEB_VERSION=`grep vsn ebin/mochiweb.app | cut -d"\"" -f 2`
cd ../../
if [ ! -d otp-$OTP_VERSION/lib/mochiweb-$MOCHIWEB_VERSION ]; then mv -v otp-$OTP_VERSION/mochiweb/ otp-$OTP_VERSION/lib/mochiweb-$MOCHIWEB_VERSION; fi
echo "Install radierl"
git clone https://github.com/sigscale/radierl.git
cd radierl
aclocal
autoheader
autoconf
automake --add-missing
#LD_FLAGS=$OPENSSL_LIB ./configure --with-ssl=$OPENSSL_LIB --prefix=$(pwd)/ocsinstall
./configure
make && make install
echo "Install OCS"
cd $CI_PROJECT_DIR/.build/otp-$OTP_VERSION/ocs
../../../configure
make
echo "Installing OCS GUI"
cd ../../../priv/www
npm install -g bower
bower  --allow-root install 
mv bower_components/* ./
mv ./* $CI_PROJECT_DIR/.build/otp-$OTP_VERSION/ocs/priv/www/
mkdir -p $CI_PROJECT_DIR/.build/otp-$OTP_VERSION/ocs/log/http
cd $CI_PROJECT_DIR/.build/otp-$OTP_VERSION/ocs
cp $CI_PROJECT_DIR/sys.config ./
# go back to ocs main dir
#if [ ! -d $CI_PROJECT_DIR/.build/otp-$OTP_VERSION/ocs/db ]; then
#    echo "Initialising DB"
#    erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -sname ocs -config sys -s ocs_app install #-s init stop
#fi
#erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -sname ocs -config sys -eval 'systools:make_script("ocs",[local])' # -s init stop
