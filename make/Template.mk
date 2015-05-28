# -*- makefile-gmake -*-

# List any source files, including their extension, containing a
# "main()" function:
MAIN:=

# If there are *other* sources, not having a main(), list them here:
SRCS:=$(filter-out $(MAIN) _SGLOB_,$(shell echo _SGLOB_))

# List all headers files here:
HDRS:=$(filter-out _HGLOB_,$(shell echo _HGLOB_))

# List files generated by MAIN that should be deleted by the 'clean'
# rule, if any:
RT_FILES:=

# Decide whether to use precompiled headers:
USE_PCH:=yes

# Decide whether to use globs or not:
USE_GLOBS:=yes


#======================================================================
# STANDARD IMPLICIT VARIABLES
#----------------------------------------------------------------------
_CVD_

# Preprocessor flags; -DNDEBUG is removed by 'debug' targets.
CPPFLAGS:=-I. -DNDEBUG

# Compiler flags; change the 5 *_FLAGS variables, below, not this
# definition, which must remain recursive:
_FMV_=$(DBUG_FLAGS) $(LANG_FLAGS) $(PROF_FLAGS) $(WARN_FLAGS) $(OPTM_FLAGS)

# Linker flags; 'debug', 'gprof', and 'pdo' targets append to LDFLAGS:
LDFLAGS:=

# Linker libs; 'gcov' targets append to LDLIBS
LDLIBS:=_LDL_
#======================================================================


#======================================================================
# 5 *_FLAGS VARIABLES
#
# What follows are non-standard variables that are combined to produce
# _FMV_, a standard implicit variable, per the definition above. The
# reason for doing this is to have the flexibility to work around
# certain bugs in 'nvcc'; in particular, to have the ability to
# exclude language option flags (LANG_FLAGS), which can cause it to
# choke.
#----------------------------------------------------------------------
# Warning and error flags; these are not altered by utility targets:
WARN_FLAGS:=-Wall -Wextra

# Language option flags; these are not altered by utility targets:
LANG_FLAGS:=_CLO_ -pedantic

# Optimization flags; the level (-Ox) is removed by the 'debug0',
# 'gprof0', and 'gcov0' targets, and (potentially) altered by the
# 'O0', 'O1', 'O2', 'O3', 'Os', 'Ofast', and 'Og' targets.
OPTM_FLAGS:=-O3 -march=native

# Profiling and DBUG flags. These flags are SET by utility targets
# ('debug', 'debug0', 'gprof', 'gprof0', 'gcov', 'gcov0', 'pdo1',
# 'pdo2') whose entire reason for existing is to obviate the need to
# alter compiler flags for profiling or debugging, so setting them
# directly circumvents the purpose of those targets and is not
# recommended:
PROF_FLAGS:=
DBUG_FLAGS:=

# Debug options to use in 'debug' and 'debug0' utility targets
# (i.e. only when debug binaries are built).
# 
# Although everyone just seems to use '-g', gcc's debugging
# information goes well beyond it.
#
# In summary (see gcc manual for details), there are two things to
# choose from:
#
#    -g<format>, with <format> one of:
#         stabs       : old Unix format, used by Solaris
#         stabs+      :     stabs with gdb-only extensions
#	  coff        : old Unix format, basis of XCOFF and ECOFF
#         xcoff       : IBM/AIX flavor of coff
#         xcoff+      :     xcoff with gdb-only extensions
#         vms         : DEC Alpha/VMS format
#         dwarf-<ver> : most modern Unixen (<ver> 2, 3, or 4)
#         gdb         : choose most expressive supported format
#         <format>+   : allow gdb extensions to <format>
#
#    -g<level>, <level> one of:
#         0 : disable debug info
#         1 : minimal - functions & externs, enough for backtraces
#         2 : default - 1 + local vars and line numbers
#         3 : extra   - 2 + extras such as macros
#
# So -g on a modern Linux box is most likely equivalent to -gdwarf-4 -g2.
#
# If I fire up a debugger, it's most likely going to be 'gdb', so I
# see no reason not to enable level 3 debug info and allow gdb
# extensions:
DBUG_OPTS:=-ggdb3
#======================================================================


# Binaries we're going to build:
BINS:=$(basename $(MAIN))

# This makefile:
THIS:=$(lastword $(MAKEFILE_LIST))

# Remember to delete the binaries:
CT_FILES:=$(BINS)

# Stems of ALL source files:
STMS:=$(BINS) $(basename $(SRCS))

# Let the builtin implicit rule build object-code files:
OBJS:=$(addsuffix .o,$(basename $(SRCS)))
ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort *.o $(CT_FILES))
else
CT_FILES:=$(sort $(STMS:=.o) $(CT_FILES))
endif

# Dependency files:
DEPS:=$(STMS:=.d)

# Handle remaking with the same/different utility pseudo-target:
-include _last.mk
ifeq ($(LAST),$(MAKECMDGOALS))
  build_deps:=$(BINS) _last.mk
else
  build_deps:=compile-time-clean $(BINS) _last.mk
endif
build: $(build_deps)


# Default rule: build the binaries!
default: build


# Include bits here:

_AUX_MK_

include(bits/pch.mk)
include(bits/debug.mk)
include(bits/optim.mk)
include(bits/gprof.mk)
include(bits/gcov.mk)
include(bits/deps.mk)
include(bits/ppc.mk)
include(bits/asm.mk)
include(bits/doxygen.mk)
include(bits/valgrind.mk)
include(bits/ignores.mk)


# Remove runtime-generated files
NODEPS+=run-time-clean
run-time-clean:
	rm -f $(RT_FILES) core core.*

# Remove compile-time generated files
NODEPS+=compile-time-clean
compile-time-clean:
	rm -f $(CT_FILES) *~

# Remove make control files:
NODEPS+=make-control-clean
make-control-clean:
	rm -f $(MC_FILES)

# Remove everything we know how to delete:
NODEPS+=clean
clean: make-control-clean compile-time-clean run-time-clean


# There are now enough varied "make control" files to warrant choosing
# between a glob and individual listing. The 3 files listed here are
# added by the 3 rules that follow.
ifeq ($(USE_GLOBS),yes)
MC_FILES:=$(sort _*.mk $(MC_FILES))
else
MC_FILES:=$(sort _last.mk _phonies.mk _multi.mk $(MC_FILES))
endif


# Make a record of this make run:
NODEPS+=_last.mk
_last.mk:
	@echo 'LAST:=$(MAKECMDGOALS)' > $@


# Silently extract phony targets from this Makefile:
NODEPS+=_phonies.mk
_phonies.mk: $(THIS)
	@echo -n 'PHONY:=_last.mk ' > $@
	@grep -E '^[a-z][a-z0-]+:([^=]|$$)' $< |cut -d: -f1 |grep -v '^doc$$' \
		|tr '\n' ' ' >> $@
	@echo '\n.PHONY: $$(PHONY)' >> $@
-include _phonies.mk


# Support building multiple binaries from the same dependencies:
NO_DEPS+=_multi.mk
_multi.mk: $(THIS)
	@rm -f $@
	@for b in $(BINS); do echo $$b: $$b.o $(OBJS) >> $@; done


# Include automagic dependencies for all targets except the ones we
# explictly exclude:
ifeq (,$(filter $(NODEPS),$(MAKECMDGOALS)))
-include $(DEPS)
-include _multi.mk
endif
