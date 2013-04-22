#ifndef UTIL_H
#define UTIL_H

#include <vector>
#include "k.h"

K kdoublea(int len, int rank, int *shape, double *val);
K kdoublev(int len, double *val);
K kinta(int len, int rank, int *shape, int *val);
K kintv(int len, int *val);
K krs(std::string s);
std::string kstring(K x);

int fwrite(string fname, char *s, int len);
std::string i2s(int i);
int s2i(std::string s);
std::vector<std::string> split(const std::string &s, char delim);

#endif
