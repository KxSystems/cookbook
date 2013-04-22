rem make w32 Rconnection

del *.o
g++ -I../include -I.. -I. -DNO_CONFIG_H -DWin32 -c Rconnection.cc
