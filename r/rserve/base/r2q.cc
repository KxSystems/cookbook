
#include "q2r.h"

using namespace std;

// ---------------------------------------------------------------------
K attR(K x,Rexp *rxp);

K from_any_robject(Rexp *);
K from_null_robject(Rexp *);
K from_logical_robject(Rexp *);
K from_byte_robject(Rexp *);
K from_integer_robject(Rexp *);
K from_double_robject(Rexp *);
K from_string_robject(Rexp *);
K from_vector_robject(Rexp *);

K error_broken_robject(Rexp *);
K error_unsupported_robject(Rexp *rxp);

// ---------------------------------------------------------------------
// Rserve types not supported:
// XT_S4, XT_CLOS, XT_LIST_TAG, XT_LANG_TAG, XT_ARRAY_CPLX

K from_any_robject(Rexp *rxp)
{
  K r;
  int type=rxp->type;

  switch (type) {
  case XT_NULL :
    r=from_null_robject(rxp);
    break;
  case XT_LIST_NOTAG :
  case XT_LANG_NOTAG :
  case XT_VECTOR_EXP :
  case XT_VECTOR :
    r=from_vector_robject(rxp);
    break;
  case XT_ARRAY_INT :
    r=from_integer_robject(rxp);
    break;
  case XT_ARRAY_DOUBLE :
    r=from_double_robject(rxp);
    break;
  case XT_ARRAY_STR :
    r=from_string_robject(rxp);
    break;
  case XT_ARRAY_BOOL :
    r=from_logical_robject(rxp);
    break;
  case XT_RAW :
    r=from_byte_robject(rxp);
    break;
  default :
    return error_unsupported_robject(rxp);
  }
  return attR(r,rxp);
}

// ---------------------------------------------------------------------
/* add attribute if any */
K attR(K x,Rexp *rxp)
{
  Rexp *att = rxp->attr;
  if (att==0) return x;
  return knk(2,from_any_robject(att),x);
}

// ---------------------------------------------------------------------
K error_broken_robject(Rexp *rxp)
{
  return krs("Broken R object type=" + i2s(rxp->type));
}

// ---------------------------------------------------------------------
K error_unsupported_robject(Rexp *rxp)
{
  return krs("Unsupported R object type=" + i2s(rxp->type));
}

// ---------------------------------------------------------------------
K from_null_robject(Rexp *rxp)
{
  return attR(ki((int)0x80000000),rxp);
}

// ---------------------------------------------------------------------
K from_logical_robject(Rexp *rxp)
{
  K r;
  Rboolx *x=(Rboolx *)rxp;
  Rinteger *dim=(Rinteger *)x->attribute("dim");

  int len=x->datalen();
  int *s=x->intArray();
  if (dim==0)
    r = kintv(len,s);
  else {
    int rank=dim->len/4;
    r=kinta(len,rank,dim->intArray(),s);
  }
  free(s);
  return attR(r,rxp);
}

// ---------------------------------------------------------------------
K from_byte_robject(Rexp *rxp)
{
  Rbytex *r=(Rbytex *)rxp;
  int len=r->datalen();
  char *p=4+r->data;
  K x = ktn(KG, len);
  DO(len,kG(x)[i]=p[i]);
  return attR(x,rxp);

}

// ---------------------------------------------------------------------
K from_integer_robject(Rexp *rxp)
{
  K r;
  Rinteger *x=(Rinteger *)rxp;
  Rinteger *dim=(Rinteger *)x->attribute("dim");
  int len=x->len/4;
  if (dim==0)
    r = kintv(len,x->intArray());
  else {
    int rank=dim->len/4;
    r=kinta(len,rank,dim->intArray(),x->intArray());
  }
  return attR(r,rxp);
}

// ---------------------------------------------------------------------
K from_double_robject(Rexp *rxp)
{
  K r;
  Rdouble *x=(Rdouble *)rxp;
  Rinteger *dim=(Rinteger *)x->attribute("dim");
  int len=x->len/8;
  if (dim==0)
    r = kdoublev(len,x->doubleArray());
  else {
    int rank=dim->len/4;
    r=kdoublea(len,rank,dim->intArray(),x->doubleArray());
  }
  return attR(r,rxp);
}

// ---------------------------------------------------------------------
K from_string_robject(Rexp *rxp)
{
  K r;
  Rstrings *x=(Rstrings *)rxp;
  int n=x->count();
  if (n==1)
    r=kp(x->string());
  else {
    r=ktn(0,n);
    DO(n,kK(r)[i]=kp(x->stringAt(i)));
  }
  return attR(r,rxp);
}

// ---------------------------------------------------------------------
K from_vector_robject(Rexp *rxp)
{
  Rvector *r=(Rvector *)rxp;
  int len=r->length();
  K x = ktn(0, len);
  DO(len,xK[i]=from_any_robject(r->elementAt(i)));
  return attR(x,rxp);
}
