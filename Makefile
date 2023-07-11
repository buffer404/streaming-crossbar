
sim: 
	vivado -mode tcl -source ./tcl_script/simulation.tcl
	
clean_sim:
	rmdir /Q /S sim_output 
	rmdir /Q /S .Xil
	del vivado.jou
	del vivado.log
	