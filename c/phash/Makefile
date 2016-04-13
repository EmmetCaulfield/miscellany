CC:=gcc
CFLAGS:=-std=c99 -O2 -Wall -Wextra
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
