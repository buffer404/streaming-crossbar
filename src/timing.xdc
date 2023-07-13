create_clock -name VCLK -period 5.0 -waveform {0 2.5}

set_input_delay  0 -clock [get_clocks VCLK] [all_inputs]
set_output_delay 0 -clock [get_clocks VCLK] [all_outputs]