Scripts in this folder will run the real time tickerplant demo.

They assume that q is installed in the default location, i.e.
c:\q in Windows and ~/q in Linux/Mac.

This folder should also be placed in the default location, i.e. 
c:\q\start\tick in Windows and ~/q/start/tick in Linux/Mac

kdb+tick should be downloaded from http://code.kx.com/wsvn/code/kx/kdb+tick and placed in start/tick.  You should therefore have a further subdirectory called tick. The file, sym.q, which defines the table schema and is contained in the start/tick directory, should be copied into start/tick/tick.  This will give a directory with following files:

start/tick/tick.q 	- tickerplant script
start/tick/tick/r.q 	- rdb script 
start/tick/tick/sym.q 	- table schema
start/tick/tick/u.q 	- publish and subscribe code

Also rlwrap should be installed in Linux/Mac.

1. Windows

Run the batch file: start/tick/run.bat

2. Mac

First open the Terminal, and ensure that "Terminal|Preferences|New tabs open with"
is set to "Default Settings".

Then in Finder browse to start/tick and select the run application.  Once you have clicked the run application, do not change the focus (e.g. do not click on a Safari window) until all the processes have launched in new tabs.  The processes will launch 0.5 seconds apart, with "feed" being the last process to start. 

The file runsource.applescript has the application source code.

3. Linux

The scripts use gnome-terminal - change this if necessary.

Then run script: start/tick/run.sh
