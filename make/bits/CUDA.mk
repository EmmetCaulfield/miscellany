#===[ bits/CUDA.mk ]===================================================
# CUDA/nvcc support
#----------------------------------------------------------------------
# CUDA additions to standart implicit variables:
LDFLAGS+=-L$(CUDA_PATH)/lib64

# At an absolute minimum, any CUDA app must be linked with the
# following libraries:
NV_LIBS:=-lcudart -lm -lstdc++

# The above libraries should go at the end of LDLIBS and, ideally, not
# be repeated, particularly if the --as-needed option is provided to
# the linker (-Wl,--as-needed):
LDLIBS:=$(filter-out $(NV_LIBS), $(LDLIBS)) $(NV_LIBS)

# A trick to get nvcc-safe CXXFLAGS as a comma-separated list:
COMFLAGS=$(BHVR_FLAGS) $(CGEN_FLAGS) $(DBUG_FLAGS) $(PROF_FLAGS) $(WARN_FLAGS) $(OPTM_FLAGS)
null:=
space:= $(null) #
comma:= ,
CSV_FLAGS=$(subst $(space),$(comma),$(strip $(COMFLAGS)))

# Nvidia CUDA compiler:
NV_CXX:=nvcc

# Nvidia (ptx) assembler flags
NV_ASFLAGS:=

# Nvidia CUDA compiler flags:
NV_CXXFLAGS=-std c++11 $(GPU_ARCH) $(NV_ASFLAGS) -Xcompiler $(CSV_FLAGS)

# Optional pipe command to enable extraction of register counts, etc.
NV_PIPECMD:=

# .cu to .o pattern rule:
%.o: %.cu
	$(NV_CXX) $(CPPFLAGS) $(NV_CXXFLAGS) -c $< $(NV_PIPECMD)

_LOCAL_MK_

# verbose: nvcc verbose output:
ifneq (,$(filter cuverbose,$(MAKECMDGOALS)))
NV_CXXFLAGS:=-v $(NV_CXXFLAGS)
endif
cuverbose: build


# regcount: get kernel register count from nvcc
ifneq (,$(filter regcount,$(MAKECMDGOALS)))
NV_ASFLAGS:=-Xptxas -v
NV_PIPECMD:=2>&1|awk -v RS='ptxas info    : Compiling entry function ' -F 'ptxas info    : ' '{print $$1 $$3}' | c++filt
endif
regcount: build

# Generate dependencies for .cu files:
%.d: %.cu
	$(CXX) -MM -x c++ $(subst -MMD,,$(CPPFLAGS)) $(CXXFLAGS) -o $@ $^


# Generate post-processed code
%.cpp.ii: %.cu
	$(NV_CXX) --cuda $(CPPFLAGS) $(NV_CXXFLAGS) -o $@ $^

ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort *.cpp.li $(CT_FILES))
else
CT_FILES:=$(sort $(CT_FILES) $(addsuffix .cpp.li, $(basename $(filter %.cu, $(MAIN) $(SRCS)))))
endif
#======================================================================
