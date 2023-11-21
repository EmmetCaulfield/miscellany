CC:=gcc
CFLAGS:=-O2 -std=c99 -Wall -Wextra -pedantic
CPPFLAGS:=-I.

OBJS = perfect.o perfhex.o lookupa.o recycle.o

perfect: $(OBJS)

perfect.o: perfect.c perfect.h lookupa.h recycle.h
lookupa.o: lookupa.c lookupa.h
recycle.o: recycle.c recycle.h
perfhex.o: perfect.h lookupa.h recycle.h

clean:
	rm -f perfect *.o *~
	rm -f phash.[ch]

.PHONY: clean
