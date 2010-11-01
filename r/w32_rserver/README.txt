This is a 32-bit Windows port of the R server for Q suitable for use with R 2.9.0 or higher. The following assumes R.2.11.1 - change as appropriate.

Create c:\rserver and copy the files there. Also copy in R.dll from the R bin directory, i.e. c:\Program Files\R\R-2.11.1\bin\R.dll.

1)Run t1.bat to compile w32/rserver.dll

2) copy all C:\program files\R\R-2.11.1\bin\*.dll and rserver.dll into c:\q\w32

3) copy rinit.q and rtest.q into C:\q

Note, the R.2.11.1 compiled rserver.dll is included. If you need to recompile, you need to install mingw gcc http://www.mingw.org/wiki/InstallationHOWTOforMinGW.

Thanks to Sergey Vidyuk for creating this port.

Chris Burke
1 Nov 2010
