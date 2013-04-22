/* rconx - extensions to Rconnection */

#include "rconx.h"

// ---------------------------------------------------------------------
int Rbytex::datalen()
{
  return ((int*)data)[0];
}

// ---------------------------------------------------------------------
void Rbytex::set(const char *s, Rsize_t n)
{
  len=4*(2+(Rsize_t)(n/4));
  data=(char*)malloc(len);
  set_master(this);
  memset(data,255,len);
  unsigned int *i=(unsigned int*)data;
  i[0]=n;
  memcpy(data+4,s,n);
}

// ---------------------------------------------------------------------
int *Rboolx::intArray()
{
  int len=datalen();
  // caller should free
  char *s =(char*)calloc(len,4);
  DO(len,s[i*4]=data[i+4]);
  return (int *)s;
}

// ---------------------------------------------------------------------
void Rstringx::set(const char *s, Rsize_t n)
{
  len=n+1;
  Rsize_t w=4*(1+(Rsize_t)(n/4));
  data=(char*)malloc(w);
  set_master(this);
  memset(data,255,w);
  memcpy(data,s,n);
  data[n]='\0';
}

// ---------------------------------------------------------------------
// builds a names tag
void Rtagx::set(vector<string> s)
{
  int n=s.size();
  int att;
  unsigned int *i;

  att=n;
  DO(n,att+=s.at(i).size());
  att=4*(int)(att+3)/4;
  len=att+16;
  data=(char*)calloc(len,1);
  memset(data+4,1,len-4);
  set_master(this);
  char *p=data+4;
  DO(n, {
    strcpy(p,s.at(i).c_str());
    p+=1+s.at(i).size();
  });
  i=(unsigned int*)(data+att+4);
  i[0]=XT_SYMNAME+256*8;
  strcpy(data+att+8,(char*)"names");
  i=(unsigned int*)data;
  i[0]=XT_ARRAY_STR+256*att;
}

// ---------------------------------------------------------------------
void Rvectorx::append(Rexp *s)
{
  cont.push_back(s);
}

// ---------------------------------------------------------------------
bool Rvectorx::make()
{
  int n=cont.size();
  int s=n*8;
  DO(n,s+=cont[i]->storageSize());
  data=(char*)calloc(s,1);
  set_master(this);
  pos=0;
  DO(n,make1(cont[i]));
  len=pos;
  DO(n,free(cont[i]));
  cont.clear();
  return true;
}

// ---------------------------------------------------------------------
void Rvectorx::make1(Rexp *s)
{
  char *buf=data+pos;
  Rsize_t len=s->storageSize();
  s->store(buf);
  pos+=len;
}

// ---------------------------------------------------------------------
void Rvectorx::setatt()
{
  if (type<128)
    type+=128;
}
