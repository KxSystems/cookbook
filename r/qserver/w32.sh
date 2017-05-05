R32=`R.exe RHOME`/bin/i386
export PKG_CFLAGS=-DKXVER=3
rm base.o
$R32/R.exe CMD SHLIB -o w32/qserver.dll base.c w32/c.o  -lws2_32
