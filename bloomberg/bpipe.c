/*
 * MWAM Bloomberg BPipe adapter for KDB.
 *
 * Description:	Event driven market data adapter for the Bloomberg BPipe API. Compiled as a shared object and loaded into a Q process.
 *        One BPipe managed thread to processes BPipe events and write to consumer queue. Events dequeued on Q main thread for processing.
 *        Uses liblfds.org lock-free queue implementation.
 *
 *
 */

#include<stdio.h>
#include<unistd.h>
#include<string.h>
#include<pthread.h>
#include<sys/eventfd.h>
#include<liblfds611.h>
#include<blpapi_session.h>
#include"k.h"

#define Q(x,e) P(x,krr(e))
#define QBB(x,e) {I _r=(x);if(_r){const char*s=blpapi_getLastErrorDescription(_r);if(*s)printf("BLPAPI ERROR: %s\n",s);R krr(e);}}

// Global variables are Capitalised except 'fd'
ZI fd;
static blpapi_Session_t *Session;
static blpapi_Identity_t *Identity;
static char *AuthString = "AuthenticationMode=APPLICATION_ONLY;ApplicationAuthenticationType=APPNAME_AND_KEY;ApplicationName=";
struct lfds611_queue_state *queue;
static K sequence_to_dictionary(blpapi_Element_t *elem); //forward references needed
static K array_to_kdb_list(blpapi_Element_t *elemArray); //because they are used recursively

static K bloomberg_to_kdb(blpapi_Element_t *elem)
{
    I b;
    C c;
    I i;
    J j;
    E e;
    F f;
    blpapi_Datetime_t z;
    const char *t;
    I r;

// All of the getValueAs* functions need trapping as BB says there is a field, but getting the value might still fail
    switch(blpapi_Element_datatype(elem))
    {
    case BLPAPI_DATATYPE_BOOL       :
        R r=blpapi_Element_getValueAsBool(elem, &b, 0),kb(r?0:b);
    case BLPAPI_DATATYPE_CHAR       :
        R r=blpapi_Element_getValueAsChar(elem, &c, 0),kc(r?' ':c);
    case BLPAPI_DATATYPE_INT32      :
        R r=blpapi_Element_getValueAsInt32(elem, &i, 0),ki(r?ni:i);
    case BLPAPI_DATATYPE_INT64      :
        R r=blpapi_Element_getValueAsInt64(elem, &j, 0),kj(r?nj:j);
    case BLPAPI_DATATYPE_FLOAT32    :
        R r=blpapi_Element_getValueAsFloat32(elem, &e, 0),ke(r?nf:e);
    case BLPAPI_DATATYPE_FLOAT64    :
        R r=blpapi_Element_getValueAsFloat64(elem, &f, 0),kf(r?nf:f);
    case BLPAPI_DATATYPE_DATE       :
        R r=blpapi_Element_getValueAsDatetime(elem, &z, 0),kd(r?ni:ymd(z.year,z.month,z.day));
    case BLPAPI_DATATYPE_TIME       :
        R r=blpapi_Element_getValueAsDatetime(elem, &z, 0),kt(r?ni:(z.milliSeconds+(z.seconds+(z.minutes+z.hours*60)*60)*1000));
    case BLPAPI_DATATYPE_DATETIME   :
        /* Sometimes it is not set properly - is it guaranteed to have zero for missing which is fine except if DATE missing.
           Can be detected just fine and we do not have that kind of data fortunately */
        R r=blpapi_Element_getValueAsDatetime(elem, &z, 0),ktj(-KP,r?nj:86400000000000LL*ymd(z.year,z.month,z.day)+1000000LL*(z.milliSeconds+(z.seconds+(z.minutes+z.hours*60)*60)*1000));
    case BLPAPI_DATATYPE_SEQUENCE   :
        R blpapi_Element_isArray(elem)?array_to_kdb_list(elem):sequence_to_dictionary(elem);
    default                         :
        R r=blpapi_Element_getValueAsString(elem, &t, 0),kp(r?"":(S)t);
    }
}

/* Note that array_to_kdb_list returns a generic list. i.e. list of atoms don't collapse to vectors or list of dicst to table, however,
 * this should not be an issue in practice as we don't have those and one can always do {x til count x}generalistFromC to collapse.
 * if i find something nicer to collapse i'll let you know
 */
static K array_to_kdb_list(blpapi_Element_t *elemArray)
{
    I n = blpapi_Element_numValues(elemArray);
    K x = ktn(0, n);
    blpapi_Element_t*e;
    DO(n,
       blpapi_Element_getValueAsElement(elemArray, &e, i);  //this could fail if we out of indexing, but we won't
       xK[i] = bloomberg_to_kdb(e))
    R x;
}

