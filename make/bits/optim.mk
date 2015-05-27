#===[ bits/optim.mk ]==================================================
# O0, O1, O2, O3, Os, Ofast, Og: targets for every optimization level
# supported by 'gcc'
#----------------------------------------------------------------------
ifneq (,$(filter O0,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-O0
endif
O0: build

ifneq (,$(filter O1,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-O1
endif
O1: build

ifneq (,$(filter O2,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-O2
endif
O2: build

ifneq (,$(filter O3,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-O3
endif
O3: build

ifneq (,$(filter Os,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-Os
endif
Os: build

ifneq (,$(filter Ofast,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-Ofast
endif
Ofast: build

ifneq (,$(filter Og,$(MAKECMDGOALS)))
OPTM_FLAGS:=$(filter-out -O%,$(OPTM_FLAGS))
OPTM_FLAGS+=-Og
endif
Og: build
#======================================================================
