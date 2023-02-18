
## Variable declarations 

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
				../../../modules/mod_add/mod_add_pip.vhd

TOPLEVEL= mod_add_pip

MODULE := test_mod_add

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim


.PHONY:wave
wave:
	vsim -view vsim.wlf -do wave.do


.PHONY:clear
clear: clean
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__ results.xml vsim.wlf