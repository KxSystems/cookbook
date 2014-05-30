/- Load the tutorial functions
@[system;"l tutorial.q";{-1"Failed to load tutorial.q : ",x;exit 1}]

/- load the smart meter functions
@[system;"l smartmeterfunctions.q";{-1"Failed to load smartmeterfunctions.q : ",x;exit 1}]

/- load the smart meter UI
@[system;"l ui/json.k";{-1"Failed to load json.k : ",x;exit 1}]
@[system;"l ui/smartmeterui.q";{-1"Failed to load smartmeterui.q : ",x;exit 1}]
.h.HOME:"../ui/html"

/- Load the HDB
hdbdir:$[0=count .z.x;"./smartmeterDB";.z.x 0]
@[system;"l ",hdbdir;{-1"Failed to load specified hdb ",x,": ",y;exit 1}[hdbdir]]

/- turn on garbage collection
.tut.gcON[]

/- Add in the smart meter details
.tut.add["meterusage[2013.08.01;2013.08.10]";"Total meter usage for every customer over a 10 day period"];
.tut.add["monthlyusage[2013.08m]";"Total meter usage for every customer for a given month"];
.tut.add["monthlychange[2013.08m;2013.09m]";"Change in average daily meter usage between two months for every customer, ranked by absolute size of change.\nAverage daily figures are used as months have different numbers of days"]
.tut.add["monthlyusagebycusttype[2013.08 2013.09m]";"Total monthly usage by customer type for a given set of months"];
.tut.add["meterusagepivot[2013.08.01;2013.08.31;0b]";"Total meter usage pivotted by customer type and region"];
.tut.add["meterusagepivot[2013.08.01;2013.08.31;1b]";"Total meter usage pivotted by customer type and region as a %"];
.tut.add["meterusagejump[2013.08.01;2013.08.31;20;100]";"For every meter over the given date range, calculate the (daycount) day moving average of total usage,\nand return those days where the usage is outside of the rangecheck percentage value"];
.tut.add["dailystats[2013.08.01;2013.08.07]";"Daily statistics for each meter including flow rates to the customer"];
.tut.add["dailystatsoptimized[2013.08.01;2013.08.12]";"Daily statistics for each meter including flow rates to the customer, with optimized implementation for slaves\nand to minimize memory usage"];
.tut.add["groupusage[2013.08.01;2013.08.31;exec meterid from static where custtype=`commercial;15]";"Time bucketed usage stats for a set of meterids aggregated together.\nThis example computes the usage stats for all the commercial customers combined."];
.tut.add["dailyaverageprofile[2013.08.01;2013.08.31;exec meterid from static where custtype=`commercial;15]";"Time bucketed usage, averaged over a date range, for a set of meter ids.\nThis example computes the average profile for all the commercial customers combined."];
.tut.add["comparetoprofile[2013.08.01;2013.08.31;exec meterid from static where custtype=`commercial;15;2013.08.01;2013.08.31;exec meterid from static where custtype=`industrial]";"Compare average daily volume profiles e.g. for different time periods, different customer types etc.\nThis example compares the profiles for the commercial and industrial customer bases."]
.tut.add["basicmonthlybill[2013.08m;2013.09m]";"Calculate the monthly bill for each customer using the basic pricing table"]
.tut.add["monthlybalance[2013.08m;2013.09m]";"Using the basic monthly bill and joining with the payments table, calculate the running balance for each customer"]
.tut.add["usageperperiod[2013.08.01;2013.08.10]";"Using the pricing table to define different periods of the day with different prices on a per-customertype basis,\nfor every day and every meter calculate how much was used in each pricing period.\nThis is a much more complex query than the basic billing query"]
.tut.add["bill[2013.08.01;2013.08.10]";"Using usageperperiod, calculate the total bill for every meter"];
.tut.add["usageperprice[2013.08.01;2013.08.10]";"Using usageperperiod, calculate the total usage at each price point"];
/- export and import
.tut.add["exportdailystats[2013.08.01;2013.08.10;`:../dailystats.csv]";"Export daily stats to csv file"]
.tut.add["importdailystats[`:../dailystats.csv]";"Import the daily stats file which has just been created"]

/- Print out the tutorial info
.tut.db[];
-1"The meter table contains the updates from the smart meters.";
-1"The usage value is the total cumulative usage to date.";
-1"The time is the time the update was received.";
-1"The static table contains the associated lookup data for each meter.";
-1"Each meter belongs to a specific customer type in a specific region.\n";
-1"The customer type distribution is:";
show select number:count i by custtype from static;
-1"\nThe region distribution is:";
show select number:count i by region from static;
-1"\nThe basicpricing table contains price-per-unit information for each customer type";
-1"for different periods of the day";
show basicpricing
-1"\nThe timepricing table contains price-per-unit information for each customer type";
-1"for different periods of the day";
show timepricing
.tut.info["SMART METER DEMO"]
