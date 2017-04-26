# linux qserver makefile
# copy in appropriate c.o

MS=$(shell getconf LONG_BIT)  # 32/64

CC=gcc
CFLAGS=-g -O -fPIC -m$(MS) -shared -D KXVER=3

R_HOME=/usr/lib/R
R_SHARE=/usr/share/R
REXE=$(R_HOME)/bin/R CMD

INCLUDES=-I. -I$(R_SHARE)/include
LIBS=-lpthread -L$(R_HOME)/lib -lR

SRC=base.c c.o
TGT=qserver.so

all:
	$(REXE) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)

clean:
	rm -rf $(TGT)
