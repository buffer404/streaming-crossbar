set outputDir ./synth_output             
file mkdir $outputDir

read_verilog  [ glob ./src/*.v ]
read_xdc ./src/timing.xdc

synth_design -top top -part xc7k70tfbg484-2
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt
