#
# simple makefile for GHDL(mcode) simulation
#
#   - requires GHDL and gtkwave to be on PATH
#
#   - currently uses phony rules with no dependencies (i.e. always rebuilds targets)
#
#   - for mcode simulator, would need to be creative with dependency rules
#       - use library .cf file as 'output' of compile
#       - use .ghw file as output of simulation
#
#   - Convenience targets:
#       - 'make view' fires up gtkwave 
#       - 'make edit' fires up an editor with all the source files
#
TB_NAME     = bit_count_tb
SIM_TOP     = testbench
STOP_TIME   = 50us

# vhdl source files
SRC_FILES  = ./hdl/bit_count.vhd

# simulation testbench files
SIM_FILES  = ./sim/$(TB_NAME).vhd

# simulator flags
GHDL_FLAGS  = 
# --ieee=synopsys -fexplicit
# --assert-level=error

RUN_FLAGS = --stop-time=$(STOP_TIME)

WAVE_FORMAT = ghw

# Program executables
GHDL = ghdl
VIEWER = gtkwave
EDITOR = gr       


.PHONY: compile sim view edit clean

all: compile sim

compile:
	$(GHDL) -a -v $(GHDL_FLAGS) --workdir=./sim/work.ghd $(SRC_FILES) $(SIM_FILES)

sim:
	$(GHDL) -r $(GHDL_FLAGS) --workdir=./sim/work.ghd  $(SIM_TOP) $(RUN_FLAGS) --wave=./sim/$(TB_NAME).$(WAVE_FORMAT) 

view:
	$(VIEWER) -f ./sim/$(TB_NAME).$(WAVE_FORMAT)  -a ./sim/$(TB_NAME).gtkw &

edit:
	$(EDITOR) $(SRC_FILES) $(SIM_FILES)

clean:
	$(GHDL) --clean --workdir=./sim/work.ghd

 