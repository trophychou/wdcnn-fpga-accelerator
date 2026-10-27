open_project -reset hls_project
set_top synthesis_top
add_files -cflags "-I./hw_lib" synthesis_top.cpp
add_files -tb -cflags "-I./hw_lib" testbench.cpp
open_solution -reset "solution1"
set_part {xczu3eg-sbva484-1-i}
create_clock -period 3.33 -name default
csim_design
csynth_design
cosim_design
exit
