rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRCS:=$(call rwildcard,src,*.vhd)

lib/xpm-obj08.cf: $(SRCS)
	XPM_TOP_DIR=. XPM_LIB_WORK_DIR=lib ./compile_ghdl_xpm_library.sh

.PHONY:clean
clean:
	rm -rf lib