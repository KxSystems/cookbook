/*
 * common code for Q/R interface
 */

int kx_connection=0;

/*
 * A (readable type name, R data type number) pair.
 */
struct data_types {
    char *name;
    Sint id;
};

/*
 * A mapping from readable names to R data type numbers.
 */
const struct data_types r_data_types[] = {
	{"unknown", -1},
	{"NULL", NILSXP},
	{"symbol", SYMSXP},
	{"pairlist", LISTSXP},
	{"closure", CLOSXP},
	{"environment", ENVSXP},
	{"promise", PROMSXP},
	{"language", LANGSXP},
	{"special", SPECIALSXP},
	{"builtin", BUILTINSXP},
	{"char", CHARSXP},
	{"logical", LGLSXP},
	{"integer", INTSXP},
	{"double", REALSXP},
	{"complex", CPLXSXP},
	{"character", STRSXP},
	{"...", DOTSXP},
	{"any", ANYSXP},
	{"expression", EXPRSXP},
	{"list", VECSXP},
	{"numeric", REALSXP},
	{"name", SYMSXP},
	{0, -1}
};

/*
 * Brute force search of R type table.
 * eg. 	get_type_name(LISTSXP)
 */
char* get_type_name(Sint type)
{
	int i;
	for (i = 1; r_data_types[i].name != 0; i++) {
		if (type == r_data_types[i].id)
			return r_data_types[i].name;
	}
	return r_data_types[0].name;
}

/*
 * Given the appropriate names, types, and lengths, create an R named list.
 */
SEXP make_named_list(char **names, SEXPTYPE *types, Sint *lengths, Sint n)
{
	SEXP output, output_names, object = NULL_USER_OBJECT;
	Sint elements; int i;

	PROTECT(output = NEW_LIST(n));
	PROTECT(output_names = NEW_CHARACTER(n));

	for(i = 0; i < n; i++){
		elements = lengths[i];
		switch((int)types[i]) {
		case LGLSXP:
			PROTECT(object = NEW_LOGICAL(elements));
			break;
		case INTSXP:
			PROTECT(object = NEW_INTEGER(elements));
			break;
		case REALSXP:
			PROTECT(object = NEW_NUMERIC(elements));
			break;
		case STRSXP:
			PROTECT(object = NEW_CHARACTER(elements));
			break;
		case VECSXP:
			PROTECT(object = NEW_LIST(elements));
			break;
		default:
			error("Unsupported data type at %d %s\n", __LINE__, __FILE__);
		}
		SET_VECTOR_ELT(output, (Sint)i, object);
		SET_STRING_ELT(output_names, i, COPY_TO_USER_STRING(names[i]));
	}
	SET_NAMES(output, output_names);
	UNPROTECT(n+2);
	return output;
}

/*
 * Make a data.frame from a named list by adding row.names, and class
 * attribute. Uses "1", "2", .. as row.names.
 */
void make_data_frame(SEXP data)
{
	SEXP class_name, row_names; Sint n;
	PROTECT(data);
	PROTECT(class_name = NEW_CHARACTER((Sint) 1));
	SET_STRING_ELT(class_name, 0, COPY_TO_USER_STRING("data.frame"));

	/* Set the row.names. */
	n = GET_LENGTH(VECTOR_ELT(data,0));
  PROTECT(row_names=NEW_INTEGER(2)); INTEGER(row_names)[0]=NA_INTEGER; INTEGER(row_names)[1]=-n;
  setAttrib(data, R_RowNamesSymbol, row_names);
  SET_CLASS(data, class_name);
  UNPROTECT(3);
}

/* for datetime, timestamp */
static void setdatetimeclass(SEXP sxp)
{
	SEXP datetimeclass = PROTECT(allocVector(STRSXP,2));
	SET_STRING_ELT(datetimeclass, 0, mkChar("POSIXt"));
	SET_STRING_ELT(datetimeclass, 1, mkChar("POSIXct"));
	setAttrib(sxp, R_ClassSymbol, datetimeclass);
	UNPROTECT(2);
}

/*
 * We have functions that turn any K object into the appropriate R SEXP.
 */
static SEXP from_any_kobject(K object);
static SEXP error_broken_kobject(K);
static SEXP from_list_of_kobjects(K);
static SEXP from_bool_kobject(K);
static SEXP from_byte_kobject(K);
static SEXP from_guid_kobject(K);
static SEXP from_string_kobject(K);
static SEXP from_string_column_kobject(K);
static SEXP from_short_kobject(K);
static SEXP from_int_kobject(K);
static SEXP from_long_kobject(K);
static SEXP from_float_kobject(K);
static SEXP from_double_kobject(K);
static SEXP from_symbol_kobject(K);
static SEXP from_month_kobject(K);
static SEXP from_date_kobject(K);
static SEXP from_datetime_kobject(K);
static SEXP from_minute_kobject(K);
static SEXP from_second_kobject(K);
static SEXP from_time_kobject(K);
static SEXP from_timespan_kobject(K);
static SEXP from_timestamp_kobject(K);
static SEXP from_columns_kobject(K object);
static SEXP from_dictionary_kobject(K);
static SEXP from_table_kobject(K);

