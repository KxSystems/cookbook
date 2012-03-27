/*
 * R server for Q
 */

/*
 * The public interface used from Q.
 */
K ropen(K x);
K rclose(K x);
K rcmd(K x);
K rget(K x);
K rset(K x,K y);

static K rexec(int type,K x);
static K kintv(int len, int *val);
static K kinta(int len, int rank, int *shape, int *val);
static K kdoublev(int len, double *val);
static K kdoublea(int len, int rank, int *shape, double *val);
static K from_any_robject(SEXP sxp);

static int ROPEN=0;

/*
 * convert R SEXP into K object.
 */
static K from_any_robject(SEXP);
static K error_broken_robject(SEXP);
static K from_null_robject(SEXP);
static K from_symbol_robject(SEXP);
static K from_pairlist_robject(SEXP);
static K from_closure_robject(SEXP);
static K from_environment_robject(SEXP);
static K from_promise_robject(SEXP);
static K from_language_robject(SEXP);
static K from_builtin_robject(SEXP);
static K from_char_robject(SEXP);
static K from_logical_robject(SEXP);
static K from_integer_robject(SEXP);
static K from_double_robject(SEXP);
static K from_complex_robject(SEXP);
static K from_character_robject(SEXP);
static K from_dot_robject(SEXP);
static K from_sxp_robject(SEXP);
static K from_vector_robject(SEXP);
static K from_numeric_robject(SEXP);
static K from_name_robject(SEXP);

static K from_any_robject(SEXP sxp)
{
	K result = 0;
	int type = TYPEOF(sxp);
	switch (type) {
	case NILSXP : return from_null_robject(sxp); break; 		/* nil = NULL */
	case SYMSXP : return from_symbol_robject(sxp); break;    	/* symbols */
	case LISTSXP : return from_pairlist_robject(sxp); break; 		/* lists of dotted pairs */
	case CLOSXP : return from_closure_robject(sxp); break;		/* closures */
	case ENVSXP : return from_environment_robject(sxp); break;	/* environments */
	case PROMSXP : return from_promise_robject(sxp); break; 		/* promises: [un]evaluated closure arguments */
	case LANGSXP : return from_language_robject(sxp); break; 	/* language constructs (special lists) */
	case SPECIALSXP : return error_broken_robject(sxp); break; 	/* special forms */
	case BUILTINSXP : return error_broken_robject(sxp); break; 	/* builtin non-special forms */
	case CHARSXP : return from_char_robject(sxp); break; 		/* "scalar" string type (internal only)*/
	case LGLSXP : return from_logical_robject(sxp); break; 		/* logical vectors */
	case INTSXP : return from_integer_robject(sxp); break; 		/* integer vectors */
	case REALSXP : return from_double_robject(sxp); break; 		/* real variables */
	case CPLXSXP : return from_complex_robject(sxp); break; 		/* complex variables */
	case STRSXP : return from_character_robject(sxp); break; 	/* string vectors */
	case DOTSXP : return from_dot_robject(sxp); break; 		/* dot-dot-dot object */
	case ANYSXP : return error_broken_robject(sxp); break; 		/* make "any" args work */
	case VECSXP : return from_vector_robject(sxp); break; 		/* generic vectors */
	case EXPRSXP : return from_sxp_robject(sxp); break; 	/* sxps vectors */
	case BCODESXP : return error_broken_robject(sxp); break; 	/* byte code */
	case EXTPTRSXP : return error_broken_robject(sxp); break; 	/* external pointer */
	case WEAKREFSXP : return error_broken_robject(sxp); break; 	/* weak reference */
	case RAWSXP : return error_broken_robject(sxp); break; 		/* raw bytes */
	case S4SXP : return error_broken_robject(sxp); break; 		/* S4 non-vector */
	case FUNSXP : return error_broken_robject(sxp); break; 		/* Closure or Builtin */
	}
	return result;
}

/* add attribute */
static K addattR (K x,SEXP att)
{
	return knk(2,from_any_robject(att),x);
}

/* add attribute if any */
static K attR(K x,SEXP sxp)
{
	SEXP att = ATTRIB(sxp);
	if (isNull(att)) return x;
	return addattR(x,att);
}

static K error_broken_robject(SEXP sxp)
{
	return krr("Broken R object.");
}

static K from_null_robject(SEXP sxp)
{
	return attR(ki((int)0x80000000),sxp);
}

static K from_symbol_robject(SEXP sxp)
{
	const char *t = CHAR(CAR(sxp));
	char *s = malloc(1+strlen(t));
	strcpy(s,t);
	K x = ks(s);
	free(s);
	return attR(x,sxp);
}

static K from_pairlist_robject(SEXP sxp)
{
	K x = knk(0);
	SEXP s = sxp;
	while (0 < length(s)) {
		x = jk(&x,from_any_robject(CAR(s)));
		x = jk(&x,from_any_robject(TAG(s)));
		s=CDR(s);
	}
	return attR(x,sxp);
}

