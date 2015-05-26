#===[ bits/debug.mk ]==================================================
# debug, debug0: make debug binaries.
#
# The 'debug' target leaves optimization alone, while the 'debug0'
# target disables optimization. Both targets remove -DNDEBUG, if
# present, which disables assert() macros.
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
#======================================================================
