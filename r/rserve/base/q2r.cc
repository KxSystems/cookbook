
#include "q2r.h"

using namespace std;

#define scalar(x) (x->t < 0)

K kxp(string s,K p);

Rexp *from_list_of_kobjects(K x);
Rexp *from_bool_kobject(K x);
Rexp *from_guid_kobject(K x);
Rexp *error_broken_kobject(K x);
Rexp *from_byte_kobject(K x);
Rexp *from_short_kobject(K x);
Rexp *from_int_kobject(K x);
Rexp *from_long_kobject(K x);
Rexp *from_float_kobject(K x);
Rexp *from_double_kobject(K x);
Rexp *from_string_kobject(K x);
Rexp *from_symbol_kobject(K x);
Rexp *from_timestamp_kobject(K x);
Rexp *from_month_kobject(K x);
Rexp *from_date_kobject(K x);
Rexp *from_datetime_kobject(K x);
Rexp *from_timespan_kobject(K x);
Rexp *from_minute_kobject(K x);
Rexp *from_second_kobject(K x);
Rexp *from_time_kobject(K x);

Rexp *from_enum_kobject(K x);

Rexp *from_table_kobject(K x);
Rexp *from_dictionary_kobject(K x);

// ---------------------------------------------------------------------
K kxp(string s,K p)
{
  return k(0,(char*)s.c_str(),r1(p),0);
}

// ---------------------------------------------------------------------
typedef Rexp *(*conversion_function)(K);

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
  from_time_kobject,
  from_enum_kobject
};

// ---------------------------------------------------------------------
Rexp *from_any_kobject(K x)
{
  Rexp *result;
  int type = abs(x->t);
  if (98 == type)
    result = from_table_kobject(x);
  else if (99 == type)
    result = from_dictionary_kobject(x);
  else if (105 == type || 101 == type)
    result = from_int_kobject(ki(0));
  else if (-1 < type && type < 20)
    result = kdbplus_types[type](x);
  else if (19 < type && type < 77)
    result = from_enum_kobject(x);
  else
    result = error_broken_kobject(x);
  return result;
}

// ---------------------------------------------------------------------
Rexp *error_broken_kobject(K x)
{
  return 0;
}

// ---------------------------------------------------------------------
Rexp *from_list_of_kobjects(K x)
{
  Rvectorx *s=new Rvectorx();
  DO(x->n,s->append(from_any_kobject(xK[i])));
  s->make();
  return s;
}

// ---------------------------------------------------------------------
Rexp *from_bool_kobject(K x)
{
  Rboolx *r=new Rboolx();
  if (scalar(x)) {
    char v=x->g;
    r->set(&v,1);
  } else
    r->set((char*)xG,x->n);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_guid_kobject(K x)
{
  Rexp *r;
  K p=kxp("string",x);
  if (scalar(x))
    r=from_string_kobject(p);
  else
    r=from_list_of_kobjects(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_byte_kobject(K x)
{
  Rbytex *r=new Rbytex();
  if (scalar(x)) {
    char v=x->g;
    r->set(&v,1);
  } else
    r->set((char*)xG,x->n);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_short_kobject(K x)
{
  K p=kxp("\"i\"$",x);
  Rexp *r=from_int_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_int_kobject(K x)
{
  if (scalar(x)) {
    int v=x->i;
    return new Rinteger(&v,1);
  } else
    return new Rinteger(xI,x->n);
}


// ---------------------------------------------------------------------
Rexp *from_long_kobject(K x)
{
  K p=kxp("\"f\"$",x);
  Rexp *r=from_double_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_float_kobject(K x)
{
  K p=kxp("\"f\"$",x);
  Rexp *r=from_double_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_double_kobject(K x)
{
  if (scalar(x)) {
    double v=x->f;
    return new Rdouble(&v,1);
  } else
    return new Rdouble(xF,x->n);
}

// ---------------------------------------------------------------------
Rexp *from_symbol_kobject(K x)
{
  Rexp *r;
  K p=kxp("string",x);
  if (scalar(x))
    r=from_string_kobject(p);
  else
    r=from_list_of_kobjects(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_string_kobject(K x)
{
  Rstringx *r=new Rstringx();
  string s=kstring(x);
  r->set(s.c_str(),s.size());
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_timestamp_kobject(K x)
{
  K p=kxp("946684800+(reciprocal 1e9)*",x);
  Rexp *r=from_double_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_month_kobject(K x)
{
  K p=kxp("-360+",x);
  Rexp *r=from_int_kobject(x);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_date_kobject(K x)
{
  K p=kxp("10957+",x);
  Rexp *r=from_int_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_datetime_kobject(K x)
{
  K p=kxp("86400*10957+",x);
  Rexp *r=from_double_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_timespan_kobject(K x)
{
  K p=kxp("(reciprocal 1e9)*",x);
  Rexp *r=from_double_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_minute_kobject(K x)
{
  return from_int_kobject(x);
}

// ---------------------------------------------------------------------
Rexp *from_second_kobject(K x)
{
  return from_int_kobject(x);
}

// ---------------------------------------------------------------------
Rexp *from_time_kobject(K x)
{
  return from_int_kobject(x);
}

// ---------------------------------------------------------------------
Rexp *from_enum_kobject(K x)
{
  K p=kxp("value",x);
  Rexp *r=from_any_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_table_kobject(K x)
{
  K p=kxp("flip",x);
  Rexp *r=from_dictionary_kobject(p);
  r0(p);
  return r;
}

// ---------------------------------------------------------------------
Rexp *from_dictionary_kobject(K x)
{
  K key,tab,val;

  /* if keyed, try to create a simple table */
  /* ktd will free its argument if successful */
  /* if fails, x is still valid */
  if (98==xx->t && 98==xy->t) {
    r1(x);
    tab=ktd(x);
    if (tab) {
      Rexp *t=from_table_kobject(tab);
      r0(tab);
      return t;
    }
    r0(x);
  }

  Rvectorx *r=new Rvectorx();

  key=xx;
  val=xy;

  if (11==abs(key->t))
    key=kxp("string",key);

  vector<string> vkeys;
  DO(key->n,vkeys.push_back(kstring(kK(key)[i])));

  Rtagx *names=new Rtagx();
  names->set(vkeys);

  r->append(names);
  DO(val->n,r->append(from_any_kobject(kK(val)[i])));

  r->make();
  r->setatt();
  return r;
}
