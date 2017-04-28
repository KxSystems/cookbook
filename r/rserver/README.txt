R server for Q
--------------

See Kx wiki http://code.kx.com/q/cookbook/interfacing-with-r/

Installation
------------

The Makefile works on l64 and l32, and is for kdb+ 3. Change KXVER to 2 for earlier versions.
It requires that R be available as a shared object, libR.so (compile R using --enable-R-shlib,
or install a package with the shared object, e.g. Rserve). 

Copy in k.h and run make.

Windows notes:

To recompile on windows you will need to install mingw gcc
Alternatively, install R tools (https://cran.r-project.org/bin/windows/Rtools/). It uses mingw as well, but has been tested and used by R package authors.

Create c:\rserver and copy the files there, also copy in R.dll from the R bin directory, i.e. c:\Program Files\R\R-2.15.1\bin\i386\R.dll. Note the i386 subdirectory is a recent addition. Create c:\c and copy common.c and rserver.c there. 

1)run t1.bat to compile w32/rserver.dll

2)copy all C:\program files\R\R-2.15.1\i386\bin\*.dll and rserver.dll into c:\q\w32

3)copy rinit.q and rtest.q into %QHOME%


Calling R
---------

When calling R, you need to set R_HOME. Required are:

  R_HOME               - R home path      (e.g. /usr/lib/R)

Optional are (depends on what calls are made to R):

  R_SHARE_DIR          - R share dir      (e.g. /usr/share/R)
  R_INCLUDE_DIR        - R include dir    (e.g. /usr/share/R/include)

Possibly required:

  LD_LIBRARY_PATH      - path to libR.so  (e.g. /usr/lib/R/lib)

For example, a script to load q might be:

  #!/bin/bash
  export R_HOME=/Library/Frameworks/R.framework/Resources
  cd ~/q
  rlwrap m64/q "$@"
