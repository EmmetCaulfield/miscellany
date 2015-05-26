#===[ bits/asm.mk ]====================================================
# asm: generate assembly language output from compilation proper.
#----------------------------------------------------------------------
#
# You arguably get better assembly output by supplying flags to gas
# rather than relying on whatever gcc provides with -fverbose-asm
#
# The 'a' flags of interest are:
#    'c' - omit false conditionals
#    'd' - omit debugging directives
#    'g' - include general information, like version and options
#    'h' - include high-level source
#    'l' - include assembly
#    'm' - include macro expansions
#    'n' - omit forms processing
#    's' - include symbols
S_ASFLAGS=-aghlnms
%.s: %_SXT_
#	$(_CMV_) -S -fverbose-asm $(CPPFLAGS) $(_FMV_) -o $@ $^
	$(_CMV_) -Wa,$(S_ASFLAGS) $(CPPFLAGS) $(_FMV_) -o $@ $^
asm:  $(STMS:=.s)

# Ensure that '-g' (debug info) flag is supplied, otherwise the output
# is much less readable.
ifneq (,$(filter asm,$(MAKECMDGOALS)))
DBUG_FLAGS:=$(DBUG_OPTS)
endif

ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort *.s, $(CT_FILES))
else
CT_FILES:=$(sort $(STMS:=.s), $(CT_FILES))
endif
#======================================================================
