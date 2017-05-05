R64=`R.exe RHOME`/bin/x64
export PKG_CFLAGS=-DKXVER=3
rm base.o
$R64/R.exe CMD SHLIB -o w64/qserver.dll base.c w64/c.o -lws2_32


#http://www.mingw.org/wiki/msvc_and_mingw_dlls