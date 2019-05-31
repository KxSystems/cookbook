.lib.Require `config`util`process;


.state.bpipe.initialised: 0b;


// load functions defined in the bpipe .so
.bpipe.loadFunctions:{[]
    soName: `$getenv[`KDBROOT], "/lib/bpipe/bpipe";

    if[ not .util.Exists hsym f: ` sv soName, `so;
        .log.Error "could not find compiled bpipe library: ", string f;
        :();
    ];

    .config.Require `bpipe`clibFunctions;
    exec .process.loadFunctionFromLib[ soName; `bpipe ]'[ functionName; numberOfArgs ] from .cfg.bpipe.clibFunctions;
 };


// load the functions listed in bpipeFunctions.table from the bpipe.so file
.bpipe.loadFunctions[];


.bpipe.connect:{[ HOST; PORT; APPNAME; CONTIMEOUT; RESPONSETIME; MAXEVENTQUEUESIZE; CONSUMERQUEUESIZE; TOPICS ]
    .bpipe.clib.connect[ HOST; PORT; APPNAME; CONTIMEOUT; RESPONSETIME; MAXEVENTQUEUESIZE; CONSUMERQUEUESIZE; TOPICS ];
 };


// wrapper for .bpipe.clib.subscribe
// subscribes to updates to lists of instruments, given a list of pairs of (bloomberg tickers; correlation IDs)
.bpipe.subscribe:{[ BBG_TICKERS; CORR_IDS; FIELDS; RESUBSCRIBE ]
    // check types & cast as necessary
    fields: .util.ensureSym (), FIELDS;
    resubscribe: `boolean$RESUBSCRIBE;
    bbgTickers: .util.ensureSym (), BBG_TICKERS;
    corrIds: `int$(), CORR_IDS;

    .bpipe.clib.subscribe[ ; ; fields; RESUBSCRIBE ] ' [bbgTickers; corrIds];
 };


.bpipe.authorize:{[ TOKEN  ]
    .cfg.bpipe.token: TOKEN;
    .bpipe.clib.authorize[ TOKEN ];
 };


.bpipe.unsubscribe:{[ CORR_ID ]
    .bpipe.clib.unsubscribe CORR_ID;
 };


.bpipe.session_dropped:{[]
    .bpipe.clib.session_dropped[];
 };


.bpipe.consumer_queue_count:{[]
    .bpipe.clib.consumer_queue_count[];
 };


.bpipe.stop:{[]
    .bpipe.clib.stop[];
 };