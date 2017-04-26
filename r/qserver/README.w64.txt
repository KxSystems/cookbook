
This is a 64-bit Windows version of the Q server, built with gcc and R-2.14.1.

The binaries are built for kdb+ 3.0. For earlier kdb+, use the version from svn release 1395. 

The c.o is single threaded. The usual c.obj on the Kx site will not work.

To rebuild the dll:

Create c:\r and copy the files there, also copy common.c and qserver.c to c:\c. Copy in R.dll from the R bin directory, e.g. c:\Program Files\R\R-2.14.1\bin\x64\R.dll.

Use gcc, and not the Microsoft compiler. Compile as:

C:\r>gcc -c base.c -I. -I "\Program Files\R\R-2.41.1\include" -D KXVER=3
C:\r>gcc -Wl,--export-all-symbols -shared -o qserver.dll c.o base.o R.dll -lws2_32

To test, assuming a q instance listening on port 5000 with a table t defined, try in R:

> source("c:/r/test.R")

Note that open_connection actually takes 3 arguments with defaults of "localhost" for the host to connect to, 5000 for the port and none for the user/password credentials.

The file qserver.R can be changed to suit your installation and preferred function names for open_connection, execute and close_connection.

Modify this line with the path to qserver.dll:
dyn.load("c:/r/qserver.dll")