static K from_closure_robject(SEXP sxp)
{
	K x = from_any_robject(FORMALS(sxp));
	K y = from_any_robject(BODY(sxp));
	return attR(knk(2,x,y),sxp);
}

static K from_environment_robject(SEXP sxp)
{
	return attR(kp("environment"),sxp);
}

static K from_promise_robject(SEXP sxp)
{
	return attR(kp("promise"),sxp);
}

static K from_language_robject(SEXP sxp)
{
	int i,len = length(sxp);
	K x = knk(0);
	SEXP s = sxp;
	while (0 < length(s)) {
		x = jk(&x,from_any_robject(CAR(s)));
		s = CDR(s);
	}
	return attR(x,sxp);
}

static K from_builtin_robject(SEXP sxp)
{
	return attR(kp("builtin"),sxp);
}

static K from_char_robject(SEXP sxp)
{
	K x = kp((char*) CHAR(STRING_ELT(sxp,0)));
	return attR(x,sxp);
}

static K from_logical_robject(SEXP sxp)
{
	K x;
	int len = LENGTH(sxp);
	int *s = malloc(len*sizeof(int));
	DO(len,s[i]=LOGICAL_POINTER(sxp)[i]);
	SEXP dim = GET_DIM(sxp);
	if (isNull(dim)) {
		x = kintv(len,s);
    free(s);
		return attR(x,sxp);
	}
	x = kinta(len,length(dim),INTEGER(dim),s);
	free(s);
	SEXP dimnames = GET_DIMNAMES(sxp);
	if (!isNull(dimnames))
		return attR(x,sxp);
	SEXP e;
	PROTECT(e = duplicate(sxp));
	SET_DIM(e, R_NilValue);
	x = attR(x,e);
	UNPROTECT(1);
	return x;
}

static K from_integer_robject(SEXP sxp)
{
	K x;
	int len = LENGTH(sxp);
	int *s = malloc(len*sizeof(int));
	DO(len,s[i]=INTEGER_POINTER(sxp)[i]);
	SEXP dim = GET_DIM(sxp);
	if (isNull(dim)) {
		x = kintv(len,s);
    free(s);
		return attR(x,sxp);
	}
	x = kinta(len,length(dim),INTEGER(dim),s);
  free(s);
	SEXP dimnames = GET_DIMNAMES(sxp);
	if (!isNull(dimnames))
		return attR(x,sxp);
	SEXP e;
	PROTECT(e = duplicate(sxp));
	SET_DIM(e, R_NilValue);
	x = attR(x,e);
	UNPROTECT(1);
	return x;
}

static K from_double_robject(SEXP sxp)
{
	K x;
	int len = LENGTH(sxp);
	double *s = malloc(len*sizeof(double));
	DO(len,s[i]=REAL(sxp)[i]);
	SEXP dim = GET_DIM(sxp);
	if (isNull(dim)) {
		x = kdoublev(len,s);
		free(s);
		return attR(x,sxp);
	}
	x = kdoublea(len,length(dim),INTEGER(dim),s);
	free(s);
	SEXP dimnames = GET_DIMNAMES(sxp);
	if (!isNull(dimnames))
		return attR(x,sxp);
	SEXP e;
	PROTECT(e = duplicate(sxp));
	SET_DIM(e, R_NilValue);
	x = attR(x,e);
	UNPROTECT(1);
	return x;
}

static K from_complex_robject(SEXP sxp)
{
	return attR(kp("complex"),sxp);
}

static K from_character_robject(SEXP sxp)
{
	K x;
	int i, length = LENGTH(sxp);
	if (length == 1)
		x = kp((char*) CHAR(STRING_ELT(sxp,0)));
	else {
		x = ktn(0, length);
		for (i = 0; i < length; i++) {
			xK[i] = kp((char*) CHAR(STRING_ELT(sxp,i)));
		}
	}
  return attR(x,sxp);
}

static K from_dot_robject(SEXP sxp)
{
	return attR(kp("pairlist"),sxp);
}

static K from_sxp_robject(SEXP sxp)
{
	return attR(kp("dot"),sxp);
}

static K from_list_robject(SEXP sxp)
{
	return attR(kp("list"),sxp);
}

static K from_vector_robject(SEXP sxp)
{
	int i, length = LENGTH(sxp);
	K x = ktn(0, length);
	for (i = 0; i < length; i++) {
		xK[i] = from_any_robject(VECTOR_ELT(sxp, i));
	}
  return attR(x,sxp);
}

static K from_numeric_robject(SEXP sxp)
{
	return attR(kp("numeric"),sxp);
}

static K from_name_robject(SEXP sxp)
{
	return attR(kp("name"),sxp);
}

/*
 * various utilities
 */

