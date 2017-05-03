OSFLAG :=
MS :=
ifeq ($(OS),Windows_NT)
	OSFLAG = w
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		MS = 64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		MS = 32
	endif
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG = l
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG = m
	endif
	MS=$(shell getconf LONG_BIT)  # 32/64
endif

QARCH=$(OSFLAG)$(MS)
Q=${QHOME}/$(QARCH)

CC=gcc
CFLAGS=-g -O0 -fPIC -m$(MS) -DKXVER=3
ifeq ($(OSFLAG),m)
	CFLAGS+=-dynamiclib -undefined dynamic_lookup
endif
ifeq ($(OSFLAG),l)
	CFLAGS+=-shared
endif

R_HOME=$(shell R RHOME)
R_INCLUDES=$(shell R CMD config --cppflags)
REXE=$(R_HOME)/bin/R CMD

LIBS=-lpthread -L$(R_HOME)/lib -lR $(addsuffix /c.o,$(QARCH))

SRC=base.c
TGT=$(addsuffix /qserver.so,$(QARCH))

all:
	$(REXE) $(CC) $(CFLAGS) $(R_INCLUDES) $(SRC) $(LIBS) -o $(TGT)
	install $(TGT) $(Q)

clean:
	rm -rf $(TGT)
