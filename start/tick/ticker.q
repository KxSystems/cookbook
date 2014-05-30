/ ticker.q
/ simple tickerplant example
/ not suitable for production code, for this use kdb+tick

quote:flip `time`sym`bid`ask`bsize`asize`mode`ex!()
trade:flip `time`sym`price`size`stop`cond`ex!()

Sub:`quote`trade!()
sub:{Sub[x],:enlist x,y,neg .z.w}

pub:{{.[pub1;x]} each Sub x}
pub1:{[t;s;h]
 sel:$[s~`all;value t;select from t where sym in s];
 if[count sel;@[h;("upd";t;sel);()]]}

upd:{[t;x]
 m:enlist(count x 0)#.z.T;
 upd1[t;m,x]}

upd1:{[t;x]
 t insert x;
 pub t;
 delete from t}
