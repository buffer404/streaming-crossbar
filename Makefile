sim: 
	vivado -mode tcl -source ./tcl_script/simulation.tcl
	
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
