#===[ bits/verbose.mk ]==================================================
# verbose: produce verbose compiler output.
# ----------------------------------------------------------------------
ifneq (,$(filter verbose,$(MAKECMDGOALS)))
BHVR_FLAGS+=-v
endif
verbose: build
#======================================================================
