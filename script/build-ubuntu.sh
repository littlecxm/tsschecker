#!/bin/bash
export LDFLAGS="-Wl,-rpath=/usr/local/lib"
cd ..
WORKDIR=$(pwd)
echo "WORKDIR: $WORKDIR"
mkdir -p ./depcomp

git -C $WORKDIR/depcomp clone --depth=1 --recursive https://github.com/libimobiledevice/libplist
cd $WORKDIR/depcomp/libplist
./autogen.sh --enable-debug --without-cython
make install

git -C $WORKDIR/depcomp clone --depth=1 --recursive https://github.com/libimobiledevice/libimobiledevice-glue
cd $WORKDIR/depcomp/libplist
./autogen.sh
make install

git -C $WORKDIR/depcomp clone --depth=1 --recursive https://github.com/libimobiledevice/libirecovery
cd $WORKDIR/depcomp/libirecovery
./autogen.sh
make install

git -C $WORKDIR/depcomp clone --depth=1 --recursive https://github.com/tihmstar/libgeneral
cd $WORKDIR/depcomp/libgeneral
./autogen.sh
make install

git -C $WORKDIR/depcomp clone --depth=1 --recursive https://github.com/tihmstar/libfragmentzip
cd $WORKDIR/depcomp/libfragmentzip
cat <<EOF | patch
--- configure.ac
+++ configure.ac
@@ -37,7 +37,7 @@
 LIBCURL_REQUIRES_STR="libcurl >= 1.0"
 LIBZIP_REQUIRES_STR="libzip >= 1.0"
 LIBZ_REQUIRES_STR="zlib >= 1.0"
-LIBGENERAL_REQUIRES_STR="libgeneral >= 48"
+LIBGENERAL_REQUIRES_STR="libgeneral >= 1"
 
EOF
./autogen.sh
make install

cd $WORKDIR

cd tsschecker
cat <<EOF | patch --ignore-whitespace
--- tss.c
+++ tss.c
@@ -51,7 +51,7 @@
         tsserror("ERROR: Invalid ECID passed.\n");
         return NULL;
     }
-    snprintf(ecid_string, ECID_STRSIZE, FMT_qu, ecid);
+    snprintf(ecid_string, ECID_STRSIZE, "%llu", (long long unsigned int)ecid);
     return ecid_string;
 }
EOF

cd ..
cat <<EOF | patch
--- configure.ac
+++ configure.ac
@@ -44,7 +44,7 @@
 
 PKG_CHECK_MODULES(libplist, libplist >= 2.2.0)
 PKG_CHECK_MODULES(libcurl, libcurl >= 1.0)
-PKG_CHECK_MODULES(libfragmentzip, libfragmentzip >= 48)
+PKG_CHECK_MODULES(libfragmentzip, libfragmentzip >= 1)
 AS_IF([test "x\$with_libcrypto" != xno],
     [PKG_CHECK_MODULES(libcrypto, libcrypto >= 1.0)]
 )
EOF

./autogen.sh
bash ./configure
make install
