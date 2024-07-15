Scripts in this folder will run the real time tickerplant demo.

There is a dependancy on tickerplant and rdb scripts, avalable from
https://github.com/KxSystems/kdb-tick
and kdb+.

To run demo:

Copy sym.q (table schema) to <kdb-tick directory>/tick/sym.q

From the downloaded kdb-tick directory run the following in seperate terminal windows:

q tick.q -p 5010
q tick/r.q -p 5011

From this directory run the following in seperate terminal windows:

q cx.q hlcv -p 5014 -t 1000
q cx.q last -p 5015 -t 1000
q cx.q tq -p 5016 -t 1000
q cx.q vwap -p 5017 -t 1000
q cx.q show

q feed.q localhost:5010 -t 107

See https://code.kx.com/q/learn/startingkdb/tick/ for more details
