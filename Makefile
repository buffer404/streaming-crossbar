sim: 
	vivado -mode tcl -source ./tcl_script/simulation.tcl
	
syn:
	vivado -mode tcl -source ./tcl_script/synthesis.tcl
	
clean_sim:
ifeq ($(OS), Windows_NT)
	rmdir /Q /S sim_output 
	rmdir /Q /S .Xil
	del vivado.jou
	del vivado.log
else
	rm -rf sim_output 
	rm -rf /Q /S .Xil
	rm vivado.jou
	rm vivado.log
endif

clean_syn:
ifeq ($(OS), Windows_NT)
	rmdir /Q /S synth_output 
	rmdir /Q /S .Xil
	del vivado.jou
	del vivado.log
else
	rm -rf synth_output 
	rm -rf /Q /S .Xil
	rm vivado.jou
	rm vivado.log
endif
