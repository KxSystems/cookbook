This is a 32-bit Windows port of the R server for Q suitable for use with R 2.9.0 or higher. The following assumes R.2.15.1 - change as appropriate. 

The gcc call is for kdb+ 3. Change KXVER to 2 for earlier versions.

Create c:\rserver and copy the files there, also copy in R.dll from the R bin directory, i.e. c:\Program Files\R\R-2.15.1\bin\i386\R.dll. Note the i386 subdirectory is a recent addition. Create c:\c and copy common.c and rserver.c there. 

1)run t1.bat to compile w32/rserver.dll

2)copy all C:\program files\R\R-2.15.1\i386\bin\*.dll and rserver.dll into c:\q\w32

3)copy rinit.q and rtest.q into C:\q

The R.2.15.1 compiled rserver.dll is included. To recompile, you need to install mingw gcc http://www.mingw.org/wiki/InstallationHOWTOforMinGW.

Thanks to Sergey Vidyuk for creating this port.

Chris Burke
4 July 2012
