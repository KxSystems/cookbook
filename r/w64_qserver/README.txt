
File qserver.dll is a 64-bit Windows version of the Q server for R, built with gcc and R-2.12.1.

Compile
-------

To recompile, create c:\r and copy the files there. Copy in R.dll from the R bin directory, e.g. c:\Program Files\R\R-2.12.1\bin\R.dll.

The c.o is single threaded. The usual c.obj on the Kx site will not work.

Compile as:

C:\r>gcc -c base.c -I. -I "\Program Files\R\R-2.12.1\include"
C:\r>gcc -Wl,--export-all-symbols -shared -o qserver.dll c.o base.o R.dll -lws2_32

Example
-------

In R, assuming a q instance listening on port 5000 with a table t defined, try:

> source("c:/r/qserver.r")
> c <- open_connection()
> t <- execute(c, "select from t")
> close_connection(c)

Note that open_connection actually takes 3 arguments with defaults of "localhost" for the host to connect to, 5000 for the port and none for the user/password credentials.

The file qserver.R can be changed to suit your installation and preferred function names for open_connection, execute and close_connection.

Modify this line with the path to qserver.dll:
dyn.load("c:/r/qserver.dll")

