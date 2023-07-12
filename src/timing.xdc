create_clock -name VCLK -period 8.0 -waveform {0 4}

set_input_delay  1.0 -clock [get_clocks VCLK] [all_inputs]
set_output_delay 1.0 -clock [get_clocks VCLK] [all_outputs]