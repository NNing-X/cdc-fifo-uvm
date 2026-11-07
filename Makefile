VLOG = vlog
VSIM = vsim
VLIB = vlib
VMAP = vmap

TOP = tb_top
TEST ?= base_test

INC = +incdir+tb +incdir+sequences +incdir+tests

RTL = src/socetlib_bin2gray.sv \
      src/socetlib_cdc_fifo_mem.sv \
      src/socetlib_cdc_fifo.sv

compile:
	@if [ ! -d work ]; then $(VLIB) work; fi
	$(VMAP) work work
	$(VLOG) -sv $(RTL)
	$(VLOG) -sv tb/cdc_fifo_if.sv
	$(VLOG) -sv $(INC) tb/cdc_fifo_pkg.sv
	$(VLOG) -sv tb/tb_top.sv

sim:
	$(VSIM) -c work.$(TOP) +UVM_TESTNAME=$(TEST) -do "run -all; quit -f"

run: compile sim

gui:
	$(VSIM) work.$(TOP) +UVM_TESTNAME=$(TEST)

clean:
	rm -rf work transcript vsim.wlf
