#===[ bits/debug.mk ]==================================================
# debug, debug0. debugg: make debug binaries.
#
# The 'debug' target leaves optimization alone, while the 'debug0'
# target disables optimization, and the 'debugg' target enables -Og,
# the recommended optimization level for development. All three
# targets remove -DNDEBUG, if present, which disables assert() macros,
# so that assert macros() are enabled.
# ----------------------------------------------------------------------
ifneq (,$(filter debug,$(MAKECMDGOALS)))
CPPFLAGS:=$(subst -DNDEBUG,,$(CPPFLAGS))
DBUG_FLAGS:=$(DBUG_OPTS)
LDFLAGS+=$(DBUG_OPTS)
endif
debug: build

ifneq (,$(filter debug0,$(MAKECMDGOALS)))
CPPFLAGS:=$(subst -DNDEBUG,,$(CPPFLAGS))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
DBUG_FLAGS:=$(DBUG_OPTS)
LDFLAGS+=$(DBUG_OPTS)
endif
debug0: build

ifneq (,$(filter debugg,$(MAKECMDGOALS)))
CPPFLAGS:=$(subst -DNDEBUG,,$(CPPFLAGS))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-Og
DBUG_FLAGS:=$(DBUG_OPTS)
LDFLAGS+=$(DBUG_OPTS)
endif
debugg: build
#======================================================================
