# -*- makefile-gmake -*-
SRCS:=main.c mseq.c
HDRS:=mseq.h

CC=gcc
CFLAGS=-std=c11 -Wall -Wextra -pedantic -O3
CPPFLAGS=-I. -DNDEBUG
LDFLAGS=
LDLIBS=

# It should be pretty well automatic from here...
OBJS:= $(SRCS:.c=.o)
DEPS:= $(SRCS:.c=.d)
BIN := $(basename $(firstword $(SRCS)))

$(BIN): $(OBJS)

# Debug phony target
ifneq (,$(filter debug,$(MAKECMDGOALS)))
override CPPFLAGS:=$(subst -DNDEBUG,,$(CPPFLAGS))
CFLAGS:=$(subst -O3,-g -O0,$(CFLAGS))
LDFLAGS+=-g
endif
debug: $(BIN)


# Generate dependencies automagically:
deps: $(DEPS)
%.d: %.c
	$(CC) -MM $(subst -MMD,,$(CPPFLAGS)) $(CFLAGS) -o $@ $^

# Build documents with Doxygen
NODEPS+=doc
doc: $(SRCS) $(HDRS)
	doxygen

# Run valgrind to check for memory leaks
NODEPS+=valgrind
valgrind:
	valgrind ./$(BIN)


# Remove compiler-generated, editor backup, and core dump files
NODEPS+=clean
clean:
	rm -f *.o *.d *~ core core.* $(BIN)

# Mark targets that aren't real files:
.PHONY: clean valgrind debug deps


# Include automagic dependencies for all targets except phonies and
# ones we explictly add:
ifeq (,$(filter $(NODEPS),$(MAKECMDGOALS)))
-include $(DEPS)
endif
