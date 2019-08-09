embedR: Embedding R inside q
============================



See  <https://code.kx.com/v2/interfaces/with-r/#calling-r-from-q>


Installation
------------

The Makefile works on l64 and l32, and is for kdb+ 3. Change KXVER to 2 for earlier versions.
It requires that R be available as a shared object, libR.so (compile R using --enable-R-shlib,
or install a package with the shared object, e.g. Rserve). 
For all platforms it is advisable to set `R_HOME`


### Linux/macOS

```bash
export R_HOME=`R RHOME`
```


### Windows

```bash
R.exe RHOME
set R_HOME=<output of above>
```


### Linux and macOS

Just run `make` in this folder. Do remember to set QHOME beforehand.


### Windows

Install [R tools](https://cran.r-project.org/bin/windows/Rtools/). It uses `mingw` to compile package and has been tested and used by R package authors.

Set your `QHOME` and add R to the `PATH` on your system. 

For 32-bit DLL run 

```bash
sh w32.sh
```

For 64-bit

```bash
sh w64.sh
```

Copy  DLLs (`w32/rserver.dll` and `%R_HOME%\bin\i386\*.dll` for 32-bit and `w64/rserver.dll` and `%R_HOME%\bin\x64\*.dll` for 64-bit) to `QHOME/w32` or `w64` respectively.
Copy `rinit.q` and `rtest.q` to `%QHOME%`.

When using 32-bit or 64-bit R make sure you have the appropriate R version in your path.


Calling R
---------

When calling R, you need to set `R_HOME`. Required are:

```bash
  R_HOME               - R home path      (e.g. /usr/lib/R)
```

For example, a script to load q might be:

```bash
#!/bin/bash
export R_HOME=`R RHOME`
rlwrap $QHOMEm64/q "$@"
```

If using interactive plotting, you have to take care of some extras.

1.  Call `Reventloop[]`. Note that this will override timer and `.z.ts`. It will give the R library some time to process graphics events. (macOS and Windows only.)
2.  To plot with `lattice` and/or `ggplot2` you will need to call `print` on chart object. 


Examples
--------

Note: Examples are kdb+ 3.5 or higher.

See examples folder:

### Example 1

`e4.q` is a simple example to plot ‘moving window volatility’ of returns. Converted from <http://www.mayin.org/ajayshah/KB/R/html/p4.html>


### Example 2

`pcd.q` is based on [corporate credit-card transactions 2014-15]( https://data.gov.uk/dataset/corporate-credit-card-transaction-2014-15).

Download CSV from the link above and save it in the same folder as `pcd.q` as `pcd2014v1.csv`.


### Example 3

<http://data.london.gov.uk/datastore/package/tubenetwork-performance-data>
Left for the reader :)



