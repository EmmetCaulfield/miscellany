#===[ bits/doxygen.mk ]================================================
# doxygen: run doxygen on source and header files
#----------------------------------------------------------------------
NODEPS+=doc
doc: $(SRCS) $(HDRS)
	doxygen

RT_FILES:=$(sort doc $(RT_FILES))
#======================================================================
