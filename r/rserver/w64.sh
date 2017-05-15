R64=`R.exe RHOME`/bin/x64
export PKG_CFLAGS=-DKXVER=3
export PATH=$R64:"$PATH"
echo $PATH
rm -f base.o
$R64/R.exe CMD SHLIB -o w64/rserver.dll base.c w64/q.a
cp w64/rserver.dll $QHOME/w64
