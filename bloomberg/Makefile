KX_INC=$(KDBROOT)/q/include

BLPAPI_VERSION = 3.8.18.1
BLPAPI_DIR     = /opt/bloomberg/blpapi_cpp_$(BLPAPI_VERSION)
BLPAPI_INCLUDE = $(BLPAPI_DIR)/include/
BLPAPI_SO      = $(BLPAPI_DIR)/Linux/libblpapi3_64.so

LIBLFDS        = /opt/liblfds6.1.1/liblfds611


main: clean
	gcc -D KXVER=3 -Wall bpipe.c -g -I$(BLPAPI_INCLUDE) -I$(LIBLFDS)/inc/ -I$(KX_INC) -fPIC -shared -o ../bpipe.so $(BLPAPI_SO) $(LIBLFDS)/bin/liblfds611.so


clean:
	if [ -a ../*.so ]; then	\
		rm ../*.so;			\
	fi;