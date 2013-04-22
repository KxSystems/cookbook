
MS=$(shell getconf LONG_BIT)

CXXFLAGS+=-g -O -fPIC -m$(MS) -shared -D HAVE_CONFIG_H

all:
	$(CXX) $(CXXFLAGS) -c Rconnection.cc

clean:
	rm -f *.o
