/* main.cc */

#define MAIN
#define SOCK_ERRORS

using namespace std;

#include "main.h"
#include "q2r.h"
#include "r2q.h"

extern "C" {
  K rsclose(K p);
  K rscmd(K p);
  K rsopen(K p);
  K rsget(K p);
  K rsset(K p,K q);
}

K rsexec(int type, K x);
Rconnection *rc;
string errmsg;
string notopen="R connection not open";

// ---------------------------------------------------------------------
K rsclose(K p)
{
  if (rc) {
    delete rc;
    rc=0;
  }
  return ki(0);
}

// ---------------------------------------------------------------------
K rscmd(K p)
{
  if (!rc)
    return krs(notopen);
  K r;
  string exp = kstring(p);
  int res=rc->voidEval(exp.c_str());
  r=ki(0);
  return r;
}

// ---------------------------------------------------------------------
K rsget(K p)
{
  if (!rc)
    return ki(0);
  K r;
  string exp = kstring(p);
  int res=0;
  Rexp *val = rc->eval(exp.c_str(),&res);
  if (val) {
    r=from_any_robject(val);
    delete val;
    return r;
  }
  return krs("get");
}

// ---------------------------------------------------------------------
K rsopen(K p)
{
  if (rc)
    return ki(0);

  int i;
  string h;
  string host="127.0.0.1";
  string port="6311";
  string user,pass;

  vector<string> v=split(kstring(p),':');
  int len=v.size();

  if (len>1) {
    h=v.at(1);
    if (h.size() && (h!="localhost"))
      host=h;
  }
  if (len>2)
    port=v.at(2);
  if (len>3)
    user=v.at(3);
  if (len>4)
    pass=v.at(4);

  rc = new Rconnection(host.c_str(),s2i(port));

  i=rc->connect();
  if (i) {
    delete rc;
    rc=0;
    char msg[128];
    sockerrorchecks(msg, 128, -1);
    return krs("unable to connect, result=" + i2s(i) + ", " + string(msg));
  }

  i=rc->login(user.c_str(),pass.c_str());
  if (i) {
    delete rc;
    rc=0;
    return krs("unable to connect, invalid user/password");
  }

  return ki(0);
}

// ---------------------------------------------------------------------
K rsset(K p, K q)
{
  if (!rc)
    return krs(notopen);
  string name = kstring(p);
  Rexp *val = from_any_kobject(q);
  if (val==0)
    return krs("could not convert K object type " + i2s(q->t));
  int r=rc->assign(name.c_str(), val);
  delete val;
  return ki(r);
}
