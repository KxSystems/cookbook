# runs kdb+ real time demo
# assumes install in default location, otherwise change Q, T
# Terminal|Preferences|New tabs open with must be set to "Default Settings"

global Q, R, T

set R to ""
tell application "Finder" to if exists "/opt/local/bin/rlwrap" as POSIX file then set R to "rlwrap "
set Q to R & "~/q/m32/q"
set T to "~/q/start/tick/"

on newdb(name, port)
	newtab(name, Q & " " & T & "cx.q " & name & " -p " & (port as text))
end newdb

on newtab(name, cmd)
	tell application "System Events" to tell process "Terminal.app" to keystroke "t" using command down
	tell application "Terminal" to do script cmd in front window
	setname(name)
	delay (0.5)
end newtab

on setname(name)
	tell front window of application "Terminal"
		tell selected tab
			set title displays device name to false
			set title displays file name to false
			set title displays shell path to false
			set title displays window size to false
			set title displays custom title to true
			set custom title to name
		end tell
	end tell
end setname

on netstat()
	do shell script "netstat -an | grep -i listen | grep 5010"
end netstat

on hasticker()
	try
		netstat()
		display dialog "Tickerplant already running"
		return true
	end try
	return false
end hasticker

on wait4ticker()
	repeat 20 times
		try
			delay 0.1
			netstat()
			return true
		end try
	end repeat
	display dialog "Could not start tickerplant"
	return false
end wait4ticker

tell application "Terminal"
	activate
	if (true = my hasticker()) then return
	do script "cd " & T & "; " & Q & " " & T & "/tick.q -p 5010"
	delay (0.5)
	if (false = my wait4ticker()) then return
	set number of rows of front window to 30
	set number of columns of front window to 100
	my newtab("rdb", "cd " & T & "; " & Q & " " & T & "/tick/r.q -p 5011")
	my newdb("hlcv", 5014)
	my newdb("last", 5015)
	my newdb("tq", 5016)
	my newdb("vwap", 5017)
	my newdb("show", 0)
	my newtab("feed", Q & " " & T & "feed.q localhost:5010 -t 507")
	set selected of tab 1 of front window to true
	my setname("ticker")
	set selected of tab 2 of front window to true
end tell
