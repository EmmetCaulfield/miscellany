#===[ bits/pdo.mk ]====================================================
# pdo1, pdo2: support the two phases of profile-directed optimization.
#
# In short, do "make pdo1", run the resultant binary with
# representative input, then run "make pdo2".
# ----------------------------------------------------------------------
ifneq (,$(filter pdo1,$(MAKECMDGOALS)))
PROF_FLAGS:=-fprofile-generate
LDFLAGS+=-fprofile-generate
endif
pdo1: build

ifneq (,$(filter pdo2,$(MAKECMDGOALS)))
PROF_FLAGS:=-fprofile-use
endif
pdo2: build

ifeq ($(USE_GLOBS),yes)
RT_FILES:=$(sort *.gcda, $(RT_FILES))
else
RT_FILES:=$(sort $(STMS:=.gcda), $(RT_FILES))
endif
#======================================================================
