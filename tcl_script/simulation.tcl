create_project simulation ./sim_output

add_files -fileset sources_1 { ./src/crossbar.v ./src/round_robin.v ./src/schedule.v ./src/top.v }
add_files -fileset sim_1 ./tb/top_tb.v

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_simulation

#close_project -delete -quiet