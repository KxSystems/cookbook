R server for Q
---------------

The Makefile works on l64 and l32. It requires that R be available as a shared object, libR.so (compile R using --enable-R-shlib, or install a package with the shared object, e.g. Rserve).

Calling R
---------

When calling R, you need to set appropriate environment variables. Required are:

  R_HOME               - R home path      (e.g. /usr/lib/R)
  LD_LIBRARY_PATH      - path to libR.so  (e.g. /usr/lib/R/lib)

Optional are (depends on what calls are made to R):

  R_SHARE_DIR          - R share dir      (e.g. /usr/share/R)
  R_INCLUDE_DIR        - R include dir    (e.g. /usr/share/R/include)

For example, a script to load q might be:

  #!/bin/bash
  export R_HOME=/usr/lib/R
  export LD_LIBRARY_PATH=$R_HOME/lib
  cd ~/q
  rlwrap l64/q profile.q "$@"

---

See also kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR.

Tested with R 2.7 and R 2.8.

Chris Burke
4 Mar 2009
