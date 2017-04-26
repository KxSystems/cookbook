R server for Q
--------------

The Makefile works on l64 and l32, and is for kdb+ 3. Change KXVER to 2 for earlier versions.
It requires that R be available as a shared object, libR.so (compile R using --enable-R-shlib,
or install a package with the shared object, e.g. Rserve). Also, copy in k.h.

Calling R
---------

When calling R, you need to set appropriate environment variables.
Required are:

  R_HOME               - R home path      (e.g. /usr/lib/R)

Optional are (depends on what calls are made to R):

  R_SHARE_DIR          - R share dir      (e.g. /usr/share/R)
  R_INCLUDE_DIR        - R include dir    (e.g. /usr/share/R/include)

Possibly required:

  LD_LIBRARY_PATH      - path to libR.so  (e.g. /usr/lib/R/lib)

For example, a script to load q might be:

  #!/bin/bash
  export R_HOME=/usr/lib/R
  cd ~/q
  rlwrap l64/q profile.q "$@"

---

See also kx wiki http://code.kx.com/wiki/Cookbook/IntegratingWithR.

Tested on R 2.12.1 and kdb+ 3.0.

Chris Burke
4 July 2012
