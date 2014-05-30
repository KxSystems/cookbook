// Script to generate large csv files for test loading

//--- CONFIG ------

// list of distinct instruments
syms:1000?`4
// exchange identifiers
exch:`N`O`L`X

// number of trades per day
tpd:1000000

// directory the csv will be written to
filedir:`:examplecsv

// date range to write
startdate:2014.01.01
enddate:2014.03.31

//--- END OF CONFIG ---- 

// get the name of the file to write to
getfilename:{[date] ` sv hsym[filedir],`$"trades",ssr[string `month$date;".";"_"],".csv"}

// generate 1 days worth of trades, write it to a file
gen1day:{[date;n] ([]sourcetime:`timestamp$date+asc 09:00:00.0 + n?08:00:00.0; instrument:n?syms;price:n?100f;size:n?10000;extra1:n?20;exchange:n?exch;extra2:n?10)}

// write out the test data
writetocsv:{[date;data] 
 -1(string .z.z)," writing ",(string count data)," rows to ",(string file:getfilename date)," for date ",string date;
 h:hopen file;
 // write out the csv data, dropping the header
 neg[h] $[hcount file;1 _ .h.cd data;.h.cd data];
 hclose h}

writedaterange:{[sd;ed;n]
 daterange:sd + til 1 + ed - sd;
 {[date;n] writetocsv[date; gen1day[date;n]]}[;n] each daterange;}

writedaterange[startdate;enddate;tpd]
