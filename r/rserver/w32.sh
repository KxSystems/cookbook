R32=`R.exe RHOME`/bin/i386
$R32/R.exe CMD SHLIB -o w32/rserver.dll base.c w32/q.a -DKXVER=3
