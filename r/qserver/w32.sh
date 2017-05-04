R32=`R.exe RHOME`/bin/i386
export PKG_CFLAGS=-DKXVER=3
$R32/R.exe CMD SHLIB -o w32/qserver.dll base.c w32/c.lib  -lws2_32