static K sequence_to_dictionary(blpapi_Element_t *elemSeq)
{
    I n = blpapi_Element_numElements(elemSeq);
    K x = ktn(KS, n);
    K y = ktn(0, n);

    blpapi_Element_t *e;
    DO(n,
       blpapi_Element_getElementAt(elemSeq, &e, i);  //this could fail if we would be out of indexing but we won't
       xS[i] = ss((S)blpapi_Element_nameString(e));
       kK(y)[i] = bloomberg_to_kdb(e))
    R xD(x, y);
}

K consume_event(I d)
{
    // consumer queue has to be initialised by any thread making use of it for the first time (apart from the instantiating thread)
    static char queueinit = 0;
    if (!queueinit)
    {
        lfds611_queue_use(queue);
        queueinit = 1;
    }

    // dummy variable to read on callback
    // TODO: handle case where read != 1
    J a;
    read(d, &a, 8);

    blpapi_Event_t *event;
    int result, eventsdequeued = 0;
    while ((result = lfds611_queue_dequeue(queue,(void **)&event)))
    {
        blpapi_MessageIterator_t*i;
        Q(!(i = blpapi_MessageIterator_create(event)), "blpapi_MessageIterator_create")
        blpapi_Message_t*m;

        while ((!blpapi_MessageIterator_next(i, &m)))
        {
            blpapi_Element_t*e;
            Q(!(e = blpapi_Message_elements(m)), "blpapi_Message_elements")
            blpapi_CorrelationId_t c = blpapi_Message_correlationId(m, 0);
            // printf("correlationID type=%d for consume_event is %lu\n", c.valueType, (unsigned long int)c.value.intValue);
            K u = knk(3, ks(ss((S)blpapi_Message_typeString(m))), ki(c.value.intValue), sequence_to_dictionary(e));
            K ret = k(0, "Update", u, (K)0);

            if(ret->t == -128) printf("Crt - error calling Update function from C code: %s\n", ret->s);
            if(!ret) printf("Crt - no connection to the kdb+ host process");

            r0(ret);
            eventsdequeued++;
        }

        blpapi_MessageIterator_destroy(i);
        blpapi_Event_release(event);
    }

    R ki(eventsdequeued);
}

static void queue_event(blpapi_Event_t *event, blpapi_Session_t *session, void *buffer)
{
    // Increment BPipe event reference count and add to consumer queue
    blpapi_Event_addRef(event);
    int res = lfds611_queue_enqueue(queue, event);
    // Not dequeing fast enough. This will add another item to the consumer queue. NOTE: worth increasing queue size if trend spotted
    // TODO: log guaranteed enqueue as warning
    if (!res) res = lfds611_queue_guaranteed_enqueue(queue, event);
    blpapi_Event_release(event);
    J a = 1;
    write(fd, &a, 8);
}

K consumer_queue_count(K ignore)
{
    lfds611_atom_t count;
    lfds611_queue_query(queue, LFDS611_QUEUE_QUERY_ELEMENT_COUNT, NULL, &count);
    R ki((int)count);
}
// TODO: change this to a dictionary
K connect(K host, K port, K appName, K conTimeout, K responseTimeout, K maxEventQueueSize, K consumerQueueSize, K topics)
{
    Q(host->t!=KS||port->t!=-KI||appName->t!=-KS||conTimeout->t!=-KT||responseTimeout->t!=-KT||maxEventQueueSize->t!=-KI || topics->t != KS, "type")
    Q(Session, "already connected")

    // fd for signalling Q main thread
    fd = eventfd(0, 0);
    sd1(fd, consume_event);

    // lock-free consumer queue
    int succ = lfds611_queue_new(&queue, consumerQueueSize->i);
    Q(!succ, "lfds611_queue_new: Failed to create consumer queue");

    blpapi_CorrelationId_t c;
    c.valueType = BLPAPI_CORRELATION_TYPE_UNSET;   //make it explicit, although implicitly it would be UNSET too as locals are initialized with all zeroes
    // printf("correlationID type is %d for connect is %lu\n", c.valueType, (long unsigned int)c.value.intValue);

    blpapi_SessionOptions_t*o;
    Q(!(o = blpapi_SessionOptions_create()), "blpapi_SessionOptions_create");

    int h;
    for(h = 0; h < host->n; h++)
    {
        QBB(blpapi_SessionOptions_setServerAddress(o, kS(host)[h], port->i, h), "blpapi_SessionOptions_setServerAddress");
    }

    QBB(blpapi_SessionOptions_setConnectTimeout(o, conTimeout->i), "blpapi_SessionOptions_setConnectTimeout");
    QBB(blpapi_SessionOptions_setDefaultKeepAliveInactivityTime(o, responseTimeout->i), "blpapi_SessionOptions_setDefaultKeepAliveInactivityTime");
    QBB(blpapi_SessionOptions_setDefaultKeepAliveResponseTimeout(o, responseTimeout->i), "blpapi_SessionOptions_setDefaultKeepAliveResponseTimeout");
    blpapi_SessionOptions_setMaxEventQueueSize(o, maxEventQueueSize->i);  //default is 10000 in 3.5.x up, in 3.4.8 it is UINT_MAX-1

    char as[256];
    strcpy(as, AuthString);
    strcpy(as+strlen(as), appName->s);
    blpapi_SessionOptions_setAuthenticationOptions(o, as); //this call really returns void, so can't trap

    Q(!(Session = blpapi_Session_create(o, &queue_event, 0, 0)), "blpapi_Session_create");
    blpapi_SessionOptions_destroy(o);

    QBB(blpapi_Session_start(Session),(blpapi_Session_destroy(Session),"blpapi_Session_start"))

    for(h = 0; h < topics->n; h++) {
        printf("%s\n",kS(topics)[h]);
        QBB(blpapi_Session_openService(Session, kS(topics)[h]), (blpapi_Session_destroy(Session), kS(topics)[h]));
    }

    QBB(blpapi_Session_generateToken(Session, &c, 0), "blpapi_Session_generateToken");
    R 0;
}

