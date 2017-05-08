R server for Q
--------------

See Kx wiki http://code.kx.com/q/cookbook/interfacing-with-r/

Installation
------------

The Makefile works on l64 and l32, and is for kdb+ 3. Change KXVER to 2 for earlier versions.
It requires that R be available as a shared object, libR.so (compile R using --enable-R-shlib,
or install a package with the shared object, e.g. Rserve). 
For all platforms it is advisable to set `R_HOME`

Linux/macOS
```
export R_HOME=`R RHOME`
```
Windows
```
R.exe RHOME
set R_HOME=<output of above>
```

Linux and macOS

Just run `make` in this folder. Do remember to set QHOME beforehand.

Windows

Install R tools (https://cran.r-project.org/bin/windows/Rtools/). It uses mingw to compile package and has been tested and used by R package authors.

Set your QHOME and add R to the PATH on your system. 
For 32bit dll run 
```
sh w32.sh
```

For 64bit
```
sh w64.sh
```

Copy  DLLs(w32/rserver.dll and %R_HOME%\bin\i386\*.dll for 32 bit and w64/rserver.dll and %R_HOME%\bin\x64\*.dll for 64 bit) to QHOME/w32 or w64 respectively.
Copy rinit.q and rtest.q to %QHOME%

When using 32bit or 64bit R make sure you have appropriate R version in your path.

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
```
  #!/bin/bash
  export R_HOME=/Library/Frameworks/R.framework/Resources
  cd $QHOME
  rlwrap m64/q "$@"
```