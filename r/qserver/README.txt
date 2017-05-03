
This library provides a Q server to R.

The Makefile works on l64/l32/m64, and is for kdb+ 3. Change KXVER to 2 for earlier versions.

The file qserver.R should be changed to suit your installation, in particular use the correct path and filename for the .so file.

See also kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR.


Windows notes:

The c.o is single threaded. The usual c.obj on the Kx site will not work.

To rebuild the dll:
```
sh w32.sh
```
or 
```
sh w64.sh 
```
To test, assuming a q instance listening on port 5000 with a table t defined, try in R:
```
> source("c:/r/test.R")
```
Note that open_connection actually takes 3 arguments with defaults of "localhost" for the host to connect to, 5000 for the port and none for the user/password credentials.

Modify this line with the path to qserver.dll:
dyn.load("c:/r/qserver.dll")

