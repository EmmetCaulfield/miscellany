#===[ bits/ppc.mk ]====================================================
# ppc: generate post-preprocessed code, sometimes needed for debugging
# preprocessor macros.
#----------------------------------------------------------------------
%.i: %_SXT_
	$(_CMV_) -E $(CPPFLAGS) $(_FMV_) -o $@ $^
ppc: $(STMS:=.i)

ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort *.i $(CT_FILES))
else
CT_FILES:=$(sort $(STMS:=.i) $(CT_FILES))
endif
#======================================================================
