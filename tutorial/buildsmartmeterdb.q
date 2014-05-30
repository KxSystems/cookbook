/- the historic database directory to save to
hdb:`$":./smartmeterDB"

/- the date range to save
startdate:2013.08.01
enddate:2013.09.30

/- the number of customers of each type - residential, commercial, industrial
/- if >10m customers of one type, modify idbase as well
custtypes:`residential`commercial`industrial
counts:custtypes!8000 1500 500

/- the gap between samples from each smartmeter
/- should not be lower than 0D00:01 (1 minute)
sampleperiod:0D00:01

/- To compress the data when saving it, uncomment the line below
/- various compression options are available
/- For details see http://code.kx.com/wiki/Cookbook/FileCompression
/- need to ensure compatibility
/ $[(.z.K>=2.8) and .z.k>=2011.11.21; .z.zd:15 1 0; '"cannot use .z.zd for compression - incompatible kdb+ version"]

/---- Should not need to change anything below here
/---- but feel free to look and modify as required!

logout:{-1(string .z.Z)," ",x} 

/- the list of dates to save
datelist:startdate+til 1+enddate-startdate

/- the base line start point for each customer type
base:custtypes!20 40 300

/- a set of lookups to determine which "region" each customer is in 
/- mapping of region!probabilty of that customer type being in that region
regions:`mallusk`carnmoney`glengormley`templepatrick
regionmap:custtypes!(`s#0 .05 .45 .85!regions;`s#0 .1 .3 .8!regions;`s#0 .8 .8 .85!regions)

/- the base ID for each of the customer types
idbase:custtypes!10000000 20000000 30000000

/- generate a random baseline daily usage for each of the customers
/- dictionary is id!(baseusage;profiletype)
baseusage:raze {(idbase[x]+til counts[x])!flip(`long$(0.5*base[x])+counts[x]?base[x];counts[x]#x)} each custtypes

/- add a unique attribute to base usage for faster lookups
baseusage:(`u#key baseusage)!value baseusage

/- a dictionary to store the current usage for a premises, so the data for consecutive days lines up
currentusage:key[baseusage]!count[baseusage]#0f

/- function to generate some noise
noise:{[n] (-.5+n?1f)+n?-5 -4 -3 -2 -1 0 0 0 1 2 3 4 5}

/- generate a gradient. 
/- at each time point the usage can either go up or down
/- The numbers on the right are the probability of upward movement, the corresponding number on the left
/- is the number of time ticks to apply it for (a time tick being 1 minute)
comgrad:raze(300 60 60 60 60 30 150 30 60 30 180 60 240 60 60)#'.5 .55 .6 .7 .6 .55 .5 .6 .5 .4 .5 .48 .385 .48 .5
resgrad:raze(360 30 60 30 480 60 180 60 120 60)#'.5 .6 .5 .45 .5 .55 .5 .48 .43 .5
indgrad:raze(300 120 900 120)#'.5 .75 .5 .25

gradients:custtypes!(resgrad;comgrad;indgrad)

/- the sample points - each smart meter produces a data point every X minutes
/- generate the indices to sample at, and the corresponding sampletimes
/- we need to sample one more value (the last value) than we actually return
/- hence why samples has one more value than sampletimes
samples:`int$((sampleperiod:0D00:01|sampleperiod)%0D00:01)*til `int$1+1D%sampleperiod
sampletimes:-1 _ samples*0D00:01

/- given a gradient probability vector, generate a randomised gradient. Each point is either a +1 or a -1
grad:{[gradient] -1+2*gradient>count[gradient]?1f}

/- generate a random day profile given a base value b and gradient vector g
profile:{[b;g] (0f,sums 0|b+noise[count g]+sums grad[g]) samples}

/- generate a day profile for a given id
/- taking into account the current usage total, and the standard baseline usage
genprofile:{[id]
 
 /- get the profile for the id, given the starting point 
 p:currentusage[id]+profile[baseusage[id;0];gradients[baseusage[id;1]]];
 
 /- store the usage
 currentusage[id]:last p;
 
 /- return the profile, drop the last value
 -1 _ p}

/- generate a table of usages.  Randomise the times 
gen1day:{([] time:(`timespan$1000*(count[sampletimes]*count[baseusage])?30000000)+raze count[baseusage]#enlist sampletimes; 
	     meterid:raze count[sampletimes]#'key baseusage; 
             usage:.01*raze genprofile each key baseusage)}

save1day:{[hdb;date]
 logout["Generating random data for date ",string date];
 
 /- modify the time to include the date
 meter::update time:`timestamp$time+date from gen1day[];
 
 /- garbage collect to minimise the memory before the save
 .Q.gc[];
 
 logout["Saving to hdb ",string hdb];
 
 /- save the table
 .[.Q.dpft;(hdb;date;`meterid;`meter);{'"save failed :",x}];
 
 /- tidy up
 delete meter from `.;
 .Q.gc[];

 logout["Save complete"]; 
 }

/- save a table of static data
savestatic:{[hdb]
 logout["Saving static data table to ",string stat:`$string[hdb],"/static"];
 /- create a static data table
 static:([meterid:key baseusage] custtype:`g#value baseusage[;1]; region:`g#raze {regionmap[x]y?1f}'[key counts;value counts]);
 .[set;(stat;static);{'"failed to save static table: ",x}];
 }

savepricing:{[hdb]
 logout["Saving pricing tables to ",(string basicp:`$string[hdb],"/basicpricing")," and ",string timep:`$string[hdb],"/timepricing"];
 /- define a pricing table
 /- different customer types have different pricing schedules
 basicpricing:([custtype:custtypes] price:1.0 0.8 0.5);
 timepricing:([custtype:custtypes] time:(00:00 08:00 11:15 12:00 17:00 18:00 22:15;
                                       00:00 09:00 17:00 20:00;
                                       00:00 08:00 17:00);
                                 price:(0.6 1.2 1.1 1.0 1.1 1.4  0.6;
                                        0.6 0.9 0.8 0.6;
                                        0.4 0.6 0.4));
 .[set;(basicp;basicpricing);{'"failed to save basicpricing table: ",x}];
 .[set;(timep;timepricing);{'"failed to save timepricing table: ",x}];
 }

/- generate some payment information
/- assume that each "customer type" pays a fixed amount per month based on their type, and that they pay on the last day of each month
/- just give each customer type the same payment
/- res pays 11500
/- com pays 25000
/- ind pays 80000
savepayment:{[hdb;datelist;nonpay]
 /- work out the list of months to save
 /- should be a payment for each month, on the last day
 mthlist:-1 _ months:distinct `month$datelist:asc datelist,:();
 if[not (last months)=`month$1+last datelist; mthlist,:last months];
 /- create a payment table
 payments:([]date:-1+`date$1+mthlist) cross ([]meterid:key baseusage; custtype:value baseusage[;1]);
 /- join on the payment value
 payments:payments lj ([custtype:custtypes] amount:11500 25000 80000f);
 /- randomly remove some payments (for non-paying customers)
 payments:delete from payments where i in (neg`long$nonpay*count payments)?count payments;
 logout["Saving payment table to ",string pay:`$string[hdb],"/payment/"];
 .[set;(pay;.Q.en[hdb;delete custtype from payments]);{'"failed to save payment table: ",x}];
 }

-1"This process is set up to save a daily profile across ",string[count datelist]," days for ",string[sum counts]," random customers with a sample every ",string[`int$sampleperiod%0D00:01]," minute(s).";
-1"This will generate ",.Q.f[2;.000001*daycount]," million rows per day and ",.Q.f[2;.000001*totalcount:count[datelist]*daycount:sum[counts]*`int$1D%sampleperiod]," million rows in total";
-1"Uncompressed disk usage will be approximately ",string[daymb]," MB per day and ",string[count[datelist]*daymb:`int$((40*sum counts)+daycount*24)%2 xexp 20]," MB in total"; 
-1"Compression is switched ",@[{value x;"ON"};`.z.zd;"OFF"];
-1"Data will be written to ",string hdb;
-1"";
-1"To modify the volume of data change either the number of customers, the number of days, or the sample period of the data.  Minimum sample period is 1 minute";
-1"These values, along with compression settings and output directory, can be modified at the top of this file (",(string .z.f),")";
-1"";
-1"To proceed, type go[]";


/- do the save
go:{
 start:.z.p; 
 savestatic[hdb];
 savepricing[hdb]; 
 save1day[hdb] each datelist;
 savepayment[hdb;datelist;0.05];
 -1"\n";
 end:.z.p;
 logout["HDB successfully built in directory ",string hdb];
 logout["Time taken to generate and store ",.Q.f[2;.000001*totalcount]," million rows was ",string timetaken:`second$end-start];
 logout["or ",.Q.f[2;.000001*totalcount%`int$timetaken]," million rows per second"];
 
 exit 0}
