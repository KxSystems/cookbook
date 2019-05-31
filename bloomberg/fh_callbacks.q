// This library contains functions which are called by the bpipe c api. Mainly market data, but also
// functions for authorising connections, managing subscriptions, etc


// All messages from the bpipe.so are received by the "Update" function, which delegates the message
// to appropriate function and writes the result into a buffer. Results (if any) are published
// downstream immediately, and written to a binary log on a timer/once the buffer reaches a certain
// size. INCOMING is a list of (function name; correlation id; dictionary of data)
Update:{[ INCOMING ]
    correlationId: INCOMING 1;

    // add the correlation id (second element) and a timestamp
    incomingMsg: .[ INCOMING; (2; `corrId`feedHandlerTimestamp); :; (correlationId; .z.p) ] 0 2;

    if[ `MarketDataEvents = first incomingMsg;
        corrIdDetails: .state.fh.refdataFields # .state.fh.subscriptions correlationId;
        incomingMsg[1],: corrIdDetails;
    ];

    .state.fh.writeCache,: enlist enlist incomingMsg;

    if[ .state.fh.heartbeatCorrId = last[incomingMsg]`corrId;
        .state.fh.lastHeartbeat: last[incomingMsg]`feedHandlerTimestamp;
        :();
    ];

    // process and insert into outgoing buffer - all data must be buffered together to preserve order
    toPub: @[ value; incomingMsg; .bbg.fh.handleBadUpdate incomingMsg ];

    {[TOPUB]
        if[ not 2 = count TOPUB;
            :();
        ];
        // publish messages downstream immediately
        .fh.publish[ TOPUB 0 ; TOPUB 1];
    } each toPub;

 };


SessionConnectionUp:{[ SERVER ]
    .log.Info "[SessionConnectionUp] connected to server: ", SERVER`server;
    serverIp: `$first ":" vs SERVER`server;
    update connStatus: `Up, time: .z.p from `.state.fh.upstreams where ipAddress = serverIp;

    .log.Info "\n\t", ssr[ ; "\n"; "\n\t" ] .Q.s .state.fh.upstreams;
 };


SessionConnectionDown:{[ SERVER ]
    .log.Error "[SessionConnectionDown] connection lost to: ", SERVER`server;
    .log.Error "check adapter log (", 1 _ string[ .state.fh.binLogName ], ") for activity to confirm failover has been successful";

    // TODO: update subscription statuses?
    serverIp: `$first ":" vs SERVER`server;
    update connStatus: `Down, time: .z.p from `.state.fh.upstreams where ipAddress = serverIp;

    .log.Info "\n\t", ssr[ ; "\n"; "\n\t" ] .Q.s .state.fh.upstreams;
 };


SessionStartupFailure:{[ FAILMSG ]
    msg: "could not connect to ", string[count .cfg.fh.upstream`bbHostNames], " appliances ";
    msg,: "\"" sv string .cfg.fh.upstream`bbHostNames;
    msg,: ": ";
    msg,: "\n\t", ssr[ ;"\n";"\n\t" ] .Q.s FAILMSG`reason;

    .log.Error msg;
 }


// DICT only contains the correlation id (0 in this case)
SessionStarted:{[ DICT ]
    .log.Info "[SessionStarted]";
 };


ServiceOpened:{[ SVC ]
    .log.Info "[ServiceOpened] ", SVC`serviceName;
 };


TokenGenerationSuccess:{[ TOKEN ]
    .log.Info "[TokenGenerationSuccess] authorising with token: ", t: TOKEN`token;
    .bpipe.authorize `$t;
 };


// DICT only contains the correlation id (0 in this case)
AuthorizationSuccess:{[ DICT ]
    .log.Info "[AuthorizationSuccess]";

    // check defined subscriptions and subscribe
    .fh.checkSubscriptions[];
 };


SubscriptionFailure:{[ FAIL ]
    update subscribed: `Failed from `.state.fh.subscriptions where corrId = FAIL`corrId;

    errMsg: "failed to subscribe to instrument with correlation ID: ", string[ FAIL`corrId ], " (";
    errMsg,: string[ .state.fh.subscriptions[ FAIL`corrId ]`BloombergTicker ], "): ";
    errMsg,: FAIL[`reason]`description;
    .log.Error errMsg;
 };


SubscriptionStarted:{[ SUB ]
    update subscribed: `Started from `.state.fh.subscriptions where corrId = SUB`corrId;

    okMsg: "started subscription to instrument with correlation ID: ", string[ SUB`corrId ], " (";
    okMsg,: string[ .state.fh.subscriptions[ SUB`corrId ]`BloombergTicker ], ")";
    .log.Info okMsg;
 };


SubscriptionTerminated:{[ TERM ]
    update subscribed: `Terminated from `.state.fh.subscriptions where corrId = TERM`corrId;

    okMsg: "terminated subscription to instrument with correlation ID: ", string[ TERM`corrId ], " (";
    okMsg,: string[ .state.fh.subscriptions[ TERM`corrId ]`BloombergTicker ], ")";
    .log.Info okMsg;
 };


SlowConsumerWarning:{
    // TODO: clarify input (if any) to this function
    .log.Error "[SlowConsumerWarning] CONTACT THE KDB TEAM IMMEDIATELY";
    .state.fh.slowConsumer: 1b;
    .state.fh.slowCount +: 1
 };


SlowConsumerWarningCleared:{
    // TODO: clarify input (if any) to this function
    .log.Error "[SlowConsumerWarningCleared]";
    .state.fh.slow: 0b;
 };


DataLoss:{[ DP ]
    .state.fh.messagesLost +: DP`numMessagesDropped;

    corrIdDetails: .state.fh.subscriptions[ DP`corrId ];
    msg: "[DataLoss] dropped ", string[ DP`numMessagesDropped ], " messages for sid ";
    msg,: string[corrIdDetails`sid], " (", string[corrIdDetails`BloombergTicker], ")";
    .log.Error msg;
 };


EntitlementChanged:{[ EC ]
    .log.Info ("[EntitlementChanged]"; EC);
 };


SessionDropped:{
    // TODO: clarify input (if any) to this function - possibly update subscription status and/or resubscribe?
    .log.Error "[SessionDropped]"
    };


SessionTerminated:{[]
    .log.Error"[SessionTerminated] Exiting";
    exit 1;
    };
