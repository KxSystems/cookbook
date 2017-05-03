/*
 * This library provides a Q server for R
 *
 * See kx wiki https://code.kx.com/trac/wiki/Cookbook/IntegratingWithR
 */

#include <errno.h>
#include <string.h>
#include <R.h>
#include <Rdefines.h>
#ifdef WIN32
#include <windows.h>
#endif
#include "../c/k.h"

#include "../c/common.c"
#include "../c/qserver.c"
