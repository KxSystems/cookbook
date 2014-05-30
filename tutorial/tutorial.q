\d .tut

displayrows:10
torun:([]func:();descrip:())
current:-1
out:{-1(string .z.Z)," ",x;}
gc:0b

/- run a function, time it and show some results
runfunc:{[execstring;descrip]
 -1"";
 -1 header:(10#"*"),"  Example ",(string current),"  ",10#"*"; 
 -1"";
 -1 descrip;
 -1"";
 func:first "[" vs execstring;
 -1"Function ",func," has definition:\n";
 c:@[{-1 (-3!value x);1};func;{-1"Failed to find function definition for ",x,": ",y;0}[func]];

 if[not c;:()];
 -1"";
 out"Running: ",execstring;
 ts:@[system;"ts .tut.res:",execstring;{-1"Failed to execute function string: ",x;0}];
 if[1=count ts; :()];
 out"Function executed in ",(string first ts),"ms using ",.Q.f[1;last[ts]%2 xexp 20]," MB of memory\n";
 
 -1"Result set contains ",(string count .tut.res)," rows.";
 -1"First ",(string disp:displayrows&count .tut.res)," element(s) of result set:\n";
  
 show disp sublist .tut.res;
 if[gc;-1"\nGarbage collecting...\n"; .Q.gc[]];
 -1 (count[header]#"*");
 -1"";
 }

/- run the example specified by the current id
runcurrent:{runfunc . value torun[current]}

add:{[func;descrip] `.tut.torun insert `func`descrip!(func;descrip);}
n:{
 if[(current + 1)>=count torun; -1"no more functions to run"; :()];
 current+::1;
 runcurrent[]}
c:{current::0|current; runcurrent[]}
p:{current::0|current-1; runcurrent[]}
f:{current::0;runcurrent[]}
j:{current::x;runcurrent[]}
gcON:{.tut.gc:1b}
gcOFF:{.tut.gc:0b}

help:{
 -1".tut.n[]     : run the Next example";
 -1".tut.p[]     : run the Previous example";
 -1".tut.c[]     : run the Current example";
 -1".tut.f[]     : go back to the First example";
 -1".tut.j[n]    : Jump to the specific example";
 -1".tut.db[]    : print out database statistics";
 -1".tut.res     : result of last run query";
 -1".tut.gcON[]  : turn garbage collection on after each query";
 -1".tut.gcOFF[] : turn garbage collection off after each query";
 -1".tut.help[]  : display help information";
 -1"\\\\           : quit"}

info:{
 -1"";
 -1 x;
 -1(count x)#"-";
 -1"These examples allows you to see some examples of q code and the corresponding";
 -1"performance on your system. Please note that the performance is dependent on";
 -1"your hardware.  Depending on the query, big performance gains can be seen";
 -1"when using multiple disks and when running the database process with slave processes";
 -1"on multicore systems e.g. -s 4";
 -1"You may want to experiment with slaves, and running each example several";
 -1"times. The performance may improve as the database and file system warm up.";
 -1"Note though that using slaves increases memory usage, and if you are using the trial";
 -1"version of kdb+ you are limited to 32bit physical memory (approx 4GB).";
 -1"The function definitions displayed here will be displayed without comments.  Please see";
 -1"the function source file for comments and more description of how it works.";
 -1"At any point you can inspect the database tables by running select statements on them.";
 -1"You can re-run the functions with different parameters.  You can create your own";
 -1"functions.  Please experiment!\n";
 -1"Turning garbage collection on after each query will lower the total memory usage";
 -1"but may degrade the query performance.";
 -1"Garbage collection is currently ",(("OFF";"ON").tut.gc);
 -1"You are currently using the ",(1 _ string .z.o),"bit version of kdb+\n";
 -1"See http://code.kx.com for reference on the q language.\n";
 -1"Run .tut.help[] to redisplay the below instructions";
 -1"Start by running .tut.n[].\n";
 help[];
 -1"";}

db:{
 -1"";
 -1"DATABASE INFO";
 -1"-------------";
 -1"This database consists of ",(string count tables[`.])," tables.";
 -1"It is using ",(string system"s")," slaves.";
 -1"There are ",(string count @[value;`.Q.pv;0])," ",(string @[value;`.Q.pf;`])," partitions.\n";
 show `rowcount xdesc ([]table:tables[`.];rowcount:count each value each tables[`.]);
 -1"\nThe schema of each table is:";
 -1"(c = column; t = type; f = foreign key field; a = attribute)\n";
 {-1(string x),":"; show meta x;-1""} each tables[`.];
 -1"";};
