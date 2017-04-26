# osx rserver makefile

MS=$(shell getconf LONG_BIT)  # 32/64
Q=~/q/m$(MS)

CC=gcc
CFLAGS=-g -O -fPIC -m$(MS) -dynamiclib -undefined dynamic_lookup -D KXVER=3

R_HOME=/Library/Frameworks/R.framework/Resources
REXE=$(R_HOME)/bin/R CMD
INCLUDES=-I. -I$(R_HOME)/include
LIBS=-lpthread -L$(R_HOME)/lib -lR

SRC=base.c
TGT=rserver.so

all:
	$(REXE) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)
	cp $(TGT) $(Q)

clean:
	rm -rf $(TGT)