/*
 * An array of functions that deal with kdbplus data types. Note that the order
 * is very important as we index it based on the kdb+ type number in the K object.
 */
typedef SEXP(*conversion_function)(K);

conversion_function kdbplus_types[] = {
	from_list_of_kobjects,
	from_bool_kobject,
	from_guid_kobject,
	error_broken_kobject,
	from_byte_kobject,
	from_short_kobject,
	from_int_kobject,
	from_long_kobject,
	from_float_kobject,
	from_double_kobject,
	from_string_kobject,
	from_symbol_kobject,
	from_timestamp_kobject,
	from_month_kobject,
	from_date_kobject,
	from_datetime_kobject,
	from_timespan_kobject,
	from_minute_kobject,
	from_second_kobject,
	from_time_kobject
};

/*
 * Convert K object to R object
 */
static SEXP from_any_kobject(K x)
{
	SEXP result;
	int type = abs(x->t);
	if (XT == type)
		result = from_table_kobject(x);
	else if (XD == type)
		result = from_dictionary_kobject(x);
	else if (105 == type || 101 == type)
		result = from_int_kobject(ki(0));
	else if (type <= KT)
		result = kdbplus_types[type](x);
	else if (KT<type && type < 77) {
		K t = k(0,"value",r1(x),(K)0);
		if(t && t->t!=-128) {
			result = from_any_kobject(t);
			r0(t);
		}else 
			result = error_broken_kobject(x);
	} else if(77<type && type < XT){
		K t = k(0,"{(::) each x}",r1(x),(K)0);
		if(t && t->t!=-128) {
			result = from_any_kobject(t);
			r0(t);
		}else 
			result = error_broken_kobject(x);
	}
	else
		result = error_broken_kobject(x);
	return result;
}

/*
 * Convert K columns to R object
 */
static SEXP from_columns_kobject(K x)
{
  SEXP col, result;
  int i, type, length = x->n;
  K c;
  PROTECT(result = NEW_LIST(length));
  for (i = 0; i < length; i++) {
    c = xK[i];
    type = abs(c->t);
    if (type == KC)
      col = from_string_column_kobject(c);
    else
      col = from_any_kobject(c);
    SET_VECTOR_ELT(result, i, col);
  }
  UNPROTECT(1);
  return result;
}

/*
 * Complain that the given K object is not valid and return "unknown".
 */
static SEXP error_broken_kobject(K broken)
{
	error("Value is not a valid kdb+ object; unknown type %d\n", broken->t);
	return mkChar(r_data_types[0].name);
}

/*
 * An R list from a K list object.
 */
static SEXP from_list_of_kobjects(K x)
{
	SEXP result;
	int i, length = x->n;
	PROTECT(result = NEW_LIST(length));
	for (i = 0; i < length; i++) {
		SET_VECTOR_ELT(result, i, from_any_kobject(xK[i]));
	}
	UNPROTECT(1);
	return result;
}

/*
 * These next functions have 2 main control flow paths. One for scalars and
 * one for vectors. Because of the way the data is laid out in k objects, its
 * not possible to combine them.
 *
 * We always decrement the reference count of the object as it will have been
 * incremented in the initial dispatch.
 *
 * We promote shorts and floats to larger types when converting to R (ints and
 * doubles respectively).
 */

#define scalar(x) (x->t < 0)

