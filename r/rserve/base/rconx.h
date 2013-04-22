#ifndef RCONX_H
#define RCONX_H

#include "main.h"

// ---------------------------------------------------------------------
class Rbytex : public Rexp
{
public:
  Rbytex() : Rexp(XT_RAW,0,0,0) {};
  int datalen();
  void set(const char*, Rsize_t);
};

// ---------------------------------------------------------------------
class Rboolx : public Rbytex
{
public:
  Rboolx() : Rbytex() {
    type=XT_ARRAY_BOOL;
  };
  int *intArray();
};

// ---------------------------------------------------------------------
class Rstringx : public Rexp
{
public:
  Rstringx() : Rexp(XT_ARRAY_STR,0,0,0) {};
  void set(const char*, Rsize_t);
};

// ---------------------------------------------------------------------
class Rtagx : public Rexp
{
public:
  Rtagx() : Rexp(XT_LIST_TAG,0,0,0) {};
  void set(vector<string> s);
};

// ---------------------------------------------------------------------
class Rvectorx : public Rexp
{
public:
  Rvectorx() : Rexp(XT_VECTOR,0,0,0) {};
  void append(Rexp *);
  bool make();
  void setatt();

private:
  void make1(Rexp *);
  int pos;
  vector<Rexp *> cont;
};

#endif