/* get k string or symbol name */
static char * getkstring(K x)
{
	char *s;
	int len;
	switch (xt) {
	case -KC :
		s = calloc(2,1); s[0] = xg; break;
	case KC :
		s = calloc(1+xn,1); memcpy(s, xG, xn); break;
	case -KS :
		len = 1+strlen(xs);
		s = calloc(len,1); memcpy(s, xs, len); break;
	default : krr("invalid name");
	}
	return s;
}

/*
 * convert R arrays to K lists
 * done for int, double
 */

static K kintv(int len, int *val)
{
	K x = ktn(KI, len);
	DO(len,kI(x)[i]=(val)[i]);
	return x;
}

static K kinta(int len, int rank, int *shape, int *val)
{
	K x,y;
	int i,j,r,c,k;
	switch (rank) {
		case 1 : x = kintv(len,val); break;
		case 2 :
			r = shape[0]; c = shape[1]; x = knk(0);
			for (i=0;i<r;i++) {
				y = ktn(KI,c);
				for (j=0;j<c;j++)
					kI(y)[j] = val[i+r*j];
				x = jk(&x,y);
			}; break;
		default :
			k = rank-1; r = shape[k]; c = len/r; x = knk(0);
			for (i=0;i<r;i++)
				x = jk(&x,kinta(c,k,shape,val+c*i));
	}
	return x;
}

static K kdoublev(int len, double *val)
{
	K x = ktn(KF, len);
	DO(len,kF(x)[i]=(val)[i]);
	return x;
}

static K kdoublea(int len, int rank, int *shape, double *val)
{
	K x,y;
	int i,j,r,c,k;
	switch (rank) {
		case 1 : x = kdoublev(len,val); break;
		case 2 :
			r = shape[0]; c = shape[1]; x = knk(0);
			for (i=0;i<r;i++) {
				y = ktn(KF,c);
				for (j=0;j<c;j++)
					kF(y)[j] = val[i+r*j];
				x = jk(&x,y);
			}; break;
		default :
			k = rank-1; r = shape[k]; c = len/r; x = knk(0);
			for (i=0;i<r;i++)
				x = jk(&x,kdoublea(c,k,shape,val+c*i));
	}
	return x;
}

/*
 * The public interface used from Q.
 */

/*
 * ropen argument is empty, 0 or 1
 * empty,0   --slave (R is quietest)
 * 1         --verbose
 */

K ropen(K x)
{
	if (ROPEN == 1) return ki(0);
	int s,mode=0;
	if (scalar(x) && (1==x->n) && (-6 == x->t))
		mode=(int) x->n;
	char *argv[] = {"R","--slave"};
	if (mode == 1) argv[1] = "--verbose";
	int argc = sizeof(argv)/sizeof(argv[0]);
	s=Rf_initEmbeddedR(argc, argv);
	if (s<0) return krr("open failed");
	ROPEN=1;
	return ki(0);
}

/*
 * in practice, errors occur if R is closed, then re-opened
 * these do not seem to affect later use
 */

K rclose(K x)
{
	if (ROPEN == 1) {
		R_RunExitFinalizers();
		R_CleanTempDir();
		Rf_KillAllDevices();
#ifndef WIN32
		fpu_setup(FALSE);
#endif
		Rf_endEmbeddedR(1);
	}
	ROPEN=0;
	return ki(0);
}

K rcmd(K x) { return rexec(0,x); }
K rget(K x) { return rexec(1,x); }

static char* ParseError[5]={"null","ok","incomplete","error","eof"};

K rexec(int type,K x)
{
	if (ROPEN == 0) ropen(ki(0));
	SEXP e, p, r, xp;
	int error;
	ParseStatus status;
	PROTECT(e=from_string_kobject(x));
	PROTECT(p=R_ParseVector(e, 1, &status, R_NilValue));
	if (status != 1) {
		UNPROTECT(2);
		return krr(ParseError[status]);
	}
	PROTECT(xp=VECTOR_ELT(p, 0));
	r=R_tryEval(xp, R_GlobalEnv, &error);
	UNPROTECT(3);
	if (error) return krr("eval error");
	if (type==1) return from_any_robject(r);
	return ki(0);
}

K rset(K x,K y) {
	if (ROPEN == 0) ropen(ki(0));
	ParseStatus status;
	SEXP txt, sym, val;
	char *name = getkstring(x);
/* generate symbol to check name is valid */
	PROTECT(txt=allocVector(STRSXP, 1));
	SET_STRING_ELT(txt, 0, mkChar(name));
	free(name);
	PROTECT(sym = R_ParseVector(txt, 1, &status,R_NilValue));
	if (status != 1) {
		UNPROTECT(2);
		return krr(ParseError[status]);
	}
/* read back symbol string */
	const char *c = CHAR(PRINTNAME(VECTOR_ELT(sym,0)));
	PROTECT(val = from_any_kobject(y));
	defineVar(install(c),val,R_GlobalEnv);
	UNPROTECT(3);
	return ki(0);
}
