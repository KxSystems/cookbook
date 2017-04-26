R server for Q
--------------

The Makefile is for kdb+ 3. Change KXVER to 2 for earlier versions.

Copy in k.h and run make.

Calling R
---------

When calling R, you need to set R_HOME. For example, a script to load q might be:

  #!/bin/bash
  export R_HOME=/Library/Frameworks/R.framework/Resources
  cd ~/q
  rlwrap m64/q "$@"

---

See also kx wiki http://code.kx.com/wiki/Cookbook/IntegratingWithR.

Tested on gcc 4.8.1, R 2.15.3 and kdb+ 3.1.

Chris Burke
5 Oct 2013
