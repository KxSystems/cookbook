
This library provides a Q server to R.

The Makefile works on l64 and l32, and is for kdb+ 3. Change KXVER to 2 for earlier versions.
Copy in k.h and the appropriate platform c.o.

The file qserver.R should be changed to suit your installation, in particular use the correct path and filename for the .so file.

See also kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR.

Tested with R 2.12.1 and kdb+ 3.0.

Originally developed by Niall Dalton.

Chris Burke
4 July 2012
