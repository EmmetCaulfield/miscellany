#===[ bits/gprof.mk ]==================================================
# gprof, gprof0: make instrumented (profiling) binaries for 'gprof'.
#
# Since you *can* profile optimized binaries, both 'gprof' and
# 'gprof0' targets are provided, which leave optimization alone and
# disable optimization, respectively.
#----------------------------------------------------------------------
ifneq (,$(filter gprof,$(MAKECMDGOALS)))
PROF_FLAGS:=-pg
LDFLAGS+=-pg
endif
gprof: build

ifneq (,$(filter gprof0,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
PROF_FLAGS:=-pg
LDFLAGS+=-pg
endif
gprof0: build

ifneq (,$(filter gprofg,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-Og
PROF_FLAGS:=-pg
LDFLAGS+=-pg
endif
gprofg: build

RT_FILES:=$(sort gmon.out $(RT_FILES))
#======================================================================
