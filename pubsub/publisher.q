\d .testdata

// set the port
@[system;"p 6812";{-2"Failed to set port to 6812: ",x,
	 	     ". Please ensure no other processes are running on that port",
		     " or change the port in both the publisher and subscriber scripts.";  
		     exit 1}]

// create some test data to be published
// this could also be read from a csv file (for example)
meterdata:([]sym:10000?200j; reading:10000?500i)
griddata:([]sym:2000?100?`3; capacity:2000?100f; flowrate:2000?3000i) 

// utility functions to get the next set of data to publish
// get the next chunk of data, return to start once data set is exhausted
counts:`.testdata.meterdata`.testdata.griddata!0 0
getdata:{[table;n]
 res:`time xcols update time:.z.p from (counts[table];n) sublist value table;
 counts[table]+:n;
 if[count[value table]<=counts[table]; counts[table]:0];
 res} 
getmeter:getdata[`.testdata.meterdata]
getgrid:getdata[`.testdata.griddata]

\d .

// the tables to be published - all must be in the top level namespace
// tables to be published require a sym column, which can be of any type
// apart from that, they can be anything you like
meter:([]time:`timestamp$(); sym:`long$(); reading:`int$())
grid:([]time:`timestamp$(); sym:`symbol$(); capacity:`float$(); flowrate:`int$())

// load in u.q from tick
upath:"tick/u.q"
@[system;"l ",upath;{-2"Failed to load u.q from ",x," : ",y, 
		       ". Please make sure u.q is accessible.",
                       " kdb+tick can be downloaded from http://code.kx.com/wsvn/code/kx/kdb+tick";
		       exit 2}[upath]]

// initialise pubsub 
// all tables in the top level namespace (`.) become publish-able
// tables that can be published can be seen in .u.w
.u.init[]

// functions to publish data
// .u.pub takes the table name and table data
// there is no checking to ensure that the table being published matches
// the table schema defined at the top level
// that is left up to the programmer!
publishmeter:{.u.pub[`meter; .testdata.getmeter[x]]}
publishgrid:{.u.pub[`grid; .testdata.getgrid[x]]}

// create timer function to randomly publish
// between 1 and 10 meter records, and between 1 and 5 grid records
.z.ts:{publishmeter[1+rand 10]; publishgrid[1+rand 5]}

/- fire timer every 1 second
\t 1000
