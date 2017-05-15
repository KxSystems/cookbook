//\l rinit.q

Reventloop[];

basedir:`:.^hsym `$last -2 _ get{}
datafile:` sv first[` vs basedir],`pcd2014v1.csv
if[()~key datafile;'"Data file not found. See README.md"]

// switch parsing to british data
system"z 1"
cct:("***D*DE";enlist csv) 0:datafile
cct:(`$"_"^string cols cct) xcol cct

Rcmd"library(lattice)"
Rnew[]
Rset["tpd";select txn:count i by Transaction_Date from cct]
Rcmd"plot1<-xyplot(txn~Transaction_Date,data=tpd,main='Payments per day')"
Rcmd"print(plot1)"


Rset[`tpt;select Transaction_Date,spent:sums JV_Value from select sum JV_Value by Transaction_Date from cct]
Rnew[]
Rcmd"plot2<-xyplot(spent~Transaction_Date,data=tpt,main='Total spent')"
Rcmd"print(plot2)"

Rinstall`plotly
Rcmd"library(plotly)"
Rset[`catd;select sum JV_Value by Service_Area from cct]
Rcmd"plot3<-plot_ly(catd, labels = ~Service_Area, values = ~JV_Value, type = 'pie')"
Rcmd"print(plot3)"