#===[ bits/gcov.mk ]===================================================
# gcov, gcov0: coverage analysis targets for 'gcov'.
#
# The 'gcov' manpage explicitly states that binaries should be built
# without optimization, but since we *can* do coverage analysis at
# some level with optimization on, two targets are provided: 'gcov',
# which leaves the optimization flag alone, and 'gcov0', which removes
# it (causing gcc to default to -O0).
#
# Generated files:
#
#     * -fprofile-arcs causes the executable to generate .gcda files
#           for each source file;
#     * -ftest-coverage causes the executable to generate .gcno files
#           for each source file
#     * gcov, run after the executable, itself generates .gcov files
#           for each source file
ifneq (,$(filter gcov,$(MAKECMDGOALS)))
PROF_FLAGS:=-fprofile-arcs -ftest-coverage
LDLIBS+=-lgcov
endif
gcov: build

ifneq (,$(filter gcov0,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
PROF_FLAGS:=-fprofile-arcs -ftest-coverage
LDLIBS+=-lgcov
endif
gcov0: build

ifeq ($(USE_GLOBS),yes)
RT_FILES:=$(sort *.gcda *.gcno *.gcov, $(RT_FILES))
else
RT_FILES:=$(sort $(STMS:=.gcda) $(STMS:=.gcno) $(STMS:=.gcov), $(RT_FILES))
endif
#======================================================================
