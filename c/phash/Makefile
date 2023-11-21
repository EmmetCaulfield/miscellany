CC:=gcc
CFLAGS:=-O2 -std=c99 -Wall -Wextra -pedantic
CPPFLAGS:=-I.

OBJS = perfect.o perfhex.o lookupa.o recycle.o

perfect: $(OBJS)
phtest: phtest.o phash.o lookupa.o

perfect.o: perfect.c perfect.h lookupa.h recycle.h
lookupa.o: lookupa.c lookupa.h
recycle.o: recycle.c recycle.h
perfhex.o: perfect.h lookupa.h recycle.h
phtest.o: phtest.c phash.o
phash.o: phash.c phash.h

phash.h phash.c: perfect keys.txt
	./perfect -nms < keys.txt

.PHONY: clean
clean:
	rm -f perfect *.o *~
	rm -f phash.[ch]
	rm -f phtest

