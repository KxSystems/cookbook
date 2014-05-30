#!/bin/bash
# start q under rlwrap

osascript <<END
 tell app "Terminal"
  do script "cd ~/q; rlwrap m32/q"
 end tell
END
