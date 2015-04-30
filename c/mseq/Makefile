SRCS:=main.c mseq.c
HDRS:=mseq.h

OBJS:= $(SRCS:.c=.o)
DEPS:= $(SRCS:.c=.d)
BIN := $(basename $(firstword $(SRCS)))

CC=gcc
CFLAGS=-std=c11 -Wall -Wextra -pedantic -O3
CPPFLAGS=-I.
LDFLAGS=
LDLIBS=

$(BIN): $(OBJS)

# Debug phony target
ifneq (,$(filter debug,$(MAKECMDGOALS)))
override CPPFLAGS:=$(subst -DNDEBUG,,$(CPPFLAGS))
CFLAGS:=$(subst -O3,-g -O0,$(CFLAGS))
LDFLAGS+=-g
endif
debug: $(BIN)


# Include automagic dependencies for everything except "clean" targets:
ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEPS)
endif

# Generate dependencies automagically:
deps: $(DEPS)
%.d: %.cpp
	$(CC) -MM $(subst -MMD,,$(CPPFLAGS)) $(CPPFLAGS) -o $@ $^

# Build documents with Doxygen
doc: $(SRCS) $(HDRS)
	doxygen

# Run valgrind to check for memory leaks
valgrind:
	valgrind ./$(BIN)

# Remove compiler-generated, editor backup, and core dump files
clean:
	rm -f *.o *.d *~ core core.* $(BIN)

foo:
	echo 


.PHONY: clean valgrind debug

