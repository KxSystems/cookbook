
This library provides a Q server to R on OSX.

The Makefile is for kdb+ 3. Change KXVER to 2 for earlier versions.

Copy in k.h and m64/c.o.

The file qserver.R should be changed to suit your installation, in particular use the correct path and filename for the .so file.

The qserver.so was built with gcc 4.8 on OSX 10.8.2 and R 3.0.2 for kdb+ 3.1.

An earlier qserver.so built with gcc 4.7 on OSX 10.8.2 and R 2.15.3 for kdb+ 3.0 is in svn rev 1583.

Note - the version of gcc supplied with OSX 10.8.2 (llvm-gcc42) does not work. A later version must be installed, e.g. using MacPorts (google update gcc macports).

See also http://code.kx.com/wiki/Cookbook/IntegratingWithR.

Thanks to Rory Winston for the port to OSX.

Chris Burke
15 Oct 2013
