
# $Id $

CFLAGS = -I. -fPIC

.SUFFIXES: .so
.PHONY: cpu clean doc

cpu: cpu.so

%.so: %.c
	${CC} ${CFLAGS} -shared -o $@ $<

doc:
	${MAKE} -C doc

clean:
	@rm -f *.so


