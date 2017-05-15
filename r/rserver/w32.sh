R32=`R.exe RHOME`/bin/i386
export PKG_CFLAGS=-DKXVER=3
export PATH=$R32:"$PATH"
rm -f base.o
$R32/R.exe CMD SHLIB -o w32/rserver.dll base.c w32/q.a
cp w32/rserver.dll $QHOME/w32
