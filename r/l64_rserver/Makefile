# linux rserver makefile

MS=$(shell getconf LONG_BIT)  # 32/64
Q=~/q/l$(MS)

CC=gcc
CFLAGS=-g -O -fPIC -m$(MS) -shared

R_HOME=/usr/lib/R
R_SHARE=/usr/share/R
REXE=$(R_HOME)/bin/R CMD

INCLUDES=-I. -I$(R_SHARE)/include
LIBS=-lpthread -L$(R_HOME)/lib -lR

SRC=base.c
TGT=rserver.so

all:
	$(REXE) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)
	cp $(TGT) $(Q)

clean:
	rm -rf $(TGT)
