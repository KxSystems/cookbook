// Subscriber 

// define upd function
// this is the function invoked when the publisher pushes data to it
upd:{[tabname;tabdata] show tabname; show tabdata}

// open a handle to the publisher
h:@[hopen;`::6812;{-2"Failed to open connection to publisher on port 6812: ",
		     x,". Please ensure publisher is running"; 
		     exit 1}]

// subscribe to the required data
// .u.sub[tablename; list of instruments]
// ` is wildcard for all
h(`.u.sub;`;`)

\
Could also do (for example)

Subscribe to 10 syms of meter data:
h(`.u.sub;`meter;`long$til 10)

Add subscriptions
h(`.u.add;`meter;20 21 22j)
