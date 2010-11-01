/*
 * This library provides a Q server for R
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
#include <k.h>

#include "../c/qserver.c"
#include "../c/rserver.c"
