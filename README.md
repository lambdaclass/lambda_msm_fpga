# MSM FPGA

This is still a work in progress.
Low level (VHDL) hardware description for MSM acceleration over FPGA.

## Repository contents

So far the repository provides:

* VHDL description of hardware [modules](hdl/README.md)
* A python software to determine optimal Karatsuba partitions
* A python simulator of the point additions scheduling process using the proposed architecture (aiming to optimize scheduling policy)
* A Rust implementation of a point addition in homogeneous projective coordinates.

## Dependencies
* Xilinx tools (Vivado/Vitis)
* To run tests [```cocotb```](https://www.cocotb.org/) python module is required.
* Questasim and/or [```GHDL```](https://github.com/ghdl/ghdl) and optionally [```GtkWave```](https://github.com/gtkwave/gtkwave) for waveform viewing

## Authors
* [Edgardo Marchi](https://github.com/edgardomarchi)
* [Federico D'Angiolo](https://github.com/fgdangiolo)
* [Marcos Cervetto](https://github.com/twint)
* [Stefano Ruberto](https://github.com/stefmr)