K authorize(K token)
{
    Q(token->t!=-KS, "[authorize] expects a symbol atom as token")
    Q(!Session,"Session down")

    blpapi_Service_t *a;
    QBB(blpapi_Session_getService(Session, &a, "//blp/apiauth"), "blpapi_Session_getService")

    Q(!(Identity = blpapi_Session_createIdentity(Session)), "blpapi_Session_createIdentity")

    blpapi_Request_t *r;
    QBB(blpapi_Service_createAuthorizationRequest(a, &r, "AuthorizationRequest"), "blpapi_Service_createAuthorizationRequest")

    blpapi_Element_t *e;
    Q(!(e = blpapi_Request_elements(r)), "blpapi_Request_elements")

    blpapi_Element_t *t;
    QBB(blpapi_Element_getElement(e, &t, "token", 0), "blpapi_Element_getElement")
    QBB(blpapi_Element_setValueString(t, token->s, 0), "blpapi_Element_setValueString")

    blpapi_CorrelationId_t c;
    c.valueType = BLPAPI_CORRELATION_TYPE_UNSET;   //make it explicit, although implicitly it would be UNSET too as locals are initialized with all zeroes

    QBB(blpapi_Session_sendAuthorizationRequest(Session, r, Identity, &c, 0, 0, 0), "blpapi_Session_sendAuthorizationRequest")
    blpapi_Request_destroy(r);
    R 0;
}

K session_dropped(K ignore)
{
    Q(!Session, "Session already down")
    blpapi_Session_destroy(Session);
    Session = NULL;
    R 0;
}

K subscribe(K sym, K sid, K fields, K resubscribe)
{
    Q(sym->t!=-KS||(sid->t!=-KJ&&sid->t!=-KI)||fields->t!=KS||resubscribe->t!=-KB,"type")
    Q(!Session,"Session down")

    blpapi_CorrelationId_t c;
    memset(&c, '\0', sizeof(c));
    c.size = sizeof(c);
    c.valueType = BLPAPI_CORRELATION_TYPE_INT, c.value.intValue = (blpapi_UInt32_t)sid->i;

    blpapi_SubscriptionList_t*s;
    Q(!(s = blpapi_SubscriptionList_create()), "blpapi_SubscriptionList_create")
    QBB(blpapi_SubscriptionList_add(s, sym->s, &c, (const char**)kS(fields), 0, fields->n, 0), "blpapi_SubscriptionList_add")

    ((int)resubscribe->g) ? (QBB(blpapi_Session_resubscribe(Session, s, 0, 0),"blpapi_Session_resubscribe"))
    : (QBB(blpapi_Session_subscribe(Session, s, Identity, 0, 0),"blpapi_Session_subscribe"));

    blpapi_SubscriptionList_destroy(s);  //destroy calls return void, so can't trap
    R (K)0;
}

K unsubscribe(K sid)
{
    Q(sid->t!=-KJ&&sid->t!=-KI,"type")
    Q(!Session, "Session down")

    blpapi_CorrelationId_t c;
    memset(&c, '\0', sizeof(c));
    c.size = sizeof(c);
    c.valueType = BLPAPI_CORRELATION_TYPE_INT;
    c.value.intValue = (blpapi_UInt32_t)sid->i;

    QBB(blpapi_Session_cancel(Session, &c, 1, 0, 0), "blpapi_Session_cancel")
    R 0;
}

K stop()
{
    QBB(blpapi_Session_stop(Session),(blpapi_Session_destroy(Session),"blpapi_Session_stop"));
    R 0;
}

//static int streamWriter(const char*data,int length,void*stream){R fwrite(data,length,1,(FILE*)stream);}
//static void pE(blpapi_Element_t*e){blpapi_Element_print(e,&streamWriter,stdout,0,4);printf("\n");fflush(stdout);}  //DEBUG
