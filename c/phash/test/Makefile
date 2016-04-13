CC:=gcc
CFLAGS = -O2
CPPFLAGS:=-I.. -I.

WORDS=words.lst

test: testperf
	./testperf -nm < ${WORDS}

testperf: testperf.o phash.o ../lookupa.o ../recycle.o

clean:
	rm -f testperf *.o *~ phash.[ch]

.PHONY: clean test


phash.o: phash.c phash.c

phash.h: ../perfect
	../perfect -nm < ${WORDS}

../perfect:
	cd .. && ${MAKE}

testperf.o: testperf.c phash.h
