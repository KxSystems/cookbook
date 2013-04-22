Rserve for kdb+
---------------

This is a kdb+ interface to Rserve, http://www.rforge.net/Rserve.

Directories:

 - base has the kdb+ interface
 - Rconnection has the Rserve c++ client
 - bin has l64, l32, m64 and w32 shared libraries for kdb+ 3.0

The w32 library is for connections without authentication,
e.g. to a local Rserve server.

To recompile, run make (or makewin.bat) in Rconnection, then
make (or makewin.bat) in base. Note, you can ignore warnings that
the closesocket macro is defined in both k.h and Rconnection.h.

To run:
 - start an Rserve server
 - edit demo.q to set login credentials
 - load q, and then demo.q

---

See also kx wiki http://code.kx.com/wiki/Cookbook/IntegratingWithR.

Tested on Rserve 0.6.8 and 1.7.0 with kdb+ 3.0.

Chris Burke
22 April 2013
