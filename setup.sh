#! /bin/bash

# 改成 x86_64-w64-mingw32 来编译64位版本
export HOST=i686-w64-mingw32

# It would be better to use nearest ubuntu archive mirror for faster
# downloads.
# RUN sed -ie 's/archive\.ubuntu/jp.archive.ubuntu/g' /etc/apt/sources.list
# 安装编译环境
apt-get update && \
apt-get install -y make binutils autoconf automake autotools-dev libtool pkg-config git curl dpkg-dev gcc-mingw-w64 autopoint libcppunit-dev libxml2-dev libgcrypt11-dev lzip

# 下载依赖库
if [ ! -f "gmp-6.1.2.tar.lz" ]; then 
	curl -L -O https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz 
fi

if [ ! -f "expat-2.2.0.tar.bz2" ]; then 
	curl -L -O http://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2
fi

if [ ! -f "sqlite-autoconf-3160200.tar.gz" ]; then 
	curl -L -O https://www.sqlite.org/2017/sqlite-autoconf-3160200.tar.gz
fi

if [ ! -f "zlib-1.2.11.tar.gz" ]; then 
	curl -L -O http://zlib.net/zlib-1.2.11.tar.gz
fi

if [ ! -f "c-ares-1.12.0.tar.gz" ]; then 
	curl -L -O https://c-ares.haxx.se/download/c-ares-1.12.0.tar.gz
fi

if [ ! -f "libssh2-1.8.0.tar.gz" ]; then 
	curl -L -O http://libssh2.org/download/libssh2-1.8.0.tar.gz
fi

# 动态编译 gmp
tar xf gmp-6.1.2.tar.lz && \
cd gmp-6.1.2 && \
./configure --enable-shared --disable-static --prefix=/usr/local/$HOST --host=$HOST --disable-cxx --enable-fat CFLAGS="-mtune=generic -O2 -g0" && \
make install

# 动态编译 expat
cd ..
tar xf expat-2.2.0.tar.bz2 && \
cd expat-2.2.0 && \
./configure --enable-shared --disable-static --prefix=/usr/local/$HOST --host=$HOST --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` && \
make install

# 动态编译 sqlite3
cd ..
tar xf sqlite-autoconf-3160200.tar.gz && cd sqlite-autoconf-3160200 && \
./configure --enable-shared --disable-static --prefix=/usr/local/$HOST --host=$HOST --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` && \
make install

# 动态编译 zlib
cd ..
tar xf zlib-1.2.11.tar.gz && \
cd zlib-1.2.11
export BINARY_PATH=/usr/local/$HOST/bin
export INCLUDE_PATH=/usr/local/$HOST/include
export LIBRARY_PATH=/usr/local/$HOST/lib
make install -f win32/Makefile.gcc PREFIX=$HOST- SHARED_MODE=1

# 动态编译 c-ares
cd ..
tar xf c-ares-1.12.0.tar.gz && \
cd c-ares-1.12.0 && \
./configure --enable-shared --disable-static --without-random --prefix=/usr/local/$HOST --host=$HOST --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` LIBS="-lws2_32" && \
make install

# 动态编译 libssh2
cd ..
tar xf libssh2-1.8.0.tar.gz && \
cd libssh2-1.8.0 && \
./configure --enable-shared --disable-static --prefix=/usr/local/$HOST --host=$HOST --build=`dpkg-architecture -qDEB_BUILD_GNU_TYPE` --without-openssl --with-wincng LIBS="-lws2_32" && \
make install
