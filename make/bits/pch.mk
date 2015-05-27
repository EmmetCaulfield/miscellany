#===[ bits/pch.mk ]====================================================
# pch: precompiled header support
#----------------------------------------------------------------------
%_HXT_.gch: %_HXT_
	$(_CMV_) $(CPPFLAGS) $(_FMV_) -o $@ $<
pch: $(HDRS:=.gch)

ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort *_HXT_.gch $(CT_FILES))
else
CT_FILES:=$(sort $(HDRS:=.gch) $(CT_FILES))
endif
#======================================================================
