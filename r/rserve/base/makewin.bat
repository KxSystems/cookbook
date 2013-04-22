rem make w32 rserve client

del *.dll

g++ -D KXVER=3 -I. -I../include -L. -D Win32 -shared ^
 -Wl,--export-all-symbols -o rserve.dll *.cc q.a ^
 ../Rconnection/Rconnection.o -lwsock32

copy rserve.dll c:\q\w32
