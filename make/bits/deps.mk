#===[ bits/deps.mk ]===================================================
# deps: generate C/C++ dependencies automagically.
#----------------------------------------------------------------------
%.d: %_SXT_
ifeq ($(USE_PCH),yes)
	$(_CMV_) -MM $(subst -MMD,,$(CPPFLAGS)) $(_FMV_) $^ | sed 's/\_HXT_\>/_HXT_.gch/g' > $@
else
	$(_CMV_) -MM $(subst -MMD,,$(CPPFLAGS)) $(_FMV_) -o $@ $^
endif
deps: $(DEPS)

ifeq ($(USE_GLOBS),yes)
MC_FILES:=$(sort *.d, $(MC_FILES))
else
MC_FILES:=$(sort $(DEPS), $(MC_FILES))
endif
#======================================================================
