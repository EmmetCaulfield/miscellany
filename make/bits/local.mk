#===[ bits/local.mk ]==================================================
# Host-specifics for my environment.
#----------------------------------------------------------------------
HOST=$(shell hostname)
ifeq ($(HOST),arugula)
  GPU_ARCH:=-arch=sm_30
else 
  ifeq ($(HOST),icme-gpu1)
    GPU_ARCH:=-arch=sm_20
    WARN_FLAGS+=-Wno-inline -Wno-unused-parameter
  endif
endif
#======================================================================
