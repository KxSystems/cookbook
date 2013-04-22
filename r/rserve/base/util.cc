
#include <fstream>
#include <sstream>
#include "main.h"

std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);

// ---------------------------------------------------------------------
int fwrite(string fname, char *s, int len)
{
  ofstream f;
  f.open(fname.c_str(), ios::out | ios::binary);
  f.write(s,len);
  f.close();
  return len;
}

// ---------------------------------------------------------------------
K kdoublev(int len, double *val)
{
  K x = ktn(KF, len);
  DO(len,kF(x)[i]=(val)[i]);
  return x;
}

// ---------------------------------------------------------------------
K kdoublea(int len, int rank, int *shape, double *val)
{
  K x,y;
  int i,j,r,c,k;
  switch (rank) {
  case 1 :
    x = kdoublev(len,val);
    break;
  case 2 :
    r = shape[0];
    c = shape[1];
    x = knk(0);
    for (i=0; i<r; i++) {
      y = ktn(KF,c);
      for (j=0; j<c; j++)
        kF(y)[j] = val[i+r*j];
      x = jk(&x,y);
    };
    break;
  default :
    k = rank-1;
    r = shape[k];
    c = len/r;
    x = knk(0);
    for (i=0; i<r; i++)
      x = jk(&x,kdoublea(c,k,shape,val+c*i));
  }
  return x;
}

// ---------------------------------------------------------------------
K kinta(int len, int rank, int *shape, int *val)
{
  K x,y;
  int i,j,r,c,k;
  switch (rank) {
  case 1 :
    x = kintv(len,val);
    break;
  case 2 :
    r = shape[0];
    c = shape[1];
    x = knk(0);
    for (i=0; i<r; i++) {
      y = ktn(KI,c);
      for (j=0; j<c; j++)
        kI(y)[j] = val[i+r*j];
      x = jk(&x,y);
    };
    break;
  default :
    k = rank-1;
    r = shape[k];
    c = len/r;
    x = knk(0);
    for (i=0; i<r; i++)
      x = jk(&x,kinta(c,k,shape,val+c*i));
  }
  return x;
}

// ---------------------------------------------------------------------
K kintv(int len, int *val)
{
  K x = ktn(KI, len);
  DO(len,kI(x)[i]=(val)[i]);
  return x;
}

// ---------------------------------------------------------------------
K krs(string s)
{
  return krr((char *)s.c_str());
}

// ---------------------------------------------------------------------
/* get k string or symbol name */
string kstring(K x)
{
  string r;
  switch (xt) {
  case -KC :
    r=string(1,(char)xg);
    break;
  case KC :
    r=string((char*)xG, xn);
    break;
  case -KS :
    r=string((char*)xs, strlen(xs));
    break;
  default :
    krs("invalid name");
  }
  return r;
}

// ---------------------------------------------------------------------
// integer to string
string i2s(int i)
{
  stringstream s;
  s << i;
  return s.str();
}

// ---------------------------------------------------------------------
// string to integer
int s2i(string s)
{
  if (!s.size()) return 0;
  return (int)strtol(s.c_str(),NULL,0);
}

// ---------------------------------------------------------------------
vector<string> &split(const string &s, char delim, vector<string> &elems)
{
  stringstream ss(s);
  string item;
  while (getline(ss, item, delim)) {
    elems.push_back(item);
  }
  return elems;
}

// ---------------------------------------------------------------------
vector<string> split(const string &s, char delim)
{
  vector<string> elems;
  split(s, delim, elems);
  return elems;
}
