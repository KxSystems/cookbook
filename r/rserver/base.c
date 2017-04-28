/*
 * This library provides an R server for Q
 *
 * See kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR
 */
#include <errno.h>
#include <string.h>
#include <R.h>
#include <Rdefines.h>
#include <Rembedded.h>
#ifndef WIN32
#include <Rinterface.h>
#endif
#ifdef WIN32
#define closesocket(x) close(x)
#endif
#include <R_ext/Parse.h>
#include "../c/k.h"

#include "../c/common.c"
#include "../c/rserver.c"

int R_SignalHandlers = 0;
