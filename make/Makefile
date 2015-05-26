MK=Makefile.gcc Makefile.g++ Makefile.cuda

all: $(MK)

Makefile.%: %.m4 Template.mk bits
	m4 $< > $@

clean:
	rm -f *~ bits/*~ $(MK)
