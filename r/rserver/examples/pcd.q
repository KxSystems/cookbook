//\l rinit.q

basedir:`:.^hsym `$last -2 _ get{}
datafile:` sv first[` vs basedir],`pcd2014v1.csv
// switch parsing to british data
system"z 1"
cct:("***D*DE";enlist csv) 0:datafile
cct:(`$"_"^string cols cct) xcol cct

Rinstall`lattice
Rcmd"library(lattice)"

Rset["tpd";select txn:count i by Transaction_Date from cct]
Rcmd"png('pcd-1.png')"
Rcmd"plot(txn~Transaction_Date,data=tpd,main=\"Payments per day\")"
Roff[]

Rset[`tpt;select Transaction_Date,spent:sums JV_Value from select sum JV_Value by Transaction_Date from cct]
Rcmd"png('pcd-2.png')"
Rcmd"plot(spent~Transaction_Date,data=tpt,main=\"Total spent\")"
Roff[]


