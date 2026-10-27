open_project -reset wdcnn_dual_hls
set_top wdcnn_dual_top
add_files wdcnn_dual_top.cpp -cflags "-I."
add_files -tb testbench.cpp -cflags "-I."
set script_dir [file dirname [file normalize [info script]]]
set prototype_dir [file normalize [file join $script_dir .. prototype_fold01]]
open_solution -reset solution1
set_part {xczu3eg-sbva484-1-i}
create_clock -period 3.33 -name default
csim_design -argv [list $prototype_dir]
csynth_design
cosim_design -argv [list $prototype_dir]
exit
