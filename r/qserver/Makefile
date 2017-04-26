MS=$(shell getconf LONG_BIT)  # 32/64

CC=gcc
CFLAGS=-g -O -fpic -m$(MS) -shared -D KXVER=3

R_HOME=/usr
R_SHARE=/Library/Frameworks/R.framework/Resources
REXE=$(R_HOME)/bin/R CMD

INCLUDES=-I. -I$(R_SHARE)/include
LIBS=-lpthread -L$(R_SHARE)/lib -lR

SRC=base.c c.o
TGT=qserver.so

all:
	$(REXE) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)

clean:
	rm -rf $(TGT)