static SEXP from_bool_kobject(K x)
{
	SEXP result;
	int length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_LOGICAL(1));
		LOGICAL_POINTER(result)[0] = x->g;
	}
	else {
		int i;
		PROTECT(result = NEW_LOGICAL(length));
		for(i = 0; i < length; i++)
			LOGICAL_POINTER(result)[i] = kG(x)[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_byte_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_INTEGER(1));
		INTEGER_POINTER(result)[0] = (int) x->g;
	}
	else {
		PROTECT(result = NEW_INTEGER(length));
		for(i = 0; i < length; i++)
			INTEGER_POINTER(result)[i] = kG(x)[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_guid_kobject(K x)
{
	K y = k(kx_connection,"string",r1(x),(K)0);
	SEXP r = from_any_kobject(y);r0(y);
	return r;
}

static SEXP from_short_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_INTEGER(1));
		INTEGER_POINTER(result)[0] = (int) x->h;
	}
	else {
		PROTECT(result = NEW_INTEGER(xn));
		for(i = 0; i < length; i++)
			INTEGER_POINTER(result)[i] = (int) xH[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_int_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_INTEGER(1));
		INTEGER_POINTER(result)[0] = x->i;
	}
	else {
		PROTECT(result = NEW_INTEGER(length));
		for(i = 0; i < length; i++)
			INTEGER_POINTER(result)[i] = (int) xI[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_long_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = (double) x->j;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
			NUMERIC_POINTER(result)[i] = (double) xJ[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_float_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = (double) x->e;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
			NUMERIC_POINTER(result)[i] = (double) xE[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_double_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = x->f;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
			NUMERIC_POINTER(result)[i] = xF[i];
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_string_kobject(K x)
{
	SEXP result;
	int length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_CHARACTER(1));
		SET_STRING_ELT(result, 0, mkCharLen((S)&x->g,1));
	}
	else {
		PROTECT(result = allocVector(STRSXP, 1));
		SET_STRING_ELT(result, 0, mkCharLen((S)xG,length));
	};
	UNPROTECT(1);
	return result;
}

static SEXP from_string_column_kobject(K x)
{
  SEXP result;
  int i, length = x->n;
  PROTECT(result = NEW_CHARACTER(length));
  for(i = 0; i < length; i++) {
    SET_STRING_ELT(result, i, mkCharLen((S)&kC(x)[i],1));
  }
  UNPROTECT(1);
  return result;
}

static SEXP from_symbol_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_CHARACTER(1));
		SET_STRING_ELT(result, 0, mkChar(xs));
	}
	else {
		PROTECT(result = NEW_CHARACTER(length));
		for(i = 0; i < length; i++)
			SET_STRING_ELT(result, i, mkChar((S)xS[i]));
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_month_kobject(K object)
{
	return from_int_kobject(object);
}

static SEXP from_date_kobject(K x)
{
  SEXP result;
  SEXP dateclass;
  int i, length = x->n;
  if (scalar(x)) {
    PROTECT(result = NEW_INTEGER(1));
    INTEGER_POINTER(result)[0] = x->i + 10957;
  }
	else {
		PROTECT(result = NEW_INTEGER(length));
		for(i = 0; i < length; i++)
		INTEGER_POINTER(result)[i] = (int) xI[i] + 10957;
  }
  dateclass = PROTECT(allocVector(STRSXP,1));
	SET_STRING_ELT(dateclass, 0, mkChar("Date"));
	setAttrib(result, R_ClassSymbol, dateclass);
	UNPROTECT(2);
	return result;
}

static SEXP from_datetime_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = (x->f + 10957) * 86400;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
			NUMERIC_POINTER(result)[i] = (kF(x)[i] + 10957) * 86400;
	}
  setdatetimeclass(result);
	return result;
}

static SEXP from_minute_kobject(K object)
{
	return from_int_kobject(object);
}

static SEXP from_second_kobject(K object)
{
	return from_int_kobject(object);
}

static SEXP from_time_kobject(K object)
{
	return from_int_kobject(object);
}

static SEXP from_timespan_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = x->j / 1e9;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
			NUMERIC_POINTER(result)[i] = xJ[i] / 1e9;
	}
	UNPROTECT(1);
	return result;
}

static SEXP from_timestamp_kobject(K x)
{
	SEXP result;
	int i, length = x->n;
	if (scalar(x)) {
		PROTECT(result = NEW_NUMERIC(1));
		NUMERIC_POINTER(result)[0] = 946684800 + x->j / 1e9;
	}
	else {
		PROTECT(result = NEW_NUMERIC(length));
		for(i = 0; i < length; i++)
  		NUMERIC_POINTER(result)[i] = 946684800 + kJ(x)[i] / 1e9;
	}
	setdatetimeclass(result);
	return result;
}

static SEXP from_dictionary_kobject(K x)
{
	SEXP names, result;
	K table;

	/* if keyed, try to create a simple table */
	/* ktd will free its argument if successful */
	/* if fails, x is still valid */
	if (XT==xx->t && XT==xy->t) {
		r1(x);
		if ((table = ktd(x))) {
			result = from_table_kobject(table);
			r0(table);
			return result;
		}
		r0(x);
	}

	PROTECT(names = from_any_kobject(xx));
	PROTECT(result = from_any_kobject(xy));
	SET_NAMES(result, names);
	UNPROTECT(2);
	return result;
}

static SEXP from_table_kobject(K x)
{
  SEXP names, result;
  PROTECT(names = from_any_kobject(kK(x->k)[0]));
  PROTECT(result = from_columns_kobject(kK(x->k)[1]));
  SET_NAMES(result, names);
  UNPROTECT(2);
  make_data_frame(result);
  return result;
}
