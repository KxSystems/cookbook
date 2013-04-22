/ demo rserve

/ Ropen argument has the form:
/  `:host:port:user:pass
/ if empty, defaults to:
/  `:localhost:6311

/ methods:
Rclose:`rserve 2:(`rsclose;1);
Rcmd:`rserve 2:(`rscmd;1);
Rget:`rserve 2:(`rsget;1);
Ropen:`rserve 2:(`rsopen;1);
Rset:`rserve 2:(`rsset;2);

/ -------------------------
/ dict of all types:
t:`$'"bgxhijefcspmdznuvt" ,' string (til 20) except 0 3
a:"p"$1234567890123456j*2 3 0N 0w -0w 5
d:t!(
 011101b;
 6?0Ng;
 "x"$"abcdef";
 2 3 0N 0w -0w 5h;
 20 30 0N 0W -0W 50i;
 (0N 0w -0wj,1 2 3 * 123456789123j)3 4 0 1 2 5;
 2.2 3.34 0N 0w -0w 5.567e;
 2.2 0.076923 0n 0w -0w 3.14159;
 "ab cef";
 `aapl`goog``ibm`msft`orcl;
 a;
 "m"$a;
 "d"$a;
 "Z"$(23&count each z)#'z:string each a;
 (24D*1 1 0 0 0 1)+"n"$a;
 "u"$a;
 "v"$a;
 "t"$a)

/ -------------------------
/ demos (change Ropen argument as required)
Ropen ""
Rcmd "a=0.123*2:7"
Rget "a"
Rset["abc";2 3 7i]
Rget "abc"
{Rset["a";x];Rget"a"} each value d
Rclose ""
