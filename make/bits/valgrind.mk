#===[ bits/valgrink.mk ]===============================================
# valgrind: to check for memory leaks
#----------------------------------------------------------------------
NODEPS+=valgrind
valgrind: $(BINS:=.vg)

%.vg: %
	valgrind --log="$@" ./$<

ifeq ($(USE_GLOBS),yes)
RT_FILES:=$(sort *.vg, $(RT_FILES))
else
RT_FILES:=$(sort $(BINS:=.vg), $(RT_FILES))
endif
#======================================================================

