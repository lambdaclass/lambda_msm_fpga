
TOPLEVEL_LANG = vhdl
SIM = questa
ARCH = i686
COMPILE_ARGS += -2008
SIM_ARGS += -t ps
GUI=0
WAVES=1

VHDL_SOURCES += ../../../utils/tipos.vhd \
				../../../utils/funciones.vhd \
				../../../config.vhd \
				../../../utils/delay_1.vhd \
				../../../utils/delay_M.vhd \
				../../../modules/kara_mul/kara_mul.vhd \
				../../../modules/mod_mul/mod_mul.vhd \
				../../../modules/mod_mul/mod_mul_pip.vhd

TOPLEVEL= mod_mul_pip
MODULE := test_mod_mul_pip

ifdef DEBUG
	export COCOTB_REDUCED_LOG_FMT=0
	export COCOTB_LOG_LEVEL=DEBUG
	export COCOTB_SCHEDULER_DEBUG=1
endif

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim


.PHONY:wave
wave:
	vsim -view vsim.wlf -do wave.do


.PHONY:clear
clear: clean
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__ results.xml vsim.wlf
