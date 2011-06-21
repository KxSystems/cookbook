
This is a 32-bit Windows version of the Q server for R suitable for use with R 2.7.0 or higher.

Create c:\r and copy the files there, also copy common.c and qserver.c to c:\c.

It is recommended to use gcc, and not the Microsoft compiler. Copy in R.dll from the R bin directory, e.g. c:\Program Files\R\R-2.9.0\bin\R.dll.

The c.o is single threaded. The usual c.obj on the Kx site will not work.

Compile as:

C:\r>gcc -c base.c -I. -I "\Program Files\R\R-2.9.0\include"
C:\r>gcc -Wl,--export-all-symbols -shared -o qserver.dll c.o base.o R.dll -lws2_32

Then in R, assuming a q instance listening on port 5000 with a table t defined, try:

> source("c:/r/qserver.r")
> c <- open_connection()
> t <- execute(c, "select from t")
> close_connection(c)

Note that open_connection actually takes 3 arguments with defaults of "localhost" for the host to connect to, 5000 for the port and none for the user/password credentials.

The file qserver.R can be changed to suit your installation and preferred function names for open_connection, execute and close_connection.

Modify this line with the path to qserver.dll:
dyn.load("c:/r/qserver.dll")

