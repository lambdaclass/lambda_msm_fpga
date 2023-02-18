TOPLEVEL_LANG = vhdl
SIM = questa
ARCH = i686
COMPILE_ARGS += -2008
SIM_ARGS += -t ps
WAVES=1

VHDL_SOURCES += ../../config.vhd \
            ../../utils/tipos.vhd \
            ../../utils/funciones.vhd \
			../../utils/delay_1.vhd \
            ../../modules/mod_add/mod_add_pip.vhd \
			../../modules/point_adder/mod_mul_x3.vhd 

TOPLEVEL= mod_mul_x3

MODULE := test_mod_mul_x3
export COCOTB_ANSI_OUTPUT=1

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim

.PHONY:wave
wave:
	vsim -view vsim.wlf -do wave.do


.PHONY:clear
clear: clean
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__ results.xml vsim.wlf
