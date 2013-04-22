
MS=$(shell getconf LONG_BIT)
UNAME=$(shell uname -s)
Q=~/q

SRC=$(wildcard *.cc)
OBJ=$(SRC:%.cc=%.o)
RCON=../Rconnection/Rconnection.o

ifeq ($(UNAME),Linux)
 PFX=l
 LIBS+=-ldl -lcrypt
 SHD=-shared
endif

ifeq ($(UNAME),Darwin)
 PFX=m
 LIBS+=-ldl
 SHD=-bundle -undefined dynamic_lookup
endif

CXXFLAGS+=-g -O -fPIC -m$(MS) -D HAVE_CONFIG_H -D KXVER=3 $(SHD)
TGT=../bin/$(PFX)$(MS)/rserve.so
WALL=-Wall

all: $(TGT)

$(TGT): $(OBJ)
	$(CXX) $(WALL) $(CXXFLAGS) $(OBJ) $(RCON) $(LIBS) -o $(TGT)
	chmod 644 $(TGT)
	ls -l $(TGT)
	cp $(TGT) $(Q)/$(PFX)$(MS)

%.o: %.cc
	$(CXX) $(WALL) $(CXXFLAGS) -c $<

clean:
	rm -rf $(OBJ) $(TGT) *~
