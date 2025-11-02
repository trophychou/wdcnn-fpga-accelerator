
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [2:0] proc_0_data_FIFO_blk;
    wire [2:0] proc_0_data_PIPO_blk;
    wire [2:0] proc_0_start_FIFO_blk;
    wire [2:0] proc_0_TLF_FIFO_blk;
    wire [2:0] proc_0_input_sync_blk;
    wire [2:0] proc_0_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_0;
    reg [2:0] proc_dep_vld_vec_0_reg;
    wire [2:0] in_chan_dep_vld_vec_0;
    wire [164:0] in_chan_dep_data_vec_0;
    wire [2:0] token_in_vec_0;
    wire [2:0] out_chan_dep_vld_vec_0;
    wire [54:0] out_chan_dep_data_0;
    wire [2:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [54:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_2_0;
    wire [54:0] dep_chan_data_2_0;
    wire token_2_0;
    wire dep_chan_vld_4_0;
    wire [54:0] dep_chan_data_4_0;
    wire token_4_0;
    wire [15:0] proc_1_data_FIFO_blk;
    wire [15:0] proc_1_data_PIPO_blk;
    wire [15:0] proc_1_start_FIFO_blk;
    wire [15:0] proc_1_TLF_FIFO_blk;
    wire [15:0] proc_1_input_sync_blk;
    wire [15:0] proc_1_output_sync_blk;
    wire [15:0] proc_dep_vld_vec_1;
    reg [15:0] proc_dep_vld_vec_1_reg;
    wire [15:0] in_chan_dep_vld_vec_1;
    wire [879:0] in_chan_dep_data_vec_1;
    wire [15:0] token_in_vec_1;
    wire [15:0] out_chan_dep_vld_vec_1;
    wire [54:0] out_chan_dep_data_1;
    wire [15:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [54:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_2_1;
    wire [54:0] dep_chan_data_2_1;
    wire token_2_1;
    wire dep_chan_vld_3_1;
    wire [54:0] dep_chan_data_3_1;
    wire token_3_1;
    wire dep_chan_vld_6_1;
    wire [54:0] dep_chan_data_6_1;
    wire token_6_1;
    wire dep_chan_vld_9_1;
    wire [54:0] dep_chan_data_9_1;
    wire token_9_1;
    wire dep_chan_vld_13_1;
    wire [54:0] dep_chan_data_13_1;
    wire token_13_1;
    wire dep_chan_vld_17_1;
    wire [54:0] dep_chan_data_17_1;
    wire token_17_1;
    wire dep_chan_vld_21_1;
    wire [54:0] dep_chan_data_21_1;
    wire token_21_1;
    wire dep_chan_vld_25_1;
    wire [54:0] dep_chan_data_25_1;
    wire token_25_1;
    wire dep_chan_vld_29_1;
    wire [54:0] dep_chan_data_29_1;
    wire token_29_1;
    wire dep_chan_vld_33_1;
    wire [54:0] dep_chan_data_33_1;
    wire token_33_1;
    wire dep_chan_vld_37_1;
    wire [54:0] dep_chan_data_37_1;
    wire token_37_1;
    wire dep_chan_vld_41_1;
    wire [54:0] dep_chan_data_41_1;
    wire token_41_1;
    wire dep_chan_vld_45_1;
    wire [54:0] dep_chan_data_45_1;
    wire token_45_1;
    wire dep_chan_vld_48_1;
    wire [54:0] dep_chan_data_48_1;
    wire token_48_1;
    wire dep_chan_vld_51_1;
    wire [54:0] dep_chan_data_51_1;
    wire token_51_1;
    wire [1:0] proc_2_data_FIFO_blk;
    wire [1:0] proc_2_data_PIPO_blk;
    wire [1:0] proc_2_start_FIFO_blk;
    wire [1:0] proc_2_TLF_FIFO_blk;
    wire [1:0] proc_2_input_sync_blk;
    wire [1:0] proc_2_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_2;
    reg [1:0] proc_dep_vld_vec_2_reg;
    wire [1:0] in_chan_dep_vld_vec_2;
    wire [109:0] in_chan_dep_data_vec_2;
    wire [1:0] token_in_vec_2;
    wire [1:0] out_chan_dep_vld_vec_2;
    wire [54:0] out_chan_dep_data_2;
    wire [1:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_0_2;
    wire [54:0] dep_chan_data_0_2;
    wire token_0_2;
    wire dep_chan_vld_1_2;
    wire [54:0] dep_chan_data_1_2;
    wire token_1_2;
    wire [2:0] proc_3_data_FIFO_blk;
    wire [2:0] proc_3_data_PIPO_blk;
    wire [2:0] proc_3_start_FIFO_blk;
    wire [2:0] proc_3_TLF_FIFO_blk;
    wire [2:0] proc_3_input_sync_blk;
    wire [2:0] proc_3_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_3;
    reg [2:0] proc_dep_vld_vec_3_reg;
    wire [2:0] in_chan_dep_vld_vec_3;
    wire [164:0] in_chan_dep_data_vec_3;
    wire [2:0] token_in_vec_3;
    wire [2:0] out_chan_dep_vld_vec_3;
    wire [54:0] out_chan_dep_data_3;
    wire [2:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_1_3;
    wire [54:0] dep_chan_data_1_3;
    wire token_1_3;
    wire dep_chan_vld_4_3;
    wire [54:0] dep_chan_data_4_3;
    wire token_4_3;
    wire dep_chan_vld_6_3;
    wire [54:0] dep_chan_data_6_3;
    wire token_6_3;
    wire [2:0] proc_4_data_FIFO_blk;
    wire [2:0] proc_4_data_PIPO_blk;
    wire [2:0] proc_4_start_FIFO_blk;
    wire [2:0] proc_4_TLF_FIFO_blk;
    wire [2:0] proc_4_input_sync_blk;
    wire [2:0] proc_4_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_4;
    reg [2:0] proc_dep_vld_vec_4_reg;
    wire [2:0] in_chan_dep_vld_vec_4;
    wire [164:0] in_chan_dep_data_vec_4;
    wire [2:0] token_in_vec_4;
    wire [2:0] out_chan_dep_vld_vec_4;
    wire [54:0] out_chan_dep_data_4;
    wire [2:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_0_4;
    wire [54:0] dep_chan_data_0_4;
    wire token_0_4;
    wire dep_chan_vld_3_4;
    wire [54:0] dep_chan_data_3_4;
    wire token_3_4;
    wire dep_chan_vld_5_4;
    wire [54:0] dep_chan_data_5_4;
    wire token_5_4;
    wire [1:0] proc_5_data_FIFO_blk;
    wire [1:0] proc_5_data_PIPO_blk;
    wire [1:0] proc_5_start_FIFO_blk;
    wire [1:0] proc_5_TLF_FIFO_blk;
    wire [1:0] proc_5_input_sync_blk;
    wire [1:0] proc_5_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_5;
    reg [1:0] proc_dep_vld_vec_5_reg;
    wire [1:0] in_chan_dep_vld_vec_5;
    wire [109:0] in_chan_dep_data_vec_5;
    wire [1:0] token_in_vec_5;
    wire [1:0] out_chan_dep_vld_vec_5;
    wire [54:0] out_chan_dep_data_5;
    wire [1:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_4_5;
    wire [54:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_6_5;
    wire [54:0] dep_chan_data_6_5;
    wire token_6_5;
    wire [5:0] proc_6_data_FIFO_blk;
    wire [5:0] proc_6_data_PIPO_blk;
    wire [5:0] proc_6_start_FIFO_blk;
    wire [5:0] proc_6_TLF_FIFO_blk;
    wire [5:0] proc_6_input_sync_blk;
    wire [5:0] proc_6_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_6;
    reg [5:0] proc_dep_vld_vec_6_reg;
    wire [5:0] in_chan_dep_vld_vec_6;
    wire [329:0] in_chan_dep_data_vec_6;
    wire [5:0] token_in_vec_6;
    wire [5:0] out_chan_dep_vld_vec_6;
    wire [54:0] out_chan_dep_data_6;
    wire [5:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_1_6;
    wire [54:0] dep_chan_data_1_6;
    wire token_1_6;
    wire dep_chan_vld_3_6;
    wire [54:0] dep_chan_data_3_6;
    wire token_3_6;
    wire dep_chan_vld_5_6;
    wire [54:0] dep_chan_data_5_6;
    wire token_5_6;
    wire dep_chan_vld_7_6;
    wire [54:0] dep_chan_data_7_6;
    wire token_7_6;
    wire dep_chan_vld_9_6;
    wire [54:0] dep_chan_data_9_6;
    wire token_9_6;
    wire dep_chan_vld_10_6;
    wire [54:0] dep_chan_data_10_6;
    wire token_10_6;
    wire [1:0] proc_7_data_FIFO_blk;
    wire [1:0] proc_7_data_PIPO_blk;
    wire [1:0] proc_7_start_FIFO_blk;
    wire [1:0] proc_7_TLF_FIFO_blk;
    wire [1:0] proc_7_input_sync_blk;
    wire [1:0] proc_7_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_7;
    reg [1:0] proc_dep_vld_vec_7_reg;
    wire [1:0] in_chan_dep_vld_vec_7;
    wire [109:0] in_chan_dep_data_vec_7;
    wire [1:0] token_in_vec_7;
    wire [1:0] out_chan_dep_vld_vec_7;
    wire [54:0] out_chan_dep_data_7;
    wire [1:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_6_7;
    wire [54:0] dep_chan_data_6_7;
    wire token_6_7;
    wire dep_chan_vld_8_7;
    wire [54:0] dep_chan_data_8_7;
    wire token_8_7;
    wire [2:0] proc_8_data_FIFO_blk;
    wire [2:0] proc_8_data_PIPO_blk;
    wire [2:0] proc_8_start_FIFO_blk;
    wire [2:0] proc_8_TLF_FIFO_blk;
    wire [2:0] proc_8_input_sync_blk;
    wire [2:0] proc_8_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_8;
    reg [2:0] proc_dep_vld_vec_8_reg;
    wire [2:0] in_chan_dep_vld_vec_8;
    wire [164:0] in_chan_dep_data_vec_8;
    wire [2:0] token_in_vec_8;
    wire [2:0] out_chan_dep_vld_vec_8;
    wire [54:0] out_chan_dep_data_8;
    wire [2:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_7_8;
    wire [54:0] dep_chan_data_7_8;
    wire token_7_8;
    wire dep_chan_vld_9_8;
    wire [54:0] dep_chan_data_9_8;
    wire token_9_8;
    wire dep_chan_vld_12_8;
    wire [54:0] dep_chan_data_12_8;
    wire token_12_8;
    wire [5:0] proc_9_data_FIFO_blk;
    wire [5:0] proc_9_data_PIPO_blk;
    wire [5:0] proc_9_start_FIFO_blk;
    wire [5:0] proc_9_TLF_FIFO_blk;
    wire [5:0] proc_9_input_sync_blk;
    wire [5:0] proc_9_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_9;
    reg [5:0] proc_dep_vld_vec_9_reg;
    wire [5:0] in_chan_dep_vld_vec_9;
    wire [329:0] in_chan_dep_data_vec_9;
    wire [5:0] token_in_vec_9;
    wire [5:0] out_chan_dep_vld_vec_9;
    wire [54:0] out_chan_dep_data_9;
    wire [5:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_1_9;
    wire [54:0] dep_chan_data_1_9;
    wire token_1_9;
    wire dep_chan_vld_6_9;
    wire [54:0] dep_chan_data_6_9;
    wire token_6_9;
    wire dep_chan_vld_8_9;
    wire [54:0] dep_chan_data_8_9;
    wire token_8_9;
    wire dep_chan_vld_15_9;
    wire [54:0] dep_chan_data_15_9;
    wire token_15_9;
    wire dep_chan_vld_17_9;
    wire [54:0] dep_chan_data_17_9;
    wire token_17_9;
    wire dep_chan_vld_18_9;
    wire [54:0] dep_chan_data_18_9;
    wire token_18_9;
    wire [4:0] proc_10_data_FIFO_blk;
    wire [4:0] proc_10_data_PIPO_blk;
    wire [4:0] proc_10_start_FIFO_blk;
    wire [4:0] proc_10_TLF_FIFO_blk;
    wire [4:0] proc_10_input_sync_blk;
    wire [4:0] proc_10_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_10;
    reg [4:0] proc_dep_vld_vec_10_reg;
    wire [4:0] in_chan_dep_vld_vec_10;
    wire [274:0] in_chan_dep_data_vec_10;
    wire [4:0] token_in_vec_10;
    wire [4:0] out_chan_dep_vld_vec_10;
    wire [54:0] out_chan_dep_data_10;
    wire [4:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_6_10;
    wire [54:0] dep_chan_data_6_10;
    wire token_6_10;
    wire dep_chan_vld_11_10;
    wire [54:0] dep_chan_data_11_10;
    wire token_11_10;
    wire dep_chan_vld_12_10;
    wire [54:0] dep_chan_data_12_10;
    wire token_12_10;
    wire dep_chan_vld_17_10;
    wire [54:0] dep_chan_data_17_10;
    wire token_17_10;
    wire dep_chan_vld_18_10;
    wire [54:0] dep_chan_data_18_10;
    wire token_18_10;
    wire [1:0] proc_11_data_FIFO_blk;
    wire [1:0] proc_11_data_PIPO_blk;
    wire [1:0] proc_11_start_FIFO_blk;
    wire [1:0] proc_11_TLF_FIFO_blk;
    wire [1:0] proc_11_input_sync_blk;
    wire [1:0] proc_11_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_11;
    reg [1:0] proc_dep_vld_vec_11_reg;
    wire [1:0] in_chan_dep_vld_vec_11;
    wire [109:0] in_chan_dep_data_vec_11;
    wire [1:0] token_in_vec_11;
    wire [1:0] out_chan_dep_vld_vec_11;
    wire [54:0] out_chan_dep_data_11;
    wire [1:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_10_11;
    wire [54:0] dep_chan_data_10_11;
    wire token_10_11;
    wire dep_chan_vld_13_11;
    wire [54:0] dep_chan_data_13_11;
    wire token_13_11;
    wire [4:0] proc_12_data_FIFO_blk;
    wire [4:0] proc_12_data_PIPO_blk;
    wire [4:0] proc_12_start_FIFO_blk;
    wire [4:0] proc_12_TLF_FIFO_blk;
    wire [4:0] proc_12_input_sync_blk;
    wire [4:0] proc_12_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_12;
    reg [4:0] proc_dep_vld_vec_12_reg;
    wire [4:0] in_chan_dep_vld_vec_12;
    wire [274:0] in_chan_dep_data_vec_12;
    wire [4:0] token_in_vec_12;
    wire [4:0] out_chan_dep_vld_vec_12;
    wire [54:0] out_chan_dep_data_12;
    wire [4:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_8_12;
    wire [54:0] dep_chan_data_8_12;
    wire token_8_12;
    wire dep_chan_vld_10_12;
    wire [54:0] dep_chan_data_10_12;
    wire token_10_12;
    wire dep_chan_vld_13_12;
    wire [54:0] dep_chan_data_13_12;
    wire token_13_12;
    wire dep_chan_vld_14_12;
    wire [54:0] dep_chan_data_14_12;
    wire token_14_12;
    wire dep_chan_vld_15_12;
    wire [54:0] dep_chan_data_15_12;
    wire token_15_12;
    wire [3:0] proc_13_data_FIFO_blk;
    wire [3:0] proc_13_data_PIPO_blk;
    wire [3:0] proc_13_start_FIFO_blk;
    wire [3:0] proc_13_TLF_FIFO_blk;
    wire [3:0] proc_13_input_sync_blk;
    wire [3:0] proc_13_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_13;
    reg [3:0] proc_dep_vld_vec_13_reg;
    wire [3:0] in_chan_dep_vld_vec_13;
    wire [219:0] in_chan_dep_data_vec_13;
    wire [3:0] token_in_vec_13;
    wire [3:0] out_chan_dep_vld_vec_13;
    wire [54:0] out_chan_dep_data_13;
    wire [3:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_1_13;
    wire [54:0] dep_chan_data_1_13;
    wire token_1_13;
    wire dep_chan_vld_11_13;
    wire [54:0] dep_chan_data_11_13;
    wire token_11_13;
    wire dep_chan_vld_12_13;
    wire [54:0] dep_chan_data_12_13;
    wire token_12_13;
    wire dep_chan_vld_14_13;
    wire [54:0] dep_chan_data_14_13;
    wire token_14_13;
    wire [2:0] proc_14_data_FIFO_blk;
    wire [2:0] proc_14_data_PIPO_blk;
    wire [2:0] proc_14_start_FIFO_blk;
    wire [2:0] proc_14_TLF_FIFO_blk;
    wire [2:0] proc_14_input_sync_blk;
    wire [2:0] proc_14_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_14;
    reg [2:0] proc_dep_vld_vec_14_reg;
    wire [2:0] in_chan_dep_vld_vec_14;
    wire [164:0] in_chan_dep_data_vec_14;
    wire [2:0] token_in_vec_14;
    wire [2:0] out_chan_dep_vld_vec_14;
    wire [54:0] out_chan_dep_data_14;
    wire [2:0] token_out_vec_14;
    wire dl_detect_out_14;
    wire dep_chan_vld_12_14;
    wire [54:0] dep_chan_data_12_14;
    wire token_12_14;
    wire dep_chan_vld_13_14;
    wire [54:0] dep_chan_data_13_14;
    wire token_13_14;
    wire dep_chan_vld_15_14;
    wire [54:0] dep_chan_data_15_14;
    wire token_15_14;
    wire [3:0] proc_15_data_FIFO_blk;
    wire [3:0] proc_15_data_PIPO_blk;
    wire [3:0] proc_15_start_FIFO_blk;
    wire [3:0] proc_15_TLF_FIFO_blk;
    wire [3:0] proc_15_input_sync_blk;
    wire [3:0] proc_15_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_15;
    reg [3:0] proc_dep_vld_vec_15_reg;
    wire [3:0] in_chan_dep_vld_vec_15;
    wire [219:0] in_chan_dep_data_vec_15;
    wire [3:0] token_in_vec_15;
    wire [3:0] out_chan_dep_vld_vec_15;
    wire [54:0] out_chan_dep_data_15;
    wire [3:0] token_out_vec_15;
    wire dl_detect_out_15;
    wire dep_chan_vld_9_15;
    wire [54:0] dep_chan_data_9_15;
    wire token_9_15;
    wire dep_chan_vld_12_15;
    wire [54:0] dep_chan_data_12_15;
    wire token_12_15;
    wire dep_chan_vld_14_15;
    wire [54:0] dep_chan_data_14_15;
    wire token_14_15;
    wire dep_chan_vld_16_15;
    wire [54:0] dep_chan_data_16_15;
    wire token_16_15;
    wire [2:0] proc_16_data_FIFO_blk;
    wire [2:0] proc_16_data_PIPO_blk;
    wire [2:0] proc_16_start_FIFO_blk;
    wire [2:0] proc_16_TLF_FIFO_blk;
    wire [2:0] proc_16_input_sync_blk;
    wire [2:0] proc_16_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_16;
    reg [2:0] proc_dep_vld_vec_16_reg;
    wire [2:0] in_chan_dep_vld_vec_16;
    wire [164:0] in_chan_dep_data_vec_16;
    wire [2:0] token_in_vec_16;
    wire [2:0] out_chan_dep_vld_vec_16;
    wire [54:0] out_chan_dep_data_16;
    wire [2:0] token_out_vec_16;
    wire dl_detect_out_16;
    wire dep_chan_vld_15_16;
    wire [54:0] dep_chan_data_15_16;
    wire token_15_16;
    wire dep_chan_vld_17_16;
    wire [54:0] dep_chan_data_17_16;
    wire token_17_16;
    wire dep_chan_vld_20_16;
    wire [54:0] dep_chan_data_20_16;
    wire token_20_16;
    wire [6:0] proc_17_data_FIFO_blk;
    wire [6:0] proc_17_data_PIPO_blk;
    wire [6:0] proc_17_start_FIFO_blk;
    wire [6:0] proc_17_TLF_FIFO_blk;
    wire [6:0] proc_17_input_sync_blk;
    wire [6:0] proc_17_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_17;
    reg [6:0] proc_dep_vld_vec_17_reg;
    wire [6:0] in_chan_dep_vld_vec_17;
    wire [384:0] in_chan_dep_data_vec_17;
    wire [6:0] token_in_vec_17;
    wire [6:0] out_chan_dep_vld_vec_17;
    wire [54:0] out_chan_dep_data_17;
    wire [6:0] token_out_vec_17;
    wire dl_detect_out_17;
    wire dep_chan_vld_1_17;
    wire [54:0] dep_chan_data_1_17;
    wire token_1_17;
    wire dep_chan_vld_9_17;
    wire [54:0] dep_chan_data_9_17;
    wire token_9_17;
    wire dep_chan_vld_10_17;
    wire [54:0] dep_chan_data_10_17;
    wire token_10_17;
    wire dep_chan_vld_16_17;
    wire [54:0] dep_chan_data_16_17;
    wire token_16_17;
    wire dep_chan_vld_23_17;
    wire [54:0] dep_chan_data_23_17;
    wire token_23_17;
    wire dep_chan_vld_25_17;
    wire [54:0] dep_chan_data_25_17;
    wire token_25_17;
    wire dep_chan_vld_26_17;
    wire [54:0] dep_chan_data_26_17;
    wire token_26_17;
    wire [5:0] proc_18_data_FIFO_blk;
    wire [5:0] proc_18_data_PIPO_blk;
    wire [5:0] proc_18_start_FIFO_blk;
    wire [5:0] proc_18_TLF_FIFO_blk;
    wire [5:0] proc_18_input_sync_blk;
    wire [5:0] proc_18_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_18;
    reg [5:0] proc_dep_vld_vec_18_reg;
    wire [5:0] in_chan_dep_vld_vec_18;
    wire [329:0] in_chan_dep_data_vec_18;
    wire [5:0] token_in_vec_18;
    wire [5:0] out_chan_dep_vld_vec_18;
    wire [54:0] out_chan_dep_data_18;
    wire [5:0] token_out_vec_18;
    wire dl_detect_out_18;
    wire dep_chan_vld_9_18;
    wire [54:0] dep_chan_data_9_18;
    wire token_9_18;
    wire dep_chan_vld_10_18;
    wire [54:0] dep_chan_data_10_18;
    wire token_10_18;
    wire dep_chan_vld_19_18;
    wire [54:0] dep_chan_data_19_18;
    wire token_19_18;
    wire dep_chan_vld_20_18;
    wire [54:0] dep_chan_data_20_18;
    wire token_20_18;
    wire dep_chan_vld_25_18;
    wire [54:0] dep_chan_data_25_18;
    wire token_25_18;
    wire dep_chan_vld_26_18;
    wire [54:0] dep_chan_data_26_18;
    wire token_26_18;
    wire [1:0] proc_19_data_FIFO_blk;
    wire [1:0] proc_19_data_PIPO_blk;
    wire [1:0] proc_19_start_FIFO_blk;
    wire [1:0] proc_19_TLF_FIFO_blk;
    wire [1:0] proc_19_input_sync_blk;
    wire [1:0] proc_19_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_19;
    reg [1:0] proc_dep_vld_vec_19_reg;
    wire [1:0] in_chan_dep_vld_vec_19;
    wire [109:0] in_chan_dep_data_vec_19;
    wire [1:0] token_in_vec_19;
    wire [1:0] out_chan_dep_vld_vec_19;
    wire [54:0] out_chan_dep_data_19;
    wire [1:0] token_out_vec_19;
    wire dl_detect_out_19;
    wire dep_chan_vld_18_19;
    wire [54:0] dep_chan_data_18_19;
    wire token_18_19;
    wire dep_chan_vld_21_19;
    wire [54:0] dep_chan_data_21_19;
    wire token_21_19;
    wire [4:0] proc_20_data_FIFO_blk;
    wire [4:0] proc_20_data_PIPO_blk;
    wire [4:0] proc_20_start_FIFO_blk;
    wire [4:0] proc_20_TLF_FIFO_blk;
    wire [4:0] proc_20_input_sync_blk;
    wire [4:0] proc_20_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_20;
    reg [4:0] proc_dep_vld_vec_20_reg;
    wire [4:0] in_chan_dep_vld_vec_20;
    wire [274:0] in_chan_dep_data_vec_20;
    wire [4:0] token_in_vec_20;
    wire [4:0] out_chan_dep_vld_vec_20;
    wire [54:0] out_chan_dep_data_20;
    wire [4:0] token_out_vec_20;
    wire dl_detect_out_20;
    wire dep_chan_vld_16_20;
    wire [54:0] dep_chan_data_16_20;
    wire token_16_20;
    wire dep_chan_vld_18_20;
    wire [54:0] dep_chan_data_18_20;
    wire token_18_20;
    wire dep_chan_vld_21_20;
    wire [54:0] dep_chan_data_21_20;
    wire token_21_20;
    wire dep_chan_vld_22_20;
    wire [54:0] dep_chan_data_22_20;
    wire token_22_20;
    wire dep_chan_vld_23_20;
    wire [54:0] dep_chan_data_23_20;
    wire token_23_20;
    wire [3:0] proc_21_data_FIFO_blk;
    wire [3:0] proc_21_data_PIPO_blk;
    wire [3:0] proc_21_start_FIFO_blk;
    wire [3:0] proc_21_TLF_FIFO_blk;
    wire [3:0] proc_21_input_sync_blk;
    wire [3:0] proc_21_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_21;
    reg [3:0] proc_dep_vld_vec_21_reg;
    wire [3:0] in_chan_dep_vld_vec_21;
    wire [219:0] in_chan_dep_data_vec_21;
    wire [3:0] token_in_vec_21;
    wire [3:0] out_chan_dep_vld_vec_21;
    wire [54:0] out_chan_dep_data_21;
    wire [3:0] token_out_vec_21;
    wire dl_detect_out_21;
    wire dep_chan_vld_1_21;
    wire [54:0] dep_chan_data_1_21;
    wire token_1_21;
    wire dep_chan_vld_19_21;
    wire [54:0] dep_chan_data_19_21;
    wire token_19_21;
    wire dep_chan_vld_20_21;
    wire [54:0] dep_chan_data_20_21;
    wire token_20_21;
    wire dep_chan_vld_22_21;
    wire [54:0] dep_chan_data_22_21;
    wire token_22_21;
    wire [2:0] proc_22_data_FIFO_blk;
    wire [2:0] proc_22_data_PIPO_blk;
    wire [2:0] proc_22_start_FIFO_blk;
    wire [2:0] proc_22_TLF_FIFO_blk;
    wire [2:0] proc_22_input_sync_blk;
    wire [2:0] proc_22_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_22;
    reg [2:0] proc_dep_vld_vec_22_reg;
    wire [2:0] in_chan_dep_vld_vec_22;
    wire [164:0] in_chan_dep_data_vec_22;
    wire [2:0] token_in_vec_22;
    wire [2:0] out_chan_dep_vld_vec_22;
    wire [54:0] out_chan_dep_data_22;
    wire [2:0] token_out_vec_22;
    wire dl_detect_out_22;
    wire dep_chan_vld_20_22;
    wire [54:0] dep_chan_data_20_22;
    wire token_20_22;
    wire dep_chan_vld_21_22;
    wire [54:0] dep_chan_data_21_22;
    wire token_21_22;
    wire dep_chan_vld_23_22;
    wire [54:0] dep_chan_data_23_22;
    wire token_23_22;
    wire [3:0] proc_23_data_FIFO_blk;
    wire [3:0] proc_23_data_PIPO_blk;
    wire [3:0] proc_23_start_FIFO_blk;
    wire [3:0] proc_23_TLF_FIFO_blk;
    wire [3:0] proc_23_input_sync_blk;
    wire [3:0] proc_23_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_23;
    reg [3:0] proc_dep_vld_vec_23_reg;
    wire [3:0] in_chan_dep_vld_vec_23;
    wire [219:0] in_chan_dep_data_vec_23;
    wire [3:0] token_in_vec_23;
    wire [3:0] out_chan_dep_vld_vec_23;
    wire [54:0] out_chan_dep_data_23;
    wire [3:0] token_out_vec_23;
    wire dl_detect_out_23;
    wire dep_chan_vld_17_23;
    wire [54:0] dep_chan_data_17_23;
    wire token_17_23;
    wire dep_chan_vld_20_23;
    wire [54:0] dep_chan_data_20_23;
    wire token_20_23;
    wire dep_chan_vld_22_23;
    wire [54:0] dep_chan_data_22_23;
    wire token_22_23;
    wire dep_chan_vld_24_23;
    wire [54:0] dep_chan_data_24_23;
    wire token_24_23;
    wire [2:0] proc_24_data_FIFO_blk;
    wire [2:0] proc_24_data_PIPO_blk;
    wire [2:0] proc_24_start_FIFO_blk;
    wire [2:0] proc_24_TLF_FIFO_blk;
    wire [2:0] proc_24_input_sync_blk;
    wire [2:0] proc_24_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_24;
    reg [2:0] proc_dep_vld_vec_24_reg;
    wire [2:0] in_chan_dep_vld_vec_24;
    wire [164:0] in_chan_dep_data_vec_24;
    wire [2:0] token_in_vec_24;
    wire [2:0] out_chan_dep_vld_vec_24;
    wire [54:0] out_chan_dep_data_24;
    wire [2:0] token_out_vec_24;
    wire dl_detect_out_24;
    wire dep_chan_vld_23_24;
    wire [54:0] dep_chan_data_23_24;
    wire token_23_24;
    wire dep_chan_vld_25_24;
    wire [54:0] dep_chan_data_25_24;
    wire token_25_24;
    wire dep_chan_vld_28_24;
    wire [54:0] dep_chan_data_28_24;
    wire token_28_24;
    wire [6:0] proc_25_data_FIFO_blk;
    wire [6:0] proc_25_data_PIPO_blk;
    wire [6:0] proc_25_start_FIFO_blk;
    wire [6:0] proc_25_TLF_FIFO_blk;
    wire [6:0] proc_25_input_sync_blk;
    wire [6:0] proc_25_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_25;
    reg [6:0] proc_dep_vld_vec_25_reg;
    wire [6:0] in_chan_dep_vld_vec_25;
    wire [384:0] in_chan_dep_data_vec_25;
    wire [6:0] token_in_vec_25;
    wire [6:0] out_chan_dep_vld_vec_25;
    wire [54:0] out_chan_dep_data_25;
    wire [6:0] token_out_vec_25;
    wire dl_detect_out_25;
    wire dep_chan_vld_1_25;
    wire [54:0] dep_chan_data_1_25;
    wire token_1_25;
    wire dep_chan_vld_17_25;
    wire [54:0] dep_chan_data_17_25;
    wire token_17_25;
    wire dep_chan_vld_18_25;
    wire [54:0] dep_chan_data_18_25;
    wire token_18_25;
    wire dep_chan_vld_24_25;
    wire [54:0] dep_chan_data_24_25;
    wire token_24_25;
    wire dep_chan_vld_31_25;
    wire [54:0] dep_chan_data_31_25;
    wire token_31_25;
    wire dep_chan_vld_33_25;
    wire [54:0] dep_chan_data_33_25;
    wire token_33_25;
    wire dep_chan_vld_34_25;
    wire [54:0] dep_chan_data_34_25;
    wire token_34_25;
    wire [5:0] proc_26_data_FIFO_blk;
    wire [5:0] proc_26_data_PIPO_blk;
    wire [5:0] proc_26_start_FIFO_blk;
    wire [5:0] proc_26_TLF_FIFO_blk;
    wire [5:0] proc_26_input_sync_blk;
    wire [5:0] proc_26_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_26;
    reg [5:0] proc_dep_vld_vec_26_reg;
    wire [5:0] in_chan_dep_vld_vec_26;
    wire [329:0] in_chan_dep_data_vec_26;
    wire [5:0] token_in_vec_26;
    wire [5:0] out_chan_dep_vld_vec_26;
    wire [54:0] out_chan_dep_data_26;
    wire [5:0] token_out_vec_26;
    wire dl_detect_out_26;
    wire dep_chan_vld_17_26;
    wire [54:0] dep_chan_data_17_26;
    wire token_17_26;
    wire dep_chan_vld_18_26;
    wire [54:0] dep_chan_data_18_26;
    wire token_18_26;
    wire dep_chan_vld_27_26;
    wire [54:0] dep_chan_data_27_26;
    wire token_27_26;
    wire dep_chan_vld_28_26;
    wire [54:0] dep_chan_data_28_26;
    wire token_28_26;
    wire dep_chan_vld_33_26;
    wire [54:0] dep_chan_data_33_26;
    wire token_33_26;
    wire dep_chan_vld_34_26;
    wire [54:0] dep_chan_data_34_26;
    wire token_34_26;
    wire [1:0] proc_27_data_FIFO_blk;
    wire [1:0] proc_27_data_PIPO_blk;
    wire [1:0] proc_27_start_FIFO_blk;
    wire [1:0] proc_27_TLF_FIFO_blk;
    wire [1:0] proc_27_input_sync_blk;
    wire [1:0] proc_27_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_27;
    reg [1:0] proc_dep_vld_vec_27_reg;
    wire [1:0] in_chan_dep_vld_vec_27;
    wire [109:0] in_chan_dep_data_vec_27;
    wire [1:0] token_in_vec_27;
    wire [1:0] out_chan_dep_vld_vec_27;
    wire [54:0] out_chan_dep_data_27;
    wire [1:0] token_out_vec_27;
    wire dl_detect_out_27;
    wire dep_chan_vld_26_27;
    wire [54:0] dep_chan_data_26_27;
    wire token_26_27;
    wire dep_chan_vld_29_27;
    wire [54:0] dep_chan_data_29_27;
    wire token_29_27;
    wire [4:0] proc_28_data_FIFO_blk;
    wire [4:0] proc_28_data_PIPO_blk;
    wire [4:0] proc_28_start_FIFO_blk;
    wire [4:0] proc_28_TLF_FIFO_blk;
    wire [4:0] proc_28_input_sync_blk;
    wire [4:0] proc_28_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_28;
    reg [4:0] proc_dep_vld_vec_28_reg;
    wire [4:0] in_chan_dep_vld_vec_28;
    wire [274:0] in_chan_dep_data_vec_28;
    wire [4:0] token_in_vec_28;
    wire [4:0] out_chan_dep_vld_vec_28;
    wire [54:0] out_chan_dep_data_28;
    wire [4:0] token_out_vec_28;
    wire dl_detect_out_28;
    wire dep_chan_vld_24_28;
    wire [54:0] dep_chan_data_24_28;
    wire token_24_28;
    wire dep_chan_vld_26_28;
    wire [54:0] dep_chan_data_26_28;
    wire token_26_28;
    wire dep_chan_vld_29_28;
    wire [54:0] dep_chan_data_29_28;
    wire token_29_28;
    wire dep_chan_vld_30_28;
    wire [54:0] dep_chan_data_30_28;
    wire token_30_28;
    wire dep_chan_vld_31_28;
    wire [54:0] dep_chan_data_31_28;
    wire token_31_28;
    wire [3:0] proc_29_data_FIFO_blk;
    wire [3:0] proc_29_data_PIPO_blk;
    wire [3:0] proc_29_start_FIFO_blk;
    wire [3:0] proc_29_TLF_FIFO_blk;
    wire [3:0] proc_29_input_sync_blk;
    wire [3:0] proc_29_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_29;
    reg [3:0] proc_dep_vld_vec_29_reg;
    wire [3:0] in_chan_dep_vld_vec_29;
    wire [219:0] in_chan_dep_data_vec_29;
    wire [3:0] token_in_vec_29;
    wire [3:0] out_chan_dep_vld_vec_29;
    wire [54:0] out_chan_dep_data_29;
    wire [3:0] token_out_vec_29;
    wire dl_detect_out_29;
    wire dep_chan_vld_1_29;
    wire [54:0] dep_chan_data_1_29;
    wire token_1_29;
    wire dep_chan_vld_27_29;
    wire [54:0] dep_chan_data_27_29;
    wire token_27_29;
    wire dep_chan_vld_28_29;
    wire [54:0] dep_chan_data_28_29;
    wire token_28_29;
    wire dep_chan_vld_30_29;
    wire [54:0] dep_chan_data_30_29;
    wire token_30_29;
    wire [2:0] proc_30_data_FIFO_blk;
    wire [2:0] proc_30_data_PIPO_blk;
    wire [2:0] proc_30_start_FIFO_blk;
    wire [2:0] proc_30_TLF_FIFO_blk;
    wire [2:0] proc_30_input_sync_blk;
    wire [2:0] proc_30_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_30;
    reg [2:0] proc_dep_vld_vec_30_reg;
    wire [2:0] in_chan_dep_vld_vec_30;
    wire [164:0] in_chan_dep_data_vec_30;
    wire [2:0] token_in_vec_30;
    wire [2:0] out_chan_dep_vld_vec_30;
    wire [54:0] out_chan_dep_data_30;
    wire [2:0] token_out_vec_30;
    wire dl_detect_out_30;
    wire dep_chan_vld_28_30;
    wire [54:0] dep_chan_data_28_30;
    wire token_28_30;
    wire dep_chan_vld_29_30;
    wire [54:0] dep_chan_data_29_30;
    wire token_29_30;
    wire dep_chan_vld_31_30;
    wire [54:0] dep_chan_data_31_30;
    wire token_31_30;
    wire [3:0] proc_31_data_FIFO_blk;
    wire [3:0] proc_31_data_PIPO_blk;
    wire [3:0] proc_31_start_FIFO_blk;
    wire [3:0] proc_31_TLF_FIFO_blk;
    wire [3:0] proc_31_input_sync_blk;
    wire [3:0] proc_31_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_31;
    reg [3:0] proc_dep_vld_vec_31_reg;
    wire [3:0] in_chan_dep_vld_vec_31;
    wire [219:0] in_chan_dep_data_vec_31;
    wire [3:0] token_in_vec_31;
    wire [3:0] out_chan_dep_vld_vec_31;
    wire [54:0] out_chan_dep_data_31;
    wire [3:0] token_out_vec_31;
    wire dl_detect_out_31;
    wire dep_chan_vld_25_31;
    wire [54:0] dep_chan_data_25_31;
    wire token_25_31;
    wire dep_chan_vld_28_31;
    wire [54:0] dep_chan_data_28_31;
    wire token_28_31;
    wire dep_chan_vld_30_31;
    wire [54:0] dep_chan_data_30_31;
    wire token_30_31;
    wire dep_chan_vld_32_31;
    wire [54:0] dep_chan_data_32_31;
    wire token_32_31;
    wire [2:0] proc_32_data_FIFO_blk;
    wire [2:0] proc_32_data_PIPO_blk;
    wire [2:0] proc_32_start_FIFO_blk;
    wire [2:0] proc_32_TLF_FIFO_blk;
    wire [2:0] proc_32_input_sync_blk;
    wire [2:0] proc_32_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_32;
    reg [2:0] proc_dep_vld_vec_32_reg;
    wire [2:0] in_chan_dep_vld_vec_32;
    wire [164:0] in_chan_dep_data_vec_32;
    wire [2:0] token_in_vec_32;
    wire [2:0] out_chan_dep_vld_vec_32;
    wire [54:0] out_chan_dep_data_32;
    wire [2:0] token_out_vec_32;
    wire dl_detect_out_32;
    wire dep_chan_vld_31_32;
    wire [54:0] dep_chan_data_31_32;
    wire token_31_32;
    wire dep_chan_vld_33_32;
    wire [54:0] dep_chan_data_33_32;
    wire token_33_32;
    wire dep_chan_vld_36_32;
    wire [54:0] dep_chan_data_36_32;
    wire token_36_32;
    wire [6:0] proc_33_data_FIFO_blk;
    wire [6:0] proc_33_data_PIPO_blk;
    wire [6:0] proc_33_start_FIFO_blk;
    wire [6:0] proc_33_TLF_FIFO_blk;
    wire [6:0] proc_33_input_sync_blk;
    wire [6:0] proc_33_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_33;
    reg [6:0] proc_dep_vld_vec_33_reg;
    wire [6:0] in_chan_dep_vld_vec_33;
    wire [384:0] in_chan_dep_data_vec_33;
    wire [6:0] token_in_vec_33;
    wire [6:0] out_chan_dep_vld_vec_33;
    wire [54:0] out_chan_dep_data_33;
    wire [6:0] token_out_vec_33;
    wire dl_detect_out_33;
    wire dep_chan_vld_1_33;
    wire [54:0] dep_chan_data_1_33;
    wire token_1_33;
    wire dep_chan_vld_25_33;
    wire [54:0] dep_chan_data_25_33;
    wire token_25_33;
    wire dep_chan_vld_26_33;
    wire [54:0] dep_chan_data_26_33;
    wire token_26_33;
    wire dep_chan_vld_32_33;
    wire [54:0] dep_chan_data_32_33;
    wire token_32_33;
    wire dep_chan_vld_39_33;
    wire [54:0] dep_chan_data_39_33;
    wire token_39_33;
    wire dep_chan_vld_41_33;
    wire [54:0] dep_chan_data_41_33;
    wire token_41_33;
    wire dep_chan_vld_42_33;
    wire [54:0] dep_chan_data_42_33;
    wire token_42_33;
    wire [5:0] proc_34_data_FIFO_blk;
    wire [5:0] proc_34_data_PIPO_blk;
    wire [5:0] proc_34_start_FIFO_blk;
    wire [5:0] proc_34_TLF_FIFO_blk;
    wire [5:0] proc_34_input_sync_blk;
    wire [5:0] proc_34_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_34;
    reg [5:0] proc_dep_vld_vec_34_reg;
    wire [5:0] in_chan_dep_vld_vec_34;
    wire [329:0] in_chan_dep_data_vec_34;
    wire [5:0] token_in_vec_34;
    wire [5:0] out_chan_dep_vld_vec_34;
    wire [54:0] out_chan_dep_data_34;
    wire [5:0] token_out_vec_34;
    wire dl_detect_out_34;
    wire dep_chan_vld_25_34;
    wire [54:0] dep_chan_data_25_34;
    wire token_25_34;
    wire dep_chan_vld_26_34;
    wire [54:0] dep_chan_data_26_34;
    wire token_26_34;
    wire dep_chan_vld_35_34;
    wire [54:0] dep_chan_data_35_34;
    wire token_35_34;
    wire dep_chan_vld_36_34;
    wire [54:0] dep_chan_data_36_34;
    wire token_36_34;
    wire dep_chan_vld_41_34;
    wire [54:0] dep_chan_data_41_34;
    wire token_41_34;
    wire dep_chan_vld_42_34;
    wire [54:0] dep_chan_data_42_34;
    wire token_42_34;
    wire [1:0] proc_35_data_FIFO_blk;
    wire [1:0] proc_35_data_PIPO_blk;
    wire [1:0] proc_35_start_FIFO_blk;
    wire [1:0] proc_35_TLF_FIFO_blk;
    wire [1:0] proc_35_input_sync_blk;
    wire [1:0] proc_35_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_35;
    reg [1:0] proc_dep_vld_vec_35_reg;
    wire [1:0] in_chan_dep_vld_vec_35;
    wire [109:0] in_chan_dep_data_vec_35;
    wire [1:0] token_in_vec_35;
    wire [1:0] out_chan_dep_vld_vec_35;
    wire [54:0] out_chan_dep_data_35;
    wire [1:0] token_out_vec_35;
    wire dl_detect_out_35;
    wire dep_chan_vld_34_35;
    wire [54:0] dep_chan_data_34_35;
    wire token_34_35;
    wire dep_chan_vld_37_35;
    wire [54:0] dep_chan_data_37_35;
    wire token_37_35;
    wire [4:0] proc_36_data_FIFO_blk;
    wire [4:0] proc_36_data_PIPO_blk;
    wire [4:0] proc_36_start_FIFO_blk;
    wire [4:0] proc_36_TLF_FIFO_blk;
    wire [4:0] proc_36_input_sync_blk;
    wire [4:0] proc_36_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_36;
    reg [4:0] proc_dep_vld_vec_36_reg;
    wire [4:0] in_chan_dep_vld_vec_36;
    wire [274:0] in_chan_dep_data_vec_36;
    wire [4:0] token_in_vec_36;
    wire [4:0] out_chan_dep_vld_vec_36;
    wire [54:0] out_chan_dep_data_36;
    wire [4:0] token_out_vec_36;
    wire dl_detect_out_36;
    wire dep_chan_vld_32_36;
    wire [54:0] dep_chan_data_32_36;
    wire token_32_36;
    wire dep_chan_vld_34_36;
    wire [54:0] dep_chan_data_34_36;
    wire token_34_36;
    wire dep_chan_vld_37_36;
    wire [54:0] dep_chan_data_37_36;
    wire token_37_36;
    wire dep_chan_vld_38_36;
    wire [54:0] dep_chan_data_38_36;
    wire token_38_36;
    wire dep_chan_vld_39_36;
    wire [54:0] dep_chan_data_39_36;
    wire token_39_36;
    wire [3:0] proc_37_data_FIFO_blk;
    wire [3:0] proc_37_data_PIPO_blk;
    wire [3:0] proc_37_start_FIFO_blk;
    wire [3:0] proc_37_TLF_FIFO_blk;
    wire [3:0] proc_37_input_sync_blk;
    wire [3:0] proc_37_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_37;
    reg [3:0] proc_dep_vld_vec_37_reg;
    wire [3:0] in_chan_dep_vld_vec_37;
    wire [219:0] in_chan_dep_data_vec_37;
    wire [3:0] token_in_vec_37;
    wire [3:0] out_chan_dep_vld_vec_37;
    wire [54:0] out_chan_dep_data_37;
    wire [3:0] token_out_vec_37;
    wire dl_detect_out_37;
    wire dep_chan_vld_1_37;
    wire [54:0] dep_chan_data_1_37;
    wire token_1_37;
    wire dep_chan_vld_35_37;
    wire [54:0] dep_chan_data_35_37;
    wire token_35_37;
    wire dep_chan_vld_36_37;
    wire [54:0] dep_chan_data_36_37;
    wire token_36_37;
    wire dep_chan_vld_38_37;
    wire [54:0] dep_chan_data_38_37;
    wire token_38_37;
    wire [2:0] proc_38_data_FIFO_blk;
    wire [2:0] proc_38_data_PIPO_blk;
    wire [2:0] proc_38_start_FIFO_blk;
    wire [2:0] proc_38_TLF_FIFO_blk;
    wire [2:0] proc_38_input_sync_blk;
    wire [2:0] proc_38_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_38;
    reg [2:0] proc_dep_vld_vec_38_reg;
    wire [2:0] in_chan_dep_vld_vec_38;
    wire [164:0] in_chan_dep_data_vec_38;
    wire [2:0] token_in_vec_38;
    wire [2:0] out_chan_dep_vld_vec_38;
    wire [54:0] out_chan_dep_data_38;
    wire [2:0] token_out_vec_38;
    wire dl_detect_out_38;
    wire dep_chan_vld_36_38;
    wire [54:0] dep_chan_data_36_38;
    wire token_36_38;
    wire dep_chan_vld_37_38;
    wire [54:0] dep_chan_data_37_38;
    wire token_37_38;
    wire dep_chan_vld_39_38;
    wire [54:0] dep_chan_data_39_38;
    wire token_39_38;
    wire [3:0] proc_39_data_FIFO_blk;
    wire [3:0] proc_39_data_PIPO_blk;
    wire [3:0] proc_39_start_FIFO_blk;
    wire [3:0] proc_39_TLF_FIFO_blk;
    wire [3:0] proc_39_input_sync_blk;
    wire [3:0] proc_39_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_39;
    reg [3:0] proc_dep_vld_vec_39_reg;
    wire [3:0] in_chan_dep_vld_vec_39;
    wire [219:0] in_chan_dep_data_vec_39;
    wire [3:0] token_in_vec_39;
    wire [3:0] out_chan_dep_vld_vec_39;
    wire [54:0] out_chan_dep_data_39;
    wire [3:0] token_out_vec_39;
    wire dl_detect_out_39;
    wire dep_chan_vld_33_39;
    wire [54:0] dep_chan_data_33_39;
    wire token_33_39;
    wire dep_chan_vld_36_39;
    wire [54:0] dep_chan_data_36_39;
    wire token_36_39;
    wire dep_chan_vld_38_39;
    wire [54:0] dep_chan_data_38_39;
    wire token_38_39;
    wire dep_chan_vld_40_39;
    wire [54:0] dep_chan_data_40_39;
    wire token_40_39;
    wire [2:0] proc_40_data_FIFO_blk;
    wire [2:0] proc_40_data_PIPO_blk;
    wire [2:0] proc_40_start_FIFO_blk;
    wire [2:0] proc_40_TLF_FIFO_blk;
    wire [2:0] proc_40_input_sync_blk;
    wire [2:0] proc_40_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_40;
    reg [2:0] proc_dep_vld_vec_40_reg;
    wire [2:0] in_chan_dep_vld_vec_40;
    wire [164:0] in_chan_dep_data_vec_40;
    wire [2:0] token_in_vec_40;
    wire [2:0] out_chan_dep_vld_vec_40;
    wire [54:0] out_chan_dep_data_40;
    wire [2:0] token_out_vec_40;
    wire dl_detect_out_40;
    wire dep_chan_vld_39_40;
    wire [54:0] dep_chan_data_39_40;
    wire token_39_40;
    wire dep_chan_vld_41_40;
    wire [54:0] dep_chan_data_41_40;
    wire token_41_40;
    wire dep_chan_vld_44_40;
    wire [54:0] dep_chan_data_44_40;
    wire token_44_40;
    wire [6:0] proc_41_data_FIFO_blk;
    wire [6:0] proc_41_data_PIPO_blk;
    wire [6:0] proc_41_start_FIFO_blk;
    wire [6:0] proc_41_TLF_FIFO_blk;
    wire [6:0] proc_41_input_sync_blk;
    wire [6:0] proc_41_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_41;
    reg [6:0] proc_dep_vld_vec_41_reg;
    wire [6:0] in_chan_dep_vld_vec_41;
    wire [384:0] in_chan_dep_data_vec_41;
    wire [6:0] token_in_vec_41;
    wire [6:0] out_chan_dep_vld_vec_41;
    wire [54:0] out_chan_dep_data_41;
    wire [6:0] token_out_vec_41;
    wire dl_detect_out_41;
    wire dep_chan_vld_1_41;
    wire [54:0] dep_chan_data_1_41;
    wire token_1_41;
    wire dep_chan_vld_33_41;
    wire [54:0] dep_chan_data_33_41;
    wire token_33_41;
    wire dep_chan_vld_34_41;
    wire [54:0] dep_chan_data_34_41;
    wire token_34_41;
    wire dep_chan_vld_40_41;
    wire [54:0] dep_chan_data_40_41;
    wire token_40_41;
    wire dep_chan_vld_47_41;
    wire [54:0] dep_chan_data_47_41;
    wire token_47_41;
    wire dep_chan_vld_48_41;
    wire [54:0] dep_chan_data_48_41;
    wire token_48_41;
    wire dep_chan_vld_49_41;
    wire [54:0] dep_chan_data_49_41;
    wire token_49_41;
    wire [5:0] proc_42_data_FIFO_blk;
    wire [5:0] proc_42_data_PIPO_blk;
    wire [5:0] proc_42_start_FIFO_blk;
    wire [5:0] proc_42_TLF_FIFO_blk;
    wire [5:0] proc_42_input_sync_blk;
    wire [5:0] proc_42_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_42;
    reg [5:0] proc_dep_vld_vec_42_reg;
    wire [5:0] in_chan_dep_vld_vec_42;
    wire [329:0] in_chan_dep_data_vec_42;
    wire [5:0] token_in_vec_42;
    wire [5:0] out_chan_dep_vld_vec_42;
    wire [54:0] out_chan_dep_data_42;
    wire [5:0] token_out_vec_42;
    wire dl_detect_out_42;
    wire dep_chan_vld_33_42;
    wire [54:0] dep_chan_data_33_42;
    wire token_33_42;
    wire dep_chan_vld_34_42;
    wire [54:0] dep_chan_data_34_42;
    wire token_34_42;
    wire dep_chan_vld_43_42;
    wire [54:0] dep_chan_data_43_42;
    wire token_43_42;
    wire dep_chan_vld_44_42;
    wire [54:0] dep_chan_data_44_42;
    wire token_44_42;
    wire dep_chan_vld_48_42;
    wire [54:0] dep_chan_data_48_42;
    wire token_48_42;
    wire dep_chan_vld_49_42;
    wire [54:0] dep_chan_data_49_42;
    wire token_49_42;
    wire [1:0] proc_43_data_FIFO_blk;
    wire [1:0] proc_43_data_PIPO_blk;
    wire [1:0] proc_43_start_FIFO_blk;
    wire [1:0] proc_43_TLF_FIFO_blk;
    wire [1:0] proc_43_input_sync_blk;
    wire [1:0] proc_43_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_43;
    reg [1:0] proc_dep_vld_vec_43_reg;
    wire [1:0] in_chan_dep_vld_vec_43;
    wire [109:0] in_chan_dep_data_vec_43;
    wire [1:0] token_in_vec_43;
    wire [1:0] out_chan_dep_vld_vec_43;
    wire [54:0] out_chan_dep_data_43;
    wire [1:0] token_out_vec_43;
    wire dl_detect_out_43;
    wire dep_chan_vld_42_43;
    wire [54:0] dep_chan_data_42_43;
    wire token_42_43;
    wire dep_chan_vld_45_43;
    wire [54:0] dep_chan_data_45_43;
    wire token_45_43;
    wire [4:0] proc_44_data_FIFO_blk;
    wire [4:0] proc_44_data_PIPO_blk;
    wire [4:0] proc_44_start_FIFO_blk;
    wire [4:0] proc_44_TLF_FIFO_blk;
    wire [4:0] proc_44_input_sync_blk;
    wire [4:0] proc_44_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_44;
    reg [4:0] proc_dep_vld_vec_44_reg;
    wire [4:0] in_chan_dep_vld_vec_44;
    wire [274:0] in_chan_dep_data_vec_44;
    wire [4:0] token_in_vec_44;
    wire [4:0] out_chan_dep_vld_vec_44;
    wire [54:0] out_chan_dep_data_44;
    wire [4:0] token_out_vec_44;
    wire dl_detect_out_44;
    wire dep_chan_vld_40_44;
    wire [54:0] dep_chan_data_40_44;
    wire token_40_44;
    wire dep_chan_vld_42_44;
    wire [54:0] dep_chan_data_42_44;
    wire token_42_44;
    wire dep_chan_vld_45_44;
    wire [54:0] dep_chan_data_45_44;
    wire token_45_44;
    wire dep_chan_vld_46_44;
    wire [54:0] dep_chan_data_46_44;
    wire token_46_44;
    wire dep_chan_vld_47_44;
    wire [54:0] dep_chan_data_47_44;
    wire token_47_44;
    wire [3:0] proc_45_data_FIFO_blk;
    wire [3:0] proc_45_data_PIPO_blk;
    wire [3:0] proc_45_start_FIFO_blk;
    wire [3:0] proc_45_TLF_FIFO_blk;
    wire [3:0] proc_45_input_sync_blk;
    wire [3:0] proc_45_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_45;
    reg [3:0] proc_dep_vld_vec_45_reg;
    wire [3:0] in_chan_dep_vld_vec_45;
    wire [219:0] in_chan_dep_data_vec_45;
    wire [3:0] token_in_vec_45;
    wire [3:0] out_chan_dep_vld_vec_45;
    wire [54:0] out_chan_dep_data_45;
    wire [3:0] token_out_vec_45;
    wire dl_detect_out_45;
    wire dep_chan_vld_1_45;
    wire [54:0] dep_chan_data_1_45;
    wire token_1_45;
    wire dep_chan_vld_43_45;
    wire [54:0] dep_chan_data_43_45;
    wire token_43_45;
    wire dep_chan_vld_44_45;
    wire [54:0] dep_chan_data_44_45;
    wire token_44_45;
    wire dep_chan_vld_46_45;
    wire [54:0] dep_chan_data_46_45;
    wire token_46_45;
    wire [2:0] proc_46_data_FIFO_blk;
    wire [2:0] proc_46_data_PIPO_blk;
    wire [2:0] proc_46_start_FIFO_blk;
    wire [2:0] proc_46_TLF_FIFO_blk;
    wire [2:0] proc_46_input_sync_blk;
    wire [2:0] proc_46_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_46;
    reg [2:0] proc_dep_vld_vec_46_reg;
    wire [2:0] in_chan_dep_vld_vec_46;
    wire [164:0] in_chan_dep_data_vec_46;
    wire [2:0] token_in_vec_46;
    wire [2:0] out_chan_dep_vld_vec_46;
    wire [54:0] out_chan_dep_data_46;
    wire [2:0] token_out_vec_46;
    wire dl_detect_out_46;
    wire dep_chan_vld_44_46;
    wire [54:0] dep_chan_data_44_46;
    wire token_44_46;
    wire dep_chan_vld_45_46;
    wire [54:0] dep_chan_data_45_46;
    wire token_45_46;
    wire dep_chan_vld_47_46;
    wire [54:0] dep_chan_data_47_46;
    wire token_47_46;
    wire [4:0] proc_47_data_FIFO_blk;
    wire [4:0] proc_47_data_PIPO_blk;
    wire [4:0] proc_47_start_FIFO_blk;
    wire [4:0] proc_47_TLF_FIFO_blk;
    wire [4:0] proc_47_input_sync_blk;
    wire [4:0] proc_47_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_47;
    reg [4:0] proc_dep_vld_vec_47_reg;
    wire [4:0] in_chan_dep_vld_vec_47;
    wire [274:0] in_chan_dep_data_vec_47;
    wire [4:0] token_in_vec_47;
    wire [4:0] out_chan_dep_vld_vec_47;
    wire [54:0] out_chan_dep_data_47;
    wire [4:0] token_out_vec_47;
    wire dl_detect_out_47;
    wire dep_chan_vld_41_47;
    wire [54:0] dep_chan_data_41_47;
    wire token_41_47;
    wire dep_chan_vld_44_47;
    wire [54:0] dep_chan_data_44_47;
    wire token_44_47;
    wire dep_chan_vld_46_47;
    wire [54:0] dep_chan_data_46_47;
    wire token_46_47;
    wire dep_chan_vld_48_47;
    wire [54:0] dep_chan_data_48_47;
    wire token_48_47;
    wire dep_chan_vld_50_47;
    wire [54:0] dep_chan_data_50_47;
    wire token_50_47;
    wire [4:0] proc_48_data_FIFO_blk;
    wire [4:0] proc_48_data_PIPO_blk;
    wire [4:0] proc_48_start_FIFO_blk;
    wire [4:0] proc_48_TLF_FIFO_blk;
    wire [4:0] proc_48_input_sync_blk;
    wire [4:0] proc_48_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_48;
    reg [4:0] proc_dep_vld_vec_48_reg;
    wire [4:0] in_chan_dep_vld_vec_48;
    wire [274:0] in_chan_dep_data_vec_48;
    wire [4:0] token_in_vec_48;
    wire [4:0] out_chan_dep_vld_vec_48;
    wire [54:0] out_chan_dep_data_48;
    wire [4:0] token_out_vec_48;
    wire dl_detect_out_48;
    wire dep_chan_vld_1_48;
    wire [54:0] dep_chan_data_1_48;
    wire token_1_48;
    wire dep_chan_vld_41_48;
    wire [54:0] dep_chan_data_41_48;
    wire token_41_48;
    wire dep_chan_vld_42_48;
    wire [54:0] dep_chan_data_42_48;
    wire token_42_48;
    wire dep_chan_vld_47_48;
    wire [54:0] dep_chan_data_47_48;
    wire token_47_48;
    wire dep_chan_vld_53_48;
    wire [54:0] dep_chan_data_53_48;
    wire token_53_48;
    wire [3:0] proc_49_data_FIFO_blk;
    wire [3:0] proc_49_data_PIPO_blk;
    wire [3:0] proc_49_start_FIFO_blk;
    wire [3:0] proc_49_TLF_FIFO_blk;
    wire [3:0] proc_49_input_sync_blk;
    wire [3:0] proc_49_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_49;
    reg [3:0] proc_dep_vld_vec_49_reg;
    wire [3:0] in_chan_dep_vld_vec_49;
    wire [219:0] in_chan_dep_data_vec_49;
    wire [3:0] token_in_vec_49;
    wire [3:0] out_chan_dep_vld_vec_49;
    wire [54:0] out_chan_dep_data_49;
    wire [3:0] token_out_vec_49;
    wire dl_detect_out_49;
    wire dep_chan_vld_41_49;
    wire [54:0] dep_chan_data_41_49;
    wire token_41_49;
    wire dep_chan_vld_42_49;
    wire [54:0] dep_chan_data_42_49;
    wire token_42_49;
    wire dep_chan_vld_50_49;
    wire [54:0] dep_chan_data_50_49;
    wire token_50_49;
    wire dep_chan_vld_51_49;
    wire [54:0] dep_chan_data_51_49;
    wire token_51_49;
    wire [4:0] proc_50_data_FIFO_blk;
    wire [4:0] proc_50_data_PIPO_blk;
    wire [4:0] proc_50_start_FIFO_blk;
    wire [4:0] proc_50_TLF_FIFO_blk;
    wire [4:0] proc_50_input_sync_blk;
    wire [4:0] proc_50_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_50;
    reg [4:0] proc_dep_vld_vec_50_reg;
    wire [4:0] in_chan_dep_vld_vec_50;
    wire [274:0] in_chan_dep_data_vec_50;
    wire [4:0] token_in_vec_50;
    wire [4:0] out_chan_dep_vld_vec_50;
    wire [54:0] out_chan_dep_data_50;
    wire [4:0] token_out_vec_50;
    wire dl_detect_out_50;
    wire dep_chan_vld_47_50;
    wire [54:0] dep_chan_data_47_50;
    wire token_47_50;
    wire dep_chan_vld_49_50;
    wire [54:0] dep_chan_data_49_50;
    wire token_49_50;
    wire dep_chan_vld_51_50;
    wire [54:0] dep_chan_data_51_50;
    wire token_51_50;
    wire dep_chan_vld_52_50;
    wire [54:0] dep_chan_data_52_50;
    wire token_52_50;
    wire dep_chan_vld_53_50;
    wire [54:0] dep_chan_data_53_50;
    wire token_53_50;
    wire [3:0] proc_51_data_FIFO_blk;
    wire [3:0] proc_51_data_PIPO_blk;
    wire [3:0] proc_51_start_FIFO_blk;
    wire [3:0] proc_51_TLF_FIFO_blk;
    wire [3:0] proc_51_input_sync_blk;
    wire [3:0] proc_51_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_51;
    reg [3:0] proc_dep_vld_vec_51_reg;
    wire [3:0] in_chan_dep_vld_vec_51;
    wire [219:0] in_chan_dep_data_vec_51;
    wire [3:0] token_in_vec_51;
    wire [3:0] out_chan_dep_vld_vec_51;
    wire [54:0] out_chan_dep_data_51;
    wire [3:0] token_out_vec_51;
    wire dl_detect_out_51;
    wire dep_chan_vld_1_51;
    wire [54:0] dep_chan_data_1_51;
    wire token_1_51;
    wire dep_chan_vld_49_51;
    wire [54:0] dep_chan_data_49_51;
    wire token_49_51;
    wire dep_chan_vld_50_51;
    wire [54:0] dep_chan_data_50_51;
    wire token_50_51;
    wire dep_chan_vld_52_51;
    wire [54:0] dep_chan_data_52_51;
    wire token_52_51;
    wire [2:0] proc_52_data_FIFO_blk;
    wire [2:0] proc_52_data_PIPO_blk;
    wire [2:0] proc_52_start_FIFO_blk;
    wire [2:0] proc_52_TLF_FIFO_blk;
    wire [2:0] proc_52_input_sync_blk;
    wire [2:0] proc_52_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_52;
    reg [2:0] proc_dep_vld_vec_52_reg;
    wire [2:0] in_chan_dep_vld_vec_52;
    wire [164:0] in_chan_dep_data_vec_52;
    wire [2:0] token_in_vec_52;
    wire [2:0] out_chan_dep_vld_vec_52;
    wire [54:0] out_chan_dep_data_52;
    wire [2:0] token_out_vec_52;
    wire dl_detect_out_52;
    wire dep_chan_vld_50_52;
    wire [54:0] dep_chan_data_50_52;
    wire token_50_52;
    wire dep_chan_vld_51_52;
    wire [54:0] dep_chan_data_51_52;
    wire token_51_52;
    wire dep_chan_vld_53_52;
    wire [54:0] dep_chan_data_53_52;
    wire token_53_52;
    wire [3:0] proc_53_data_FIFO_blk;
    wire [3:0] proc_53_data_PIPO_blk;
    wire [3:0] proc_53_start_FIFO_blk;
    wire [3:0] proc_53_TLF_FIFO_blk;
    wire [3:0] proc_53_input_sync_blk;
    wire [3:0] proc_53_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_53;
    reg [3:0] proc_dep_vld_vec_53_reg;
    wire [3:0] in_chan_dep_vld_vec_53;
    wire [219:0] in_chan_dep_data_vec_53;
    wire [3:0] token_in_vec_53;
    wire [3:0] out_chan_dep_vld_vec_53;
    wire [54:0] out_chan_dep_data_53;
    wire [3:0] token_out_vec_53;
    wire dl_detect_out_53;
    wire dep_chan_vld_48_53;
    wire [54:0] dep_chan_data_48_53;
    wire token_48_53;
    wire dep_chan_vld_50_53;
    wire [54:0] dep_chan_data_50_53;
    wire token_50_53;
    wire dep_chan_vld_52_53;
    wire [54:0] dep_chan_data_52_53;
    wire token_52_53;
    wire dep_chan_vld_54_53;
    wire [54:0] dep_chan_data_54_53;
    wire token_54_53;
    wire [0:0] proc_54_data_FIFO_blk;
    wire [0:0] proc_54_data_PIPO_blk;
    wire [0:0] proc_54_start_FIFO_blk;
    wire [0:0] proc_54_TLF_FIFO_blk;
    wire [0:0] proc_54_input_sync_blk;
    wire [0:0] proc_54_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_54;
    reg [0:0] proc_dep_vld_vec_54_reg;
    wire [0:0] in_chan_dep_vld_vec_54;
    wire [54:0] in_chan_dep_data_vec_54;
    wire [0:0] token_in_vec_54;
    wire [0:0] out_chan_dep_vld_vec_54;
    wire [54:0] out_chan_dep_data_54;
    wire [0:0] token_out_vec_54;
    wire dl_detect_out_54;
    wire dep_chan_vld_53_54;
    wire [54:0] dep_chan_data_53_54;
    wire token_53_54;
    wire [54:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [54:0] origin;

    reg ap_done_reg_0;// for module compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_continue;
        end
    end

    reg ap_done_reg_5;// for module compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_5 <= 'b0;
        end
        else begin
            ap_done_reg_5 <= compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.ap_continue;
        end
    end

    reg ap_done_reg_6;// for module compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_6 <= 'b0;
        end
        else begin
            ap_done_reg_6 <= compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_continue;
        end
    end

    reg ap_done_reg_7;// for module compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_7 <= 'b0;
        end
        else begin
            ap_done_reg_7 <= compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.ap_continue;
        end
    end

    reg ap_done_reg_8;// for module compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_8 <= 'b0;
        end
        else begin
            ap_done_reg_8 <= compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_continue;
        end
    end

    reg ap_done_reg_9;// for module compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_9 <= 'b0;
        end
        else begin
            ap_done_reg_9 <= compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.ap_continue;
        end
    end

    reg ap_done_reg_10;// for module compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_10 <= 'b0;
        end
        else begin
            ap_done_reg_10 <= compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_11;// for module compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_11 <= 'b0;
        end
        else begin
            ap_done_reg_11 <= compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_continue;
        end
    end

    reg ap_done_reg_12;// for module compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_12 <= 'b0;
        end
        else begin
            ap_done_reg_12 <= compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_13;// for module compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_13 <= 'b0;
        end
        else begin
            ap_done_reg_13 <= compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_continue;
        end
    end

    reg ap_done_reg_14;// for module compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_14 <= 'b0;
        end
        else begin
            ap_done_reg_14 <= compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_15;// for module compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_15 <= 'b0;
        end
        else begin
            ap_done_reg_15 <= compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_continue;
        end
    end

    reg ap_done_reg_16;// for module compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_16 <= 'b0;
        end
        else begin
            ap_done_reg_16 <= compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_17;// for module compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_17 <= 'b0;
        end
        else begin
            ap_done_reg_17 <= compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_continue;
        end
    end

    reg ap_done_reg_18;// for module compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_18 <= 'b0;
        end
        else begin
            ap_done_reg_18 <= compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_19;// for module compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_19 <= 'b0;
        end
        else begin
            ap_done_reg_19 <= compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_continue;
        end
    end

    reg ap_done_reg_20;// for module compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_20 <= 'b0;
        end
        else begin
            ap_done_reg_20 <= compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_continue;
        end
    end

    reg ap_done_reg_21;// for module compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_21 <= 'b0;
        end
        else begin
            ap_done_reg_21 <= compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process entry_proc11_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (entry_proc11_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process entry_proc11_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (entry_proc11_U0.ap_done == 1'b1 && entry_proc11_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process compute_engine_U0.axis_512_to_hls_stream_8_5120_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process compute_engine_U0.axis_512_to_hls_stream_8_5120_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_done == 1'b1 && compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

reg [15:0] trans_in_cnt_2;// for process compute_engine_U0.entry_proc10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_2 <= 16'h0;
    end
    else if (compute_engine_U0.entry_proc10_U0.start_write == 1'b1) begin
        trans_in_cnt_2 <= trans_in_cnt_2 + 16'h1;
    end
    else begin
        trans_in_cnt_2 <= trans_in_cnt_2;
    end
end

reg [15:0] trans_out_cnt_2;// for process compute_engine_U0.entry_proc10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_2 <= 16'h0;
    end
    else if (compute_engine_U0.entry_proc10_U0.ap_done == 1'b1 && compute_engine_U0.entry_proc10_U0.ap_continue == 1'b1) begin
        trans_out_cnt_2 <= trans_out_cnt_2 + 16'h1;
    end
    else begin
        trans_out_cnt_2 <= trans_out_cnt_2;
    end
end

reg [15:0] trans_in_cnt_3;// for process compute_engine_U0.conv1_accelerator_specialized_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_3 <= 16'h0;
    end
    else if (compute_engine_U0.conv1_accelerator_specialized_U0.start_write == 1'b1) begin
        trans_in_cnt_3 <= trans_in_cnt_3 + 16'h1;
    end
    else begin
        trans_in_cnt_3 <= trans_in_cnt_3;
    end
end

reg [15:0] trans_out_cnt_3;// for process compute_engine_U0.conv1_accelerator_specialized_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_3 <= 16'h0;
    end
    else if (compute_engine_U0.conv1_accelerator_specialized_U0.ap_done == 1'b1 && compute_engine_U0.conv1_accelerator_specialized_U0.ap_continue == 1'b1) begin
        trans_out_cnt_3 <= trans_out_cnt_3 + 16'h1;
    end
    else begin
        trans_out_cnt_3 <= trans_out_cnt_3;
    end
end

reg [15:0] trans_in_cnt_4;// for process compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_4 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.start_write == 1'b1) begin
        trans_in_cnt_4 <= trans_in_cnt_4 + 16'h1;
    end
    else begin
        trans_in_cnt_4 <= trans_in_cnt_4;
    end
end

reg [15:0] trans_out_cnt_4;// for process compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_4 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_done == 1'b1 && compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_4 <= trans_out_cnt_4 + 16'h1;
    end
    else begin
        trans_out_cnt_4 <= trans_out_cnt_4;
    end
end

reg [15:0] trans_in_cnt_5;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_5 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.start_write == 1'b1) begin
        trans_in_cnt_5 <= trans_in_cnt_5 + 16'h1;
    end
    else begin
        trans_in_cnt_5 <= trans_in_cnt_5;
    end
end

reg [15:0] trans_out_cnt_5;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_5 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_continue == 1'b1) begin
        trans_out_cnt_5 <= trans_out_cnt_5 + 16'h1;
    end
    else begin
        trans_out_cnt_5 <= trans_out_cnt_5;
    end
end

reg [15:0] trans_in_cnt_6;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_6 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.start_write == 1'b1) begin
        trans_in_cnt_6 <= trans_in_cnt_6 + 16'h1;
    end
    else begin
        trans_in_cnt_6 <= trans_in_cnt_6;
    end
end

reg [15:0] trans_out_cnt_6;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_6 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_continue == 1'b1) begin
        trans_out_cnt_6 <= trans_out_cnt_6 + 16'h1;
    end
    else begin
        trans_out_cnt_6 <= trans_out_cnt_6;
    end
end

reg [15:0] trans_in_cnt_7;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_7 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.start_write == 1'b1) begin
        trans_in_cnt_7 <= trans_in_cnt_7 + 16'h1;
    end
    else begin
        trans_in_cnt_7 <= trans_in_cnt_7;
    end
end

reg [15:0] trans_out_cnt_7;// for process compute_engine_U0.general_1d_conv_accelerator_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_7 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_continue == 1'b1) begin
        trans_out_cnt_7 <= trans_out_cnt_7 + 16'h1;
    end
    else begin
        trans_out_cnt_7 <= trans_out_cnt_7;
    end
end

reg [15:0] trans_in_cnt_8;// for process compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_8 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.start_write == 1'b1) begin
        trans_in_cnt_8 <= trans_in_cnt_8 + 16'h1;
    end
    else begin
        trans_in_cnt_8 <= trans_in_cnt_8;
    end
end

reg [15:0] trans_out_cnt_8;// for process compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_8 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_done == 1'b1 && compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_8 <= trans_out_cnt_8 + 16'h1;
    end
    else begin
        trans_out_cnt_8 <= trans_out_cnt_8;
    end
end

reg [15:0] trans_in_cnt_9;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_9 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.start_write == 1'b1) begin
        trans_in_cnt_9 <= trans_in_cnt_9 + 16'h1;
    end
    else begin
        trans_in_cnt_9 <= trans_in_cnt_9;
    end
end

reg [15:0] trans_out_cnt_9;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_9 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_continue == 1'b1) begin
        trans_out_cnt_9 <= trans_out_cnt_9 + 16'h1;
    end
    else begin
        trans_out_cnt_9 <= trans_out_cnt_9;
    end
end

reg [15:0] trans_in_cnt_10;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_10 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.start_write == 1'b1) begin
        trans_in_cnt_10 <= trans_in_cnt_10 + 16'h1;
    end
    else begin
        trans_in_cnt_10 <= trans_in_cnt_10;
    end
end

reg [15:0] trans_out_cnt_10;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_10 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_continue == 1'b1) begin
        trans_out_cnt_10 <= trans_out_cnt_10 + 16'h1;
    end
    else begin
        trans_out_cnt_10 <= trans_out_cnt_10;
    end
end

reg [15:0] trans_in_cnt_11;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_11 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.start_write == 1'b1) begin
        trans_in_cnt_11 <= trans_in_cnt_11 + 16'h1;
    end
    else begin
        trans_in_cnt_11 <= trans_in_cnt_11;
    end
end

reg [15:0] trans_out_cnt_11;// for process compute_engine_U0.general_1d_conv_accelerator_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_11 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_continue == 1'b1) begin
        trans_out_cnt_11 <= trans_out_cnt_11 + 16'h1;
    end
    else begin
        trans_out_cnt_11 <= trans_out_cnt_11;
    end
end

reg [15:0] trans_in_cnt_12;// for process compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_12 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.start_write == 1'b1) begin
        trans_in_cnt_12 <= trans_in_cnt_12 + 16'h1;
    end
    else begin
        trans_in_cnt_12 <= trans_in_cnt_12;
    end
end

reg [15:0] trans_out_cnt_12;// for process compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_12 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_done == 1'b1 && compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_12 <= trans_out_cnt_12 + 16'h1;
    end
    else begin
        trans_out_cnt_12 <= trans_out_cnt_12;
    end
end

reg [15:0] trans_in_cnt_13;// for process compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_13 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.start_write == 1'b1) begin
        trans_in_cnt_13 <= trans_in_cnt_13 + 16'h1;
    end
    else begin
        trans_in_cnt_13 <= trans_in_cnt_13;
    end
end

reg [15:0] trans_out_cnt_13;// for process compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_13 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_continue == 1'b1) begin
        trans_out_cnt_13 <= trans_out_cnt_13 + 16'h1;
    end
    else begin
        trans_out_cnt_13 <= trans_out_cnt_13;
    end
end

reg [15:0] trans_in_cnt_14;// for process compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_14 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.start_write == 1'b1) begin
        trans_in_cnt_14 <= trans_in_cnt_14 + 16'h1;
    end
    else begin
        trans_in_cnt_14 <= trans_in_cnt_14;
    end
end

reg [15:0] trans_out_cnt_14;// for process compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_14 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_continue == 1'b1) begin
        trans_out_cnt_14 <= trans_out_cnt_14 + 16'h1;
    end
    else begin
        trans_out_cnt_14 <= trans_out_cnt_14;
    end
end

reg [15:0] trans_in_cnt_15;// for process compute_engine_U0.general_1d_conv_accelerator_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_15 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.start_write == 1'b1) begin
        trans_in_cnt_15 <= trans_in_cnt_15 + 16'h1;
    end
    else begin
        trans_in_cnt_15 <= trans_in_cnt_15;
    end
end

reg [15:0] trans_out_cnt_15;// for process compute_engine_U0.general_1d_conv_accelerator_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_15 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_U0.ap_continue == 1'b1) begin
        trans_out_cnt_15 <= trans_out_cnt_15 + 16'h1;
    end
    else begin
        trans_out_cnt_15 <= trans_out_cnt_15;
    end
end

reg [15:0] trans_in_cnt_16;// for process compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_16 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.start_write == 1'b1) begin
        trans_in_cnt_16 <= trans_in_cnt_16 + 16'h1;
    end
    else begin
        trans_in_cnt_16 <= trans_in_cnt_16;
    end
end

reg [15:0] trans_out_cnt_16;// for process compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_16 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_done == 1'b1 && compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_16 <= trans_out_cnt_16 + 16'h1;
    end
    else begin
        trans_out_cnt_16 <= trans_out_cnt_16;
    end
end

reg [15:0] trans_in_cnt_17;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_17 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.start_write == 1'b1) begin
        trans_in_cnt_17 <= trans_in_cnt_17 + 16'h1;
    end
    else begin
        trans_in_cnt_17 <= trans_in_cnt_17;
    end
end

reg [15:0] trans_out_cnt_17;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_17 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_continue == 1'b1) begin
        trans_out_cnt_17 <= trans_out_cnt_17 + 16'h1;
    end
    else begin
        trans_out_cnt_17 <= trans_out_cnt_17;
    end
end

reg [15:0] trans_in_cnt_18;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_18 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.start_write == 1'b1) begin
        trans_in_cnt_18 <= trans_in_cnt_18 + 16'h1;
    end
    else begin
        trans_in_cnt_18 <= trans_in_cnt_18;
    end
end

reg [15:0] trans_out_cnt_18;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_18 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_continue == 1'b1) begin
        trans_out_cnt_18 <= trans_out_cnt_18 + 16'h1;
    end
    else begin
        trans_out_cnt_18 <= trans_out_cnt_18;
    end
end

reg [15:0] trans_in_cnt_19;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_19 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.start_write == 1'b1) begin
        trans_in_cnt_19 <= trans_in_cnt_19 + 16'h1;
    end
    else begin
        trans_in_cnt_19 <= trans_in_cnt_19;
    end
end

reg [15:0] trans_out_cnt_19;// for process compute_engine_U0.general_1d_conv_accelerator_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_19 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_continue == 1'b1) begin
        trans_out_cnt_19 <= trans_out_cnt_19 + 16'h1;
    end
    else begin
        trans_out_cnt_19 <= trans_out_cnt_19;
    end
end

reg [15:0] trans_in_cnt_20;// for process compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_20 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.start_write == 1'b1) begin
        trans_in_cnt_20 <= trans_in_cnt_20 + 16'h1;
    end
    else begin
        trans_in_cnt_20 <= trans_in_cnt_20;
    end
end

reg [15:0] trans_out_cnt_20;// for process compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_20 <= 16'h0;
    end
    else if (compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_done == 1'b1 && compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_20 <= trans_out_cnt_20 + 16'h1;
    end
    else begin
        trans_out_cnt_20 <= trans_out_cnt_20;
    end
end

reg [15:0] trans_in_cnt_21;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_21 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.start_write == 1'b1) begin
        trans_in_cnt_21 <= trans_in_cnt_21 + 16'h1;
    end
    else begin
        trans_in_cnt_21 <= trans_in_cnt_21;
    end
end

reg [15:0] trans_out_cnt_21;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_21 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_continue == 1'b1) begin
        trans_out_cnt_21 <= trans_out_cnt_21 + 16'h1;
    end
    else begin
        trans_out_cnt_21 <= trans_out_cnt_21;
    end
end

reg [15:0] trans_in_cnt_22;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_22 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.start_write == 1'b1) begin
        trans_in_cnt_22 <= trans_in_cnt_22 + 16'h1;
    end
    else begin
        trans_in_cnt_22 <= trans_in_cnt_22;
    end
end

reg [15:0] trans_out_cnt_22;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_22 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_continue == 1'b1) begin
        trans_out_cnt_22 <= trans_out_cnt_22 + 16'h1;
    end
    else begin
        trans_out_cnt_22 <= trans_out_cnt_22;
    end
end

reg [15:0] trans_in_cnt_23;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_23 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.start_write == 1'b1) begin
        trans_in_cnt_23 <= trans_in_cnt_23 + 16'h1;
    end
    else begin
        trans_in_cnt_23 <= trans_in_cnt_23;
    end
end

reg [15:0] trans_out_cnt_23;// for process compute_engine_U0.general_1d_conv_accelerator_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_23 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_continue == 1'b1) begin
        trans_out_cnt_23 <= trans_out_cnt_23 + 16'h1;
    end
    else begin
        trans_out_cnt_23 <= trans_out_cnt_23;
    end
end

reg [15:0] trans_in_cnt_24;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_24 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.start_write == 1'b1) begin
        trans_in_cnt_24 <= trans_in_cnt_24 + 16'h1;
    end
    else begin
        trans_in_cnt_24 <= trans_in_cnt_24;
    end
end

reg [15:0] trans_out_cnt_24;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_24 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_continue == 1'b1) begin
        trans_out_cnt_24 <= trans_out_cnt_24 + 16'h1;
    end
    else begin
        trans_out_cnt_24 <= trans_out_cnt_24;
    end
end

reg [15:0] trans_in_cnt_25;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_25 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.start_write == 1'b1) begin
        trans_in_cnt_25 <= trans_in_cnt_25 + 16'h1;
    end
    else begin
        trans_in_cnt_25 <= trans_in_cnt_25;
    end
end

reg [15:0] trans_out_cnt_25;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_25 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_continue == 1'b1) begin
        trans_out_cnt_25 <= trans_out_cnt_25 + 16'h1;
    end
    else begin
        trans_out_cnt_25 <= trans_out_cnt_25;
    end
end

reg [15:0] trans_in_cnt_26;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_26 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.start_write == 1'b1) begin
        trans_in_cnt_26 <= trans_in_cnt_26 + 16'h1;
    end
    else begin
        trans_in_cnt_26 <= trans_in_cnt_26;
    end
end

reg [15:0] trans_out_cnt_26;// for process compute_engine_U0.general_1d_conv_accelerator_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_26 <= 16'h0;
    end
    else if (compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_done == 1'b1 && compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_continue == 1'b1) begin
        trans_out_cnt_26 <= trans_out_cnt_26 + 16'h1;
    end
    else begin
        trans_out_cnt_26 <= trans_out_cnt_26;
    end
end

reg [15:0] trans_in_cnt_27;// for process compute_engine_U0.stream_width_adjust_flex_8_32_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_27 <= 16'h0;
    end
    else if (compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.start_write == 1'b1) begin
        trans_in_cnt_27 <= trans_in_cnt_27 + 16'h1;
    end
    else begin
        trans_in_cnt_27 <= trans_in_cnt_27;
    end
end

reg [15:0] trans_out_cnt_27;// for process compute_engine_U0.stream_width_adjust_flex_8_32_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_27 <= 16'h0;
    end
    else if (compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_done == 1'b1 && compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_continue == 1'b1) begin
        trans_out_cnt_27 <= trans_out_cnt_27 + 16'h1;
    end
    else begin
        trans_out_cnt_27 <= trans_out_cnt_27;
    end
end

    // Process: entry_proc11_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 0, 3, 3) synthesis_top_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~entry_proc11_U0.num_samples_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~start_for_compute_engine_U0_U.if_full_n & entry_proc11_U0.ap_start & ~entry_proc11_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_compute_engine_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0 | (~entry_proc11_U0.num_samples_c_blk_n);
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0;
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0;
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0;
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0 | (ap_sync_entry_proc11_U0_ap_ready & entry_proc11_U0.ap_idle & ~ap_sync_load_weights_wrapper_U0_ap_ready);
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[54 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_2_0;
    assign in_chan_dep_data_vec_0[109 : 55] = dep_chan_data_2_0;
    assign token_in_vec_0[1] = token_2_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_4_0;
    assign in_chan_dep_data_vec_0[164 : 110] = dep_chan_data_4_0;
    assign token_in_vec_0[2] = token_4_0;
    assign dep_chan_vld_0_2 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_2 = out_chan_dep_data_0;
    assign token_0_2 = token_out_vec_0[0];
    assign dep_chan_vld_0_4 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_4 = out_chan_dep_data_0;
    assign token_0_4 = token_out_vec_0[1];
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[2];

    // Process: load_weights_wrapper_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 1, 16, 16) synthesis_top_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n) | (~load_weights_wrapper_U0.reload_weights_c_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0;
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n);
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0;
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n);
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0;
    assign proc_1_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    assign proc_1_data_FIFO_blk[3] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n);
    assign proc_1_data_PIPO_blk[3] = 1'b0;
    assign proc_1_start_FIFO_blk[3] = 1'b0;
    assign proc_1_TLF_FIFO_blk[3] = 1'b0;
    assign proc_1_input_sync_blk[3] = 1'b0;
    assign proc_1_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_1[3] = dl_detect_out ? proc_dep_vld_vec_1_reg[3] : (proc_1_data_FIFO_blk[3] | proc_1_data_PIPO_blk[3] | proc_1_start_FIFO_blk[3] | proc_1_TLF_FIFO_blk[3] | proc_1_input_sync_blk[3] | proc_1_output_sync_blk[3]);
    assign proc_1_data_FIFO_blk[4] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n);
    assign proc_1_data_PIPO_blk[4] = 1'b0;
    assign proc_1_start_FIFO_blk[4] = 1'b0;
    assign proc_1_TLF_FIFO_blk[4] = 1'b0;
    assign proc_1_input_sync_blk[4] = 1'b0;
    assign proc_1_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_1[4] = dl_detect_out ? proc_dep_vld_vec_1_reg[4] : (proc_1_data_FIFO_blk[4] | proc_1_data_PIPO_blk[4] | proc_1_start_FIFO_blk[4] | proc_1_TLF_FIFO_blk[4] | proc_1_input_sync_blk[4] | proc_1_output_sync_blk[4]);
    assign proc_1_data_FIFO_blk[5] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n);
    assign proc_1_data_PIPO_blk[5] = 1'b0;
    assign proc_1_start_FIFO_blk[5] = 1'b0;
    assign proc_1_TLF_FIFO_blk[5] = 1'b0;
    assign proc_1_input_sync_blk[5] = 1'b0;
    assign proc_1_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_1[5] = dl_detect_out ? proc_dep_vld_vec_1_reg[5] : (proc_1_data_FIFO_blk[5] | proc_1_data_PIPO_blk[5] | proc_1_start_FIFO_blk[5] | proc_1_TLF_FIFO_blk[5] | proc_1_input_sync_blk[5] | proc_1_output_sync_blk[5]);
    assign proc_1_data_FIFO_blk[6] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n);
    assign proc_1_data_PIPO_blk[6] = 1'b0;
    assign proc_1_start_FIFO_blk[6] = 1'b0;
    assign proc_1_TLF_FIFO_blk[6] = 1'b0;
    assign proc_1_input_sync_blk[6] = 1'b0;
    assign proc_1_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_1[6] = dl_detect_out ? proc_dep_vld_vec_1_reg[6] : (proc_1_data_FIFO_blk[6] | proc_1_data_PIPO_blk[6] | proc_1_start_FIFO_blk[6] | proc_1_TLF_FIFO_blk[6] | proc_1_input_sync_blk[6] | proc_1_output_sync_blk[6]);
    assign proc_1_data_FIFO_blk[7] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n);
    assign proc_1_data_PIPO_blk[7] = 1'b0;
    assign proc_1_start_FIFO_blk[7] = 1'b0;
    assign proc_1_TLF_FIFO_blk[7] = 1'b0;
    assign proc_1_input_sync_blk[7] = 1'b0;
    assign proc_1_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_1[7] = dl_detect_out ? proc_dep_vld_vec_1_reg[7] : (proc_1_data_FIFO_blk[7] | proc_1_data_PIPO_blk[7] | proc_1_start_FIFO_blk[7] | proc_1_TLF_FIFO_blk[7] | proc_1_input_sync_blk[7] | proc_1_output_sync_blk[7]);
    assign proc_1_data_FIFO_blk[8] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n);
    assign proc_1_data_PIPO_blk[8] = 1'b0;
    assign proc_1_start_FIFO_blk[8] = 1'b0;
    assign proc_1_TLF_FIFO_blk[8] = 1'b0;
    assign proc_1_input_sync_blk[8] = 1'b0;
    assign proc_1_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_1[8] = dl_detect_out ? proc_dep_vld_vec_1_reg[8] : (proc_1_data_FIFO_blk[8] | proc_1_data_PIPO_blk[8] | proc_1_start_FIFO_blk[8] | proc_1_TLF_FIFO_blk[8] | proc_1_input_sync_blk[8] | proc_1_output_sync_blk[8]);
    assign proc_1_data_FIFO_blk[9] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n);
    assign proc_1_data_PIPO_blk[9] = 1'b0;
    assign proc_1_start_FIFO_blk[9] = 1'b0;
    assign proc_1_TLF_FIFO_blk[9] = 1'b0;
    assign proc_1_input_sync_blk[9] = 1'b0;
    assign proc_1_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_1[9] = dl_detect_out ? proc_dep_vld_vec_1_reg[9] : (proc_1_data_FIFO_blk[9] | proc_1_data_PIPO_blk[9] | proc_1_start_FIFO_blk[9] | proc_1_TLF_FIFO_blk[9] | proc_1_input_sync_blk[9] | proc_1_output_sync_blk[9]);
    assign proc_1_data_FIFO_blk[10] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n);
    assign proc_1_data_PIPO_blk[10] = 1'b0;
    assign proc_1_start_FIFO_blk[10] = 1'b0;
    assign proc_1_TLF_FIFO_blk[10] = 1'b0;
    assign proc_1_input_sync_blk[10] = 1'b0;
    assign proc_1_output_sync_blk[10] = 1'b0;
    assign proc_dep_vld_vec_1[10] = dl_detect_out ? proc_dep_vld_vec_1_reg[10] : (proc_1_data_FIFO_blk[10] | proc_1_data_PIPO_blk[10] | proc_1_start_FIFO_blk[10] | proc_1_TLF_FIFO_blk[10] | proc_1_input_sync_blk[10] | proc_1_output_sync_blk[10]);
    assign proc_1_data_FIFO_blk[11] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n);
    assign proc_1_data_PIPO_blk[11] = 1'b0;
    assign proc_1_start_FIFO_blk[11] = 1'b0;
    assign proc_1_TLF_FIFO_blk[11] = 1'b0;
    assign proc_1_input_sync_blk[11] = 1'b0;
    assign proc_1_output_sync_blk[11] = 1'b0;
    assign proc_dep_vld_vec_1[11] = dl_detect_out ? proc_dep_vld_vec_1_reg[11] : (proc_1_data_FIFO_blk[11] | proc_1_data_PIPO_blk[11] | proc_1_start_FIFO_blk[11] | proc_1_TLF_FIFO_blk[11] | proc_1_input_sync_blk[11] | proc_1_output_sync_blk[11]);
    assign proc_1_data_FIFO_blk[12] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n);
    assign proc_1_data_PIPO_blk[12] = 1'b0;
    assign proc_1_start_FIFO_blk[12] = 1'b0;
    assign proc_1_TLF_FIFO_blk[12] = 1'b0;
    assign proc_1_input_sync_blk[12] = 1'b0;
    assign proc_1_output_sync_blk[12] = 1'b0;
    assign proc_dep_vld_vec_1[12] = dl_detect_out ? proc_dep_vld_vec_1_reg[12] : (proc_1_data_FIFO_blk[12] | proc_1_data_PIPO_blk[12] | proc_1_start_FIFO_blk[12] | proc_1_TLF_FIFO_blk[12] | proc_1_input_sync_blk[12] | proc_1_output_sync_blk[12]);
    assign proc_1_data_FIFO_blk[13] = 1'b0 | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n) | (~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n);
    assign proc_1_data_PIPO_blk[13] = 1'b0;
    assign proc_1_start_FIFO_blk[13] = 1'b0;
    assign proc_1_TLF_FIFO_blk[13] = 1'b0;
    assign proc_1_input_sync_blk[13] = 1'b0;
    assign proc_1_output_sync_blk[13] = 1'b0;
    assign proc_dep_vld_vec_1[13] = dl_detect_out ? proc_dep_vld_vec_1_reg[13] : (proc_1_data_FIFO_blk[13] | proc_1_data_PIPO_blk[13] | proc_1_start_FIFO_blk[13] | proc_1_TLF_FIFO_blk[13] | proc_1_input_sync_blk[13] | proc_1_output_sync_blk[13]);
    assign proc_1_data_FIFO_blk[14] = 1'b0 | (~load_weights_wrapper_U0.reload_weights_c_blk_n);
    assign proc_1_data_PIPO_blk[14] = 1'b0;
    assign proc_1_start_FIFO_blk[14] = 1'b0;
    assign proc_1_TLF_FIFO_blk[14] = 1'b0;
    assign proc_1_input_sync_blk[14] = 1'b0;
    assign proc_1_output_sync_blk[14] = 1'b0;
    assign proc_dep_vld_vec_1[14] = dl_detect_out ? proc_dep_vld_vec_1_reg[14] : (proc_1_data_FIFO_blk[14] | proc_1_data_PIPO_blk[14] | proc_1_start_FIFO_blk[14] | proc_1_TLF_FIFO_blk[14] | proc_1_input_sync_blk[14] | proc_1_output_sync_blk[14]);
    assign proc_1_data_FIFO_blk[15] = 1'b0;
    assign proc_1_data_PIPO_blk[15] = 1'b0;
    assign proc_1_start_FIFO_blk[15] = 1'b0;
    assign proc_1_TLF_FIFO_blk[15] = 1'b0;
    assign proc_1_input_sync_blk[15] = 1'b0 | (ap_sync_load_weights_wrapper_U0_ap_ready & load_weights_wrapper_U0.ap_idle & ~ap_sync_entry_proc11_U0_ap_ready);
    assign proc_1_output_sync_blk[15] = 1'b0;
    assign proc_dep_vld_vec_1[15] = dl_detect_out ? proc_dep_vld_vec_1_reg[15] : (proc_1_data_FIFO_blk[15] | proc_1_data_PIPO_blk[15] | proc_1_start_FIFO_blk[15] | proc_1_TLF_FIFO_blk[15] | proc_1_input_sync_blk[15] | proc_1_output_sync_blk[15]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[54 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[109 : 55] = dep_chan_data_2_1;
    assign token_in_vec_1[1] = token_2_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[164 : 110] = dep_chan_data_3_1;
    assign token_in_vec_1[2] = token_3_1;
    assign in_chan_dep_vld_vec_1[3] = dep_chan_vld_6_1;
    assign in_chan_dep_data_vec_1[219 : 165] = dep_chan_data_6_1;
    assign token_in_vec_1[3] = token_6_1;
    assign in_chan_dep_vld_vec_1[4] = dep_chan_vld_9_1;
    assign in_chan_dep_data_vec_1[274 : 220] = dep_chan_data_9_1;
    assign token_in_vec_1[4] = token_9_1;
    assign in_chan_dep_vld_vec_1[5] = dep_chan_vld_13_1;
    assign in_chan_dep_data_vec_1[329 : 275] = dep_chan_data_13_1;
    assign token_in_vec_1[5] = token_13_1;
    assign in_chan_dep_vld_vec_1[6] = dep_chan_vld_17_1;
    assign in_chan_dep_data_vec_1[384 : 330] = dep_chan_data_17_1;
    assign token_in_vec_1[6] = token_17_1;
    assign in_chan_dep_vld_vec_1[7] = dep_chan_vld_21_1;
    assign in_chan_dep_data_vec_1[439 : 385] = dep_chan_data_21_1;
    assign token_in_vec_1[7] = token_21_1;
    assign in_chan_dep_vld_vec_1[8] = dep_chan_vld_25_1;
    assign in_chan_dep_data_vec_1[494 : 440] = dep_chan_data_25_1;
    assign token_in_vec_1[8] = token_25_1;
    assign in_chan_dep_vld_vec_1[9] = dep_chan_vld_29_1;
    assign in_chan_dep_data_vec_1[549 : 495] = dep_chan_data_29_1;
    assign token_in_vec_1[9] = token_29_1;
    assign in_chan_dep_vld_vec_1[10] = dep_chan_vld_33_1;
    assign in_chan_dep_data_vec_1[604 : 550] = dep_chan_data_33_1;
    assign token_in_vec_1[10] = token_33_1;
    assign in_chan_dep_vld_vec_1[11] = dep_chan_vld_37_1;
    assign in_chan_dep_data_vec_1[659 : 605] = dep_chan_data_37_1;
    assign token_in_vec_1[11] = token_37_1;
    assign in_chan_dep_vld_vec_1[12] = dep_chan_vld_41_1;
    assign in_chan_dep_data_vec_1[714 : 660] = dep_chan_data_41_1;
    assign token_in_vec_1[12] = token_41_1;
    assign in_chan_dep_vld_vec_1[13] = dep_chan_vld_45_1;
    assign in_chan_dep_data_vec_1[769 : 715] = dep_chan_data_45_1;
    assign token_in_vec_1[13] = token_45_1;
    assign in_chan_dep_vld_vec_1[14] = dep_chan_vld_48_1;
    assign in_chan_dep_data_vec_1[824 : 770] = dep_chan_data_48_1;
    assign token_in_vec_1[14] = token_48_1;
    assign in_chan_dep_vld_vec_1[15] = dep_chan_vld_51_1;
    assign in_chan_dep_data_vec_1[879 : 825] = dep_chan_data_51_1;
    assign token_in_vec_1[15] = token_51_1;
    assign dep_chan_vld_1_2 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_2 = out_chan_dep_data_1;
    assign token_1_2 = token_out_vec_1[0];
    assign dep_chan_vld_1_6 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_6 = out_chan_dep_data_1;
    assign token_1_6 = token_out_vec_1[1];
    assign dep_chan_vld_1_9 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_9 = out_chan_dep_data_1;
    assign token_1_9 = token_out_vec_1[2];
    assign dep_chan_vld_1_13 = out_chan_dep_vld_vec_1[3];
    assign dep_chan_data_1_13 = out_chan_dep_data_1;
    assign token_1_13 = token_out_vec_1[3];
    assign dep_chan_vld_1_17 = out_chan_dep_vld_vec_1[4];
    assign dep_chan_data_1_17 = out_chan_dep_data_1;
    assign token_1_17 = token_out_vec_1[4];
    assign dep_chan_vld_1_21 = out_chan_dep_vld_vec_1[5];
    assign dep_chan_data_1_21 = out_chan_dep_data_1;
    assign token_1_21 = token_out_vec_1[5];
    assign dep_chan_vld_1_25 = out_chan_dep_vld_vec_1[6];
    assign dep_chan_data_1_25 = out_chan_dep_data_1;
    assign token_1_25 = token_out_vec_1[6];
    assign dep_chan_vld_1_29 = out_chan_dep_vld_vec_1[7];
    assign dep_chan_data_1_29 = out_chan_dep_data_1;
    assign token_1_29 = token_out_vec_1[7];
    assign dep_chan_vld_1_33 = out_chan_dep_vld_vec_1[8];
    assign dep_chan_data_1_33 = out_chan_dep_data_1;
    assign token_1_33 = token_out_vec_1[8];
    assign dep_chan_vld_1_37 = out_chan_dep_vld_vec_1[9];
    assign dep_chan_data_1_37 = out_chan_dep_data_1;
    assign token_1_37 = token_out_vec_1[9];
    assign dep_chan_vld_1_41 = out_chan_dep_vld_vec_1[10];
    assign dep_chan_data_1_41 = out_chan_dep_data_1;
    assign token_1_41 = token_out_vec_1[10];
    assign dep_chan_vld_1_45 = out_chan_dep_vld_vec_1[11];
    assign dep_chan_data_1_45 = out_chan_dep_data_1;
    assign token_1_45 = token_out_vec_1[11];
    assign dep_chan_vld_1_48 = out_chan_dep_vld_vec_1[12];
    assign dep_chan_data_1_48 = out_chan_dep_data_1;
    assign token_1_48 = token_out_vec_1[12];
    assign dep_chan_vld_1_51 = out_chan_dep_vld_vec_1[13];
    assign dep_chan_data_1_51 = out_chan_dep_data_1;
    assign token_1_51 = token_out_vec_1[13];
    assign dep_chan_vld_1_3 = out_chan_dep_vld_vec_1[14];
    assign dep_chan_data_1_3 = out_chan_dep_data_1;
    assign token_1_3 = token_out_vec_1[14];
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[15];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[15];

    // Process: compute_engine_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 2, 2, 2) synthesis_top_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n) | (~compute_engine_U0.entry_proc10_U0.load_weights_blk_n);
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0;
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n);
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0 | (~start_for_compute_engine_U0_U.if_empty_n & compute_engine_U0.ap_idle & ~start_for_compute_engine_U0_U.if_write);
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0;
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_0_2;
    assign in_chan_dep_data_vec_2[54 : 0] = dep_chan_data_0_2;
    assign token_in_vec_2[0] = token_0_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_1_2;
    assign in_chan_dep_data_vec_2[109 : 55] = dep_chan_data_1_2;
    assign token_in_vec_2[1] = token_1_2;
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[0];
    assign dep_chan_vld_2_0 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_0 = out_chan_dep_data_2;
    assign token_2_0 = token_out_vec_2[1];

    // Process: compute_engine_U0.entry_proc10_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 3, 3, 3) synthesis_top_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.entry_proc10_U0.load_weights_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.entry_proc10_U0.load_weights_c26_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_full_n & compute_engine_U0.entry_proc10_U0.ap_start & ~compute_engine_U0.entry_proc10_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_read);
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    assign proc_3_data_FIFO_blk[2] = 1'b0;
    assign proc_3_data_PIPO_blk[2] = 1'b0;
    assign proc_3_start_FIFO_blk[2] = 1'b0;
    assign proc_3_TLF_FIFO_blk[2] = 1'b0;
    assign proc_3_input_sync_blk[2] = 1'b0 | (compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready & compute_engine_U0.entry_proc10_U0.ap_idle & ~compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready);
    assign proc_3_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_3[2] = dl_detect_out ? proc_dep_vld_vec_3_reg[2] : (proc_3_data_FIFO_blk[2] | proc_3_data_PIPO_blk[2] | proc_3_start_FIFO_blk[2] | proc_3_TLF_FIFO_blk[2] | proc_3_input_sync_blk[2] | proc_3_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_1_3;
    assign in_chan_dep_data_vec_3[54 : 0] = dep_chan_data_1_3;
    assign token_in_vec_3[0] = token_1_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[109 : 55] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign in_chan_dep_vld_vec_3[2] = dep_chan_vld_6_3;
    assign in_chan_dep_data_vec_3[164 : 110] = dep_chan_data_6_3;
    assign token_in_vec_3[2] = token_6_3;
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[0];
    assign dep_chan_vld_3_6 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_6 = out_chan_dep_data_3;
    assign token_3_6 = token_out_vec_3[1];
    assign dep_chan_vld_3_4 = out_chan_dep_vld_vec_3[2];
    assign dep_chan_data_3_4 = out_chan_dep_data_3;
    assign token_3_4 = token_out_vec_3[2];

    // Process: compute_engine_U0.axis_512_to_hls_stream_8_5120_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 4, 3, 3) synthesis_top_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.grp_axis_512_to_hls_stream_8_5120_Pipeline_VITIS_LOOP_20_3_fu_113.s_raw_in_blk_n) | (~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.num_samples_c20_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_full_n & compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_start & ~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n);
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0;
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    assign proc_4_data_FIFO_blk[2] = 1'b0;
    assign proc_4_data_PIPO_blk[2] = 1'b0;
    assign proc_4_start_FIFO_blk[2] = 1'b0;
    assign proc_4_TLF_FIFO_blk[2] = 1'b0;
    assign proc_4_input_sync_blk[2] = 1'b0 | (compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready & compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_idle & ~compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready);
    assign proc_4_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_4[2] = dl_detect_out ? proc_dep_vld_vec_4_reg[2] : (proc_4_data_FIFO_blk[2] | proc_4_data_PIPO_blk[2] | proc_4_start_FIFO_blk[2] | proc_4_TLF_FIFO_blk[2] | proc_4_input_sync_blk[2] | proc_4_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_0_4;
    assign in_chan_dep_data_vec_4[54 : 0] = dep_chan_data_0_4;
    assign token_in_vec_4[0] = token_0_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_3_4;
    assign in_chan_dep_data_vec_4[109 : 55] = dep_chan_data_3_4;
    assign token_in_vec_4[1] = token_3_4;
    assign in_chan_dep_vld_vec_4[2] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[164 : 110] = dep_chan_data_5_4;
    assign token_in_vec_4[2] = token_5_4;
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[0];
    assign dep_chan_vld_4_0 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_0 = out_chan_dep_data_4;
    assign token_4_0 = token_out_vec_4[1];
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[2];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[2];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 5, 2, 2) synthesis_top_hls_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_raw_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.reps_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_write);
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_l1_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.num_samples_c19_blk_n);
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0;
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[54 : 0] = dep_chan_data_4_5;
    assign token_in_vec_5[0] = token_4_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[109 : 55] = dep_chan_data_6_5;
    assign token_in_vec_5[1] = token_6_5;
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[0];
    assign dep_chan_vld_5_6 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_6 = out_chan_dep_data_5;
    assign token_5_6 = token_out_vec_5[1];

    // Process: compute_engine_U0.conv1_accelerator_specialized_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 6, 6, 6) synthesis_top_hls_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_69_6_fu_403.s_l1_in_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.reps_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0;
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    assign proc_6_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_98_11_fu_466.s_l1_conv_blk_n) | (~compute_engine_U0.conv1_accelerator_specialized_U0.num_samples_c18_blk_n);
    assign proc_6_data_PIPO_blk[2] = 1'b0;
    assign proc_6_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_read);
    assign proc_6_TLF_FIFO_blk[2] = 1'b0;
    assign proc_6_input_sync_blk[2] = 1'b0;
    assign proc_6_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_6[2] = dl_detect_out ? proc_dep_vld_vec_6_reg[2] : (proc_6_data_FIFO_blk[2] | proc_6_data_PIPO_blk[2] | proc_6_start_FIFO_blk[2] | proc_6_TLF_FIFO_blk[2] | proc_6_input_sync_blk[2] | proc_6_output_sync_blk[2]);
    assign proc_6_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_blk_n);
    assign proc_6_data_PIPO_blk[3] = 1'b0;
    assign proc_6_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_empty_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_idle & ~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_write);
    assign proc_6_TLF_FIFO_blk[3] = 1'b0;
    assign proc_6_input_sync_blk[3] = 1'b0;
    assign proc_6_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_6[3] = dl_detect_out ? proc_dep_vld_vec_6_reg[3] : (proc_6_data_FIFO_blk[3] | proc_6_data_PIPO_blk[3] | proc_6_start_FIFO_blk[3] | proc_6_TLF_FIFO_blk[3] | proc_6_input_sync_blk[3] | proc_6_output_sync_blk[3]);
    assign proc_6_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n);
    assign proc_6_data_PIPO_blk[4] = 1'b0;
    assign proc_6_start_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_full_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_read);
    assign proc_6_TLF_FIFO_blk[4] = 1'b0;
    assign proc_6_input_sync_blk[4] = 1'b0;
    assign proc_6_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_6[4] = dl_detect_out ? proc_dep_vld_vec_6_reg[4] : (proc_6_data_FIFO_blk[4] | proc_6_data_PIPO_blk[4] | proc_6_start_FIFO_blk[4] | proc_6_TLF_FIFO_blk[4] | proc_6_input_sync_blk[4] | proc_6_output_sync_blk[4]);
    assign proc_6_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n);
    assign proc_6_data_PIPO_blk[5] = 1'b0;
    assign proc_6_start_FIFO_blk[5] = 1'b0;
    assign proc_6_TLF_FIFO_blk[5] = 1'b0;
    assign proc_6_input_sync_blk[5] = 1'b0;
    assign proc_6_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_6[5] = dl_detect_out ? proc_dep_vld_vec_6_reg[5] : (proc_6_data_FIFO_blk[5] | proc_6_data_PIPO_blk[5] | proc_6_start_FIFO_blk[5] | proc_6_TLF_FIFO_blk[5] | proc_6_input_sync_blk[5] | proc_6_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_1_6;
    assign in_chan_dep_data_vec_6[54 : 0] = dep_chan_data_1_6;
    assign token_in_vec_6[0] = token_1_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_3_6;
    assign in_chan_dep_data_vec_6[109 : 55] = dep_chan_data_3_6;
    assign token_in_vec_6[1] = token_3_6;
    assign in_chan_dep_vld_vec_6[2] = dep_chan_vld_5_6;
    assign in_chan_dep_data_vec_6[164 : 110] = dep_chan_data_5_6;
    assign token_in_vec_6[2] = token_5_6;
    assign in_chan_dep_vld_vec_6[3] = dep_chan_vld_7_6;
    assign in_chan_dep_data_vec_6[219 : 165] = dep_chan_data_7_6;
    assign token_in_vec_6[3] = token_7_6;
    assign in_chan_dep_vld_vec_6[4] = dep_chan_vld_9_6;
    assign in_chan_dep_data_vec_6[274 : 220] = dep_chan_data_9_6;
    assign token_in_vec_6[4] = token_9_6;
    assign in_chan_dep_vld_vec_6[5] = dep_chan_vld_10_6;
    assign in_chan_dep_data_vec_6[329 : 275] = dep_chan_data_10_6;
    assign token_in_vec_6[5] = token_10_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];
    assign dep_chan_vld_6_1 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_1 = out_chan_dep_data_6;
    assign token_6_1 = token_out_vec_6[1];
    assign dep_chan_vld_6_7 = out_chan_dep_vld_vec_6[2];
    assign dep_chan_data_6_7 = out_chan_dep_data_6;
    assign token_6_7 = token_out_vec_6[2];
    assign dep_chan_vld_6_3 = out_chan_dep_vld_vec_6[3];
    assign dep_chan_data_6_3 = out_chan_dep_data_6;
    assign token_6_3 = token_out_vec_6[3];
    assign dep_chan_vld_6_9 = out_chan_dep_vld_vec_6[4];
    assign dep_chan_data_6_9 = out_chan_dep_data_6;
    assign token_6_9 = token_out_vec_6[4];
    assign dep_chan_vld_6_10 = out_chan_dep_vld_vec_6[5];
    assign dep_chan_data_6_10 = out_chan_dep_data_6;
    assign token_6_10 = token_out_vec_6[5];

    // Process: compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 7, 2, 2) synthesis_top_hls_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_conv_blk_n) | (~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_write);
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_pool1_blk_n) | (~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c17_blk_n);
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_read);
    assign proc_7_TLF_FIFO_blk[1] = 1'b0;
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_6_7;
    assign in_chan_dep_data_vec_7[54 : 0] = dep_chan_data_6_7;
    assign token_in_vec_7[0] = token_6_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_8_7;
    assign in_chan_dep_data_vec_7[109 : 55] = dep_chan_data_8_7;
    assign token_in_vec_7[1] = token_8_7;
    assign dep_chan_vld_7_6 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_6 = out_chan_dep_data_7;
    assign token_7_6 = token_out_vec_7[0];
    assign dep_chan_vld_7_8 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_8 = out_chan_dep_data_7;
    assign token_7_8 = token_out_vec_7[1];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 8, 3, 3) synthesis_top_hls_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l1_pool1_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.reps_blk_n);
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_write);
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    assign proc_8_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n);
    assign proc_8_data_PIPO_blk[1] = 1'b0;
    assign proc_8_start_FIFO_blk[1] = 1'b0;
    assign proc_8_TLF_FIFO_blk[1] = 1'b0;
    assign proc_8_input_sync_blk[1] = 1'b0;
    assign proc_8_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_8[1] = dl_detect_out ? proc_dep_vld_vec_8_reg[1] : (proc_8_data_FIFO_blk[1] | proc_8_data_PIPO_blk[1] | proc_8_start_FIFO_blk[1] | proc_8_TLF_FIFO_blk[1] | proc_8_input_sync_blk[1] | proc_8_output_sync_blk[1]);
    assign proc_8_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n);
    assign proc_8_data_PIPO_blk[2] = 1'b0;
    assign proc_8_start_FIFO_blk[2] = 1'b0;
    assign proc_8_TLF_FIFO_blk[2] = 1'b0;
    assign proc_8_input_sync_blk[2] = 1'b0;
    assign proc_8_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_8[2] = dl_detect_out ? proc_dep_vld_vec_8_reg[2] : (proc_8_data_FIFO_blk[2] | proc_8_data_PIPO_blk[2] | proc_8_start_FIFO_blk[2] | proc_8_TLF_FIFO_blk[2] | proc_8_input_sync_blk[2] | proc_8_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_7_8;
    assign in_chan_dep_data_vec_8[54 : 0] = dep_chan_data_7_8;
    assign token_in_vec_8[0] = token_7_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_9_8;
    assign in_chan_dep_data_vec_8[109 : 55] = dep_chan_data_9_8;
    assign token_in_vec_8[1] = token_9_8;
    assign in_chan_dep_vld_vec_8[2] = dep_chan_vld_12_8;
    assign in_chan_dep_data_vec_8[164 : 110] = dep_chan_data_12_8;
    assign token_in_vec_8[2] = token_12_8;
    assign dep_chan_vld_8_7 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_7 = out_chan_dep_data_8;
    assign token_8_7 = token_out_vec_8[0];
    assign dep_chan_vld_8_9 = out_chan_dep_vld_vec_8[1];
    assign dep_chan_data_8_9 = out_chan_dep_data_8;
    assign token_8_9 = token_out_vec_8[1];
    assign dep_chan_vld_8_12 = out_chan_dep_vld_vec_8[2];
    assign dep_chan_data_8_12 = out_chan_dep_data_8;
    assign token_8_12 = token_out_vec_8[2];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 9, 6, 6) synthesis_top_hls_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n);
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0;
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0;
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    assign proc_9_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n);
    assign proc_9_data_PIPO_blk[1] = 1'b0;
    assign proc_9_start_FIFO_blk[1] = 1'b0;
    assign proc_9_TLF_FIFO_blk[1] = 1'b0;
    assign proc_9_input_sync_blk[1] = 1'b0;
    assign proc_9_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_9[1] = dl_detect_out ? proc_dep_vld_vec_9_reg[1] : (proc_9_data_FIFO_blk[1] | proc_9_data_PIPO_blk[1] | proc_9_start_FIFO_blk[1] | proc_9_TLF_FIFO_blk[1] | proc_9_input_sync_blk[1] | proc_9_output_sync_blk[1]);
    assign proc_9_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n);
    assign proc_9_data_PIPO_blk[2] = 1'b0;
    assign proc_9_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_read);
    assign proc_9_TLF_FIFO_blk[2] = 1'b0;
    assign proc_9_input_sync_blk[2] = 1'b0;
    assign proc_9_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_9[2] = dl_detect_out ? proc_dep_vld_vec_9_reg[2] : (proc_9_data_FIFO_blk[2] | proc_9_data_PIPO_blk[2] | proc_9_start_FIFO_blk[2] | proc_9_TLF_FIFO_blk[2] | proc_9_input_sync_blk[2] | proc_9_output_sync_blk[2]);
    assign proc_9_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n);
    assign proc_9_data_PIPO_blk[3] = 1'b0;
    assign proc_9_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_write);
    assign proc_9_TLF_FIFO_blk[3] = 1'b0;
    assign proc_9_input_sync_blk[3] = 1'b0;
    assign proc_9_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_9[3] = dl_detect_out ? proc_dep_vld_vec_9_reg[3] : (proc_9_data_FIFO_blk[3] | proc_9_data_PIPO_blk[3] | proc_9_start_FIFO_blk[3] | proc_9_TLF_FIFO_blk[3] | proc_9_input_sync_blk[3] | proc_9_output_sync_blk[3]);
    assign proc_9_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n);
    assign proc_9_data_PIPO_blk[4] = 1'b0;
    assign proc_9_start_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_read);
    assign proc_9_TLF_FIFO_blk[4] = 1'b0;
    assign proc_9_input_sync_blk[4] = 1'b0;
    assign proc_9_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_9[4] = dl_detect_out ? proc_dep_vld_vec_9_reg[4] : (proc_9_data_FIFO_blk[4] | proc_9_data_PIPO_blk[4] | proc_9_start_FIFO_blk[4] | proc_9_TLF_FIFO_blk[4] | proc_9_input_sync_blk[4] | proc_9_output_sync_blk[4]);
    assign proc_9_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n);
    assign proc_9_data_PIPO_blk[5] = 1'b0;
    assign proc_9_start_FIFO_blk[5] = 1'b0;
    assign proc_9_TLF_FIFO_blk[5] = 1'b0;
    assign proc_9_input_sync_blk[5] = 1'b0;
    assign proc_9_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_9[5] = dl_detect_out ? proc_dep_vld_vec_9_reg[5] : (proc_9_data_FIFO_blk[5] | proc_9_data_PIPO_blk[5] | proc_9_start_FIFO_blk[5] | proc_9_TLF_FIFO_blk[5] | proc_9_input_sync_blk[5] | proc_9_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_1_9;
    assign in_chan_dep_data_vec_9[54 : 0] = dep_chan_data_1_9;
    assign token_in_vec_9[0] = token_1_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_6_9;
    assign in_chan_dep_data_vec_9[109 : 55] = dep_chan_data_6_9;
    assign token_in_vec_9[1] = token_6_9;
    assign in_chan_dep_vld_vec_9[2] = dep_chan_vld_8_9;
    assign in_chan_dep_data_vec_9[164 : 110] = dep_chan_data_8_9;
    assign token_in_vec_9[2] = token_8_9;
    assign in_chan_dep_vld_vec_9[3] = dep_chan_vld_15_9;
    assign in_chan_dep_data_vec_9[219 : 165] = dep_chan_data_15_9;
    assign token_in_vec_9[3] = token_15_9;
    assign in_chan_dep_vld_vec_9[4] = dep_chan_vld_17_9;
    assign in_chan_dep_data_vec_9[274 : 220] = dep_chan_data_17_9;
    assign token_in_vec_9[4] = token_17_9;
    assign in_chan_dep_vld_vec_9[5] = dep_chan_vld_18_9;
    assign in_chan_dep_data_vec_9[329 : 275] = dep_chan_data_18_9;
    assign token_in_vec_9[5] = token_18_9;
    assign dep_chan_vld_9_8 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_8 = out_chan_dep_data_9;
    assign token_9_8 = token_out_vec_9[0];
    assign dep_chan_vld_9_1 = out_chan_dep_vld_vec_9[1];
    assign dep_chan_data_9_1 = out_chan_dep_data_9;
    assign token_9_1 = token_out_vec_9[1];
    assign dep_chan_vld_9_15 = out_chan_dep_vld_vec_9[2];
    assign dep_chan_data_9_15 = out_chan_dep_data_9;
    assign token_9_15 = token_out_vec_9[2];
    assign dep_chan_vld_9_6 = out_chan_dep_vld_vec_9[3];
    assign dep_chan_data_9_6 = out_chan_dep_data_9;
    assign token_9_6 = token_out_vec_9[3];
    assign dep_chan_vld_9_17 = out_chan_dep_vld_vec_9[4];
    assign dep_chan_data_9_17 = out_chan_dep_data_9;
    assign token_9_17 = token_out_vec_9[4];
    assign dep_chan_vld_9_18 = out_chan_dep_vld_vec_9[5];
    assign dep_chan_data_9_18 = out_chan_dep_data_9;
    assign token_9_18 = token_out_vec_9[5];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 10, 5, 5) synthesis_top_hls_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n);
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0;
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0;
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    assign proc_10_data_FIFO_blk[1] = 1'b0;
    assign proc_10_data_PIPO_blk[1] = 1'b0;
    assign proc_10_start_FIFO_blk[1] = 1'b0;
    assign proc_10_TLF_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_done & ap_done_reg_0 & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_read);
    assign proc_10_input_sync_blk[1] = 1'b0;
    assign proc_10_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_10[1] = dl_detect_out ? proc_dep_vld_vec_10_reg[1] : (proc_10_data_FIFO_blk[1] | proc_10_data_PIPO_blk[1] | proc_10_start_FIFO_blk[1] | proc_10_TLF_FIFO_blk[1] | proc_10_input_sync_blk[1] | proc_10_output_sync_blk[1]);
    assign proc_10_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n);
    assign proc_10_data_PIPO_blk[2] = 1'b0;
    assign proc_10_start_FIFO_blk[2] = 1'b0;
    assign proc_10_TLF_FIFO_blk[2] = 1'b0;
    assign proc_10_input_sync_blk[2] = 1'b0;
    assign proc_10_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_10[2] = dl_detect_out ? proc_dep_vld_vec_10_reg[2] : (proc_10_data_FIFO_blk[2] | proc_10_data_PIPO_blk[2] | proc_10_start_FIFO_blk[2] | proc_10_TLF_FIFO_blk[2] | proc_10_input_sync_blk[2] | proc_10_output_sync_blk[2]);
    assign proc_10_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n);
    assign proc_10_data_PIPO_blk[3] = 1'b0;
    assign proc_10_start_FIFO_blk[3] = 1'b0;
    assign proc_10_TLF_FIFO_blk[3] = 1'b0;
    assign proc_10_input_sync_blk[3] = 1'b0;
    assign proc_10_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_10[3] = dl_detect_out ? proc_dep_vld_vec_10_reg[3] : (proc_10_data_FIFO_blk[3] | proc_10_data_PIPO_blk[3] | proc_10_start_FIFO_blk[3] | proc_10_TLF_FIFO_blk[3] | proc_10_input_sync_blk[3] | proc_10_output_sync_blk[3]);
    assign proc_10_data_FIFO_blk[4] = 1'b0;
    assign proc_10_data_PIPO_blk[4] = 1'b0;
    assign proc_10_start_FIFO_blk[4] = 1'b0;
    assign proc_10_TLF_FIFO_blk[4] = 1'b0;
    assign proc_10_input_sync_blk[4] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready);
    assign proc_10_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_10[4] = dl_detect_out ? proc_dep_vld_vec_10_reg[4] : (proc_10_data_FIFO_blk[4] | proc_10_data_PIPO_blk[4] | proc_10_start_FIFO_blk[4] | proc_10_TLF_FIFO_blk[4] | proc_10_input_sync_blk[4] | proc_10_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_6_10;
    assign in_chan_dep_data_vec_10[54 : 0] = dep_chan_data_6_10;
    assign token_in_vec_10[0] = token_6_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[109 : 55] = dep_chan_data_11_10;
    assign token_in_vec_10[1] = token_11_10;
    assign in_chan_dep_vld_vec_10[2] = dep_chan_vld_12_10;
    assign in_chan_dep_data_vec_10[164 : 110] = dep_chan_data_12_10;
    assign token_in_vec_10[2] = token_12_10;
    assign in_chan_dep_vld_vec_10[3] = dep_chan_vld_17_10;
    assign in_chan_dep_data_vec_10[219 : 165] = dep_chan_data_17_10;
    assign token_in_vec_10[3] = token_17_10;
    assign in_chan_dep_vld_vec_10[4] = dep_chan_vld_18_10;
    assign in_chan_dep_data_vec_10[274 : 220] = dep_chan_data_18_10;
    assign token_in_vec_10[4] = token_18_10;
    assign dep_chan_vld_10_6 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_6 = out_chan_dep_data_10;
    assign token_10_6 = token_out_vec_10[0];
    assign dep_chan_vld_10_11 = out_chan_dep_vld_vec_10[1];
    assign dep_chan_data_10_11 = out_chan_dep_data_10;
    assign token_10_11 = token_out_vec_10[1];
    assign dep_chan_vld_10_17 = out_chan_dep_vld_vec_10[2];
    assign dep_chan_data_10_17 = out_chan_dep_data_10;
    assign token_10_17 = token_out_vec_10[2];
    assign dep_chan_vld_10_18 = out_chan_dep_vld_vec_10[3];
    assign dep_chan_data_10_18 = out_chan_dep_data_10;
    assign token_10_18 = token_out_vec_10[3];
    assign dep_chan_vld_10_12 = out_chan_dep_vld_vec_10[4];
    assign dep_chan_data_10_12 = out_chan_dep_data_10;
    assign token_10_12 = token_out_vec_10[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 11, 2, 2) synthesis_top_hls_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0;
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0;
    assign proc_11_TLF_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_write);
    assign proc_11_input_sync_blk[0] = 1'b0;
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.load_c_blk_n);
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0;
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0;
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_10_11;
    assign in_chan_dep_data_vec_11[54 : 0] = dep_chan_data_10_11;
    assign token_in_vec_11[0] = token_10_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_13_11;
    assign in_chan_dep_data_vec_11[109 : 55] = dep_chan_data_13_11;
    assign token_in_vec_11[1] = token_13_11;
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[0];
    assign dep_chan_vld_11_13 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_13 = out_chan_dep_data_11;
    assign token_11_13 = token_out_vec_11[1];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 12, 5, 5) synthesis_top_hls_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0;
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.win_s_2_blk_n);
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_read);
    assign proc_12_TLF_FIFO_blk[1] = 1'b0;
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n);
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0;
    assign proc_12_input_sync_blk[2] = 1'b0;
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    assign proc_12_data_FIFO_blk[3] = 1'b0;
    assign proc_12_data_PIPO_blk[3] = 1'b0;
    assign proc_12_start_FIFO_blk[3] = 1'b0;
    assign proc_12_TLF_FIFO_blk[3] = 1'b0;
    assign proc_12_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready);
    assign proc_12_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_12[3] = dl_detect_out ? proc_dep_vld_vec_12_reg[3] : (proc_12_data_FIFO_blk[3] | proc_12_data_PIPO_blk[3] | proc_12_start_FIFO_blk[3] | proc_12_TLF_FIFO_blk[3] | proc_12_input_sync_blk[3] | proc_12_output_sync_blk[3]);
    assign proc_12_data_FIFO_blk[4] = 1'b0;
    assign proc_12_data_PIPO_blk[4] = 1'b0;
    assign proc_12_start_FIFO_blk[4] = 1'b0;
    assign proc_12_TLF_FIFO_blk[4] = 1'b0;
    assign proc_12_input_sync_blk[4] = 1'b0;
    assign proc_12_output_sync_blk[4] = 1'b0 | (ap_done_reg_10 & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done);
    assign proc_dep_vld_vec_12[4] = dl_detect_out ? proc_dep_vld_vec_12_reg[4] : (proc_12_data_FIFO_blk[4] | proc_12_data_PIPO_blk[4] | proc_12_start_FIFO_blk[4] | proc_12_TLF_FIFO_blk[4] | proc_12_input_sync_blk[4] | proc_12_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_8_12;
    assign in_chan_dep_data_vec_12[54 : 0] = dep_chan_data_8_12;
    assign token_in_vec_12[0] = token_8_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_10_12;
    assign in_chan_dep_data_vec_12[109 : 55] = dep_chan_data_10_12;
    assign token_in_vec_12[1] = token_10_12;
    assign in_chan_dep_vld_vec_12[2] = dep_chan_vld_13_12;
    assign in_chan_dep_data_vec_12[164 : 110] = dep_chan_data_13_12;
    assign token_in_vec_12[2] = token_13_12;
    assign in_chan_dep_vld_vec_12[3] = dep_chan_vld_14_12;
    assign in_chan_dep_data_vec_12[219 : 165] = dep_chan_data_14_12;
    assign token_in_vec_12[3] = token_14_12;
    assign in_chan_dep_vld_vec_12[4] = dep_chan_vld_15_12;
    assign in_chan_dep_data_vec_12[274 : 220] = dep_chan_data_15_12;
    assign token_in_vec_12[4] = token_15_12;
    assign dep_chan_vld_12_8 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_8 = out_chan_dep_data_12;
    assign token_12_8 = token_out_vec_12[0];
    assign dep_chan_vld_12_13 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_13 = out_chan_dep_data_12;
    assign token_12_13 = token_out_vec_12[1];
    assign dep_chan_vld_12_15 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_15 = out_chan_dep_data_12;
    assign token_12_15 = token_out_vec_12[2];
    assign dep_chan_vld_12_10 = out_chan_dep_vld_vec_12[3];
    assign dep_chan_data_12_10 = out_chan_dep_data_12;
    assign token_12_10 = token_out_vec_12[3];
    assign dep_chan_vld_12_14 = out_chan_dep_vld_vec_12[4];
    assign dep_chan_data_12_14 = out_chan_dep_data_12;
    assign token_12_14 = token_out_vec_12[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 13, 4, 4) synthesis_top_hls_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n);
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0;
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0;
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.win_s_2_blk_n);
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_write);
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0;
    assign proc_13_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    assign proc_13_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.load_weights_blk_n);
    assign proc_13_data_PIPO_blk[2] = 1'b0;
    assign proc_13_start_FIFO_blk[2] = 1'b0;
    assign proc_13_TLF_FIFO_blk[2] = 1'b0;
    assign proc_13_input_sync_blk[2] = 1'b0;
    assign proc_13_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_13[2] = dl_detect_out ? proc_dep_vld_vec_13_reg[2] : (proc_13_data_FIFO_blk[2] | proc_13_data_PIPO_blk[2] | proc_13_start_FIFO_blk[2] | proc_13_TLF_FIFO_blk[2] | proc_13_input_sync_blk[2] | proc_13_output_sync_blk[2]);
    assign proc_13_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.out_vec_s_2_blk_n);
    assign proc_13_data_PIPO_blk[3] = 1'b0;
    assign proc_13_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_read);
    assign proc_13_TLF_FIFO_blk[3] = 1'b0;
    assign proc_13_input_sync_blk[3] = 1'b0;
    assign proc_13_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_13[3] = dl_detect_out ? proc_dep_vld_vec_13_reg[3] : (proc_13_data_FIFO_blk[3] | proc_13_data_PIPO_blk[3] | proc_13_start_FIFO_blk[3] | proc_13_TLF_FIFO_blk[3] | proc_13_input_sync_blk[3] | proc_13_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_1_13;
    assign in_chan_dep_data_vec_13[54 : 0] = dep_chan_data_1_13;
    assign token_in_vec_13[0] = token_1_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_11_13;
    assign in_chan_dep_data_vec_13[109 : 55] = dep_chan_data_11_13;
    assign token_in_vec_13[1] = token_11_13;
    assign in_chan_dep_vld_vec_13[2] = dep_chan_vld_12_13;
    assign in_chan_dep_data_vec_13[164 : 110] = dep_chan_data_12_13;
    assign token_in_vec_13[2] = token_12_13;
    assign in_chan_dep_vld_vec_13[3] = dep_chan_vld_14_13;
    assign in_chan_dep_data_vec_13[219 : 165] = dep_chan_data_14_13;
    assign token_in_vec_13[3] = token_14_13;
    assign dep_chan_vld_13_1 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_1 = out_chan_dep_data_13;
    assign token_13_1 = token_out_vec_13[0];
    assign dep_chan_vld_13_12 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_12 = out_chan_dep_data_13;
    assign token_13_12 = token_out_vec_13[1];
    assign dep_chan_vld_13_11 = out_chan_dep_vld_vec_13[2];
    assign dep_chan_data_13_11 = out_chan_dep_data_13;
    assign token_13_11 = token_out_vec_13[2];
    assign dep_chan_vld_13_14 = out_chan_dep_vld_vec_13[3];
    assign dep_chan_data_13_14 = out_chan_dep_data_13;
    assign token_13_14 = token_out_vec_13[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 14, 3, 3) synthesis_top_hls_deadlock_detect_unit_14 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_14),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_14),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_14),
        .token_in_vec(token_in_vec_14),
        .dl_detect_in(dl_detect_out),
        .origin(origin[14]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_14),
        .out_chan_dep_data(out_chan_dep_data_14),
        .token_out_vec(token_out_vec_14),
        .dl_detect_out(dl_in_vec[14]));

    assign proc_14_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n);
    assign proc_14_data_PIPO_blk[0] = 1'b0;
    assign proc_14_start_FIFO_blk[0] = 1'b0;
    assign proc_14_TLF_FIFO_blk[0] = 1'b0;
    assign proc_14_input_sync_blk[0] = 1'b0;
    assign proc_14_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_14[0] = dl_detect_out ? proc_dep_vld_vec_14_reg[0] : (proc_14_data_FIFO_blk[0] | proc_14_data_PIPO_blk[0] | proc_14_start_FIFO_blk[0] | proc_14_TLF_FIFO_blk[0] | proc_14_input_sync_blk[0] | proc_14_output_sync_blk[0]);
    assign proc_14_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.out_vec_s_2_blk_n);
    assign proc_14_data_PIPO_blk[1] = 1'b0;
    assign proc_14_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_write);
    assign proc_14_TLF_FIFO_blk[1] = 1'b0;
    assign proc_14_input_sync_blk[1] = 1'b0;
    assign proc_14_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_14[1] = dl_detect_out ? proc_dep_vld_vec_14_reg[1] : (proc_14_data_FIFO_blk[1] | proc_14_data_PIPO_blk[1] | proc_14_start_FIFO_blk[1] | proc_14_TLF_FIFO_blk[1] | proc_14_input_sync_blk[1] | proc_14_output_sync_blk[1]);
    assign proc_14_data_FIFO_blk[2] = 1'b0;
    assign proc_14_data_PIPO_blk[2] = 1'b0;
    assign proc_14_start_FIFO_blk[2] = 1'b0;
    assign proc_14_TLF_FIFO_blk[2] = 1'b0;
    assign proc_14_input_sync_blk[2] = 1'b0;
    assign proc_14_output_sync_blk[2] = 1'b0 | (ap_done_reg_11 & compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done);
    assign proc_dep_vld_vec_14[2] = dl_detect_out ? proc_dep_vld_vec_14_reg[2] : (proc_14_data_FIFO_blk[2] | proc_14_data_PIPO_blk[2] | proc_14_start_FIFO_blk[2] | proc_14_TLF_FIFO_blk[2] | proc_14_input_sync_blk[2] | proc_14_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_14_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_14_reg <= proc_dep_vld_vec_14;
        end
    end
    assign in_chan_dep_vld_vec_14[0] = dep_chan_vld_12_14;
    assign in_chan_dep_data_vec_14[54 : 0] = dep_chan_data_12_14;
    assign token_in_vec_14[0] = token_12_14;
    assign in_chan_dep_vld_vec_14[1] = dep_chan_vld_13_14;
    assign in_chan_dep_data_vec_14[109 : 55] = dep_chan_data_13_14;
    assign token_in_vec_14[1] = token_13_14;
    assign in_chan_dep_vld_vec_14[2] = dep_chan_vld_15_14;
    assign in_chan_dep_data_vec_14[164 : 110] = dep_chan_data_15_14;
    assign token_in_vec_14[2] = token_15_14;
    assign dep_chan_vld_14_15 = out_chan_dep_vld_vec_14[0];
    assign dep_chan_data_14_15 = out_chan_dep_data_14;
    assign token_14_15 = token_out_vec_14[0];
    assign dep_chan_vld_14_13 = out_chan_dep_vld_vec_14[1];
    assign dep_chan_data_14_13 = out_chan_dep_data_14;
    assign token_14_13 = token_out_vec_14[1];
    assign dep_chan_vld_14_12 = out_chan_dep_vld_vec_14[2];
    assign dep_chan_data_14_12 = out_chan_dep_data_14;
    assign token_14_12 = token_out_vec_14[2];

    // Process: compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 15, 4, 4) synthesis_top_hls_deadlock_detect_unit_15 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_15),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_15),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_15),
        .token_in_vec(token_in_vec_15),
        .dl_detect_in(dl_detect_out),
        .origin(origin[15]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_15),
        .out_chan_dep_data(out_chan_dep_data_15),
        .token_out_vec(token_out_vec_15),
        .dl_detect_out(dl_in_vec[15]));

    assign proc_15_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n) | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_15_data_PIPO_blk[0] = 1'b0;
    assign proc_15_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_write);
    assign proc_15_TLF_FIFO_blk[0] = 1'b0;
    assign proc_15_input_sync_blk[0] = 1'b0;
    assign proc_15_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_15[0] = dl_detect_out ? proc_dep_vld_vec_15_reg[0] : (proc_15_data_FIFO_blk[0] | proc_15_data_PIPO_blk[0] | proc_15_start_FIFO_blk[0] | proc_15_TLF_FIFO_blk[0] | proc_15_input_sync_blk[0] | proc_15_output_sync_blk[0]);
    assign proc_15_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n);
    assign proc_15_data_PIPO_blk[1] = 1'b0;
    assign proc_15_start_FIFO_blk[1] = 1'b0;
    assign proc_15_TLF_FIFO_blk[1] = 1'b0;
    assign proc_15_input_sync_blk[1] = 1'b0;
    assign proc_15_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_15[1] = dl_detect_out ? proc_dep_vld_vec_15_reg[1] : (proc_15_data_FIFO_blk[1] | proc_15_data_PIPO_blk[1] | proc_15_start_FIFO_blk[1] | proc_15_TLF_FIFO_blk[1] | proc_15_input_sync_blk[1] | proc_15_output_sync_blk[1]);
    assign proc_15_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_pool1_blk_n) | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c14_blk_n);
    assign proc_15_data_PIPO_blk[2] = 1'b0;
    assign proc_15_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_read);
    assign proc_15_TLF_FIFO_blk[2] = 1'b0;
    assign proc_15_input_sync_blk[2] = 1'b0;
    assign proc_15_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_15[2] = dl_detect_out ? proc_dep_vld_vec_15_reg[2] : (proc_15_data_FIFO_blk[2] | proc_15_data_PIPO_blk[2] | proc_15_start_FIFO_blk[2] | proc_15_TLF_FIFO_blk[2] | proc_15_input_sync_blk[2] | proc_15_output_sync_blk[2]);
    assign proc_15_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_15_data_PIPO_blk[3] = 1'b0;
    assign proc_15_start_FIFO_blk[3] = 1'b0;
    assign proc_15_TLF_FIFO_blk[3] = 1'b0;
    assign proc_15_input_sync_blk[3] = 1'b0;
    assign proc_15_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_15[3] = dl_detect_out ? proc_dep_vld_vec_15_reg[3] : (proc_15_data_FIFO_blk[3] | proc_15_data_PIPO_blk[3] | proc_15_start_FIFO_blk[3] | proc_15_TLF_FIFO_blk[3] | proc_15_input_sync_blk[3] | proc_15_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_15_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_15_reg <= proc_dep_vld_vec_15;
        end
    end
    assign in_chan_dep_vld_vec_15[0] = dep_chan_vld_9_15;
    assign in_chan_dep_data_vec_15[54 : 0] = dep_chan_data_9_15;
    assign token_in_vec_15[0] = token_9_15;
    assign in_chan_dep_vld_vec_15[1] = dep_chan_vld_12_15;
    assign in_chan_dep_data_vec_15[109 : 55] = dep_chan_data_12_15;
    assign token_in_vec_15[1] = token_12_15;
    assign in_chan_dep_vld_vec_15[2] = dep_chan_vld_14_15;
    assign in_chan_dep_data_vec_15[164 : 110] = dep_chan_data_14_15;
    assign token_in_vec_15[2] = token_14_15;
    assign in_chan_dep_vld_vec_15[3] = dep_chan_vld_16_15;
    assign in_chan_dep_data_vec_15[219 : 165] = dep_chan_data_16_15;
    assign token_in_vec_15[3] = token_16_15;
    assign dep_chan_vld_15_9 = out_chan_dep_vld_vec_15[0];
    assign dep_chan_data_15_9 = out_chan_dep_data_15;
    assign token_15_9 = token_out_vec_15[0];
    assign dep_chan_vld_15_14 = out_chan_dep_vld_vec_15[1];
    assign dep_chan_data_15_14 = out_chan_dep_data_15;
    assign token_15_14 = token_out_vec_15[1];
    assign dep_chan_vld_15_16 = out_chan_dep_vld_vec_15[2];
    assign dep_chan_data_15_16 = out_chan_dep_data_15;
    assign token_15_16 = token_out_vec_15[2];
    assign dep_chan_vld_15_12 = out_chan_dep_vld_vec_15[3];
    assign dep_chan_data_15_12 = out_chan_dep_data_15;
    assign token_15_12 = token_out_vec_15[3];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 16, 3, 3) synthesis_top_hls_deadlock_detect_unit_16 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_16),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_16),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_16),
        .token_in_vec(token_in_vec_16),
        .dl_detect_in(dl_detect_out),
        .origin(origin[16]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_16),
        .out_chan_dep_data(out_chan_dep_data_16),
        .token_out_vec(token_out_vec_16),
        .dl_detect_out(dl_in_vec[16]));

    assign proc_16_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l2_pool1_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.reps_blk_n);
    assign proc_16_data_PIPO_blk[0] = 1'b0;
    assign proc_16_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_write);
    assign proc_16_TLF_FIFO_blk[0] = 1'b0;
    assign proc_16_input_sync_blk[0] = 1'b0;
    assign proc_16_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_16[0] = dl_detect_out ? proc_dep_vld_vec_16_reg[0] : (proc_16_data_FIFO_blk[0] | proc_16_data_PIPO_blk[0] | proc_16_start_FIFO_blk[0] | proc_16_TLF_FIFO_blk[0] | proc_16_input_sync_blk[0] | proc_16_output_sync_blk[0]);
    assign proc_16_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n);
    assign proc_16_data_PIPO_blk[1] = 1'b0;
    assign proc_16_start_FIFO_blk[1] = 1'b0;
    assign proc_16_TLF_FIFO_blk[1] = 1'b0;
    assign proc_16_input_sync_blk[1] = 1'b0;
    assign proc_16_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_16[1] = dl_detect_out ? proc_dep_vld_vec_16_reg[1] : (proc_16_data_FIFO_blk[1] | proc_16_data_PIPO_blk[1] | proc_16_start_FIFO_blk[1] | proc_16_TLF_FIFO_blk[1] | proc_16_input_sync_blk[1] | proc_16_output_sync_blk[1]);
    assign proc_16_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n);
    assign proc_16_data_PIPO_blk[2] = 1'b0;
    assign proc_16_start_FIFO_blk[2] = 1'b0;
    assign proc_16_TLF_FIFO_blk[2] = 1'b0;
    assign proc_16_input_sync_blk[2] = 1'b0;
    assign proc_16_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_16[2] = dl_detect_out ? proc_dep_vld_vec_16_reg[2] : (proc_16_data_FIFO_blk[2] | proc_16_data_PIPO_blk[2] | proc_16_start_FIFO_blk[2] | proc_16_TLF_FIFO_blk[2] | proc_16_input_sync_blk[2] | proc_16_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_16_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_16_reg <= proc_dep_vld_vec_16;
        end
    end
    assign in_chan_dep_vld_vec_16[0] = dep_chan_vld_15_16;
    assign in_chan_dep_data_vec_16[54 : 0] = dep_chan_data_15_16;
    assign token_in_vec_16[0] = token_15_16;
    assign in_chan_dep_vld_vec_16[1] = dep_chan_vld_17_16;
    assign in_chan_dep_data_vec_16[109 : 55] = dep_chan_data_17_16;
    assign token_in_vec_16[1] = token_17_16;
    assign in_chan_dep_vld_vec_16[2] = dep_chan_vld_20_16;
    assign in_chan_dep_data_vec_16[164 : 110] = dep_chan_data_20_16;
    assign token_in_vec_16[2] = token_20_16;
    assign dep_chan_vld_16_15 = out_chan_dep_vld_vec_16[0];
    assign dep_chan_data_16_15 = out_chan_dep_data_16;
    assign token_16_15 = token_out_vec_16[0];
    assign dep_chan_vld_16_17 = out_chan_dep_vld_vec_16[1];
    assign dep_chan_data_16_17 = out_chan_dep_data_16;
    assign token_16_17 = token_out_vec_16[1];
    assign dep_chan_vld_16_20 = out_chan_dep_vld_vec_16[2];
    assign dep_chan_data_16_20 = out_chan_dep_data_16;
    assign token_16_20 = token_out_vec_16[2];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 17, 7, 7) synthesis_top_hls_deadlock_detect_unit_17 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_17),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_17),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_17),
        .token_in_vec(token_in_vec_17),
        .dl_detect_in(dl_detect_out),
        .origin(origin[17]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_17),
        .out_chan_dep_data(out_chan_dep_data_17),
        .token_out_vec(token_out_vec_17),
        .dl_detect_out(dl_in_vec[17]));

    assign proc_17_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n);
    assign proc_17_data_PIPO_blk[0] = 1'b0;
    assign proc_17_start_FIFO_blk[0] = 1'b0;
    assign proc_17_TLF_FIFO_blk[0] = 1'b0;
    assign proc_17_input_sync_blk[0] = 1'b0;
    assign proc_17_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_17[0] = dl_detect_out ? proc_dep_vld_vec_17_reg[0] : (proc_17_data_FIFO_blk[0] | proc_17_data_PIPO_blk[0] | proc_17_start_FIFO_blk[0] | proc_17_TLF_FIFO_blk[0] | proc_17_input_sync_blk[0] | proc_17_output_sync_blk[0]);
    assign proc_17_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n);
    assign proc_17_data_PIPO_blk[1] = 1'b0;
    assign proc_17_start_FIFO_blk[1] = 1'b0;
    assign proc_17_TLF_FIFO_blk[1] = 1'b0;
    assign proc_17_input_sync_blk[1] = 1'b0;
    assign proc_17_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_17[1] = dl_detect_out ? proc_dep_vld_vec_17_reg[1] : (proc_17_data_FIFO_blk[1] | proc_17_data_PIPO_blk[1] | proc_17_start_FIFO_blk[1] | proc_17_TLF_FIFO_blk[1] | proc_17_input_sync_blk[1] | proc_17_output_sync_blk[1]);
    assign proc_17_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n);
    assign proc_17_data_PIPO_blk[2] = 1'b0;
    assign proc_17_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read);
    assign proc_17_TLF_FIFO_blk[2] = 1'b0;
    assign proc_17_input_sync_blk[2] = 1'b0;
    assign proc_17_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_17[2] = dl_detect_out ? proc_dep_vld_vec_17_reg[2] : (proc_17_data_FIFO_blk[2] | proc_17_data_PIPO_blk[2] | proc_17_start_FIFO_blk[2] | proc_17_TLF_FIFO_blk[2] | proc_17_input_sync_blk[2] | proc_17_output_sync_blk[2]);
    assign proc_17_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n);
    assign proc_17_data_PIPO_blk[3] = 1'b0;
    assign proc_17_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_write);
    assign proc_17_TLF_FIFO_blk[3] = 1'b0;
    assign proc_17_input_sync_blk[3] = 1'b0;
    assign proc_17_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_17[3] = dl_detect_out ? proc_dep_vld_vec_17_reg[3] : (proc_17_data_FIFO_blk[3] | proc_17_data_PIPO_blk[3] | proc_17_start_FIFO_blk[3] | proc_17_TLF_FIFO_blk[3] | proc_17_input_sync_blk[3] | proc_17_output_sync_blk[3]);
    assign proc_17_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n);
    assign proc_17_data_PIPO_blk[4] = 1'b0;
    assign proc_17_start_FIFO_blk[4] = 1'b0;
    assign proc_17_TLF_FIFO_blk[4] = 1'b0;
    assign proc_17_input_sync_blk[4] = 1'b0;
    assign proc_17_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_17[4] = dl_detect_out ? proc_dep_vld_vec_17_reg[4] : (proc_17_data_FIFO_blk[4] | proc_17_data_PIPO_blk[4] | proc_17_start_FIFO_blk[4] | proc_17_TLF_FIFO_blk[4] | proc_17_input_sync_blk[4] | proc_17_output_sync_blk[4]);
    assign proc_17_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n);
    assign proc_17_data_PIPO_blk[5] = 1'b0;
    assign proc_17_start_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_read);
    assign proc_17_TLF_FIFO_blk[5] = 1'b0;
    assign proc_17_input_sync_blk[5] = 1'b0;
    assign proc_17_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_17[5] = dl_detect_out ? proc_dep_vld_vec_17_reg[5] : (proc_17_data_FIFO_blk[5] | proc_17_data_PIPO_blk[5] | proc_17_start_FIFO_blk[5] | proc_17_TLF_FIFO_blk[5] | proc_17_input_sync_blk[5] | proc_17_output_sync_blk[5]);
    assign proc_17_data_FIFO_blk[6] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n);
    assign proc_17_data_PIPO_blk[6] = 1'b0;
    assign proc_17_start_FIFO_blk[6] = 1'b0;
    assign proc_17_TLF_FIFO_blk[6] = 1'b0;
    assign proc_17_input_sync_blk[6] = 1'b0;
    assign proc_17_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_17[6] = dl_detect_out ? proc_dep_vld_vec_17_reg[6] : (proc_17_data_FIFO_blk[6] | proc_17_data_PIPO_blk[6] | proc_17_start_FIFO_blk[6] | proc_17_TLF_FIFO_blk[6] | proc_17_input_sync_blk[6] | proc_17_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_17_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_17_reg <= proc_dep_vld_vec_17;
        end
    end
    assign in_chan_dep_vld_vec_17[0] = dep_chan_vld_1_17;
    assign in_chan_dep_data_vec_17[54 : 0] = dep_chan_data_1_17;
    assign token_in_vec_17[0] = token_1_17;
    assign in_chan_dep_vld_vec_17[1] = dep_chan_vld_9_17;
    assign in_chan_dep_data_vec_17[109 : 55] = dep_chan_data_9_17;
    assign token_in_vec_17[1] = token_9_17;
    assign in_chan_dep_vld_vec_17[2] = dep_chan_vld_10_17;
    assign in_chan_dep_data_vec_17[164 : 110] = dep_chan_data_10_17;
    assign token_in_vec_17[2] = token_10_17;
    assign in_chan_dep_vld_vec_17[3] = dep_chan_vld_16_17;
    assign in_chan_dep_data_vec_17[219 : 165] = dep_chan_data_16_17;
    assign token_in_vec_17[3] = token_16_17;
    assign in_chan_dep_vld_vec_17[4] = dep_chan_vld_23_17;
    assign in_chan_dep_data_vec_17[274 : 220] = dep_chan_data_23_17;
    assign token_in_vec_17[4] = token_23_17;
    assign in_chan_dep_vld_vec_17[5] = dep_chan_vld_25_17;
    assign in_chan_dep_data_vec_17[329 : 275] = dep_chan_data_25_17;
    assign token_in_vec_17[5] = token_25_17;
    assign in_chan_dep_vld_vec_17[6] = dep_chan_vld_26_17;
    assign in_chan_dep_data_vec_17[384 : 330] = dep_chan_data_26_17;
    assign token_in_vec_17[6] = token_26_17;
    assign dep_chan_vld_17_16 = out_chan_dep_vld_vec_17[0];
    assign dep_chan_data_17_16 = out_chan_dep_data_17;
    assign token_17_16 = token_out_vec_17[0];
    assign dep_chan_vld_17_1 = out_chan_dep_vld_vec_17[1];
    assign dep_chan_data_17_1 = out_chan_dep_data_17;
    assign token_17_1 = token_out_vec_17[1];
    assign dep_chan_vld_17_23 = out_chan_dep_vld_vec_17[2];
    assign dep_chan_data_17_23 = out_chan_dep_data_17;
    assign token_17_23 = token_out_vec_17[2];
    assign dep_chan_vld_17_9 = out_chan_dep_vld_vec_17[3];
    assign dep_chan_data_17_9 = out_chan_dep_data_17;
    assign token_17_9 = token_out_vec_17[3];
    assign dep_chan_vld_17_10 = out_chan_dep_vld_vec_17[4];
    assign dep_chan_data_17_10 = out_chan_dep_data_17;
    assign token_17_10 = token_out_vec_17[4];
    assign dep_chan_vld_17_25 = out_chan_dep_vld_vec_17[5];
    assign dep_chan_data_17_25 = out_chan_dep_data_17;
    assign token_17_25 = token_out_vec_17[5];
    assign dep_chan_vld_17_26 = out_chan_dep_vld_vec_17[6];
    assign dep_chan_data_17_26 = out_chan_dep_data_17;
    assign token_17_26 = token_out_vec_17[6];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 18, 6, 6) synthesis_top_hls_deadlock_detect_unit_18 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_18),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_18),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_18),
        .token_in_vec(token_in_vec_18),
        .dl_detect_in(dl_detect_out),
        .origin(origin[18]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_18),
        .out_chan_dep_data(out_chan_dep_data_18),
        .token_out_vec(token_out_vec_18),
        .dl_detect_out(dl_in_vec[18]));

    assign proc_18_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n);
    assign proc_18_data_PIPO_blk[0] = 1'b0;
    assign proc_18_start_FIFO_blk[0] = 1'b0;
    assign proc_18_TLF_FIFO_blk[0] = 1'b0;
    assign proc_18_input_sync_blk[0] = 1'b0;
    assign proc_18_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_18[0] = dl_detect_out ? proc_dep_vld_vec_18_reg[0] : (proc_18_data_FIFO_blk[0] | proc_18_data_PIPO_blk[0] | proc_18_start_FIFO_blk[0] | proc_18_TLF_FIFO_blk[0] | proc_18_input_sync_blk[0] | proc_18_output_sync_blk[0]);
    assign proc_18_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n);
    assign proc_18_data_PIPO_blk[1] = 1'b0;
    assign proc_18_start_FIFO_blk[1] = 1'b0;
    assign proc_18_TLF_FIFO_blk[1] = 1'b0;
    assign proc_18_input_sync_blk[1] = 1'b0;
    assign proc_18_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_18[1] = dl_detect_out ? proc_dep_vld_vec_18_reg[1] : (proc_18_data_FIFO_blk[1] | proc_18_data_PIPO_blk[1] | proc_18_start_FIFO_blk[1] | proc_18_TLF_FIFO_blk[1] | proc_18_input_sync_blk[1] | proc_18_output_sync_blk[1]);
    assign proc_18_data_FIFO_blk[2] = 1'b0;
    assign proc_18_data_PIPO_blk[2] = 1'b0;
    assign proc_18_start_FIFO_blk[2] = 1'b0;
    assign proc_18_TLF_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_done & ap_done_reg_2 & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_read);
    assign proc_18_input_sync_blk[2] = 1'b0;
    assign proc_18_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_18[2] = dl_detect_out ? proc_dep_vld_vec_18_reg[2] : (proc_18_data_FIFO_blk[2] | proc_18_data_PIPO_blk[2] | proc_18_start_FIFO_blk[2] | proc_18_TLF_FIFO_blk[2] | proc_18_input_sync_blk[2] | proc_18_output_sync_blk[2]);
    assign proc_18_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n);
    assign proc_18_data_PIPO_blk[3] = 1'b0;
    assign proc_18_start_FIFO_blk[3] = 1'b0;
    assign proc_18_TLF_FIFO_blk[3] = 1'b0;
    assign proc_18_input_sync_blk[3] = 1'b0;
    assign proc_18_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_18[3] = dl_detect_out ? proc_dep_vld_vec_18_reg[3] : (proc_18_data_FIFO_blk[3] | proc_18_data_PIPO_blk[3] | proc_18_start_FIFO_blk[3] | proc_18_TLF_FIFO_blk[3] | proc_18_input_sync_blk[3] | proc_18_output_sync_blk[3]);
    assign proc_18_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n);
    assign proc_18_data_PIPO_blk[4] = 1'b0;
    assign proc_18_start_FIFO_blk[4] = 1'b0;
    assign proc_18_TLF_FIFO_blk[4] = 1'b0;
    assign proc_18_input_sync_blk[4] = 1'b0;
    assign proc_18_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_18[4] = dl_detect_out ? proc_dep_vld_vec_18_reg[4] : (proc_18_data_FIFO_blk[4] | proc_18_data_PIPO_blk[4] | proc_18_start_FIFO_blk[4] | proc_18_TLF_FIFO_blk[4] | proc_18_input_sync_blk[4] | proc_18_output_sync_blk[4]);
    assign proc_18_data_FIFO_blk[5] = 1'b0;
    assign proc_18_data_PIPO_blk[5] = 1'b0;
    assign proc_18_start_FIFO_blk[5] = 1'b0;
    assign proc_18_TLF_FIFO_blk[5] = 1'b0;
    assign proc_18_input_sync_blk[5] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready);
    assign proc_18_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_18[5] = dl_detect_out ? proc_dep_vld_vec_18_reg[5] : (proc_18_data_FIFO_blk[5] | proc_18_data_PIPO_blk[5] | proc_18_start_FIFO_blk[5] | proc_18_TLF_FIFO_blk[5] | proc_18_input_sync_blk[5] | proc_18_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_18_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_18_reg <= proc_dep_vld_vec_18;
        end
    end
    assign in_chan_dep_vld_vec_18[0] = dep_chan_vld_9_18;
    assign in_chan_dep_data_vec_18[54 : 0] = dep_chan_data_9_18;
    assign token_in_vec_18[0] = token_9_18;
    assign in_chan_dep_vld_vec_18[1] = dep_chan_vld_10_18;
    assign in_chan_dep_data_vec_18[109 : 55] = dep_chan_data_10_18;
    assign token_in_vec_18[1] = token_10_18;
    assign in_chan_dep_vld_vec_18[2] = dep_chan_vld_19_18;
    assign in_chan_dep_data_vec_18[164 : 110] = dep_chan_data_19_18;
    assign token_in_vec_18[2] = token_19_18;
    assign in_chan_dep_vld_vec_18[3] = dep_chan_vld_20_18;
    assign in_chan_dep_data_vec_18[219 : 165] = dep_chan_data_20_18;
    assign token_in_vec_18[3] = token_20_18;
    assign in_chan_dep_vld_vec_18[4] = dep_chan_vld_25_18;
    assign in_chan_dep_data_vec_18[274 : 220] = dep_chan_data_25_18;
    assign token_in_vec_18[4] = token_25_18;
    assign in_chan_dep_vld_vec_18[5] = dep_chan_vld_26_18;
    assign in_chan_dep_data_vec_18[329 : 275] = dep_chan_data_26_18;
    assign token_in_vec_18[5] = token_26_18;
    assign dep_chan_vld_18_9 = out_chan_dep_vld_vec_18[0];
    assign dep_chan_data_18_9 = out_chan_dep_data_18;
    assign token_18_9 = token_out_vec_18[0];
    assign dep_chan_vld_18_10 = out_chan_dep_vld_vec_18[1];
    assign dep_chan_data_18_10 = out_chan_dep_data_18;
    assign token_18_10 = token_out_vec_18[1];
    assign dep_chan_vld_18_19 = out_chan_dep_vld_vec_18[2];
    assign dep_chan_data_18_19 = out_chan_dep_data_18;
    assign token_18_19 = token_out_vec_18[2];
    assign dep_chan_vld_18_25 = out_chan_dep_vld_vec_18[3];
    assign dep_chan_data_18_25 = out_chan_dep_data_18;
    assign token_18_25 = token_out_vec_18[3];
    assign dep_chan_vld_18_26 = out_chan_dep_vld_vec_18[4];
    assign dep_chan_data_18_26 = out_chan_dep_data_18;
    assign token_18_26 = token_out_vec_18[4];
    assign dep_chan_vld_18_20 = out_chan_dep_vld_vec_18[5];
    assign dep_chan_data_18_20 = out_chan_dep_data_18;
    assign token_18_20 = token_out_vec_18[5];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 19, 2, 2) synthesis_top_hls_deadlock_detect_unit_19 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_19),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_19),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_19),
        .token_in_vec(token_in_vec_19),
        .dl_detect_in(dl_detect_out),
        .origin(origin[19]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_19),
        .out_chan_dep_data(out_chan_dep_data_19),
        .token_out_vec(token_out_vec_19),
        .dl_detect_out(dl_in_vec[19]));

    assign proc_19_data_FIFO_blk[0] = 1'b0;
    assign proc_19_data_PIPO_blk[0] = 1'b0;
    assign proc_19_start_FIFO_blk[0] = 1'b0;
    assign proc_19_TLF_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_write);
    assign proc_19_input_sync_blk[0] = 1'b0;
    assign proc_19_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_19[0] = dl_detect_out ? proc_dep_vld_vec_19_reg[0] : (proc_19_data_FIFO_blk[0] | proc_19_data_PIPO_blk[0] | proc_19_start_FIFO_blk[0] | proc_19_TLF_FIFO_blk[0] | proc_19_input_sync_blk[0] | proc_19_output_sync_blk[0]);
    assign proc_19_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.load_c_blk_n);
    assign proc_19_data_PIPO_blk[1] = 1'b0;
    assign proc_19_start_FIFO_blk[1] = 1'b0;
    assign proc_19_TLF_FIFO_blk[1] = 1'b0;
    assign proc_19_input_sync_blk[1] = 1'b0;
    assign proc_19_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_19[1] = dl_detect_out ? proc_dep_vld_vec_19_reg[1] : (proc_19_data_FIFO_blk[1] | proc_19_data_PIPO_blk[1] | proc_19_start_FIFO_blk[1] | proc_19_TLF_FIFO_blk[1] | proc_19_input_sync_blk[1] | proc_19_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_19_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_19_reg <= proc_dep_vld_vec_19;
        end
    end
    assign in_chan_dep_vld_vec_19[0] = dep_chan_vld_18_19;
    assign in_chan_dep_data_vec_19[54 : 0] = dep_chan_data_18_19;
    assign token_in_vec_19[0] = token_18_19;
    assign in_chan_dep_vld_vec_19[1] = dep_chan_vld_21_19;
    assign in_chan_dep_data_vec_19[109 : 55] = dep_chan_data_21_19;
    assign token_in_vec_19[1] = token_21_19;
    assign dep_chan_vld_19_18 = out_chan_dep_vld_vec_19[0];
    assign dep_chan_data_19_18 = out_chan_dep_data_19;
    assign token_19_18 = token_out_vec_19[0];
    assign dep_chan_vld_19_21 = out_chan_dep_vld_vec_19[1];
    assign dep_chan_data_19_21 = out_chan_dep_data_19;
    assign token_19_21 = token_out_vec_19[1];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 20, 5, 5) synthesis_top_hls_deadlock_detect_unit_20 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_20),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_20),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_20),
        .token_in_vec(token_in_vec_20),
        .dl_detect_in(dl_detect_out),
        .origin(origin[20]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_20),
        .out_chan_dep_data(out_chan_dep_data_20),
        .token_out_vec(token_out_vec_20),
        .dl_detect_out(dl_in_vec[20]));

    assign proc_20_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n);
    assign proc_20_data_PIPO_blk[0] = 1'b0;
    assign proc_20_start_FIFO_blk[0] = 1'b0;
    assign proc_20_TLF_FIFO_blk[0] = 1'b0;
    assign proc_20_input_sync_blk[0] = 1'b0;
    assign proc_20_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_20[0] = dl_detect_out ? proc_dep_vld_vec_20_reg[0] : (proc_20_data_FIFO_blk[0] | proc_20_data_PIPO_blk[0] | proc_20_start_FIFO_blk[0] | proc_20_TLF_FIFO_blk[0] | proc_20_input_sync_blk[0] | proc_20_output_sync_blk[0]);
    assign proc_20_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.win_s_5_blk_n);
    assign proc_20_data_PIPO_blk[1] = 1'b0;
    assign proc_20_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_read);
    assign proc_20_TLF_FIFO_blk[1] = 1'b0;
    assign proc_20_input_sync_blk[1] = 1'b0;
    assign proc_20_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_20[1] = dl_detect_out ? proc_dep_vld_vec_20_reg[1] : (proc_20_data_FIFO_blk[1] | proc_20_data_PIPO_blk[1] | proc_20_start_FIFO_blk[1] | proc_20_TLF_FIFO_blk[1] | proc_20_input_sync_blk[1] | proc_20_output_sync_blk[1]);
    assign proc_20_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n);
    assign proc_20_data_PIPO_blk[2] = 1'b0;
    assign proc_20_start_FIFO_blk[2] = 1'b0;
    assign proc_20_TLF_FIFO_blk[2] = 1'b0;
    assign proc_20_input_sync_blk[2] = 1'b0;
    assign proc_20_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_20[2] = dl_detect_out ? proc_dep_vld_vec_20_reg[2] : (proc_20_data_FIFO_blk[2] | proc_20_data_PIPO_blk[2] | proc_20_start_FIFO_blk[2] | proc_20_TLF_FIFO_blk[2] | proc_20_input_sync_blk[2] | proc_20_output_sync_blk[2]);
    assign proc_20_data_FIFO_blk[3] = 1'b0;
    assign proc_20_data_PIPO_blk[3] = 1'b0;
    assign proc_20_start_FIFO_blk[3] = 1'b0;
    assign proc_20_TLF_FIFO_blk[3] = 1'b0;
    assign proc_20_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready);
    assign proc_20_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_20[3] = dl_detect_out ? proc_dep_vld_vec_20_reg[3] : (proc_20_data_FIFO_blk[3] | proc_20_data_PIPO_blk[3] | proc_20_start_FIFO_blk[3] | proc_20_TLF_FIFO_blk[3] | proc_20_input_sync_blk[3] | proc_20_output_sync_blk[3]);
    assign proc_20_data_FIFO_blk[4] = 1'b0;
    assign proc_20_data_PIPO_blk[4] = 1'b0;
    assign proc_20_start_FIFO_blk[4] = 1'b0;
    assign proc_20_TLF_FIFO_blk[4] = 1'b0;
    assign proc_20_input_sync_blk[4] = 1'b0;
    assign proc_20_output_sync_blk[4] = 1'b0 | (ap_done_reg_12 & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done);
    assign proc_dep_vld_vec_20[4] = dl_detect_out ? proc_dep_vld_vec_20_reg[4] : (proc_20_data_FIFO_blk[4] | proc_20_data_PIPO_blk[4] | proc_20_start_FIFO_blk[4] | proc_20_TLF_FIFO_blk[4] | proc_20_input_sync_blk[4] | proc_20_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_20_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_20_reg <= proc_dep_vld_vec_20;
        end
    end
    assign in_chan_dep_vld_vec_20[0] = dep_chan_vld_16_20;
    assign in_chan_dep_data_vec_20[54 : 0] = dep_chan_data_16_20;
    assign token_in_vec_20[0] = token_16_20;
    assign in_chan_dep_vld_vec_20[1] = dep_chan_vld_18_20;
    assign in_chan_dep_data_vec_20[109 : 55] = dep_chan_data_18_20;
    assign token_in_vec_20[1] = token_18_20;
    assign in_chan_dep_vld_vec_20[2] = dep_chan_vld_21_20;
    assign in_chan_dep_data_vec_20[164 : 110] = dep_chan_data_21_20;
    assign token_in_vec_20[2] = token_21_20;
    assign in_chan_dep_vld_vec_20[3] = dep_chan_vld_22_20;
    assign in_chan_dep_data_vec_20[219 : 165] = dep_chan_data_22_20;
    assign token_in_vec_20[3] = token_22_20;
    assign in_chan_dep_vld_vec_20[4] = dep_chan_vld_23_20;
    assign in_chan_dep_data_vec_20[274 : 220] = dep_chan_data_23_20;
    assign token_in_vec_20[4] = token_23_20;
    assign dep_chan_vld_20_16 = out_chan_dep_vld_vec_20[0];
    assign dep_chan_data_20_16 = out_chan_dep_data_20;
    assign token_20_16 = token_out_vec_20[0];
    assign dep_chan_vld_20_21 = out_chan_dep_vld_vec_20[1];
    assign dep_chan_data_20_21 = out_chan_dep_data_20;
    assign token_20_21 = token_out_vec_20[1];
    assign dep_chan_vld_20_23 = out_chan_dep_vld_vec_20[2];
    assign dep_chan_data_20_23 = out_chan_dep_data_20;
    assign token_20_23 = token_out_vec_20[2];
    assign dep_chan_vld_20_18 = out_chan_dep_vld_vec_20[3];
    assign dep_chan_data_20_18 = out_chan_dep_data_20;
    assign token_20_18 = token_out_vec_20[3];
    assign dep_chan_vld_20_22 = out_chan_dep_vld_vec_20[4];
    assign dep_chan_data_20_22 = out_chan_dep_data_20;
    assign token_20_22 = token_out_vec_20[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 21, 4, 4) synthesis_top_hls_deadlock_detect_unit_21 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_21),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_21),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_21),
        .token_in_vec(token_in_vec_21),
        .dl_detect_in(dl_detect_out),
        .origin(origin[21]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_21),
        .out_chan_dep_data(out_chan_dep_data_21),
        .token_out_vec(token_out_vec_21),
        .dl_detect_out(dl_in_vec[21]));

    assign proc_21_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n);
    assign proc_21_data_PIPO_blk[0] = 1'b0;
    assign proc_21_start_FIFO_blk[0] = 1'b0;
    assign proc_21_TLF_FIFO_blk[0] = 1'b0;
    assign proc_21_input_sync_blk[0] = 1'b0;
    assign proc_21_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_21[0] = dl_detect_out ? proc_dep_vld_vec_21_reg[0] : (proc_21_data_FIFO_blk[0] | proc_21_data_PIPO_blk[0] | proc_21_start_FIFO_blk[0] | proc_21_TLF_FIFO_blk[0] | proc_21_input_sync_blk[0] | proc_21_output_sync_blk[0]);
    assign proc_21_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.win_s_5_blk_n);
    assign proc_21_data_PIPO_blk[1] = 1'b0;
    assign proc_21_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_write);
    assign proc_21_TLF_FIFO_blk[1] = 1'b0;
    assign proc_21_input_sync_blk[1] = 1'b0;
    assign proc_21_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_21[1] = dl_detect_out ? proc_dep_vld_vec_21_reg[1] : (proc_21_data_FIFO_blk[1] | proc_21_data_PIPO_blk[1] | proc_21_start_FIFO_blk[1] | proc_21_TLF_FIFO_blk[1] | proc_21_input_sync_blk[1] | proc_21_output_sync_blk[1]);
    assign proc_21_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.load_weights_blk_n);
    assign proc_21_data_PIPO_blk[2] = 1'b0;
    assign proc_21_start_FIFO_blk[2] = 1'b0;
    assign proc_21_TLF_FIFO_blk[2] = 1'b0;
    assign proc_21_input_sync_blk[2] = 1'b0;
    assign proc_21_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_21[2] = dl_detect_out ? proc_dep_vld_vec_21_reg[2] : (proc_21_data_FIFO_blk[2] | proc_21_data_PIPO_blk[2] | proc_21_start_FIFO_blk[2] | proc_21_TLF_FIFO_blk[2] | proc_21_input_sync_blk[2] | proc_21_output_sync_blk[2]);
    assign proc_21_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.out_vec_s_5_blk_n);
    assign proc_21_data_PIPO_blk[3] = 1'b0;
    assign proc_21_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.real_start & (trans_in_cnt_10 == trans_out_cnt_10) & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_read);
    assign proc_21_TLF_FIFO_blk[3] = 1'b0;
    assign proc_21_input_sync_blk[3] = 1'b0;
    assign proc_21_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_21[3] = dl_detect_out ? proc_dep_vld_vec_21_reg[3] : (proc_21_data_FIFO_blk[3] | proc_21_data_PIPO_blk[3] | proc_21_start_FIFO_blk[3] | proc_21_TLF_FIFO_blk[3] | proc_21_input_sync_blk[3] | proc_21_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_21_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_21_reg <= proc_dep_vld_vec_21;
        end
    end
    assign in_chan_dep_vld_vec_21[0] = dep_chan_vld_1_21;
    assign in_chan_dep_data_vec_21[54 : 0] = dep_chan_data_1_21;
    assign token_in_vec_21[0] = token_1_21;
    assign in_chan_dep_vld_vec_21[1] = dep_chan_vld_19_21;
    assign in_chan_dep_data_vec_21[109 : 55] = dep_chan_data_19_21;
    assign token_in_vec_21[1] = token_19_21;
    assign in_chan_dep_vld_vec_21[2] = dep_chan_vld_20_21;
    assign in_chan_dep_data_vec_21[164 : 110] = dep_chan_data_20_21;
    assign token_in_vec_21[2] = token_20_21;
    assign in_chan_dep_vld_vec_21[3] = dep_chan_vld_22_21;
    assign in_chan_dep_data_vec_21[219 : 165] = dep_chan_data_22_21;
    assign token_in_vec_21[3] = token_22_21;
    assign dep_chan_vld_21_1 = out_chan_dep_vld_vec_21[0];
    assign dep_chan_data_21_1 = out_chan_dep_data_21;
    assign token_21_1 = token_out_vec_21[0];
    assign dep_chan_vld_21_20 = out_chan_dep_vld_vec_21[1];
    assign dep_chan_data_21_20 = out_chan_dep_data_21;
    assign token_21_20 = token_out_vec_21[1];
    assign dep_chan_vld_21_19 = out_chan_dep_vld_vec_21[2];
    assign dep_chan_data_21_19 = out_chan_dep_data_21;
    assign token_21_19 = token_out_vec_21[2];
    assign dep_chan_vld_21_22 = out_chan_dep_vld_vec_21[3];
    assign dep_chan_data_21_22 = out_chan_dep_data_21;
    assign token_21_22 = token_out_vec_21[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 22, 3, 3) synthesis_top_hls_deadlock_detect_unit_22 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_22),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_22),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_22),
        .token_in_vec(token_in_vec_22),
        .dl_detect_in(dl_detect_out),
        .origin(origin[22]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_22),
        .out_chan_dep_data(out_chan_dep_data_22),
        .token_out_vec(token_out_vec_22),
        .dl_detect_out(dl_in_vec[22]));

    assign proc_22_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n);
    assign proc_22_data_PIPO_blk[0] = 1'b0;
    assign proc_22_start_FIFO_blk[0] = 1'b0;
    assign proc_22_TLF_FIFO_blk[0] = 1'b0;
    assign proc_22_input_sync_blk[0] = 1'b0;
    assign proc_22_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_22[0] = dl_detect_out ? proc_dep_vld_vec_22_reg[0] : (proc_22_data_FIFO_blk[0] | proc_22_data_PIPO_blk[0] | proc_22_start_FIFO_blk[0] | proc_22_TLF_FIFO_blk[0] | proc_22_input_sync_blk[0] | proc_22_output_sync_blk[0]);
    assign proc_22_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.out_vec_s_5_blk_n);
    assign proc_22_data_PIPO_blk[1] = 1'b0;
    assign proc_22_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_write);
    assign proc_22_TLF_FIFO_blk[1] = 1'b0;
    assign proc_22_input_sync_blk[1] = 1'b0;
    assign proc_22_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_22[1] = dl_detect_out ? proc_dep_vld_vec_22_reg[1] : (proc_22_data_FIFO_blk[1] | proc_22_data_PIPO_blk[1] | proc_22_start_FIFO_blk[1] | proc_22_TLF_FIFO_blk[1] | proc_22_input_sync_blk[1] | proc_22_output_sync_blk[1]);
    assign proc_22_data_FIFO_blk[2] = 1'b0;
    assign proc_22_data_PIPO_blk[2] = 1'b0;
    assign proc_22_start_FIFO_blk[2] = 1'b0;
    assign proc_22_TLF_FIFO_blk[2] = 1'b0;
    assign proc_22_input_sync_blk[2] = 1'b0;
    assign proc_22_output_sync_blk[2] = 1'b0 | (ap_done_reg_13 & compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done);
    assign proc_dep_vld_vec_22[2] = dl_detect_out ? proc_dep_vld_vec_22_reg[2] : (proc_22_data_FIFO_blk[2] | proc_22_data_PIPO_blk[2] | proc_22_start_FIFO_blk[2] | proc_22_TLF_FIFO_blk[2] | proc_22_input_sync_blk[2] | proc_22_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_22_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_22_reg <= proc_dep_vld_vec_22;
        end
    end
    assign in_chan_dep_vld_vec_22[0] = dep_chan_vld_20_22;
    assign in_chan_dep_data_vec_22[54 : 0] = dep_chan_data_20_22;
    assign token_in_vec_22[0] = token_20_22;
    assign in_chan_dep_vld_vec_22[1] = dep_chan_vld_21_22;
    assign in_chan_dep_data_vec_22[109 : 55] = dep_chan_data_21_22;
    assign token_in_vec_22[1] = token_21_22;
    assign in_chan_dep_vld_vec_22[2] = dep_chan_vld_23_22;
    assign in_chan_dep_data_vec_22[164 : 110] = dep_chan_data_23_22;
    assign token_in_vec_22[2] = token_23_22;
    assign dep_chan_vld_22_23 = out_chan_dep_vld_vec_22[0];
    assign dep_chan_data_22_23 = out_chan_dep_data_22;
    assign token_22_23 = token_out_vec_22[0];
    assign dep_chan_vld_22_21 = out_chan_dep_vld_vec_22[1];
    assign dep_chan_data_22_21 = out_chan_dep_data_22;
    assign token_22_21 = token_out_vec_22[1];
    assign dep_chan_vld_22_20 = out_chan_dep_vld_vec_22[2];
    assign dep_chan_data_22_20 = out_chan_dep_data_22;
    assign token_22_20 = token_out_vec_22[2];

    // Process: compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 23, 4, 4) synthesis_top_hls_deadlock_detect_unit_23 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_23),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_23),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_23),
        .token_in_vec(token_in_vec_23),
        .dl_detect_in(dl_detect_out),
        .origin(origin[23]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_23),
        .out_chan_dep_data(out_chan_dep_data_23),
        .token_out_vec(token_out_vec_23),
        .dl_detect_out(dl_in_vec[23]));

    assign proc_23_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n) | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_23_data_PIPO_blk[0] = 1'b0;
    assign proc_23_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write);
    assign proc_23_TLF_FIFO_blk[0] = 1'b0;
    assign proc_23_input_sync_blk[0] = 1'b0;
    assign proc_23_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_23[0] = dl_detect_out ? proc_dep_vld_vec_23_reg[0] : (proc_23_data_FIFO_blk[0] | proc_23_data_PIPO_blk[0] | proc_23_start_FIFO_blk[0] | proc_23_TLF_FIFO_blk[0] | proc_23_input_sync_blk[0] | proc_23_output_sync_blk[0]);
    assign proc_23_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n);
    assign proc_23_data_PIPO_blk[1] = 1'b0;
    assign proc_23_start_FIFO_blk[1] = 1'b0;
    assign proc_23_TLF_FIFO_blk[1] = 1'b0;
    assign proc_23_input_sync_blk[1] = 1'b0;
    assign proc_23_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_23[1] = dl_detect_out ? proc_dep_vld_vec_23_reg[1] : (proc_23_data_FIFO_blk[1] | proc_23_data_PIPO_blk[1] | proc_23_start_FIFO_blk[1] | proc_23_TLF_FIFO_blk[1] | proc_23_input_sync_blk[1] | proc_23_output_sync_blk[1]);
    assign proc_23_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_pool1_blk_n) | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c11_blk_n);
    assign proc_23_data_PIPO_blk[2] = 1'b0;
    assign proc_23_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_12 == trans_out_cnt_12) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_read);
    assign proc_23_TLF_FIFO_blk[2] = 1'b0;
    assign proc_23_input_sync_blk[2] = 1'b0;
    assign proc_23_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_23[2] = dl_detect_out ? proc_dep_vld_vec_23_reg[2] : (proc_23_data_FIFO_blk[2] | proc_23_data_PIPO_blk[2] | proc_23_start_FIFO_blk[2] | proc_23_TLF_FIFO_blk[2] | proc_23_input_sync_blk[2] | proc_23_output_sync_blk[2]);
    assign proc_23_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_23_data_PIPO_blk[3] = 1'b0;
    assign proc_23_start_FIFO_blk[3] = 1'b0;
    assign proc_23_TLF_FIFO_blk[3] = 1'b0;
    assign proc_23_input_sync_blk[3] = 1'b0;
    assign proc_23_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_23[3] = dl_detect_out ? proc_dep_vld_vec_23_reg[3] : (proc_23_data_FIFO_blk[3] | proc_23_data_PIPO_blk[3] | proc_23_start_FIFO_blk[3] | proc_23_TLF_FIFO_blk[3] | proc_23_input_sync_blk[3] | proc_23_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_23_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_23_reg <= proc_dep_vld_vec_23;
        end
    end
    assign in_chan_dep_vld_vec_23[0] = dep_chan_vld_17_23;
    assign in_chan_dep_data_vec_23[54 : 0] = dep_chan_data_17_23;
    assign token_in_vec_23[0] = token_17_23;
    assign in_chan_dep_vld_vec_23[1] = dep_chan_vld_20_23;
    assign in_chan_dep_data_vec_23[109 : 55] = dep_chan_data_20_23;
    assign token_in_vec_23[1] = token_20_23;
    assign in_chan_dep_vld_vec_23[2] = dep_chan_vld_22_23;
    assign in_chan_dep_data_vec_23[164 : 110] = dep_chan_data_22_23;
    assign token_in_vec_23[2] = token_22_23;
    assign in_chan_dep_vld_vec_23[3] = dep_chan_vld_24_23;
    assign in_chan_dep_data_vec_23[219 : 165] = dep_chan_data_24_23;
    assign token_in_vec_23[3] = token_24_23;
    assign dep_chan_vld_23_17 = out_chan_dep_vld_vec_23[0];
    assign dep_chan_data_23_17 = out_chan_dep_data_23;
    assign token_23_17 = token_out_vec_23[0];
    assign dep_chan_vld_23_22 = out_chan_dep_vld_vec_23[1];
    assign dep_chan_data_23_22 = out_chan_dep_data_23;
    assign token_23_22 = token_out_vec_23[1];
    assign dep_chan_vld_23_24 = out_chan_dep_vld_vec_23[2];
    assign dep_chan_data_23_24 = out_chan_dep_data_23;
    assign token_23_24 = token_out_vec_23[2];
    assign dep_chan_vld_23_20 = out_chan_dep_vld_vec_23[3];
    assign dep_chan_data_23_20 = out_chan_dep_data_23;
    assign token_23_20 = token_out_vec_23[3];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 24, 3, 3) synthesis_top_hls_deadlock_detect_unit_24 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_24),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_24),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_24),
        .token_in_vec(token_in_vec_24),
        .dl_detect_in(dl_detect_out),
        .origin(origin[24]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_24),
        .out_chan_dep_data(out_chan_dep_data_24),
        .token_out_vec(token_out_vec_24),
        .dl_detect_out(dl_in_vec[24]));

    assign proc_24_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_pool1_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.reps_blk_n);
    assign proc_24_data_PIPO_blk[0] = 1'b0;
    assign proc_24_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_write);
    assign proc_24_TLF_FIFO_blk[0] = 1'b0;
    assign proc_24_input_sync_blk[0] = 1'b0;
    assign proc_24_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_24[0] = dl_detect_out ? proc_dep_vld_vec_24_reg[0] : (proc_24_data_FIFO_blk[0] | proc_24_data_PIPO_blk[0] | proc_24_start_FIFO_blk[0] | proc_24_TLF_FIFO_blk[0] | proc_24_input_sync_blk[0] | proc_24_output_sync_blk[0]);
    assign proc_24_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n);
    assign proc_24_data_PIPO_blk[1] = 1'b0;
    assign proc_24_start_FIFO_blk[1] = 1'b0;
    assign proc_24_TLF_FIFO_blk[1] = 1'b0;
    assign proc_24_input_sync_blk[1] = 1'b0;
    assign proc_24_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_24[1] = dl_detect_out ? proc_dep_vld_vec_24_reg[1] : (proc_24_data_FIFO_blk[1] | proc_24_data_PIPO_blk[1] | proc_24_start_FIFO_blk[1] | proc_24_TLF_FIFO_blk[1] | proc_24_input_sync_blk[1] | proc_24_output_sync_blk[1]);
    assign proc_24_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n);
    assign proc_24_data_PIPO_blk[2] = 1'b0;
    assign proc_24_start_FIFO_blk[2] = 1'b0;
    assign proc_24_TLF_FIFO_blk[2] = 1'b0;
    assign proc_24_input_sync_blk[2] = 1'b0;
    assign proc_24_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_24[2] = dl_detect_out ? proc_dep_vld_vec_24_reg[2] : (proc_24_data_FIFO_blk[2] | proc_24_data_PIPO_blk[2] | proc_24_start_FIFO_blk[2] | proc_24_TLF_FIFO_blk[2] | proc_24_input_sync_blk[2] | proc_24_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_24_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_24_reg <= proc_dep_vld_vec_24;
        end
    end
    assign in_chan_dep_vld_vec_24[0] = dep_chan_vld_23_24;
    assign in_chan_dep_data_vec_24[54 : 0] = dep_chan_data_23_24;
    assign token_in_vec_24[0] = token_23_24;
    assign in_chan_dep_vld_vec_24[1] = dep_chan_vld_25_24;
    assign in_chan_dep_data_vec_24[109 : 55] = dep_chan_data_25_24;
    assign token_in_vec_24[1] = token_25_24;
    assign in_chan_dep_vld_vec_24[2] = dep_chan_vld_28_24;
    assign in_chan_dep_data_vec_24[164 : 110] = dep_chan_data_28_24;
    assign token_in_vec_24[2] = token_28_24;
    assign dep_chan_vld_24_23 = out_chan_dep_vld_vec_24[0];
    assign dep_chan_data_24_23 = out_chan_dep_data_24;
    assign token_24_23 = token_out_vec_24[0];
    assign dep_chan_vld_24_25 = out_chan_dep_vld_vec_24[1];
    assign dep_chan_data_24_25 = out_chan_dep_data_24;
    assign token_24_25 = token_out_vec_24[1];
    assign dep_chan_vld_24_28 = out_chan_dep_vld_vec_24[2];
    assign dep_chan_data_24_28 = out_chan_dep_data_24;
    assign token_24_28 = token_out_vec_24[2];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 25, 7, 7) synthesis_top_hls_deadlock_detect_unit_25 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_25),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_25),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_25),
        .token_in_vec(token_in_vec_25),
        .dl_detect_in(dl_detect_out),
        .origin(origin[25]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_25),
        .out_chan_dep_data(out_chan_dep_data_25),
        .token_out_vec(token_out_vec_25),
        .dl_detect_out(dl_in_vec[25]));

    assign proc_25_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n);
    assign proc_25_data_PIPO_blk[0] = 1'b0;
    assign proc_25_start_FIFO_blk[0] = 1'b0;
    assign proc_25_TLF_FIFO_blk[0] = 1'b0;
    assign proc_25_input_sync_blk[0] = 1'b0;
    assign proc_25_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_25[0] = dl_detect_out ? proc_dep_vld_vec_25_reg[0] : (proc_25_data_FIFO_blk[0] | proc_25_data_PIPO_blk[0] | proc_25_start_FIFO_blk[0] | proc_25_TLF_FIFO_blk[0] | proc_25_input_sync_blk[0] | proc_25_output_sync_blk[0]);
    assign proc_25_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n);
    assign proc_25_data_PIPO_blk[1] = 1'b0;
    assign proc_25_start_FIFO_blk[1] = 1'b0;
    assign proc_25_TLF_FIFO_blk[1] = 1'b0;
    assign proc_25_input_sync_blk[1] = 1'b0;
    assign proc_25_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_25[1] = dl_detect_out ? proc_dep_vld_vec_25_reg[1] : (proc_25_data_FIFO_blk[1] | proc_25_data_PIPO_blk[1] | proc_25_start_FIFO_blk[1] | proc_25_TLF_FIFO_blk[1] | proc_25_input_sync_blk[1] | proc_25_output_sync_blk[1]);
    assign proc_25_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n);
    assign proc_25_data_PIPO_blk[2] = 1'b0;
    assign proc_25_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read);
    assign proc_25_TLF_FIFO_blk[2] = 1'b0;
    assign proc_25_input_sync_blk[2] = 1'b0;
    assign proc_25_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_25[2] = dl_detect_out ? proc_dep_vld_vec_25_reg[2] : (proc_25_data_FIFO_blk[2] | proc_25_data_PIPO_blk[2] | proc_25_start_FIFO_blk[2] | proc_25_TLF_FIFO_blk[2] | proc_25_input_sync_blk[2] | proc_25_output_sync_blk[2]);
    assign proc_25_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n);
    assign proc_25_data_PIPO_blk[3] = 1'b0;
    assign proc_25_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_write);
    assign proc_25_TLF_FIFO_blk[3] = 1'b0;
    assign proc_25_input_sync_blk[3] = 1'b0;
    assign proc_25_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_25[3] = dl_detect_out ? proc_dep_vld_vec_25_reg[3] : (proc_25_data_FIFO_blk[3] | proc_25_data_PIPO_blk[3] | proc_25_start_FIFO_blk[3] | proc_25_TLF_FIFO_blk[3] | proc_25_input_sync_blk[3] | proc_25_output_sync_blk[3]);
    assign proc_25_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n);
    assign proc_25_data_PIPO_blk[4] = 1'b0;
    assign proc_25_start_FIFO_blk[4] = 1'b0;
    assign proc_25_TLF_FIFO_blk[4] = 1'b0;
    assign proc_25_input_sync_blk[4] = 1'b0;
    assign proc_25_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_25[4] = dl_detect_out ? proc_dep_vld_vec_25_reg[4] : (proc_25_data_FIFO_blk[4] | proc_25_data_PIPO_blk[4] | proc_25_start_FIFO_blk[4] | proc_25_TLF_FIFO_blk[4] | proc_25_input_sync_blk[4] | proc_25_output_sync_blk[4]);
    assign proc_25_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n);
    assign proc_25_data_PIPO_blk[5] = 1'b0;
    assign proc_25_start_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_read);
    assign proc_25_TLF_FIFO_blk[5] = 1'b0;
    assign proc_25_input_sync_blk[5] = 1'b0;
    assign proc_25_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_25[5] = dl_detect_out ? proc_dep_vld_vec_25_reg[5] : (proc_25_data_FIFO_blk[5] | proc_25_data_PIPO_blk[5] | proc_25_start_FIFO_blk[5] | proc_25_TLF_FIFO_blk[5] | proc_25_input_sync_blk[5] | proc_25_output_sync_blk[5]);
    assign proc_25_data_FIFO_blk[6] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n);
    assign proc_25_data_PIPO_blk[6] = 1'b0;
    assign proc_25_start_FIFO_blk[6] = 1'b0;
    assign proc_25_TLF_FIFO_blk[6] = 1'b0;
    assign proc_25_input_sync_blk[6] = 1'b0;
    assign proc_25_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_25[6] = dl_detect_out ? proc_dep_vld_vec_25_reg[6] : (proc_25_data_FIFO_blk[6] | proc_25_data_PIPO_blk[6] | proc_25_start_FIFO_blk[6] | proc_25_TLF_FIFO_blk[6] | proc_25_input_sync_blk[6] | proc_25_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_25_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_25_reg <= proc_dep_vld_vec_25;
        end
    end
    assign in_chan_dep_vld_vec_25[0] = dep_chan_vld_1_25;
    assign in_chan_dep_data_vec_25[54 : 0] = dep_chan_data_1_25;
    assign token_in_vec_25[0] = token_1_25;
    assign in_chan_dep_vld_vec_25[1] = dep_chan_vld_17_25;
    assign in_chan_dep_data_vec_25[109 : 55] = dep_chan_data_17_25;
    assign token_in_vec_25[1] = token_17_25;
    assign in_chan_dep_vld_vec_25[2] = dep_chan_vld_18_25;
    assign in_chan_dep_data_vec_25[164 : 110] = dep_chan_data_18_25;
    assign token_in_vec_25[2] = token_18_25;
    assign in_chan_dep_vld_vec_25[3] = dep_chan_vld_24_25;
    assign in_chan_dep_data_vec_25[219 : 165] = dep_chan_data_24_25;
    assign token_in_vec_25[3] = token_24_25;
    assign in_chan_dep_vld_vec_25[4] = dep_chan_vld_31_25;
    assign in_chan_dep_data_vec_25[274 : 220] = dep_chan_data_31_25;
    assign token_in_vec_25[4] = token_31_25;
    assign in_chan_dep_vld_vec_25[5] = dep_chan_vld_33_25;
    assign in_chan_dep_data_vec_25[329 : 275] = dep_chan_data_33_25;
    assign token_in_vec_25[5] = token_33_25;
    assign in_chan_dep_vld_vec_25[6] = dep_chan_vld_34_25;
    assign in_chan_dep_data_vec_25[384 : 330] = dep_chan_data_34_25;
    assign token_in_vec_25[6] = token_34_25;
    assign dep_chan_vld_25_24 = out_chan_dep_vld_vec_25[0];
    assign dep_chan_data_25_24 = out_chan_dep_data_25;
    assign token_25_24 = token_out_vec_25[0];
    assign dep_chan_vld_25_1 = out_chan_dep_vld_vec_25[1];
    assign dep_chan_data_25_1 = out_chan_dep_data_25;
    assign token_25_1 = token_out_vec_25[1];
    assign dep_chan_vld_25_31 = out_chan_dep_vld_vec_25[2];
    assign dep_chan_data_25_31 = out_chan_dep_data_25;
    assign token_25_31 = token_out_vec_25[2];
    assign dep_chan_vld_25_17 = out_chan_dep_vld_vec_25[3];
    assign dep_chan_data_25_17 = out_chan_dep_data_25;
    assign token_25_17 = token_out_vec_25[3];
    assign dep_chan_vld_25_18 = out_chan_dep_vld_vec_25[4];
    assign dep_chan_data_25_18 = out_chan_dep_data_25;
    assign token_25_18 = token_out_vec_25[4];
    assign dep_chan_vld_25_33 = out_chan_dep_vld_vec_25[5];
    assign dep_chan_data_25_33 = out_chan_dep_data_25;
    assign token_25_33 = token_out_vec_25[5];
    assign dep_chan_vld_25_34 = out_chan_dep_vld_vec_25[6];
    assign dep_chan_data_25_34 = out_chan_dep_data_25;
    assign token_25_34 = token_out_vec_25[6];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 26, 6, 6) synthesis_top_hls_deadlock_detect_unit_26 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_26),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_26),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_26),
        .token_in_vec(token_in_vec_26),
        .dl_detect_in(dl_detect_out),
        .origin(origin[26]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_26),
        .out_chan_dep_data(out_chan_dep_data_26),
        .token_out_vec(token_out_vec_26),
        .dl_detect_out(dl_in_vec[26]));

    assign proc_26_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n);
    assign proc_26_data_PIPO_blk[0] = 1'b0;
    assign proc_26_start_FIFO_blk[0] = 1'b0;
    assign proc_26_TLF_FIFO_blk[0] = 1'b0;
    assign proc_26_input_sync_blk[0] = 1'b0;
    assign proc_26_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_26[0] = dl_detect_out ? proc_dep_vld_vec_26_reg[0] : (proc_26_data_FIFO_blk[0] | proc_26_data_PIPO_blk[0] | proc_26_start_FIFO_blk[0] | proc_26_TLF_FIFO_blk[0] | proc_26_input_sync_blk[0] | proc_26_output_sync_blk[0]);
    assign proc_26_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n);
    assign proc_26_data_PIPO_blk[1] = 1'b0;
    assign proc_26_start_FIFO_blk[1] = 1'b0;
    assign proc_26_TLF_FIFO_blk[1] = 1'b0;
    assign proc_26_input_sync_blk[1] = 1'b0;
    assign proc_26_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_26[1] = dl_detect_out ? proc_dep_vld_vec_26_reg[1] : (proc_26_data_FIFO_blk[1] | proc_26_data_PIPO_blk[1] | proc_26_start_FIFO_blk[1] | proc_26_TLF_FIFO_blk[1] | proc_26_input_sync_blk[1] | proc_26_output_sync_blk[1]);
    assign proc_26_data_FIFO_blk[2] = 1'b0;
    assign proc_26_data_PIPO_blk[2] = 1'b0;
    assign proc_26_start_FIFO_blk[2] = 1'b0;
    assign proc_26_TLF_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_done & ap_done_reg_4 & ~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_read);
    assign proc_26_input_sync_blk[2] = 1'b0;
    assign proc_26_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_26[2] = dl_detect_out ? proc_dep_vld_vec_26_reg[2] : (proc_26_data_FIFO_blk[2] | proc_26_data_PIPO_blk[2] | proc_26_start_FIFO_blk[2] | proc_26_TLF_FIFO_blk[2] | proc_26_input_sync_blk[2] | proc_26_output_sync_blk[2]);
    assign proc_26_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n);
    assign proc_26_data_PIPO_blk[3] = 1'b0;
    assign proc_26_start_FIFO_blk[3] = 1'b0;
    assign proc_26_TLF_FIFO_blk[3] = 1'b0;
    assign proc_26_input_sync_blk[3] = 1'b0;
    assign proc_26_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_26[3] = dl_detect_out ? proc_dep_vld_vec_26_reg[3] : (proc_26_data_FIFO_blk[3] | proc_26_data_PIPO_blk[3] | proc_26_start_FIFO_blk[3] | proc_26_TLF_FIFO_blk[3] | proc_26_input_sync_blk[3] | proc_26_output_sync_blk[3]);
    assign proc_26_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n);
    assign proc_26_data_PIPO_blk[4] = 1'b0;
    assign proc_26_start_FIFO_blk[4] = 1'b0;
    assign proc_26_TLF_FIFO_blk[4] = 1'b0;
    assign proc_26_input_sync_blk[4] = 1'b0;
    assign proc_26_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_26[4] = dl_detect_out ? proc_dep_vld_vec_26_reg[4] : (proc_26_data_FIFO_blk[4] | proc_26_data_PIPO_blk[4] | proc_26_start_FIFO_blk[4] | proc_26_TLF_FIFO_blk[4] | proc_26_input_sync_blk[4] | proc_26_output_sync_blk[4]);
    assign proc_26_data_FIFO_blk[5] = 1'b0;
    assign proc_26_data_PIPO_blk[5] = 1'b0;
    assign proc_26_start_FIFO_blk[5] = 1'b0;
    assign proc_26_TLF_FIFO_blk[5] = 1'b0;
    assign proc_26_input_sync_blk[5] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready);
    assign proc_26_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_26[5] = dl_detect_out ? proc_dep_vld_vec_26_reg[5] : (proc_26_data_FIFO_blk[5] | proc_26_data_PIPO_blk[5] | proc_26_start_FIFO_blk[5] | proc_26_TLF_FIFO_blk[5] | proc_26_input_sync_blk[5] | proc_26_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_26_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_26_reg <= proc_dep_vld_vec_26;
        end
    end
    assign in_chan_dep_vld_vec_26[0] = dep_chan_vld_17_26;
    assign in_chan_dep_data_vec_26[54 : 0] = dep_chan_data_17_26;
    assign token_in_vec_26[0] = token_17_26;
    assign in_chan_dep_vld_vec_26[1] = dep_chan_vld_18_26;
    assign in_chan_dep_data_vec_26[109 : 55] = dep_chan_data_18_26;
    assign token_in_vec_26[1] = token_18_26;
    assign in_chan_dep_vld_vec_26[2] = dep_chan_vld_27_26;
    assign in_chan_dep_data_vec_26[164 : 110] = dep_chan_data_27_26;
    assign token_in_vec_26[2] = token_27_26;
    assign in_chan_dep_vld_vec_26[3] = dep_chan_vld_28_26;
    assign in_chan_dep_data_vec_26[219 : 165] = dep_chan_data_28_26;
    assign token_in_vec_26[3] = token_28_26;
    assign in_chan_dep_vld_vec_26[4] = dep_chan_vld_33_26;
    assign in_chan_dep_data_vec_26[274 : 220] = dep_chan_data_33_26;
    assign token_in_vec_26[4] = token_33_26;
    assign in_chan_dep_vld_vec_26[5] = dep_chan_vld_34_26;
    assign in_chan_dep_data_vec_26[329 : 275] = dep_chan_data_34_26;
    assign token_in_vec_26[5] = token_34_26;
    assign dep_chan_vld_26_17 = out_chan_dep_vld_vec_26[0];
    assign dep_chan_data_26_17 = out_chan_dep_data_26;
    assign token_26_17 = token_out_vec_26[0];
    assign dep_chan_vld_26_18 = out_chan_dep_vld_vec_26[1];
    assign dep_chan_data_26_18 = out_chan_dep_data_26;
    assign token_26_18 = token_out_vec_26[1];
    assign dep_chan_vld_26_27 = out_chan_dep_vld_vec_26[2];
    assign dep_chan_data_26_27 = out_chan_dep_data_26;
    assign token_26_27 = token_out_vec_26[2];
    assign dep_chan_vld_26_33 = out_chan_dep_vld_vec_26[3];
    assign dep_chan_data_26_33 = out_chan_dep_data_26;
    assign token_26_33 = token_out_vec_26[3];
    assign dep_chan_vld_26_34 = out_chan_dep_vld_vec_26[4];
    assign dep_chan_data_26_34 = out_chan_dep_data_26;
    assign token_26_34 = token_out_vec_26[4];
    assign dep_chan_vld_26_28 = out_chan_dep_vld_vec_26[5];
    assign dep_chan_data_26_28 = out_chan_dep_data_26;
    assign token_26_28 = token_out_vec_26[5];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 27, 2, 2) synthesis_top_hls_deadlock_detect_unit_27 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_27),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_27),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_27),
        .token_in_vec(token_in_vec_27),
        .dl_detect_in(dl_detect_out),
        .origin(origin[27]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_27),
        .out_chan_dep_data(out_chan_dep_data_27),
        .token_out_vec(token_out_vec_27),
        .dl_detect_out(dl_in_vec[27]));

    assign proc_27_data_FIFO_blk[0] = 1'b0;
    assign proc_27_data_PIPO_blk[0] = 1'b0;
    assign proc_27_start_FIFO_blk[0] = 1'b0;
    assign proc_27_TLF_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_write);
    assign proc_27_input_sync_blk[0] = 1'b0;
    assign proc_27_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_27[0] = dl_detect_out ? proc_dep_vld_vec_27_reg[0] : (proc_27_data_FIFO_blk[0] | proc_27_data_PIPO_blk[0] | proc_27_start_FIFO_blk[0] | proc_27_TLF_FIFO_blk[0] | proc_27_input_sync_blk[0] | proc_27_output_sync_blk[0]);
    assign proc_27_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.load_c_blk_n);
    assign proc_27_data_PIPO_blk[1] = 1'b0;
    assign proc_27_start_FIFO_blk[1] = 1'b0;
    assign proc_27_TLF_FIFO_blk[1] = 1'b0;
    assign proc_27_input_sync_blk[1] = 1'b0;
    assign proc_27_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_27[1] = dl_detect_out ? proc_dep_vld_vec_27_reg[1] : (proc_27_data_FIFO_blk[1] | proc_27_data_PIPO_blk[1] | proc_27_start_FIFO_blk[1] | proc_27_TLF_FIFO_blk[1] | proc_27_input_sync_blk[1] | proc_27_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_27_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_27_reg <= proc_dep_vld_vec_27;
        end
    end
    assign in_chan_dep_vld_vec_27[0] = dep_chan_vld_26_27;
    assign in_chan_dep_data_vec_27[54 : 0] = dep_chan_data_26_27;
    assign token_in_vec_27[0] = token_26_27;
    assign in_chan_dep_vld_vec_27[1] = dep_chan_vld_29_27;
    assign in_chan_dep_data_vec_27[109 : 55] = dep_chan_data_29_27;
    assign token_in_vec_27[1] = token_29_27;
    assign dep_chan_vld_27_26 = out_chan_dep_vld_vec_27[0];
    assign dep_chan_data_27_26 = out_chan_dep_data_27;
    assign token_27_26 = token_out_vec_27[0];
    assign dep_chan_vld_27_29 = out_chan_dep_vld_vec_27[1];
    assign dep_chan_data_27_29 = out_chan_dep_data_27;
    assign token_27_29 = token_out_vec_27[1];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 28, 5, 5) synthesis_top_hls_deadlock_detect_unit_28 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_28),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_28),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_28),
        .token_in_vec(token_in_vec_28),
        .dl_detect_in(dl_detect_out),
        .origin(origin[28]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_28),
        .out_chan_dep_data(out_chan_dep_data_28),
        .token_out_vec(token_out_vec_28),
        .dl_detect_out(dl_in_vec[28]));

    assign proc_28_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n);
    assign proc_28_data_PIPO_blk[0] = 1'b0;
    assign proc_28_start_FIFO_blk[0] = 1'b0;
    assign proc_28_TLF_FIFO_blk[0] = 1'b0;
    assign proc_28_input_sync_blk[0] = 1'b0;
    assign proc_28_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_28[0] = dl_detect_out ? proc_dep_vld_vec_28_reg[0] : (proc_28_data_FIFO_blk[0] | proc_28_data_PIPO_blk[0] | proc_28_start_FIFO_blk[0] | proc_28_TLF_FIFO_blk[0] | proc_28_input_sync_blk[0] | proc_28_output_sync_blk[0]);
    assign proc_28_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.win_s_blk_n);
    assign proc_28_data_PIPO_blk[1] = 1'b0;
    assign proc_28_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.real_start & (trans_in_cnt_13 == trans_out_cnt_13) & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_read);
    assign proc_28_TLF_FIFO_blk[1] = 1'b0;
    assign proc_28_input_sync_blk[1] = 1'b0;
    assign proc_28_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_28[1] = dl_detect_out ? proc_dep_vld_vec_28_reg[1] : (proc_28_data_FIFO_blk[1] | proc_28_data_PIPO_blk[1] | proc_28_start_FIFO_blk[1] | proc_28_TLF_FIFO_blk[1] | proc_28_input_sync_blk[1] | proc_28_output_sync_blk[1]);
    assign proc_28_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n);
    assign proc_28_data_PIPO_blk[2] = 1'b0;
    assign proc_28_start_FIFO_blk[2] = 1'b0;
    assign proc_28_TLF_FIFO_blk[2] = 1'b0;
    assign proc_28_input_sync_blk[2] = 1'b0;
    assign proc_28_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_28[2] = dl_detect_out ? proc_dep_vld_vec_28_reg[2] : (proc_28_data_FIFO_blk[2] | proc_28_data_PIPO_blk[2] | proc_28_start_FIFO_blk[2] | proc_28_TLF_FIFO_blk[2] | proc_28_input_sync_blk[2] | proc_28_output_sync_blk[2]);
    assign proc_28_data_FIFO_blk[3] = 1'b0;
    assign proc_28_data_PIPO_blk[3] = 1'b0;
    assign proc_28_start_FIFO_blk[3] = 1'b0;
    assign proc_28_TLF_FIFO_blk[3] = 1'b0;
    assign proc_28_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready);
    assign proc_28_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_28[3] = dl_detect_out ? proc_dep_vld_vec_28_reg[3] : (proc_28_data_FIFO_blk[3] | proc_28_data_PIPO_blk[3] | proc_28_start_FIFO_blk[3] | proc_28_TLF_FIFO_blk[3] | proc_28_input_sync_blk[3] | proc_28_output_sync_blk[3]);
    assign proc_28_data_FIFO_blk[4] = 1'b0;
    assign proc_28_data_PIPO_blk[4] = 1'b0;
    assign proc_28_start_FIFO_blk[4] = 1'b0;
    assign proc_28_TLF_FIFO_blk[4] = 1'b0;
    assign proc_28_input_sync_blk[4] = 1'b0;
    assign proc_28_output_sync_blk[4] = 1'b0 | (ap_done_reg_14 & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done);
    assign proc_dep_vld_vec_28[4] = dl_detect_out ? proc_dep_vld_vec_28_reg[4] : (proc_28_data_FIFO_blk[4] | proc_28_data_PIPO_blk[4] | proc_28_start_FIFO_blk[4] | proc_28_TLF_FIFO_blk[4] | proc_28_input_sync_blk[4] | proc_28_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_28_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_28_reg <= proc_dep_vld_vec_28;
        end
    end
    assign in_chan_dep_vld_vec_28[0] = dep_chan_vld_24_28;
    assign in_chan_dep_data_vec_28[54 : 0] = dep_chan_data_24_28;
    assign token_in_vec_28[0] = token_24_28;
    assign in_chan_dep_vld_vec_28[1] = dep_chan_vld_26_28;
    assign in_chan_dep_data_vec_28[109 : 55] = dep_chan_data_26_28;
    assign token_in_vec_28[1] = token_26_28;
    assign in_chan_dep_vld_vec_28[2] = dep_chan_vld_29_28;
    assign in_chan_dep_data_vec_28[164 : 110] = dep_chan_data_29_28;
    assign token_in_vec_28[2] = token_29_28;
    assign in_chan_dep_vld_vec_28[3] = dep_chan_vld_30_28;
    assign in_chan_dep_data_vec_28[219 : 165] = dep_chan_data_30_28;
    assign token_in_vec_28[3] = token_30_28;
    assign in_chan_dep_vld_vec_28[4] = dep_chan_vld_31_28;
    assign in_chan_dep_data_vec_28[274 : 220] = dep_chan_data_31_28;
    assign token_in_vec_28[4] = token_31_28;
    assign dep_chan_vld_28_24 = out_chan_dep_vld_vec_28[0];
    assign dep_chan_data_28_24 = out_chan_dep_data_28;
    assign token_28_24 = token_out_vec_28[0];
    assign dep_chan_vld_28_29 = out_chan_dep_vld_vec_28[1];
    assign dep_chan_data_28_29 = out_chan_dep_data_28;
    assign token_28_29 = token_out_vec_28[1];
    assign dep_chan_vld_28_31 = out_chan_dep_vld_vec_28[2];
    assign dep_chan_data_28_31 = out_chan_dep_data_28;
    assign token_28_31 = token_out_vec_28[2];
    assign dep_chan_vld_28_26 = out_chan_dep_vld_vec_28[3];
    assign dep_chan_data_28_26 = out_chan_dep_data_28;
    assign token_28_26 = token_out_vec_28[3];
    assign dep_chan_vld_28_30 = out_chan_dep_vld_vec_28[4];
    assign dep_chan_data_28_30 = out_chan_dep_data_28;
    assign token_28_30 = token_out_vec_28[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 29, 4, 4) synthesis_top_hls_deadlock_detect_unit_29 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_29),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_29),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_29),
        .token_in_vec(token_in_vec_29),
        .dl_detect_in(dl_detect_out),
        .origin(origin[29]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_29),
        .out_chan_dep_data(out_chan_dep_data_29),
        .token_out_vec(token_out_vec_29),
        .dl_detect_out(dl_in_vec[29]));

    assign proc_29_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n);
    assign proc_29_data_PIPO_blk[0] = 1'b0;
    assign proc_29_start_FIFO_blk[0] = 1'b0;
    assign proc_29_TLF_FIFO_blk[0] = 1'b0;
    assign proc_29_input_sync_blk[0] = 1'b0;
    assign proc_29_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_29[0] = dl_detect_out ? proc_dep_vld_vec_29_reg[0] : (proc_29_data_FIFO_blk[0] | proc_29_data_PIPO_blk[0] | proc_29_start_FIFO_blk[0] | proc_29_TLF_FIFO_blk[0] | proc_29_input_sync_blk[0] | proc_29_output_sync_blk[0]);
    assign proc_29_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.win_s_blk_n);
    assign proc_29_data_PIPO_blk[1] = 1'b0;
    assign proc_29_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_write);
    assign proc_29_TLF_FIFO_blk[1] = 1'b0;
    assign proc_29_input_sync_blk[1] = 1'b0;
    assign proc_29_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_29[1] = dl_detect_out ? proc_dep_vld_vec_29_reg[1] : (proc_29_data_FIFO_blk[1] | proc_29_data_PIPO_blk[1] | proc_29_start_FIFO_blk[1] | proc_29_TLF_FIFO_blk[1] | proc_29_input_sync_blk[1] | proc_29_output_sync_blk[1]);
    assign proc_29_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.load_weights_blk_n);
    assign proc_29_data_PIPO_blk[2] = 1'b0;
    assign proc_29_start_FIFO_blk[2] = 1'b0;
    assign proc_29_TLF_FIFO_blk[2] = 1'b0;
    assign proc_29_input_sync_blk[2] = 1'b0;
    assign proc_29_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_29[2] = dl_detect_out ? proc_dep_vld_vec_29_reg[2] : (proc_29_data_FIFO_blk[2] | proc_29_data_PIPO_blk[2] | proc_29_start_FIFO_blk[2] | proc_29_TLF_FIFO_blk[2] | proc_29_input_sync_blk[2] | proc_29_output_sync_blk[2]);
    assign proc_29_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.out_vec_s_blk_n);
    assign proc_29_data_PIPO_blk[3] = 1'b0;
    assign proc_29_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.real_start & (trans_in_cnt_14 == trans_out_cnt_14) & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_read);
    assign proc_29_TLF_FIFO_blk[3] = 1'b0;
    assign proc_29_input_sync_blk[3] = 1'b0;
    assign proc_29_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_29[3] = dl_detect_out ? proc_dep_vld_vec_29_reg[3] : (proc_29_data_FIFO_blk[3] | proc_29_data_PIPO_blk[3] | proc_29_start_FIFO_blk[3] | proc_29_TLF_FIFO_blk[3] | proc_29_input_sync_blk[3] | proc_29_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_29_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_29_reg <= proc_dep_vld_vec_29;
        end
    end
    assign in_chan_dep_vld_vec_29[0] = dep_chan_vld_1_29;
    assign in_chan_dep_data_vec_29[54 : 0] = dep_chan_data_1_29;
    assign token_in_vec_29[0] = token_1_29;
    assign in_chan_dep_vld_vec_29[1] = dep_chan_vld_27_29;
    assign in_chan_dep_data_vec_29[109 : 55] = dep_chan_data_27_29;
    assign token_in_vec_29[1] = token_27_29;
    assign in_chan_dep_vld_vec_29[2] = dep_chan_vld_28_29;
    assign in_chan_dep_data_vec_29[164 : 110] = dep_chan_data_28_29;
    assign token_in_vec_29[2] = token_28_29;
    assign in_chan_dep_vld_vec_29[3] = dep_chan_vld_30_29;
    assign in_chan_dep_data_vec_29[219 : 165] = dep_chan_data_30_29;
    assign token_in_vec_29[3] = token_30_29;
    assign dep_chan_vld_29_1 = out_chan_dep_vld_vec_29[0];
    assign dep_chan_data_29_1 = out_chan_dep_data_29;
    assign token_29_1 = token_out_vec_29[0];
    assign dep_chan_vld_29_28 = out_chan_dep_vld_vec_29[1];
    assign dep_chan_data_29_28 = out_chan_dep_data_29;
    assign token_29_28 = token_out_vec_29[1];
    assign dep_chan_vld_29_27 = out_chan_dep_vld_vec_29[2];
    assign dep_chan_data_29_27 = out_chan_dep_data_29;
    assign token_29_27 = token_out_vec_29[2];
    assign dep_chan_vld_29_30 = out_chan_dep_vld_vec_29[3];
    assign dep_chan_data_29_30 = out_chan_dep_data_29;
    assign token_29_30 = token_out_vec_29[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 30, 3, 3) synthesis_top_hls_deadlock_detect_unit_30 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_30),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_30),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_30),
        .token_in_vec(token_in_vec_30),
        .dl_detect_in(dl_detect_out),
        .origin(origin[30]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_30),
        .out_chan_dep_data(out_chan_dep_data_30),
        .token_out_vec(token_out_vec_30),
        .dl_detect_out(dl_in_vec[30]));

    assign proc_30_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n);
    assign proc_30_data_PIPO_blk[0] = 1'b0;
    assign proc_30_start_FIFO_blk[0] = 1'b0;
    assign proc_30_TLF_FIFO_blk[0] = 1'b0;
    assign proc_30_input_sync_blk[0] = 1'b0;
    assign proc_30_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_30[0] = dl_detect_out ? proc_dep_vld_vec_30_reg[0] : (proc_30_data_FIFO_blk[0] | proc_30_data_PIPO_blk[0] | proc_30_start_FIFO_blk[0] | proc_30_TLF_FIFO_blk[0] | proc_30_input_sync_blk[0] | proc_30_output_sync_blk[0]);
    assign proc_30_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.out_vec_s_blk_n);
    assign proc_30_data_PIPO_blk[1] = 1'b0;
    assign proc_30_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_write);
    assign proc_30_TLF_FIFO_blk[1] = 1'b0;
    assign proc_30_input_sync_blk[1] = 1'b0;
    assign proc_30_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_30[1] = dl_detect_out ? proc_dep_vld_vec_30_reg[1] : (proc_30_data_FIFO_blk[1] | proc_30_data_PIPO_blk[1] | proc_30_start_FIFO_blk[1] | proc_30_TLF_FIFO_blk[1] | proc_30_input_sync_blk[1] | proc_30_output_sync_blk[1]);
    assign proc_30_data_FIFO_blk[2] = 1'b0;
    assign proc_30_data_PIPO_blk[2] = 1'b0;
    assign proc_30_start_FIFO_blk[2] = 1'b0;
    assign proc_30_TLF_FIFO_blk[2] = 1'b0;
    assign proc_30_input_sync_blk[2] = 1'b0;
    assign proc_30_output_sync_blk[2] = 1'b0 | (ap_done_reg_15 & compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done);
    assign proc_dep_vld_vec_30[2] = dl_detect_out ? proc_dep_vld_vec_30_reg[2] : (proc_30_data_FIFO_blk[2] | proc_30_data_PIPO_blk[2] | proc_30_start_FIFO_blk[2] | proc_30_TLF_FIFO_blk[2] | proc_30_input_sync_blk[2] | proc_30_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_30_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_30_reg <= proc_dep_vld_vec_30;
        end
    end
    assign in_chan_dep_vld_vec_30[0] = dep_chan_vld_28_30;
    assign in_chan_dep_data_vec_30[54 : 0] = dep_chan_data_28_30;
    assign token_in_vec_30[0] = token_28_30;
    assign in_chan_dep_vld_vec_30[1] = dep_chan_vld_29_30;
    assign in_chan_dep_data_vec_30[109 : 55] = dep_chan_data_29_30;
    assign token_in_vec_30[1] = token_29_30;
    assign in_chan_dep_vld_vec_30[2] = dep_chan_vld_31_30;
    assign in_chan_dep_data_vec_30[164 : 110] = dep_chan_data_31_30;
    assign token_in_vec_30[2] = token_31_30;
    assign dep_chan_vld_30_31 = out_chan_dep_vld_vec_30[0];
    assign dep_chan_data_30_31 = out_chan_dep_data_30;
    assign token_30_31 = token_out_vec_30[0];
    assign dep_chan_vld_30_29 = out_chan_dep_vld_vec_30[1];
    assign dep_chan_data_30_29 = out_chan_dep_data_30;
    assign token_30_29 = token_out_vec_30[1];
    assign dep_chan_vld_30_28 = out_chan_dep_vld_vec_30[2];
    assign dep_chan_data_30_28 = out_chan_dep_data_30;
    assign token_30_28 = token_out_vec_30[2];

    // Process: compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 31, 4, 4) synthesis_top_hls_deadlock_detect_unit_31 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_31),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_31),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_31),
        .token_in_vec(token_in_vec_31),
        .dl_detect_in(dl_detect_out),
        .origin(origin[31]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_31),
        .out_chan_dep_data(out_chan_dep_data_31),
        .token_out_vec(token_out_vec_31),
        .dl_detect_out(dl_in_vec[31]));

    assign proc_31_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n) | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_31_data_PIPO_blk[0] = 1'b0;
    assign proc_31_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write);
    assign proc_31_TLF_FIFO_blk[0] = 1'b0;
    assign proc_31_input_sync_blk[0] = 1'b0;
    assign proc_31_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_31[0] = dl_detect_out ? proc_dep_vld_vec_31_reg[0] : (proc_31_data_FIFO_blk[0] | proc_31_data_PIPO_blk[0] | proc_31_start_FIFO_blk[0] | proc_31_TLF_FIFO_blk[0] | proc_31_input_sync_blk[0] | proc_31_output_sync_blk[0]);
    assign proc_31_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n);
    assign proc_31_data_PIPO_blk[1] = 1'b0;
    assign proc_31_start_FIFO_blk[1] = 1'b0;
    assign proc_31_TLF_FIFO_blk[1] = 1'b0;
    assign proc_31_input_sync_blk[1] = 1'b0;
    assign proc_31_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_31[1] = dl_detect_out ? proc_dep_vld_vec_31_reg[1] : (proc_31_data_FIFO_blk[1] | proc_31_data_PIPO_blk[1] | proc_31_start_FIFO_blk[1] | proc_31_TLF_FIFO_blk[1] | proc_31_input_sync_blk[1] | proc_31_output_sync_blk[1]);
    assign proc_31_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_pool1_blk_n) | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c8_blk_n);
    assign proc_31_data_PIPO_blk[2] = 1'b0;
    assign proc_31_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_16 == trans_out_cnt_16) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_read);
    assign proc_31_TLF_FIFO_blk[2] = 1'b0;
    assign proc_31_input_sync_blk[2] = 1'b0;
    assign proc_31_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_31[2] = dl_detect_out ? proc_dep_vld_vec_31_reg[2] : (proc_31_data_FIFO_blk[2] | proc_31_data_PIPO_blk[2] | proc_31_start_FIFO_blk[2] | proc_31_TLF_FIFO_blk[2] | proc_31_input_sync_blk[2] | proc_31_output_sync_blk[2]);
    assign proc_31_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_31_data_PIPO_blk[3] = 1'b0;
    assign proc_31_start_FIFO_blk[3] = 1'b0;
    assign proc_31_TLF_FIFO_blk[3] = 1'b0;
    assign proc_31_input_sync_blk[3] = 1'b0;
    assign proc_31_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_31[3] = dl_detect_out ? proc_dep_vld_vec_31_reg[3] : (proc_31_data_FIFO_blk[3] | proc_31_data_PIPO_blk[3] | proc_31_start_FIFO_blk[3] | proc_31_TLF_FIFO_blk[3] | proc_31_input_sync_blk[3] | proc_31_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_31_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_31_reg <= proc_dep_vld_vec_31;
        end
    end
    assign in_chan_dep_vld_vec_31[0] = dep_chan_vld_25_31;
    assign in_chan_dep_data_vec_31[54 : 0] = dep_chan_data_25_31;
    assign token_in_vec_31[0] = token_25_31;
    assign in_chan_dep_vld_vec_31[1] = dep_chan_vld_28_31;
    assign in_chan_dep_data_vec_31[109 : 55] = dep_chan_data_28_31;
    assign token_in_vec_31[1] = token_28_31;
    assign in_chan_dep_vld_vec_31[2] = dep_chan_vld_30_31;
    assign in_chan_dep_data_vec_31[164 : 110] = dep_chan_data_30_31;
    assign token_in_vec_31[2] = token_30_31;
    assign in_chan_dep_vld_vec_31[3] = dep_chan_vld_32_31;
    assign in_chan_dep_data_vec_31[219 : 165] = dep_chan_data_32_31;
    assign token_in_vec_31[3] = token_32_31;
    assign dep_chan_vld_31_25 = out_chan_dep_vld_vec_31[0];
    assign dep_chan_data_31_25 = out_chan_dep_data_31;
    assign token_31_25 = token_out_vec_31[0];
    assign dep_chan_vld_31_30 = out_chan_dep_vld_vec_31[1];
    assign dep_chan_data_31_30 = out_chan_dep_data_31;
    assign token_31_30 = token_out_vec_31[1];
    assign dep_chan_vld_31_32 = out_chan_dep_vld_vec_31[2];
    assign dep_chan_data_31_32 = out_chan_dep_data_31;
    assign token_31_32 = token_out_vec_31[2];
    assign dep_chan_vld_31_28 = out_chan_dep_vld_vec_31[3];
    assign dep_chan_data_31_28 = out_chan_dep_data_31;
    assign token_31_28 = token_out_vec_31[3];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 32, 3, 3) synthesis_top_hls_deadlock_detect_unit_32 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_32),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_32),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_32),
        .token_in_vec(token_in_vec_32),
        .dl_detect_in(dl_detect_out),
        .origin(origin[32]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_32),
        .out_chan_dep_data(out_chan_dep_data_32),
        .token_out_vec(token_out_vec_32),
        .dl_detect_out(dl_in_vec[32]));

    assign proc_32_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_pool1_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.reps_blk_n);
    assign proc_32_data_PIPO_blk[0] = 1'b0;
    assign proc_32_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_write);
    assign proc_32_TLF_FIFO_blk[0] = 1'b0;
    assign proc_32_input_sync_blk[0] = 1'b0;
    assign proc_32_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_32[0] = dl_detect_out ? proc_dep_vld_vec_32_reg[0] : (proc_32_data_FIFO_blk[0] | proc_32_data_PIPO_blk[0] | proc_32_start_FIFO_blk[0] | proc_32_TLF_FIFO_blk[0] | proc_32_input_sync_blk[0] | proc_32_output_sync_blk[0]);
    assign proc_32_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n);
    assign proc_32_data_PIPO_blk[1] = 1'b0;
    assign proc_32_start_FIFO_blk[1] = 1'b0;
    assign proc_32_TLF_FIFO_blk[1] = 1'b0;
    assign proc_32_input_sync_blk[1] = 1'b0;
    assign proc_32_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_32[1] = dl_detect_out ? proc_dep_vld_vec_32_reg[1] : (proc_32_data_FIFO_blk[1] | proc_32_data_PIPO_blk[1] | proc_32_start_FIFO_blk[1] | proc_32_TLF_FIFO_blk[1] | proc_32_input_sync_blk[1] | proc_32_output_sync_blk[1]);
    assign proc_32_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n);
    assign proc_32_data_PIPO_blk[2] = 1'b0;
    assign proc_32_start_FIFO_blk[2] = 1'b0;
    assign proc_32_TLF_FIFO_blk[2] = 1'b0;
    assign proc_32_input_sync_blk[2] = 1'b0;
    assign proc_32_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_32[2] = dl_detect_out ? proc_dep_vld_vec_32_reg[2] : (proc_32_data_FIFO_blk[2] | proc_32_data_PIPO_blk[2] | proc_32_start_FIFO_blk[2] | proc_32_TLF_FIFO_blk[2] | proc_32_input_sync_blk[2] | proc_32_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_32_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_32_reg <= proc_dep_vld_vec_32;
        end
    end
    assign in_chan_dep_vld_vec_32[0] = dep_chan_vld_31_32;
    assign in_chan_dep_data_vec_32[54 : 0] = dep_chan_data_31_32;
    assign token_in_vec_32[0] = token_31_32;
    assign in_chan_dep_vld_vec_32[1] = dep_chan_vld_33_32;
    assign in_chan_dep_data_vec_32[109 : 55] = dep_chan_data_33_32;
    assign token_in_vec_32[1] = token_33_32;
    assign in_chan_dep_vld_vec_32[2] = dep_chan_vld_36_32;
    assign in_chan_dep_data_vec_32[164 : 110] = dep_chan_data_36_32;
    assign token_in_vec_32[2] = token_36_32;
    assign dep_chan_vld_32_31 = out_chan_dep_vld_vec_32[0];
    assign dep_chan_data_32_31 = out_chan_dep_data_32;
    assign token_32_31 = token_out_vec_32[0];
    assign dep_chan_vld_32_33 = out_chan_dep_vld_vec_32[1];
    assign dep_chan_data_32_33 = out_chan_dep_data_32;
    assign token_32_33 = token_out_vec_32[1];
    assign dep_chan_vld_32_36 = out_chan_dep_vld_vec_32[2];
    assign dep_chan_data_32_36 = out_chan_dep_data_32;
    assign token_32_36 = token_out_vec_32[2];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 33, 7, 7) synthesis_top_hls_deadlock_detect_unit_33 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_33),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_33),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_33),
        .token_in_vec(token_in_vec_33),
        .dl_detect_in(dl_detect_out),
        .origin(origin[33]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_33),
        .out_chan_dep_data(out_chan_dep_data_33),
        .token_out_vec(token_out_vec_33),
        .dl_detect_out(dl_in_vec[33]));

    assign proc_33_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n);
    assign proc_33_data_PIPO_blk[0] = 1'b0;
    assign proc_33_start_FIFO_blk[0] = 1'b0;
    assign proc_33_TLF_FIFO_blk[0] = 1'b0;
    assign proc_33_input_sync_blk[0] = 1'b0;
    assign proc_33_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_33[0] = dl_detect_out ? proc_dep_vld_vec_33_reg[0] : (proc_33_data_FIFO_blk[0] | proc_33_data_PIPO_blk[0] | proc_33_start_FIFO_blk[0] | proc_33_TLF_FIFO_blk[0] | proc_33_input_sync_blk[0] | proc_33_output_sync_blk[0]);
    assign proc_33_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n);
    assign proc_33_data_PIPO_blk[1] = 1'b0;
    assign proc_33_start_FIFO_blk[1] = 1'b0;
    assign proc_33_TLF_FIFO_blk[1] = 1'b0;
    assign proc_33_input_sync_blk[1] = 1'b0;
    assign proc_33_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_33[1] = dl_detect_out ? proc_dep_vld_vec_33_reg[1] : (proc_33_data_FIFO_blk[1] | proc_33_data_PIPO_blk[1] | proc_33_start_FIFO_blk[1] | proc_33_TLF_FIFO_blk[1] | proc_33_input_sync_blk[1] | proc_33_output_sync_blk[1]);
    assign proc_33_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n);
    assign proc_33_data_PIPO_blk[2] = 1'b0;
    assign proc_33_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read);
    assign proc_33_TLF_FIFO_blk[2] = 1'b0;
    assign proc_33_input_sync_blk[2] = 1'b0;
    assign proc_33_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_33[2] = dl_detect_out ? proc_dep_vld_vec_33_reg[2] : (proc_33_data_FIFO_blk[2] | proc_33_data_PIPO_blk[2] | proc_33_start_FIFO_blk[2] | proc_33_TLF_FIFO_blk[2] | proc_33_input_sync_blk[2] | proc_33_output_sync_blk[2]);
    assign proc_33_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n);
    assign proc_33_data_PIPO_blk[3] = 1'b0;
    assign proc_33_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_write);
    assign proc_33_TLF_FIFO_blk[3] = 1'b0;
    assign proc_33_input_sync_blk[3] = 1'b0;
    assign proc_33_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_33[3] = dl_detect_out ? proc_dep_vld_vec_33_reg[3] : (proc_33_data_FIFO_blk[3] | proc_33_data_PIPO_blk[3] | proc_33_start_FIFO_blk[3] | proc_33_TLF_FIFO_blk[3] | proc_33_input_sync_blk[3] | proc_33_output_sync_blk[3]);
    assign proc_33_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n);
    assign proc_33_data_PIPO_blk[4] = 1'b0;
    assign proc_33_start_FIFO_blk[4] = 1'b0;
    assign proc_33_TLF_FIFO_blk[4] = 1'b0;
    assign proc_33_input_sync_blk[4] = 1'b0;
    assign proc_33_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_33[4] = dl_detect_out ? proc_dep_vld_vec_33_reg[4] : (proc_33_data_FIFO_blk[4] | proc_33_data_PIPO_blk[4] | proc_33_start_FIFO_blk[4] | proc_33_TLF_FIFO_blk[4] | proc_33_input_sync_blk[4] | proc_33_output_sync_blk[4]);
    assign proc_33_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n);
    assign proc_33_data_PIPO_blk[5] = 1'b0;
    assign proc_33_start_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_read);
    assign proc_33_TLF_FIFO_blk[5] = 1'b0;
    assign proc_33_input_sync_blk[5] = 1'b0;
    assign proc_33_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_33[5] = dl_detect_out ? proc_dep_vld_vec_33_reg[5] : (proc_33_data_FIFO_blk[5] | proc_33_data_PIPO_blk[5] | proc_33_start_FIFO_blk[5] | proc_33_TLF_FIFO_blk[5] | proc_33_input_sync_blk[5] | proc_33_output_sync_blk[5]);
    assign proc_33_data_FIFO_blk[6] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n);
    assign proc_33_data_PIPO_blk[6] = 1'b0;
    assign proc_33_start_FIFO_blk[6] = 1'b0;
    assign proc_33_TLF_FIFO_blk[6] = 1'b0;
    assign proc_33_input_sync_blk[6] = 1'b0;
    assign proc_33_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_33[6] = dl_detect_out ? proc_dep_vld_vec_33_reg[6] : (proc_33_data_FIFO_blk[6] | proc_33_data_PIPO_blk[6] | proc_33_start_FIFO_blk[6] | proc_33_TLF_FIFO_blk[6] | proc_33_input_sync_blk[6] | proc_33_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_33_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_33_reg <= proc_dep_vld_vec_33;
        end
    end
    assign in_chan_dep_vld_vec_33[0] = dep_chan_vld_1_33;
    assign in_chan_dep_data_vec_33[54 : 0] = dep_chan_data_1_33;
    assign token_in_vec_33[0] = token_1_33;
    assign in_chan_dep_vld_vec_33[1] = dep_chan_vld_25_33;
    assign in_chan_dep_data_vec_33[109 : 55] = dep_chan_data_25_33;
    assign token_in_vec_33[1] = token_25_33;
    assign in_chan_dep_vld_vec_33[2] = dep_chan_vld_26_33;
    assign in_chan_dep_data_vec_33[164 : 110] = dep_chan_data_26_33;
    assign token_in_vec_33[2] = token_26_33;
    assign in_chan_dep_vld_vec_33[3] = dep_chan_vld_32_33;
    assign in_chan_dep_data_vec_33[219 : 165] = dep_chan_data_32_33;
    assign token_in_vec_33[3] = token_32_33;
    assign in_chan_dep_vld_vec_33[4] = dep_chan_vld_39_33;
    assign in_chan_dep_data_vec_33[274 : 220] = dep_chan_data_39_33;
    assign token_in_vec_33[4] = token_39_33;
    assign in_chan_dep_vld_vec_33[5] = dep_chan_vld_41_33;
    assign in_chan_dep_data_vec_33[329 : 275] = dep_chan_data_41_33;
    assign token_in_vec_33[5] = token_41_33;
    assign in_chan_dep_vld_vec_33[6] = dep_chan_vld_42_33;
    assign in_chan_dep_data_vec_33[384 : 330] = dep_chan_data_42_33;
    assign token_in_vec_33[6] = token_42_33;
    assign dep_chan_vld_33_32 = out_chan_dep_vld_vec_33[0];
    assign dep_chan_data_33_32 = out_chan_dep_data_33;
    assign token_33_32 = token_out_vec_33[0];
    assign dep_chan_vld_33_1 = out_chan_dep_vld_vec_33[1];
    assign dep_chan_data_33_1 = out_chan_dep_data_33;
    assign token_33_1 = token_out_vec_33[1];
    assign dep_chan_vld_33_39 = out_chan_dep_vld_vec_33[2];
    assign dep_chan_data_33_39 = out_chan_dep_data_33;
    assign token_33_39 = token_out_vec_33[2];
    assign dep_chan_vld_33_25 = out_chan_dep_vld_vec_33[3];
    assign dep_chan_data_33_25 = out_chan_dep_data_33;
    assign token_33_25 = token_out_vec_33[3];
    assign dep_chan_vld_33_26 = out_chan_dep_vld_vec_33[4];
    assign dep_chan_data_33_26 = out_chan_dep_data_33;
    assign token_33_26 = token_out_vec_33[4];
    assign dep_chan_vld_33_41 = out_chan_dep_vld_vec_33[5];
    assign dep_chan_data_33_41 = out_chan_dep_data_33;
    assign token_33_41 = token_out_vec_33[5];
    assign dep_chan_vld_33_42 = out_chan_dep_vld_vec_33[6];
    assign dep_chan_data_33_42 = out_chan_dep_data_33;
    assign token_33_42 = token_out_vec_33[6];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 34, 6, 6) synthesis_top_hls_deadlock_detect_unit_34 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_34),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_34),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_34),
        .token_in_vec(token_in_vec_34),
        .dl_detect_in(dl_detect_out),
        .origin(origin[34]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_34),
        .out_chan_dep_data(out_chan_dep_data_34),
        .token_out_vec(token_out_vec_34),
        .dl_detect_out(dl_in_vec[34]));

    assign proc_34_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n);
    assign proc_34_data_PIPO_blk[0] = 1'b0;
    assign proc_34_start_FIFO_blk[0] = 1'b0;
    assign proc_34_TLF_FIFO_blk[0] = 1'b0;
    assign proc_34_input_sync_blk[0] = 1'b0;
    assign proc_34_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_34[0] = dl_detect_out ? proc_dep_vld_vec_34_reg[0] : (proc_34_data_FIFO_blk[0] | proc_34_data_PIPO_blk[0] | proc_34_start_FIFO_blk[0] | proc_34_TLF_FIFO_blk[0] | proc_34_input_sync_blk[0] | proc_34_output_sync_blk[0]);
    assign proc_34_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n);
    assign proc_34_data_PIPO_blk[1] = 1'b0;
    assign proc_34_start_FIFO_blk[1] = 1'b0;
    assign proc_34_TLF_FIFO_blk[1] = 1'b0;
    assign proc_34_input_sync_blk[1] = 1'b0;
    assign proc_34_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_34[1] = dl_detect_out ? proc_dep_vld_vec_34_reg[1] : (proc_34_data_FIFO_blk[1] | proc_34_data_PIPO_blk[1] | proc_34_start_FIFO_blk[1] | proc_34_TLF_FIFO_blk[1] | proc_34_input_sync_blk[1] | proc_34_output_sync_blk[1]);
    assign proc_34_data_FIFO_blk[2] = 1'b0;
    assign proc_34_data_PIPO_blk[2] = 1'b0;
    assign proc_34_start_FIFO_blk[2] = 1'b0;
    assign proc_34_TLF_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_done & ap_done_reg_6 & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_read);
    assign proc_34_input_sync_blk[2] = 1'b0;
    assign proc_34_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_34[2] = dl_detect_out ? proc_dep_vld_vec_34_reg[2] : (proc_34_data_FIFO_blk[2] | proc_34_data_PIPO_blk[2] | proc_34_start_FIFO_blk[2] | proc_34_TLF_FIFO_blk[2] | proc_34_input_sync_blk[2] | proc_34_output_sync_blk[2]);
    assign proc_34_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n);
    assign proc_34_data_PIPO_blk[3] = 1'b0;
    assign proc_34_start_FIFO_blk[3] = 1'b0;
    assign proc_34_TLF_FIFO_blk[3] = 1'b0;
    assign proc_34_input_sync_blk[3] = 1'b0;
    assign proc_34_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_34[3] = dl_detect_out ? proc_dep_vld_vec_34_reg[3] : (proc_34_data_FIFO_blk[3] | proc_34_data_PIPO_blk[3] | proc_34_start_FIFO_blk[3] | proc_34_TLF_FIFO_blk[3] | proc_34_input_sync_blk[3] | proc_34_output_sync_blk[3]);
    assign proc_34_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n);
    assign proc_34_data_PIPO_blk[4] = 1'b0;
    assign proc_34_start_FIFO_blk[4] = 1'b0;
    assign proc_34_TLF_FIFO_blk[4] = 1'b0;
    assign proc_34_input_sync_blk[4] = 1'b0;
    assign proc_34_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_34[4] = dl_detect_out ? proc_dep_vld_vec_34_reg[4] : (proc_34_data_FIFO_blk[4] | proc_34_data_PIPO_blk[4] | proc_34_start_FIFO_blk[4] | proc_34_TLF_FIFO_blk[4] | proc_34_input_sync_blk[4] | proc_34_output_sync_blk[4]);
    assign proc_34_data_FIFO_blk[5] = 1'b0;
    assign proc_34_data_PIPO_blk[5] = 1'b0;
    assign proc_34_start_FIFO_blk[5] = 1'b0;
    assign proc_34_TLF_FIFO_blk[5] = 1'b0;
    assign proc_34_input_sync_blk[5] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready);
    assign proc_34_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_34[5] = dl_detect_out ? proc_dep_vld_vec_34_reg[5] : (proc_34_data_FIFO_blk[5] | proc_34_data_PIPO_blk[5] | proc_34_start_FIFO_blk[5] | proc_34_TLF_FIFO_blk[5] | proc_34_input_sync_blk[5] | proc_34_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_34_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_34_reg <= proc_dep_vld_vec_34;
        end
    end
    assign in_chan_dep_vld_vec_34[0] = dep_chan_vld_25_34;
    assign in_chan_dep_data_vec_34[54 : 0] = dep_chan_data_25_34;
    assign token_in_vec_34[0] = token_25_34;
    assign in_chan_dep_vld_vec_34[1] = dep_chan_vld_26_34;
    assign in_chan_dep_data_vec_34[109 : 55] = dep_chan_data_26_34;
    assign token_in_vec_34[1] = token_26_34;
    assign in_chan_dep_vld_vec_34[2] = dep_chan_vld_35_34;
    assign in_chan_dep_data_vec_34[164 : 110] = dep_chan_data_35_34;
    assign token_in_vec_34[2] = token_35_34;
    assign in_chan_dep_vld_vec_34[3] = dep_chan_vld_36_34;
    assign in_chan_dep_data_vec_34[219 : 165] = dep_chan_data_36_34;
    assign token_in_vec_34[3] = token_36_34;
    assign in_chan_dep_vld_vec_34[4] = dep_chan_vld_41_34;
    assign in_chan_dep_data_vec_34[274 : 220] = dep_chan_data_41_34;
    assign token_in_vec_34[4] = token_41_34;
    assign in_chan_dep_vld_vec_34[5] = dep_chan_vld_42_34;
    assign in_chan_dep_data_vec_34[329 : 275] = dep_chan_data_42_34;
    assign token_in_vec_34[5] = token_42_34;
    assign dep_chan_vld_34_25 = out_chan_dep_vld_vec_34[0];
    assign dep_chan_data_34_25 = out_chan_dep_data_34;
    assign token_34_25 = token_out_vec_34[0];
    assign dep_chan_vld_34_26 = out_chan_dep_vld_vec_34[1];
    assign dep_chan_data_34_26 = out_chan_dep_data_34;
    assign token_34_26 = token_out_vec_34[1];
    assign dep_chan_vld_34_35 = out_chan_dep_vld_vec_34[2];
    assign dep_chan_data_34_35 = out_chan_dep_data_34;
    assign token_34_35 = token_out_vec_34[2];
    assign dep_chan_vld_34_41 = out_chan_dep_vld_vec_34[3];
    assign dep_chan_data_34_41 = out_chan_dep_data_34;
    assign token_34_41 = token_out_vec_34[3];
    assign dep_chan_vld_34_42 = out_chan_dep_vld_vec_34[4];
    assign dep_chan_data_34_42 = out_chan_dep_data_34;
    assign token_34_42 = token_out_vec_34[4];
    assign dep_chan_vld_34_36 = out_chan_dep_vld_vec_34[5];
    assign dep_chan_data_34_36 = out_chan_dep_data_34;
    assign token_34_36 = token_out_vec_34[5];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 35, 2, 2) synthesis_top_hls_deadlock_detect_unit_35 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_35),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_35),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_35),
        .token_in_vec(token_in_vec_35),
        .dl_detect_in(dl_detect_out),
        .origin(origin[35]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_35),
        .out_chan_dep_data(out_chan_dep_data_35),
        .token_out_vec(token_out_vec_35),
        .dl_detect_out(dl_in_vec[35]));

    assign proc_35_data_FIFO_blk[0] = 1'b0;
    assign proc_35_data_PIPO_blk[0] = 1'b0;
    assign proc_35_start_FIFO_blk[0] = 1'b0;
    assign proc_35_TLF_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_write);
    assign proc_35_input_sync_blk[0] = 1'b0;
    assign proc_35_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_35[0] = dl_detect_out ? proc_dep_vld_vec_35_reg[0] : (proc_35_data_FIFO_blk[0] | proc_35_data_PIPO_blk[0] | proc_35_start_FIFO_blk[0] | proc_35_TLF_FIFO_blk[0] | proc_35_input_sync_blk[0] | proc_35_output_sync_blk[0]);
    assign proc_35_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.load_c_blk_n);
    assign proc_35_data_PIPO_blk[1] = 1'b0;
    assign proc_35_start_FIFO_blk[1] = 1'b0;
    assign proc_35_TLF_FIFO_blk[1] = 1'b0;
    assign proc_35_input_sync_blk[1] = 1'b0;
    assign proc_35_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_35[1] = dl_detect_out ? proc_dep_vld_vec_35_reg[1] : (proc_35_data_FIFO_blk[1] | proc_35_data_PIPO_blk[1] | proc_35_start_FIFO_blk[1] | proc_35_TLF_FIFO_blk[1] | proc_35_input_sync_blk[1] | proc_35_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_35_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_35_reg <= proc_dep_vld_vec_35;
        end
    end
    assign in_chan_dep_vld_vec_35[0] = dep_chan_vld_34_35;
    assign in_chan_dep_data_vec_35[54 : 0] = dep_chan_data_34_35;
    assign token_in_vec_35[0] = token_34_35;
    assign in_chan_dep_vld_vec_35[1] = dep_chan_vld_37_35;
    assign in_chan_dep_data_vec_35[109 : 55] = dep_chan_data_37_35;
    assign token_in_vec_35[1] = token_37_35;
    assign dep_chan_vld_35_34 = out_chan_dep_vld_vec_35[0];
    assign dep_chan_data_35_34 = out_chan_dep_data_35;
    assign token_35_34 = token_out_vec_35[0];
    assign dep_chan_vld_35_37 = out_chan_dep_vld_vec_35[1];
    assign dep_chan_data_35_37 = out_chan_dep_data_35;
    assign token_35_37 = token_out_vec_35[1];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 36, 5, 5) synthesis_top_hls_deadlock_detect_unit_36 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_36),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_36),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_36),
        .token_in_vec(token_in_vec_36),
        .dl_detect_in(dl_detect_out),
        .origin(origin[36]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_36),
        .out_chan_dep_data(out_chan_dep_data_36),
        .token_out_vec(token_out_vec_36),
        .dl_detect_out(dl_in_vec[36]));

    assign proc_36_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n);
    assign proc_36_data_PIPO_blk[0] = 1'b0;
    assign proc_36_start_FIFO_blk[0] = 1'b0;
    assign proc_36_TLF_FIFO_blk[0] = 1'b0;
    assign proc_36_input_sync_blk[0] = 1'b0;
    assign proc_36_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_36[0] = dl_detect_out ? proc_dep_vld_vec_36_reg[0] : (proc_36_data_FIFO_blk[0] | proc_36_data_PIPO_blk[0] | proc_36_start_FIFO_blk[0] | proc_36_TLF_FIFO_blk[0] | proc_36_input_sync_blk[0] | proc_36_output_sync_blk[0]);
    assign proc_36_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.win_s_1_blk_n);
    assign proc_36_data_PIPO_blk[1] = 1'b0;
    assign proc_36_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.real_start & (trans_in_cnt_17 == trans_out_cnt_17) & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_read);
    assign proc_36_TLF_FIFO_blk[1] = 1'b0;
    assign proc_36_input_sync_blk[1] = 1'b0;
    assign proc_36_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_36[1] = dl_detect_out ? proc_dep_vld_vec_36_reg[1] : (proc_36_data_FIFO_blk[1] | proc_36_data_PIPO_blk[1] | proc_36_start_FIFO_blk[1] | proc_36_TLF_FIFO_blk[1] | proc_36_input_sync_blk[1] | proc_36_output_sync_blk[1]);
    assign proc_36_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n);
    assign proc_36_data_PIPO_blk[2] = 1'b0;
    assign proc_36_start_FIFO_blk[2] = 1'b0;
    assign proc_36_TLF_FIFO_blk[2] = 1'b0;
    assign proc_36_input_sync_blk[2] = 1'b0;
    assign proc_36_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_36[2] = dl_detect_out ? proc_dep_vld_vec_36_reg[2] : (proc_36_data_FIFO_blk[2] | proc_36_data_PIPO_blk[2] | proc_36_start_FIFO_blk[2] | proc_36_TLF_FIFO_blk[2] | proc_36_input_sync_blk[2] | proc_36_output_sync_blk[2]);
    assign proc_36_data_FIFO_blk[3] = 1'b0;
    assign proc_36_data_PIPO_blk[3] = 1'b0;
    assign proc_36_start_FIFO_blk[3] = 1'b0;
    assign proc_36_TLF_FIFO_blk[3] = 1'b0;
    assign proc_36_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready);
    assign proc_36_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_36[3] = dl_detect_out ? proc_dep_vld_vec_36_reg[3] : (proc_36_data_FIFO_blk[3] | proc_36_data_PIPO_blk[3] | proc_36_start_FIFO_blk[3] | proc_36_TLF_FIFO_blk[3] | proc_36_input_sync_blk[3] | proc_36_output_sync_blk[3]);
    assign proc_36_data_FIFO_blk[4] = 1'b0;
    assign proc_36_data_PIPO_blk[4] = 1'b0;
    assign proc_36_start_FIFO_blk[4] = 1'b0;
    assign proc_36_TLF_FIFO_blk[4] = 1'b0;
    assign proc_36_input_sync_blk[4] = 1'b0;
    assign proc_36_output_sync_blk[4] = 1'b0 | (ap_done_reg_16 & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done);
    assign proc_dep_vld_vec_36[4] = dl_detect_out ? proc_dep_vld_vec_36_reg[4] : (proc_36_data_FIFO_blk[4] | proc_36_data_PIPO_blk[4] | proc_36_start_FIFO_blk[4] | proc_36_TLF_FIFO_blk[4] | proc_36_input_sync_blk[4] | proc_36_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_36_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_36_reg <= proc_dep_vld_vec_36;
        end
    end
    assign in_chan_dep_vld_vec_36[0] = dep_chan_vld_32_36;
    assign in_chan_dep_data_vec_36[54 : 0] = dep_chan_data_32_36;
    assign token_in_vec_36[0] = token_32_36;
    assign in_chan_dep_vld_vec_36[1] = dep_chan_vld_34_36;
    assign in_chan_dep_data_vec_36[109 : 55] = dep_chan_data_34_36;
    assign token_in_vec_36[1] = token_34_36;
    assign in_chan_dep_vld_vec_36[2] = dep_chan_vld_37_36;
    assign in_chan_dep_data_vec_36[164 : 110] = dep_chan_data_37_36;
    assign token_in_vec_36[2] = token_37_36;
    assign in_chan_dep_vld_vec_36[3] = dep_chan_vld_38_36;
    assign in_chan_dep_data_vec_36[219 : 165] = dep_chan_data_38_36;
    assign token_in_vec_36[3] = token_38_36;
    assign in_chan_dep_vld_vec_36[4] = dep_chan_vld_39_36;
    assign in_chan_dep_data_vec_36[274 : 220] = dep_chan_data_39_36;
    assign token_in_vec_36[4] = token_39_36;
    assign dep_chan_vld_36_32 = out_chan_dep_vld_vec_36[0];
    assign dep_chan_data_36_32 = out_chan_dep_data_36;
    assign token_36_32 = token_out_vec_36[0];
    assign dep_chan_vld_36_37 = out_chan_dep_vld_vec_36[1];
    assign dep_chan_data_36_37 = out_chan_dep_data_36;
    assign token_36_37 = token_out_vec_36[1];
    assign dep_chan_vld_36_39 = out_chan_dep_vld_vec_36[2];
    assign dep_chan_data_36_39 = out_chan_dep_data_36;
    assign token_36_39 = token_out_vec_36[2];
    assign dep_chan_vld_36_34 = out_chan_dep_vld_vec_36[3];
    assign dep_chan_data_36_34 = out_chan_dep_data_36;
    assign token_36_34 = token_out_vec_36[3];
    assign dep_chan_vld_36_38 = out_chan_dep_vld_vec_36[4];
    assign dep_chan_data_36_38 = out_chan_dep_data_36;
    assign token_36_38 = token_out_vec_36[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 37, 4, 4) synthesis_top_hls_deadlock_detect_unit_37 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_37),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_37),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_37),
        .token_in_vec(token_in_vec_37),
        .dl_detect_in(dl_detect_out),
        .origin(origin[37]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_37),
        .out_chan_dep_data(out_chan_dep_data_37),
        .token_out_vec(token_out_vec_37),
        .dl_detect_out(dl_in_vec[37]));

    assign proc_37_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n);
    assign proc_37_data_PIPO_blk[0] = 1'b0;
    assign proc_37_start_FIFO_blk[0] = 1'b0;
    assign proc_37_TLF_FIFO_blk[0] = 1'b0;
    assign proc_37_input_sync_blk[0] = 1'b0;
    assign proc_37_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_37[0] = dl_detect_out ? proc_dep_vld_vec_37_reg[0] : (proc_37_data_FIFO_blk[0] | proc_37_data_PIPO_blk[0] | proc_37_start_FIFO_blk[0] | proc_37_TLF_FIFO_blk[0] | proc_37_input_sync_blk[0] | proc_37_output_sync_blk[0]);
    assign proc_37_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.win_s_1_blk_n);
    assign proc_37_data_PIPO_blk[1] = 1'b0;
    assign proc_37_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_write);
    assign proc_37_TLF_FIFO_blk[1] = 1'b0;
    assign proc_37_input_sync_blk[1] = 1'b0;
    assign proc_37_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_37[1] = dl_detect_out ? proc_dep_vld_vec_37_reg[1] : (proc_37_data_FIFO_blk[1] | proc_37_data_PIPO_blk[1] | proc_37_start_FIFO_blk[1] | proc_37_TLF_FIFO_blk[1] | proc_37_input_sync_blk[1] | proc_37_output_sync_blk[1]);
    assign proc_37_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.load_weights_blk_n);
    assign proc_37_data_PIPO_blk[2] = 1'b0;
    assign proc_37_start_FIFO_blk[2] = 1'b0;
    assign proc_37_TLF_FIFO_blk[2] = 1'b0;
    assign proc_37_input_sync_blk[2] = 1'b0;
    assign proc_37_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_37[2] = dl_detect_out ? proc_dep_vld_vec_37_reg[2] : (proc_37_data_FIFO_blk[2] | proc_37_data_PIPO_blk[2] | proc_37_start_FIFO_blk[2] | proc_37_TLF_FIFO_blk[2] | proc_37_input_sync_blk[2] | proc_37_output_sync_blk[2]);
    assign proc_37_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.out_vec_s_1_blk_n);
    assign proc_37_data_PIPO_blk[3] = 1'b0;
    assign proc_37_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.real_start & (trans_in_cnt_18 == trans_out_cnt_18) & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_read);
    assign proc_37_TLF_FIFO_blk[3] = 1'b0;
    assign proc_37_input_sync_blk[3] = 1'b0;
    assign proc_37_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_37[3] = dl_detect_out ? proc_dep_vld_vec_37_reg[3] : (proc_37_data_FIFO_blk[3] | proc_37_data_PIPO_blk[3] | proc_37_start_FIFO_blk[3] | proc_37_TLF_FIFO_blk[3] | proc_37_input_sync_blk[3] | proc_37_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_37_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_37_reg <= proc_dep_vld_vec_37;
        end
    end
    assign in_chan_dep_vld_vec_37[0] = dep_chan_vld_1_37;
    assign in_chan_dep_data_vec_37[54 : 0] = dep_chan_data_1_37;
    assign token_in_vec_37[0] = token_1_37;
    assign in_chan_dep_vld_vec_37[1] = dep_chan_vld_35_37;
    assign in_chan_dep_data_vec_37[109 : 55] = dep_chan_data_35_37;
    assign token_in_vec_37[1] = token_35_37;
    assign in_chan_dep_vld_vec_37[2] = dep_chan_vld_36_37;
    assign in_chan_dep_data_vec_37[164 : 110] = dep_chan_data_36_37;
    assign token_in_vec_37[2] = token_36_37;
    assign in_chan_dep_vld_vec_37[3] = dep_chan_vld_38_37;
    assign in_chan_dep_data_vec_37[219 : 165] = dep_chan_data_38_37;
    assign token_in_vec_37[3] = token_38_37;
    assign dep_chan_vld_37_1 = out_chan_dep_vld_vec_37[0];
    assign dep_chan_data_37_1 = out_chan_dep_data_37;
    assign token_37_1 = token_out_vec_37[0];
    assign dep_chan_vld_37_36 = out_chan_dep_vld_vec_37[1];
    assign dep_chan_data_37_36 = out_chan_dep_data_37;
    assign token_37_36 = token_out_vec_37[1];
    assign dep_chan_vld_37_35 = out_chan_dep_vld_vec_37[2];
    assign dep_chan_data_37_35 = out_chan_dep_data_37;
    assign token_37_35 = token_out_vec_37[2];
    assign dep_chan_vld_37_38 = out_chan_dep_vld_vec_37[3];
    assign dep_chan_data_37_38 = out_chan_dep_data_37;
    assign token_37_38 = token_out_vec_37[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 38, 3, 3) synthesis_top_hls_deadlock_detect_unit_38 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_38),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_38),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_38),
        .token_in_vec(token_in_vec_38),
        .dl_detect_in(dl_detect_out),
        .origin(origin[38]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_38),
        .out_chan_dep_data(out_chan_dep_data_38),
        .token_out_vec(token_out_vec_38),
        .dl_detect_out(dl_in_vec[38]));

    assign proc_38_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n);
    assign proc_38_data_PIPO_blk[0] = 1'b0;
    assign proc_38_start_FIFO_blk[0] = 1'b0;
    assign proc_38_TLF_FIFO_blk[0] = 1'b0;
    assign proc_38_input_sync_blk[0] = 1'b0;
    assign proc_38_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_38[0] = dl_detect_out ? proc_dep_vld_vec_38_reg[0] : (proc_38_data_FIFO_blk[0] | proc_38_data_PIPO_blk[0] | proc_38_start_FIFO_blk[0] | proc_38_TLF_FIFO_blk[0] | proc_38_input_sync_blk[0] | proc_38_output_sync_blk[0]);
    assign proc_38_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.out_vec_s_1_blk_n);
    assign proc_38_data_PIPO_blk[1] = 1'b0;
    assign proc_38_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_write);
    assign proc_38_TLF_FIFO_blk[1] = 1'b0;
    assign proc_38_input_sync_blk[1] = 1'b0;
    assign proc_38_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_38[1] = dl_detect_out ? proc_dep_vld_vec_38_reg[1] : (proc_38_data_FIFO_blk[1] | proc_38_data_PIPO_blk[1] | proc_38_start_FIFO_blk[1] | proc_38_TLF_FIFO_blk[1] | proc_38_input_sync_blk[1] | proc_38_output_sync_blk[1]);
    assign proc_38_data_FIFO_blk[2] = 1'b0;
    assign proc_38_data_PIPO_blk[2] = 1'b0;
    assign proc_38_start_FIFO_blk[2] = 1'b0;
    assign proc_38_TLF_FIFO_blk[2] = 1'b0;
    assign proc_38_input_sync_blk[2] = 1'b0;
    assign proc_38_output_sync_blk[2] = 1'b0 | (ap_done_reg_17 & compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done);
    assign proc_dep_vld_vec_38[2] = dl_detect_out ? proc_dep_vld_vec_38_reg[2] : (proc_38_data_FIFO_blk[2] | proc_38_data_PIPO_blk[2] | proc_38_start_FIFO_blk[2] | proc_38_TLF_FIFO_blk[2] | proc_38_input_sync_blk[2] | proc_38_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_38_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_38_reg <= proc_dep_vld_vec_38;
        end
    end
    assign in_chan_dep_vld_vec_38[0] = dep_chan_vld_36_38;
    assign in_chan_dep_data_vec_38[54 : 0] = dep_chan_data_36_38;
    assign token_in_vec_38[0] = token_36_38;
    assign in_chan_dep_vld_vec_38[1] = dep_chan_vld_37_38;
    assign in_chan_dep_data_vec_38[109 : 55] = dep_chan_data_37_38;
    assign token_in_vec_38[1] = token_37_38;
    assign in_chan_dep_vld_vec_38[2] = dep_chan_vld_39_38;
    assign in_chan_dep_data_vec_38[164 : 110] = dep_chan_data_39_38;
    assign token_in_vec_38[2] = token_39_38;
    assign dep_chan_vld_38_39 = out_chan_dep_vld_vec_38[0];
    assign dep_chan_data_38_39 = out_chan_dep_data_38;
    assign token_38_39 = token_out_vec_38[0];
    assign dep_chan_vld_38_37 = out_chan_dep_vld_vec_38[1];
    assign dep_chan_data_38_37 = out_chan_dep_data_38;
    assign token_38_37 = token_out_vec_38[1];
    assign dep_chan_vld_38_36 = out_chan_dep_vld_vec_38[2];
    assign dep_chan_data_38_36 = out_chan_dep_data_38;
    assign token_38_36 = token_out_vec_38[2];

    // Process: compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 39, 4, 4) synthesis_top_hls_deadlock_detect_unit_39 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_39),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_39),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_39),
        .token_in_vec(token_in_vec_39),
        .dl_detect_in(dl_detect_out),
        .origin(origin[39]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_39),
        .out_chan_dep_data(out_chan_dep_data_39),
        .token_out_vec(token_out_vec_39),
        .dl_detect_out(dl_in_vec[39]));

    assign proc_39_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n) | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_39_data_PIPO_blk[0] = 1'b0;
    assign proc_39_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write);
    assign proc_39_TLF_FIFO_blk[0] = 1'b0;
    assign proc_39_input_sync_blk[0] = 1'b0;
    assign proc_39_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_39[0] = dl_detect_out ? proc_dep_vld_vec_39_reg[0] : (proc_39_data_FIFO_blk[0] | proc_39_data_PIPO_blk[0] | proc_39_start_FIFO_blk[0] | proc_39_TLF_FIFO_blk[0] | proc_39_input_sync_blk[0] | proc_39_output_sync_blk[0]);
    assign proc_39_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n);
    assign proc_39_data_PIPO_blk[1] = 1'b0;
    assign proc_39_start_FIFO_blk[1] = 1'b0;
    assign proc_39_TLF_FIFO_blk[1] = 1'b0;
    assign proc_39_input_sync_blk[1] = 1'b0;
    assign proc_39_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_39[1] = dl_detect_out ? proc_dep_vld_vec_39_reg[1] : (proc_39_data_FIFO_blk[1] | proc_39_data_PIPO_blk[1] | proc_39_start_FIFO_blk[1] | proc_39_TLF_FIFO_blk[1] | proc_39_input_sync_blk[1] | proc_39_output_sync_blk[1]);
    assign proc_39_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_pool1_blk_n) | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c5_blk_n);
    assign proc_39_data_PIPO_blk[2] = 1'b0;
    assign proc_39_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_20 == trans_out_cnt_20) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_read);
    assign proc_39_TLF_FIFO_blk[2] = 1'b0;
    assign proc_39_input_sync_blk[2] = 1'b0;
    assign proc_39_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_39[2] = dl_detect_out ? proc_dep_vld_vec_39_reg[2] : (proc_39_data_FIFO_blk[2] | proc_39_data_PIPO_blk[2] | proc_39_start_FIFO_blk[2] | proc_39_TLF_FIFO_blk[2] | proc_39_input_sync_blk[2] | proc_39_output_sync_blk[2]);
    assign proc_39_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n);
    assign proc_39_data_PIPO_blk[3] = 1'b0;
    assign proc_39_start_FIFO_blk[3] = 1'b0;
    assign proc_39_TLF_FIFO_blk[3] = 1'b0;
    assign proc_39_input_sync_blk[3] = 1'b0;
    assign proc_39_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_39[3] = dl_detect_out ? proc_dep_vld_vec_39_reg[3] : (proc_39_data_FIFO_blk[3] | proc_39_data_PIPO_blk[3] | proc_39_start_FIFO_blk[3] | proc_39_TLF_FIFO_blk[3] | proc_39_input_sync_blk[3] | proc_39_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_39_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_39_reg <= proc_dep_vld_vec_39;
        end
    end
    assign in_chan_dep_vld_vec_39[0] = dep_chan_vld_33_39;
    assign in_chan_dep_data_vec_39[54 : 0] = dep_chan_data_33_39;
    assign token_in_vec_39[0] = token_33_39;
    assign in_chan_dep_vld_vec_39[1] = dep_chan_vld_36_39;
    assign in_chan_dep_data_vec_39[109 : 55] = dep_chan_data_36_39;
    assign token_in_vec_39[1] = token_36_39;
    assign in_chan_dep_vld_vec_39[2] = dep_chan_vld_38_39;
    assign in_chan_dep_data_vec_39[164 : 110] = dep_chan_data_38_39;
    assign token_in_vec_39[2] = token_38_39;
    assign in_chan_dep_vld_vec_39[3] = dep_chan_vld_40_39;
    assign in_chan_dep_data_vec_39[219 : 165] = dep_chan_data_40_39;
    assign token_in_vec_39[3] = token_40_39;
    assign dep_chan_vld_39_33 = out_chan_dep_vld_vec_39[0];
    assign dep_chan_data_39_33 = out_chan_dep_data_39;
    assign token_39_33 = token_out_vec_39[0];
    assign dep_chan_vld_39_38 = out_chan_dep_vld_vec_39[1];
    assign dep_chan_data_39_38 = out_chan_dep_data_39;
    assign token_39_38 = token_out_vec_39[1];
    assign dep_chan_vld_39_40 = out_chan_dep_vld_vec_39[2];
    assign dep_chan_data_39_40 = out_chan_dep_data_39;
    assign token_39_40 = token_out_vec_39[2];
    assign dep_chan_vld_39_36 = out_chan_dep_vld_vec_39[3];
    assign dep_chan_data_39_36 = out_chan_dep_data_39;
    assign token_39_36 = token_out_vec_39[3];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 40, 3, 3) synthesis_top_hls_deadlock_detect_unit_40 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_40),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_40),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_40),
        .token_in_vec(token_in_vec_40),
        .dl_detect_in(dl_detect_out),
        .origin(origin[40]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_40),
        .out_chan_dep_data(out_chan_dep_data_40),
        .token_out_vec(token_out_vec_40),
        .dl_detect_out(dl_in_vec[40]));

    assign proc_40_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l5_pool1_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.reps_blk_n);
    assign proc_40_data_PIPO_blk[0] = 1'b0;
    assign proc_40_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_write);
    assign proc_40_TLF_FIFO_blk[0] = 1'b0;
    assign proc_40_input_sync_blk[0] = 1'b0;
    assign proc_40_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_40[0] = dl_detect_out ? proc_dep_vld_vec_40_reg[0] : (proc_40_data_FIFO_blk[0] | proc_40_data_PIPO_blk[0] | proc_40_start_FIFO_blk[0] | proc_40_TLF_FIFO_blk[0] | proc_40_input_sync_blk[0] | proc_40_output_sync_blk[0]);
    assign proc_40_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n);
    assign proc_40_data_PIPO_blk[1] = 1'b0;
    assign proc_40_start_FIFO_blk[1] = 1'b0;
    assign proc_40_TLF_FIFO_blk[1] = 1'b0;
    assign proc_40_input_sync_blk[1] = 1'b0;
    assign proc_40_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_40[1] = dl_detect_out ? proc_dep_vld_vec_40_reg[1] : (proc_40_data_FIFO_blk[1] | proc_40_data_PIPO_blk[1] | proc_40_start_FIFO_blk[1] | proc_40_TLF_FIFO_blk[1] | proc_40_input_sync_blk[1] | proc_40_output_sync_blk[1]);
    assign proc_40_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n);
    assign proc_40_data_PIPO_blk[2] = 1'b0;
    assign proc_40_start_FIFO_blk[2] = 1'b0;
    assign proc_40_TLF_FIFO_blk[2] = 1'b0;
    assign proc_40_input_sync_blk[2] = 1'b0;
    assign proc_40_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_40[2] = dl_detect_out ? proc_dep_vld_vec_40_reg[2] : (proc_40_data_FIFO_blk[2] | proc_40_data_PIPO_blk[2] | proc_40_start_FIFO_blk[2] | proc_40_TLF_FIFO_blk[2] | proc_40_input_sync_blk[2] | proc_40_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_40_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_40_reg <= proc_dep_vld_vec_40;
        end
    end
    assign in_chan_dep_vld_vec_40[0] = dep_chan_vld_39_40;
    assign in_chan_dep_data_vec_40[54 : 0] = dep_chan_data_39_40;
    assign token_in_vec_40[0] = token_39_40;
    assign in_chan_dep_vld_vec_40[1] = dep_chan_vld_41_40;
    assign in_chan_dep_data_vec_40[109 : 55] = dep_chan_data_41_40;
    assign token_in_vec_40[1] = token_41_40;
    assign in_chan_dep_vld_vec_40[2] = dep_chan_vld_44_40;
    assign in_chan_dep_data_vec_40[164 : 110] = dep_chan_data_44_40;
    assign token_in_vec_40[2] = token_44_40;
    assign dep_chan_vld_40_39 = out_chan_dep_vld_vec_40[0];
    assign dep_chan_data_40_39 = out_chan_dep_data_40;
    assign token_40_39 = token_out_vec_40[0];
    assign dep_chan_vld_40_41 = out_chan_dep_vld_vec_40[1];
    assign dep_chan_data_40_41 = out_chan_dep_data_40;
    assign token_40_41 = token_out_vec_40[1];
    assign dep_chan_vld_40_44 = out_chan_dep_vld_vec_40[2];
    assign dep_chan_data_40_44 = out_chan_dep_data_40;
    assign token_40_44 = token_out_vec_40[2];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 41, 7, 7) synthesis_top_hls_deadlock_detect_unit_41 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_41),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_41),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_41),
        .token_in_vec(token_in_vec_41),
        .dl_detect_in(dl_detect_out),
        .origin(origin[41]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_41),
        .out_chan_dep_data(out_chan_dep_data_41),
        .token_out_vec(token_out_vec_41),
        .dl_detect_out(dl_in_vec[41]));

    assign proc_41_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n);
    assign proc_41_data_PIPO_blk[0] = 1'b0;
    assign proc_41_start_FIFO_blk[0] = 1'b0;
    assign proc_41_TLF_FIFO_blk[0] = 1'b0;
    assign proc_41_input_sync_blk[0] = 1'b0;
    assign proc_41_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_41[0] = dl_detect_out ? proc_dep_vld_vec_41_reg[0] : (proc_41_data_FIFO_blk[0] | proc_41_data_PIPO_blk[0] | proc_41_start_FIFO_blk[0] | proc_41_TLF_FIFO_blk[0] | proc_41_input_sync_blk[0] | proc_41_output_sync_blk[0]);
    assign proc_41_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n);
    assign proc_41_data_PIPO_blk[1] = 1'b0;
    assign proc_41_start_FIFO_blk[1] = 1'b0;
    assign proc_41_TLF_FIFO_blk[1] = 1'b0;
    assign proc_41_input_sync_blk[1] = 1'b0;
    assign proc_41_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_41[1] = dl_detect_out ? proc_dep_vld_vec_41_reg[1] : (proc_41_data_FIFO_blk[1] | proc_41_data_PIPO_blk[1] | proc_41_start_FIFO_blk[1] | proc_41_TLF_FIFO_blk[1] | proc_41_input_sync_blk[1] | proc_41_output_sync_blk[1]);
    assign proc_41_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n);
    assign proc_41_data_PIPO_blk[2] = 1'b0;
    assign proc_41_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_read);
    assign proc_41_TLF_FIFO_blk[2] = 1'b0;
    assign proc_41_input_sync_blk[2] = 1'b0;
    assign proc_41_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_41[2] = dl_detect_out ? proc_dep_vld_vec_41_reg[2] : (proc_41_data_FIFO_blk[2] | proc_41_data_PIPO_blk[2] | proc_41_start_FIFO_blk[2] | proc_41_TLF_FIFO_blk[2] | proc_41_input_sync_blk[2] | proc_41_output_sync_blk[2]);
    assign proc_41_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n);
    assign proc_41_data_PIPO_blk[3] = 1'b0;
    assign proc_41_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_write);
    assign proc_41_TLF_FIFO_blk[3] = 1'b0;
    assign proc_41_input_sync_blk[3] = 1'b0;
    assign proc_41_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_41[3] = dl_detect_out ? proc_dep_vld_vec_41_reg[3] : (proc_41_data_FIFO_blk[3] | proc_41_data_PIPO_blk[3] | proc_41_start_FIFO_blk[3] | proc_41_TLF_FIFO_blk[3] | proc_41_input_sync_blk[3] | proc_41_output_sync_blk[3]);
    assign proc_41_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n);
    assign proc_41_data_PIPO_blk[4] = 1'b0;
    assign proc_41_start_FIFO_blk[4] = 1'b0;
    assign proc_41_TLF_FIFO_blk[4] = 1'b0;
    assign proc_41_input_sync_blk[4] = 1'b0;
    assign proc_41_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_41[4] = dl_detect_out ? proc_dep_vld_vec_41_reg[4] : (proc_41_data_FIFO_blk[4] | proc_41_data_PIPO_blk[4] | proc_41_start_FIFO_blk[4] | proc_41_TLF_FIFO_blk[4] | proc_41_input_sync_blk[4] | proc_41_output_sync_blk[4]);
    assign proc_41_data_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n);
    assign proc_41_data_PIPO_blk[5] = 1'b0;
    assign proc_41_start_FIFO_blk[5] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_read);
    assign proc_41_TLF_FIFO_blk[5] = 1'b0;
    assign proc_41_input_sync_blk[5] = 1'b0;
    assign proc_41_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_41[5] = dl_detect_out ? proc_dep_vld_vec_41_reg[5] : (proc_41_data_FIFO_blk[5] | proc_41_data_PIPO_blk[5] | proc_41_start_FIFO_blk[5] | proc_41_TLF_FIFO_blk[5] | proc_41_input_sync_blk[5] | proc_41_output_sync_blk[5]);
    assign proc_41_data_FIFO_blk[6] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n);
    assign proc_41_data_PIPO_blk[6] = 1'b0;
    assign proc_41_start_FIFO_blk[6] = 1'b0;
    assign proc_41_TLF_FIFO_blk[6] = 1'b0;
    assign proc_41_input_sync_blk[6] = 1'b0;
    assign proc_41_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_41[6] = dl_detect_out ? proc_dep_vld_vec_41_reg[6] : (proc_41_data_FIFO_blk[6] | proc_41_data_PIPO_blk[6] | proc_41_start_FIFO_blk[6] | proc_41_TLF_FIFO_blk[6] | proc_41_input_sync_blk[6] | proc_41_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_41_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_41_reg <= proc_dep_vld_vec_41;
        end
    end
    assign in_chan_dep_vld_vec_41[0] = dep_chan_vld_1_41;
    assign in_chan_dep_data_vec_41[54 : 0] = dep_chan_data_1_41;
    assign token_in_vec_41[0] = token_1_41;
    assign in_chan_dep_vld_vec_41[1] = dep_chan_vld_33_41;
    assign in_chan_dep_data_vec_41[109 : 55] = dep_chan_data_33_41;
    assign token_in_vec_41[1] = token_33_41;
    assign in_chan_dep_vld_vec_41[2] = dep_chan_vld_34_41;
    assign in_chan_dep_data_vec_41[164 : 110] = dep_chan_data_34_41;
    assign token_in_vec_41[2] = token_34_41;
    assign in_chan_dep_vld_vec_41[3] = dep_chan_vld_40_41;
    assign in_chan_dep_data_vec_41[219 : 165] = dep_chan_data_40_41;
    assign token_in_vec_41[3] = token_40_41;
    assign in_chan_dep_vld_vec_41[4] = dep_chan_vld_47_41;
    assign in_chan_dep_data_vec_41[274 : 220] = dep_chan_data_47_41;
    assign token_in_vec_41[4] = token_47_41;
    assign in_chan_dep_vld_vec_41[5] = dep_chan_vld_48_41;
    assign in_chan_dep_data_vec_41[329 : 275] = dep_chan_data_48_41;
    assign token_in_vec_41[5] = token_48_41;
    assign in_chan_dep_vld_vec_41[6] = dep_chan_vld_49_41;
    assign in_chan_dep_data_vec_41[384 : 330] = dep_chan_data_49_41;
    assign token_in_vec_41[6] = token_49_41;
    assign dep_chan_vld_41_40 = out_chan_dep_vld_vec_41[0];
    assign dep_chan_data_41_40 = out_chan_dep_data_41;
    assign token_41_40 = token_out_vec_41[0];
    assign dep_chan_vld_41_1 = out_chan_dep_vld_vec_41[1];
    assign dep_chan_data_41_1 = out_chan_dep_data_41;
    assign token_41_1 = token_out_vec_41[1];
    assign dep_chan_vld_41_47 = out_chan_dep_vld_vec_41[2];
    assign dep_chan_data_41_47 = out_chan_dep_data_41;
    assign token_41_47 = token_out_vec_41[2];
    assign dep_chan_vld_41_33 = out_chan_dep_vld_vec_41[3];
    assign dep_chan_data_41_33 = out_chan_dep_data_41;
    assign token_41_33 = token_out_vec_41[3];
    assign dep_chan_vld_41_34 = out_chan_dep_vld_vec_41[4];
    assign dep_chan_data_41_34 = out_chan_dep_data_41;
    assign token_41_34 = token_out_vec_41[4];
    assign dep_chan_vld_41_48 = out_chan_dep_vld_vec_41[5];
    assign dep_chan_data_41_48 = out_chan_dep_data_41;
    assign token_41_48 = token_out_vec_41[5];
    assign dep_chan_vld_41_49 = out_chan_dep_vld_vec_41[6];
    assign dep_chan_data_41_49 = out_chan_dep_data_41;
    assign token_41_49 = token_out_vec_41[6];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 42, 6, 6) synthesis_top_hls_deadlock_detect_unit_42 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_42),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_42),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_42),
        .token_in_vec(token_in_vec_42),
        .dl_detect_in(dl_detect_out),
        .origin(origin[42]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_42),
        .out_chan_dep_data(out_chan_dep_data_42),
        .token_out_vec(token_out_vec_42),
        .dl_detect_out(dl_in_vec[42]));

    assign proc_42_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n);
    assign proc_42_data_PIPO_blk[0] = 1'b0;
    assign proc_42_start_FIFO_blk[0] = 1'b0;
    assign proc_42_TLF_FIFO_blk[0] = 1'b0;
    assign proc_42_input_sync_blk[0] = 1'b0;
    assign proc_42_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_42[0] = dl_detect_out ? proc_dep_vld_vec_42_reg[0] : (proc_42_data_FIFO_blk[0] | proc_42_data_PIPO_blk[0] | proc_42_start_FIFO_blk[0] | proc_42_TLF_FIFO_blk[0] | proc_42_input_sync_blk[0] | proc_42_output_sync_blk[0]);
    assign proc_42_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n);
    assign proc_42_data_PIPO_blk[1] = 1'b0;
    assign proc_42_start_FIFO_blk[1] = 1'b0;
    assign proc_42_TLF_FIFO_blk[1] = 1'b0;
    assign proc_42_input_sync_blk[1] = 1'b0;
    assign proc_42_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_42[1] = dl_detect_out ? proc_dep_vld_vec_42_reg[1] : (proc_42_data_FIFO_blk[1] | proc_42_data_PIPO_blk[1] | proc_42_start_FIFO_blk[1] | proc_42_TLF_FIFO_blk[1] | proc_42_input_sync_blk[1] | proc_42_output_sync_blk[1]);
    assign proc_42_data_FIFO_blk[2] = 1'b0;
    assign proc_42_data_PIPO_blk[2] = 1'b0;
    assign proc_42_start_FIFO_blk[2] = 1'b0;
    assign proc_42_TLF_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_done & ap_done_reg_8 & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_read);
    assign proc_42_input_sync_blk[2] = 1'b0;
    assign proc_42_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_42[2] = dl_detect_out ? proc_dep_vld_vec_42_reg[2] : (proc_42_data_FIFO_blk[2] | proc_42_data_PIPO_blk[2] | proc_42_start_FIFO_blk[2] | proc_42_TLF_FIFO_blk[2] | proc_42_input_sync_blk[2] | proc_42_output_sync_blk[2]);
    assign proc_42_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n);
    assign proc_42_data_PIPO_blk[3] = 1'b0;
    assign proc_42_start_FIFO_blk[3] = 1'b0;
    assign proc_42_TLF_FIFO_blk[3] = 1'b0;
    assign proc_42_input_sync_blk[3] = 1'b0;
    assign proc_42_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_42[3] = dl_detect_out ? proc_dep_vld_vec_42_reg[3] : (proc_42_data_FIFO_blk[3] | proc_42_data_PIPO_blk[3] | proc_42_start_FIFO_blk[3] | proc_42_TLF_FIFO_blk[3] | proc_42_input_sync_blk[3] | proc_42_output_sync_blk[3]);
    assign proc_42_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n);
    assign proc_42_data_PIPO_blk[4] = 1'b0;
    assign proc_42_start_FIFO_blk[4] = 1'b0;
    assign proc_42_TLF_FIFO_blk[4] = 1'b0;
    assign proc_42_input_sync_blk[4] = 1'b0;
    assign proc_42_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_42[4] = dl_detect_out ? proc_dep_vld_vec_42_reg[4] : (proc_42_data_FIFO_blk[4] | proc_42_data_PIPO_blk[4] | proc_42_start_FIFO_blk[4] | proc_42_TLF_FIFO_blk[4] | proc_42_input_sync_blk[4] | proc_42_output_sync_blk[4]);
    assign proc_42_data_FIFO_blk[5] = 1'b0;
    assign proc_42_data_PIPO_blk[5] = 1'b0;
    assign proc_42_start_FIFO_blk[5] = 1'b0;
    assign proc_42_TLF_FIFO_blk[5] = 1'b0;
    assign proc_42_input_sync_blk[5] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready);
    assign proc_42_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_42[5] = dl_detect_out ? proc_dep_vld_vec_42_reg[5] : (proc_42_data_FIFO_blk[5] | proc_42_data_PIPO_blk[5] | proc_42_start_FIFO_blk[5] | proc_42_TLF_FIFO_blk[5] | proc_42_input_sync_blk[5] | proc_42_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_42_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_42_reg <= proc_dep_vld_vec_42;
        end
    end
    assign in_chan_dep_vld_vec_42[0] = dep_chan_vld_33_42;
    assign in_chan_dep_data_vec_42[54 : 0] = dep_chan_data_33_42;
    assign token_in_vec_42[0] = token_33_42;
    assign in_chan_dep_vld_vec_42[1] = dep_chan_vld_34_42;
    assign in_chan_dep_data_vec_42[109 : 55] = dep_chan_data_34_42;
    assign token_in_vec_42[1] = token_34_42;
    assign in_chan_dep_vld_vec_42[2] = dep_chan_vld_43_42;
    assign in_chan_dep_data_vec_42[164 : 110] = dep_chan_data_43_42;
    assign token_in_vec_42[2] = token_43_42;
    assign in_chan_dep_vld_vec_42[3] = dep_chan_vld_44_42;
    assign in_chan_dep_data_vec_42[219 : 165] = dep_chan_data_44_42;
    assign token_in_vec_42[3] = token_44_42;
    assign in_chan_dep_vld_vec_42[4] = dep_chan_vld_48_42;
    assign in_chan_dep_data_vec_42[274 : 220] = dep_chan_data_48_42;
    assign token_in_vec_42[4] = token_48_42;
    assign in_chan_dep_vld_vec_42[5] = dep_chan_vld_49_42;
    assign in_chan_dep_data_vec_42[329 : 275] = dep_chan_data_49_42;
    assign token_in_vec_42[5] = token_49_42;
    assign dep_chan_vld_42_33 = out_chan_dep_vld_vec_42[0];
    assign dep_chan_data_42_33 = out_chan_dep_data_42;
    assign token_42_33 = token_out_vec_42[0];
    assign dep_chan_vld_42_34 = out_chan_dep_vld_vec_42[1];
    assign dep_chan_data_42_34 = out_chan_dep_data_42;
    assign token_42_34 = token_out_vec_42[1];
    assign dep_chan_vld_42_43 = out_chan_dep_vld_vec_42[2];
    assign dep_chan_data_42_43 = out_chan_dep_data_42;
    assign token_42_43 = token_out_vec_42[2];
    assign dep_chan_vld_42_48 = out_chan_dep_vld_vec_42[3];
    assign dep_chan_data_42_48 = out_chan_dep_data_42;
    assign token_42_48 = token_out_vec_42[3];
    assign dep_chan_vld_42_49 = out_chan_dep_vld_vec_42[4];
    assign dep_chan_data_42_49 = out_chan_dep_data_42;
    assign token_42_49 = token_out_vec_42[4];
    assign dep_chan_vld_42_44 = out_chan_dep_vld_vec_42[5];
    assign dep_chan_data_42_44 = out_chan_dep_data_42;
    assign token_42_44 = token_out_vec_42[5];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 43, 2, 2) synthesis_top_hls_deadlock_detect_unit_43 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_43),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_43),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_43),
        .token_in_vec(token_in_vec_43),
        .dl_detect_in(dl_detect_out),
        .origin(origin[43]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_43),
        .out_chan_dep_data(out_chan_dep_data_43),
        .token_out_vec(token_out_vec_43),
        .dl_detect_out(dl_in_vec[43]));

    assign proc_43_data_FIFO_blk[0] = 1'b0;
    assign proc_43_data_PIPO_blk[0] = 1'b0;
    assign proc_43_start_FIFO_blk[0] = 1'b0;
    assign proc_43_TLF_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_write);
    assign proc_43_input_sync_blk[0] = 1'b0;
    assign proc_43_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_43[0] = dl_detect_out ? proc_dep_vld_vec_43_reg[0] : (proc_43_data_FIFO_blk[0] | proc_43_data_PIPO_blk[0] | proc_43_start_FIFO_blk[0] | proc_43_TLF_FIFO_blk[0] | proc_43_input_sync_blk[0] | proc_43_output_sync_blk[0]);
    assign proc_43_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.load_c_blk_n);
    assign proc_43_data_PIPO_blk[1] = 1'b0;
    assign proc_43_start_FIFO_blk[1] = 1'b0;
    assign proc_43_TLF_FIFO_blk[1] = 1'b0;
    assign proc_43_input_sync_blk[1] = 1'b0;
    assign proc_43_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_43[1] = dl_detect_out ? proc_dep_vld_vec_43_reg[1] : (proc_43_data_FIFO_blk[1] | proc_43_data_PIPO_blk[1] | proc_43_start_FIFO_blk[1] | proc_43_TLF_FIFO_blk[1] | proc_43_input_sync_blk[1] | proc_43_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_43_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_43_reg <= proc_dep_vld_vec_43;
        end
    end
    assign in_chan_dep_vld_vec_43[0] = dep_chan_vld_42_43;
    assign in_chan_dep_data_vec_43[54 : 0] = dep_chan_data_42_43;
    assign token_in_vec_43[0] = token_42_43;
    assign in_chan_dep_vld_vec_43[1] = dep_chan_vld_45_43;
    assign in_chan_dep_data_vec_43[109 : 55] = dep_chan_data_45_43;
    assign token_in_vec_43[1] = token_45_43;
    assign dep_chan_vld_43_42 = out_chan_dep_vld_vec_43[0];
    assign dep_chan_data_43_42 = out_chan_dep_data_43;
    assign token_43_42 = token_out_vec_43[0];
    assign dep_chan_vld_43_45 = out_chan_dep_vld_vec_43[1];
    assign dep_chan_data_43_45 = out_chan_dep_data_43;
    assign token_43_45 = token_out_vec_43[1];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 44, 5, 5) synthesis_top_hls_deadlock_detect_unit_44 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_44),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_44),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_44),
        .token_in_vec(token_in_vec_44),
        .dl_detect_in(dl_detect_out),
        .origin(origin[44]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_44),
        .out_chan_dep_data(out_chan_dep_data_44),
        .token_out_vec(token_out_vec_44),
        .dl_detect_out(dl_in_vec[44]));

    assign proc_44_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n);
    assign proc_44_data_PIPO_blk[0] = 1'b0;
    assign proc_44_start_FIFO_blk[0] = 1'b0;
    assign proc_44_TLF_FIFO_blk[0] = 1'b0;
    assign proc_44_input_sync_blk[0] = 1'b0;
    assign proc_44_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_44[0] = dl_detect_out ? proc_dep_vld_vec_44_reg[0] : (proc_44_data_FIFO_blk[0] | proc_44_data_PIPO_blk[0] | proc_44_start_FIFO_blk[0] | proc_44_TLF_FIFO_blk[0] | proc_44_input_sync_blk[0] | proc_44_output_sync_blk[0]);
    assign proc_44_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.win_s_3_blk_n);
    assign proc_44_data_PIPO_blk[1] = 1'b0;
    assign proc_44_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.real_start & (trans_in_cnt_21 == trans_out_cnt_21) & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_read);
    assign proc_44_TLF_FIFO_blk[1] = 1'b0;
    assign proc_44_input_sync_blk[1] = 1'b0;
    assign proc_44_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_44[1] = dl_detect_out ? proc_dep_vld_vec_44_reg[1] : (proc_44_data_FIFO_blk[1] | proc_44_data_PIPO_blk[1] | proc_44_start_FIFO_blk[1] | proc_44_TLF_FIFO_blk[1] | proc_44_input_sync_blk[1] | proc_44_output_sync_blk[1]);
    assign proc_44_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n);
    assign proc_44_data_PIPO_blk[2] = 1'b0;
    assign proc_44_start_FIFO_blk[2] = 1'b0;
    assign proc_44_TLF_FIFO_blk[2] = 1'b0;
    assign proc_44_input_sync_blk[2] = 1'b0;
    assign proc_44_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_44[2] = dl_detect_out ? proc_dep_vld_vec_44_reg[2] : (proc_44_data_FIFO_blk[2] | proc_44_data_PIPO_blk[2] | proc_44_start_FIFO_blk[2] | proc_44_TLF_FIFO_blk[2] | proc_44_input_sync_blk[2] | proc_44_output_sync_blk[2]);
    assign proc_44_data_FIFO_blk[3] = 1'b0;
    assign proc_44_data_PIPO_blk[3] = 1'b0;
    assign proc_44_start_FIFO_blk[3] = 1'b0;
    assign proc_44_TLF_FIFO_blk[3] = 1'b0;
    assign proc_44_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready);
    assign proc_44_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_44[3] = dl_detect_out ? proc_dep_vld_vec_44_reg[3] : (proc_44_data_FIFO_blk[3] | proc_44_data_PIPO_blk[3] | proc_44_start_FIFO_blk[3] | proc_44_TLF_FIFO_blk[3] | proc_44_input_sync_blk[3] | proc_44_output_sync_blk[3]);
    assign proc_44_data_FIFO_blk[4] = 1'b0;
    assign proc_44_data_PIPO_blk[4] = 1'b0;
    assign proc_44_start_FIFO_blk[4] = 1'b0;
    assign proc_44_TLF_FIFO_blk[4] = 1'b0;
    assign proc_44_input_sync_blk[4] = 1'b0;
    assign proc_44_output_sync_blk[4] = 1'b0 | (ap_done_reg_18 & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done);
    assign proc_dep_vld_vec_44[4] = dl_detect_out ? proc_dep_vld_vec_44_reg[4] : (proc_44_data_FIFO_blk[4] | proc_44_data_PIPO_blk[4] | proc_44_start_FIFO_blk[4] | proc_44_TLF_FIFO_blk[4] | proc_44_input_sync_blk[4] | proc_44_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_44_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_44_reg <= proc_dep_vld_vec_44;
        end
    end
    assign in_chan_dep_vld_vec_44[0] = dep_chan_vld_40_44;
    assign in_chan_dep_data_vec_44[54 : 0] = dep_chan_data_40_44;
    assign token_in_vec_44[0] = token_40_44;
    assign in_chan_dep_vld_vec_44[1] = dep_chan_vld_42_44;
    assign in_chan_dep_data_vec_44[109 : 55] = dep_chan_data_42_44;
    assign token_in_vec_44[1] = token_42_44;
    assign in_chan_dep_vld_vec_44[2] = dep_chan_vld_45_44;
    assign in_chan_dep_data_vec_44[164 : 110] = dep_chan_data_45_44;
    assign token_in_vec_44[2] = token_45_44;
    assign in_chan_dep_vld_vec_44[3] = dep_chan_vld_46_44;
    assign in_chan_dep_data_vec_44[219 : 165] = dep_chan_data_46_44;
    assign token_in_vec_44[3] = token_46_44;
    assign in_chan_dep_vld_vec_44[4] = dep_chan_vld_47_44;
    assign in_chan_dep_data_vec_44[274 : 220] = dep_chan_data_47_44;
    assign token_in_vec_44[4] = token_47_44;
    assign dep_chan_vld_44_40 = out_chan_dep_vld_vec_44[0];
    assign dep_chan_data_44_40 = out_chan_dep_data_44;
    assign token_44_40 = token_out_vec_44[0];
    assign dep_chan_vld_44_45 = out_chan_dep_vld_vec_44[1];
    assign dep_chan_data_44_45 = out_chan_dep_data_44;
    assign token_44_45 = token_out_vec_44[1];
    assign dep_chan_vld_44_47 = out_chan_dep_vld_vec_44[2];
    assign dep_chan_data_44_47 = out_chan_dep_data_44;
    assign token_44_47 = token_out_vec_44[2];
    assign dep_chan_vld_44_42 = out_chan_dep_vld_vec_44[3];
    assign dep_chan_data_44_42 = out_chan_dep_data_44;
    assign token_44_42 = token_out_vec_44[3];
    assign dep_chan_vld_44_46 = out_chan_dep_vld_vec_44[4];
    assign dep_chan_data_44_46 = out_chan_dep_data_44;
    assign token_44_46 = token_out_vec_44[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 45, 4, 4) synthesis_top_hls_deadlock_detect_unit_45 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_45),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_45),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_45),
        .token_in_vec(token_in_vec_45),
        .dl_detect_in(dl_detect_out),
        .origin(origin[45]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_45),
        .out_chan_dep_data(out_chan_dep_data_45),
        .token_out_vec(token_out_vec_45),
        .dl_detect_out(dl_in_vec[45]));

    assign proc_45_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n);
    assign proc_45_data_PIPO_blk[0] = 1'b0;
    assign proc_45_start_FIFO_blk[0] = 1'b0;
    assign proc_45_TLF_FIFO_blk[0] = 1'b0;
    assign proc_45_input_sync_blk[0] = 1'b0;
    assign proc_45_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_45[0] = dl_detect_out ? proc_dep_vld_vec_45_reg[0] : (proc_45_data_FIFO_blk[0] | proc_45_data_PIPO_blk[0] | proc_45_start_FIFO_blk[0] | proc_45_TLF_FIFO_blk[0] | proc_45_input_sync_blk[0] | proc_45_output_sync_blk[0]);
    assign proc_45_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.win_s_3_blk_n);
    assign proc_45_data_PIPO_blk[1] = 1'b0;
    assign proc_45_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_write);
    assign proc_45_TLF_FIFO_blk[1] = 1'b0;
    assign proc_45_input_sync_blk[1] = 1'b0;
    assign proc_45_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_45[1] = dl_detect_out ? proc_dep_vld_vec_45_reg[1] : (proc_45_data_FIFO_blk[1] | proc_45_data_PIPO_blk[1] | proc_45_start_FIFO_blk[1] | proc_45_TLF_FIFO_blk[1] | proc_45_input_sync_blk[1] | proc_45_output_sync_blk[1]);
    assign proc_45_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.load_weights_blk_n);
    assign proc_45_data_PIPO_blk[2] = 1'b0;
    assign proc_45_start_FIFO_blk[2] = 1'b0;
    assign proc_45_TLF_FIFO_blk[2] = 1'b0;
    assign proc_45_input_sync_blk[2] = 1'b0;
    assign proc_45_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_45[2] = dl_detect_out ? proc_dep_vld_vec_45_reg[2] : (proc_45_data_FIFO_blk[2] | proc_45_data_PIPO_blk[2] | proc_45_start_FIFO_blk[2] | proc_45_TLF_FIFO_blk[2] | proc_45_input_sync_blk[2] | proc_45_output_sync_blk[2]);
    assign proc_45_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.out_vec_s_3_blk_n);
    assign proc_45_data_PIPO_blk[3] = 1'b0;
    assign proc_45_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.real_start & (trans_in_cnt_22 == trans_out_cnt_22) & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_read);
    assign proc_45_TLF_FIFO_blk[3] = 1'b0;
    assign proc_45_input_sync_blk[3] = 1'b0;
    assign proc_45_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_45[3] = dl_detect_out ? proc_dep_vld_vec_45_reg[3] : (proc_45_data_FIFO_blk[3] | proc_45_data_PIPO_blk[3] | proc_45_start_FIFO_blk[3] | proc_45_TLF_FIFO_blk[3] | proc_45_input_sync_blk[3] | proc_45_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_45_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_45_reg <= proc_dep_vld_vec_45;
        end
    end
    assign in_chan_dep_vld_vec_45[0] = dep_chan_vld_1_45;
    assign in_chan_dep_data_vec_45[54 : 0] = dep_chan_data_1_45;
    assign token_in_vec_45[0] = token_1_45;
    assign in_chan_dep_vld_vec_45[1] = dep_chan_vld_43_45;
    assign in_chan_dep_data_vec_45[109 : 55] = dep_chan_data_43_45;
    assign token_in_vec_45[1] = token_43_45;
    assign in_chan_dep_vld_vec_45[2] = dep_chan_vld_44_45;
    assign in_chan_dep_data_vec_45[164 : 110] = dep_chan_data_44_45;
    assign token_in_vec_45[2] = token_44_45;
    assign in_chan_dep_vld_vec_45[3] = dep_chan_vld_46_45;
    assign in_chan_dep_data_vec_45[219 : 165] = dep_chan_data_46_45;
    assign token_in_vec_45[3] = token_46_45;
    assign dep_chan_vld_45_1 = out_chan_dep_vld_vec_45[0];
    assign dep_chan_data_45_1 = out_chan_dep_data_45;
    assign token_45_1 = token_out_vec_45[0];
    assign dep_chan_vld_45_44 = out_chan_dep_vld_vec_45[1];
    assign dep_chan_data_45_44 = out_chan_dep_data_45;
    assign token_45_44 = token_out_vec_45[1];
    assign dep_chan_vld_45_43 = out_chan_dep_vld_vec_45[2];
    assign dep_chan_data_45_43 = out_chan_dep_data_45;
    assign token_45_43 = token_out_vec_45[2];
    assign dep_chan_vld_45_46 = out_chan_dep_vld_vec_45[3];
    assign dep_chan_data_45_46 = out_chan_dep_data_45;
    assign token_45_46 = token_out_vec_45[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 46, 3, 3) synthesis_top_hls_deadlock_detect_unit_46 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_46),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_46),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_46),
        .token_in_vec(token_in_vec_46),
        .dl_detect_in(dl_detect_out),
        .origin(origin[46]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_46),
        .out_chan_dep_data(out_chan_dep_data_46),
        .token_out_vec(token_out_vec_46),
        .dl_detect_out(dl_in_vec[46]));

    assign proc_46_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n);
    assign proc_46_data_PIPO_blk[0] = 1'b0;
    assign proc_46_start_FIFO_blk[0] = 1'b0;
    assign proc_46_TLF_FIFO_blk[0] = 1'b0;
    assign proc_46_input_sync_blk[0] = 1'b0;
    assign proc_46_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_46[0] = dl_detect_out ? proc_dep_vld_vec_46_reg[0] : (proc_46_data_FIFO_blk[0] | proc_46_data_PIPO_blk[0] | proc_46_start_FIFO_blk[0] | proc_46_TLF_FIFO_blk[0] | proc_46_input_sync_blk[0] | proc_46_output_sync_blk[0]);
    assign proc_46_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.out_vec_s_3_blk_n);
    assign proc_46_data_PIPO_blk[1] = 1'b0;
    assign proc_46_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_write);
    assign proc_46_TLF_FIFO_blk[1] = 1'b0;
    assign proc_46_input_sync_blk[1] = 1'b0;
    assign proc_46_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_46[1] = dl_detect_out ? proc_dep_vld_vec_46_reg[1] : (proc_46_data_FIFO_blk[1] | proc_46_data_PIPO_blk[1] | proc_46_start_FIFO_blk[1] | proc_46_TLF_FIFO_blk[1] | proc_46_input_sync_blk[1] | proc_46_output_sync_blk[1]);
    assign proc_46_data_FIFO_blk[2] = 1'b0;
    assign proc_46_data_PIPO_blk[2] = 1'b0;
    assign proc_46_start_FIFO_blk[2] = 1'b0;
    assign proc_46_TLF_FIFO_blk[2] = 1'b0;
    assign proc_46_input_sync_blk[2] = 1'b0;
    assign proc_46_output_sync_blk[2] = 1'b0 | (ap_done_reg_19 & compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done);
    assign proc_dep_vld_vec_46[2] = dl_detect_out ? proc_dep_vld_vec_46_reg[2] : (proc_46_data_FIFO_blk[2] | proc_46_data_PIPO_blk[2] | proc_46_start_FIFO_blk[2] | proc_46_TLF_FIFO_blk[2] | proc_46_input_sync_blk[2] | proc_46_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_46_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_46_reg <= proc_dep_vld_vec_46;
        end
    end
    assign in_chan_dep_vld_vec_46[0] = dep_chan_vld_44_46;
    assign in_chan_dep_data_vec_46[54 : 0] = dep_chan_data_44_46;
    assign token_in_vec_46[0] = token_44_46;
    assign in_chan_dep_vld_vec_46[1] = dep_chan_vld_45_46;
    assign in_chan_dep_data_vec_46[109 : 55] = dep_chan_data_45_46;
    assign token_in_vec_46[1] = token_45_46;
    assign in_chan_dep_vld_vec_46[2] = dep_chan_vld_47_46;
    assign in_chan_dep_data_vec_46[164 : 110] = dep_chan_data_47_46;
    assign token_in_vec_46[2] = token_47_46;
    assign dep_chan_vld_46_47 = out_chan_dep_vld_vec_46[0];
    assign dep_chan_data_46_47 = out_chan_dep_data_46;
    assign token_46_47 = token_out_vec_46[0];
    assign dep_chan_vld_46_45 = out_chan_dep_vld_vec_46[1];
    assign dep_chan_data_46_45 = out_chan_dep_data_46;
    assign token_46_45 = token_out_vec_46[1];
    assign dep_chan_vld_46_44 = out_chan_dep_vld_vec_46[2];
    assign dep_chan_data_46_44 = out_chan_dep_data_46;
    assign token_46_44 = token_out_vec_46[2];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_8_100_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 47, 5, 5) synthesis_top_hls_deadlock_detect_unit_47 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_47),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_47),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_47),
        .token_in_vec(token_in_vec_47),
        .dl_detect_in(dl_detect_out),
        .origin(origin[47]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_47),
        .out_chan_dep_data(out_chan_dep_data_47),
        .token_out_vec(token_out_vec_47),
        .dl_detect_out(dl_in_vec[47]));

    assign proc_47_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n);
    assign proc_47_data_PIPO_blk[0] = 1'b0;
    assign proc_47_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_write);
    assign proc_47_TLF_FIFO_blk[0] = 1'b0;
    assign proc_47_input_sync_blk[0] = 1'b0;
    assign proc_47_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_47[0] = dl_detect_out ? proc_dep_vld_vec_47_reg[0] : (proc_47_data_FIFO_blk[0] | proc_47_data_PIPO_blk[0] | proc_47_start_FIFO_blk[0] | proc_47_TLF_FIFO_blk[0] | proc_47_input_sync_blk[0] | proc_47_output_sync_blk[0]);
    assign proc_47_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n);
    assign proc_47_data_PIPO_blk[1] = 1'b0;
    assign proc_47_start_FIFO_blk[1] = 1'b0;
    assign proc_47_TLF_FIFO_blk[1] = 1'b0;
    assign proc_47_input_sync_blk[1] = 1'b0;
    assign proc_47_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_47[1] = dl_detect_out ? proc_dep_vld_vec_47_reg[1] : (proc_47_data_FIFO_blk[1] | proc_47_data_PIPO_blk[1] | proc_47_start_FIFO_blk[1] | proc_47_TLF_FIFO_blk[1] | proc_47_input_sync_blk[1] | proc_47_output_sync_blk[1]);
    assign proc_47_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n);
    assign proc_47_data_PIPO_blk[2] = 1'b0;
    assign proc_47_start_FIFO_blk[2] = 1'b0;
    assign proc_47_TLF_FIFO_blk[2] = 1'b0;
    assign proc_47_input_sync_blk[2] = 1'b0;
    assign proc_47_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_47[2] = dl_detect_out ? proc_dep_vld_vec_47_reg[2] : (proc_47_data_FIFO_blk[2] | proc_47_data_PIPO_blk[2] | proc_47_start_FIFO_blk[2] | proc_47_TLF_FIFO_blk[2] | proc_47_input_sync_blk[2] | proc_47_output_sync_blk[2]);
    assign proc_47_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n);
    assign proc_47_data_PIPO_blk[3] = 1'b0;
    assign proc_47_start_FIFO_blk[3] = 1'b0;
    assign proc_47_TLF_FIFO_blk[3] = 1'b0;
    assign proc_47_input_sync_blk[3] = 1'b0;
    assign proc_47_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_47[3] = dl_detect_out ? proc_dep_vld_vec_47_reg[3] : (proc_47_data_FIFO_blk[3] | proc_47_data_PIPO_blk[3] | proc_47_start_FIFO_blk[3] | proc_47_TLF_FIFO_blk[3] | proc_47_input_sync_blk[3] | proc_47_output_sync_blk[3]);
    assign proc_47_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n);
    assign proc_47_data_PIPO_blk[4] = 1'b0;
    assign proc_47_start_FIFO_blk[4] = 1'b0;
    assign proc_47_TLF_FIFO_blk[4] = 1'b0;
    assign proc_47_input_sync_blk[4] = 1'b0;
    assign proc_47_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_47[4] = dl_detect_out ? proc_dep_vld_vec_47_reg[4] : (proc_47_data_FIFO_blk[4] | proc_47_data_PIPO_blk[4] | proc_47_start_FIFO_blk[4] | proc_47_TLF_FIFO_blk[4] | proc_47_input_sync_blk[4] | proc_47_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_47_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_47_reg <= proc_dep_vld_vec_47;
        end
    end
    assign in_chan_dep_vld_vec_47[0] = dep_chan_vld_41_47;
    assign in_chan_dep_data_vec_47[54 : 0] = dep_chan_data_41_47;
    assign token_in_vec_47[0] = token_41_47;
    assign in_chan_dep_vld_vec_47[1] = dep_chan_vld_44_47;
    assign in_chan_dep_data_vec_47[109 : 55] = dep_chan_data_44_47;
    assign token_in_vec_47[1] = token_44_47;
    assign in_chan_dep_vld_vec_47[2] = dep_chan_vld_46_47;
    assign in_chan_dep_data_vec_47[164 : 110] = dep_chan_data_46_47;
    assign token_in_vec_47[2] = token_46_47;
    assign in_chan_dep_vld_vec_47[3] = dep_chan_vld_48_47;
    assign in_chan_dep_data_vec_47[219 : 165] = dep_chan_data_48_47;
    assign token_in_vec_47[3] = token_48_47;
    assign in_chan_dep_vld_vec_47[4] = dep_chan_vld_50_47;
    assign in_chan_dep_data_vec_47[274 : 220] = dep_chan_data_50_47;
    assign token_in_vec_47[4] = token_50_47;
    assign dep_chan_vld_47_41 = out_chan_dep_vld_vec_47[0];
    assign dep_chan_data_47_41 = out_chan_dep_data_47;
    assign token_47_41 = token_out_vec_47[0];
    assign dep_chan_vld_47_46 = out_chan_dep_vld_vec_47[1];
    assign dep_chan_data_47_46 = out_chan_dep_data_47;
    assign token_47_46 = token_out_vec_47[1];
    assign dep_chan_vld_47_48 = out_chan_dep_vld_vec_47[2];
    assign dep_chan_data_47_48 = out_chan_dep_data_47;
    assign token_47_48 = token_out_vec_47[2];
    assign dep_chan_vld_47_50 = out_chan_dep_vld_vec_47[3];
    assign dep_chan_data_47_50 = out_chan_dep_data_47;
    assign token_47_50 = token_out_vec_47[3];
    assign dep_chan_vld_47_44 = out_chan_dep_vld_vec_47[4];
    assign dep_chan_data_47_44 = out_chan_dep_data_47;
    assign token_47_44 = token_out_vec_47[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_4_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 48, 5, 5) synthesis_top_hls_deadlock_detect_unit_48 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_48),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_48),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_48),
        .token_in_vec(token_in_vec_48),
        .dl_detect_in(dl_detect_out),
        .origin(origin[48]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_48),
        .out_chan_dep_data(out_chan_dep_data_48),
        .token_out_vec(token_out_vec_48),
        .dl_detect_out(dl_in_vec[48]));

    assign proc_48_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n);
    assign proc_48_data_PIPO_blk[0] = 1'b0;
    assign proc_48_start_FIFO_blk[0] = 1'b0;
    assign proc_48_TLF_FIFO_blk[0] = 1'b0;
    assign proc_48_input_sync_blk[0] = 1'b0;
    assign proc_48_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_48[0] = dl_detect_out ? proc_dep_vld_vec_48_reg[0] : (proc_48_data_FIFO_blk[0] | proc_48_data_PIPO_blk[0] | proc_48_start_FIFO_blk[0] | proc_48_TLF_FIFO_blk[0] | proc_48_input_sync_blk[0] | proc_48_output_sync_blk[0]);
    assign proc_48_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n);
    assign proc_48_data_PIPO_blk[1] = 1'b0;
    assign proc_48_start_FIFO_blk[1] = 1'b0;
    assign proc_48_TLF_FIFO_blk[1] = 1'b0;
    assign proc_48_input_sync_blk[1] = 1'b0;
    assign proc_48_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_48[1] = dl_detect_out ? proc_dep_vld_vec_48_reg[1] : (proc_48_data_FIFO_blk[1] | proc_48_data_PIPO_blk[1] | proc_48_start_FIFO_blk[1] | proc_48_TLF_FIFO_blk[1] | proc_48_input_sync_blk[1] | proc_48_output_sync_blk[1]);
    assign proc_48_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n);
    assign proc_48_data_PIPO_blk[2] = 1'b0;
    assign proc_48_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.real_start & (trans_in_cnt_26 == trans_out_cnt_26) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_read);
    assign proc_48_TLF_FIFO_blk[2] = 1'b0;
    assign proc_48_input_sync_blk[2] = 1'b0;
    assign proc_48_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_48[2] = dl_detect_out ? proc_dep_vld_vec_48_reg[2] : (proc_48_data_FIFO_blk[2] | proc_48_data_PIPO_blk[2] | proc_48_start_FIFO_blk[2] | proc_48_TLF_FIFO_blk[2] | proc_48_input_sync_blk[2] | proc_48_output_sync_blk[2]);
    assign proc_48_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n);
    assign proc_48_data_PIPO_blk[3] = 1'b0;
    assign proc_48_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_write);
    assign proc_48_TLF_FIFO_blk[3] = 1'b0;
    assign proc_48_input_sync_blk[3] = 1'b0;
    assign proc_48_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_48[3] = dl_detect_out ? proc_dep_vld_vec_48_reg[3] : (proc_48_data_FIFO_blk[3] | proc_48_data_PIPO_blk[3] | proc_48_start_FIFO_blk[3] | proc_48_TLF_FIFO_blk[3] | proc_48_input_sync_blk[3] | proc_48_output_sync_blk[3]);
    assign proc_48_data_FIFO_blk[4] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n);
    assign proc_48_data_PIPO_blk[4] = 1'b0;
    assign proc_48_start_FIFO_blk[4] = 1'b0;
    assign proc_48_TLF_FIFO_blk[4] = 1'b0;
    assign proc_48_input_sync_blk[4] = 1'b0;
    assign proc_48_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_48[4] = dl_detect_out ? proc_dep_vld_vec_48_reg[4] : (proc_48_data_FIFO_blk[4] | proc_48_data_PIPO_blk[4] | proc_48_start_FIFO_blk[4] | proc_48_TLF_FIFO_blk[4] | proc_48_input_sync_blk[4] | proc_48_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_48_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_48_reg <= proc_dep_vld_vec_48;
        end
    end
    assign in_chan_dep_vld_vec_48[0] = dep_chan_vld_1_48;
    assign in_chan_dep_data_vec_48[54 : 0] = dep_chan_data_1_48;
    assign token_in_vec_48[0] = token_1_48;
    assign in_chan_dep_vld_vec_48[1] = dep_chan_vld_41_48;
    assign in_chan_dep_data_vec_48[109 : 55] = dep_chan_data_41_48;
    assign token_in_vec_48[1] = token_41_48;
    assign in_chan_dep_vld_vec_48[2] = dep_chan_vld_42_48;
    assign in_chan_dep_data_vec_48[164 : 110] = dep_chan_data_42_48;
    assign token_in_vec_48[2] = token_42_48;
    assign in_chan_dep_vld_vec_48[3] = dep_chan_vld_47_48;
    assign in_chan_dep_data_vec_48[219 : 165] = dep_chan_data_47_48;
    assign token_in_vec_48[3] = token_47_48;
    assign in_chan_dep_vld_vec_48[4] = dep_chan_vld_53_48;
    assign in_chan_dep_data_vec_48[274 : 220] = dep_chan_data_53_48;
    assign token_in_vec_48[4] = token_53_48;
    assign dep_chan_vld_48_47 = out_chan_dep_vld_vec_48[0];
    assign dep_chan_data_48_47 = out_chan_dep_data_48;
    assign token_48_47 = token_out_vec_48[0];
    assign dep_chan_vld_48_1 = out_chan_dep_vld_vec_48[1];
    assign dep_chan_data_48_1 = out_chan_dep_data_48;
    assign token_48_1 = token_out_vec_48[1];
    assign dep_chan_vld_48_53 = out_chan_dep_vld_vec_48[2];
    assign dep_chan_data_48_53 = out_chan_dep_data_48;
    assign token_48_53 = token_out_vec_48[2];
    assign dep_chan_vld_48_41 = out_chan_dep_vld_vec_48[3];
    assign dep_chan_data_48_41 = out_chan_dep_data_48;
    assign token_48_41 = token_out_vec_48[3];
    assign dep_chan_vld_48_42 = out_chan_dep_vld_vec_48[4];
    assign dep_chan_data_48_42 = out_chan_dep_data_48;
    assign token_48_42 = token_out_vec_48[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 49, 4, 4) synthesis_top_hls_deadlock_detect_unit_49 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_49),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_49),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_49),
        .token_in_vec(token_in_vec_49),
        .dl_detect_in(dl_detect_out),
        .origin(origin[49]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_49),
        .out_chan_dep_data(out_chan_dep_data_49),
        .token_out_vec(token_out_vec_49),
        .dl_detect_out(dl_in_vec[49]));

    assign proc_49_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n);
    assign proc_49_data_PIPO_blk[0] = 1'b0;
    assign proc_49_start_FIFO_blk[0] = 1'b0;
    assign proc_49_TLF_FIFO_blk[0] = 1'b0;
    assign proc_49_input_sync_blk[0] = 1'b0;
    assign proc_49_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_49[0] = dl_detect_out ? proc_dep_vld_vec_49_reg[0] : (proc_49_data_FIFO_blk[0] | proc_49_data_PIPO_blk[0] | proc_49_start_FIFO_blk[0] | proc_49_TLF_FIFO_blk[0] | proc_49_input_sync_blk[0] | proc_49_output_sync_blk[0]);
    assign proc_49_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n);
    assign proc_49_data_PIPO_blk[1] = 1'b0;
    assign proc_49_start_FIFO_blk[1] = 1'b0;
    assign proc_49_TLF_FIFO_blk[1] = 1'b0;
    assign proc_49_input_sync_blk[1] = 1'b0;
    assign proc_49_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_49[1] = dl_detect_out ? proc_dep_vld_vec_49_reg[1] : (proc_49_data_FIFO_blk[1] | proc_49_data_PIPO_blk[1] | proc_49_start_FIFO_blk[1] | proc_49_TLF_FIFO_blk[1] | proc_49_input_sync_blk[1] | proc_49_output_sync_blk[1]);
    assign proc_49_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_c_blk_n);
    assign proc_49_data_PIPO_blk[2] = 1'b0;
    assign proc_49_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.real_start & (trans_in_cnt_24 == trans_out_cnt_24) & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_read);
    assign proc_49_TLF_FIFO_blk[2] = 1'b0;
    assign proc_49_input_sync_blk[2] = 1'b0;
    assign proc_49_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_49[2] = dl_detect_out ? proc_dep_vld_vec_49_reg[2] : (proc_49_data_FIFO_blk[2] | proc_49_data_PIPO_blk[2] | proc_49_start_FIFO_blk[2] | proc_49_TLF_FIFO_blk[2] | proc_49_input_sync_blk[2] | proc_49_output_sync_blk[2]);
    assign proc_49_data_FIFO_blk[3] = 1'b0;
    assign proc_49_data_PIPO_blk[3] = 1'b0;
    assign proc_49_start_FIFO_blk[3] = 1'b0;
    assign proc_49_TLF_FIFO_blk[3] = 1'b0;
    assign proc_49_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready);
    assign proc_49_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_49[3] = dl_detect_out ? proc_dep_vld_vec_49_reg[3] : (proc_49_data_FIFO_blk[3] | proc_49_data_PIPO_blk[3] | proc_49_start_FIFO_blk[3] | proc_49_TLF_FIFO_blk[3] | proc_49_input_sync_blk[3] | proc_49_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_49_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_49_reg <= proc_dep_vld_vec_49;
        end
    end
    assign in_chan_dep_vld_vec_49[0] = dep_chan_vld_41_49;
    assign in_chan_dep_data_vec_49[54 : 0] = dep_chan_data_41_49;
    assign token_in_vec_49[0] = token_41_49;
    assign in_chan_dep_vld_vec_49[1] = dep_chan_vld_42_49;
    assign in_chan_dep_data_vec_49[109 : 55] = dep_chan_data_42_49;
    assign token_in_vec_49[1] = token_42_49;
    assign in_chan_dep_vld_vec_49[2] = dep_chan_vld_50_49;
    assign in_chan_dep_data_vec_49[164 : 110] = dep_chan_data_50_49;
    assign token_in_vec_49[2] = token_50_49;
    assign in_chan_dep_vld_vec_49[3] = dep_chan_vld_51_49;
    assign in_chan_dep_data_vec_49[219 : 165] = dep_chan_data_51_49;
    assign token_in_vec_49[3] = token_51_49;
    assign dep_chan_vld_49_41 = out_chan_dep_vld_vec_49[0];
    assign dep_chan_data_49_41 = out_chan_dep_data_49;
    assign token_49_41 = token_out_vec_49[0];
    assign dep_chan_vld_49_42 = out_chan_dep_vld_vec_49[1];
    assign dep_chan_data_49_42 = out_chan_dep_data_49;
    assign token_49_42 = token_out_vec_49[1];
    assign dep_chan_vld_49_51 = out_chan_dep_vld_vec_49[2];
    assign dep_chan_data_49_51 = out_chan_dep_data_49;
    assign token_49_51 = token_out_vec_49[2];
    assign dep_chan_vld_49_50 = out_chan_dep_vld_vec_49[3];
    assign dep_chan_data_49_50 = out_chan_dep_data_49;
    assign token_49_50 = token_out_vec_49[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 50, 5, 5) synthesis_top_hls_deadlock_detect_unit_50 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_50),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_50),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_50),
        .token_in_vec(token_in_vec_50),
        .dl_detect_in(dl_detect_out),
        .origin(origin[50]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_50),
        .out_chan_dep_data(out_chan_dep_data_50),
        .token_out_vec(token_out_vec_50),
        .dl_detect_out(dl_in_vec[50]));

    assign proc_50_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n);
    assign proc_50_data_PIPO_blk[0] = 1'b0;
    assign proc_50_start_FIFO_blk[0] = 1'b0;
    assign proc_50_TLF_FIFO_blk[0] = 1'b0;
    assign proc_50_input_sync_blk[0] = 1'b0;
    assign proc_50_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_50[0] = dl_detect_out ? proc_dep_vld_vec_50_reg[0] : (proc_50_data_FIFO_blk[0] | proc_50_data_PIPO_blk[0] | proc_50_start_FIFO_blk[0] | proc_50_TLF_FIFO_blk[0] | proc_50_input_sync_blk[0] | proc_50_output_sync_blk[0]);
    assign proc_50_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_c1_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.win_s_4_blk_n);
    assign proc_50_data_PIPO_blk[1] = 1'b0;
    assign proc_50_start_FIFO_blk[1] = 1'b0;
    assign proc_50_TLF_FIFO_blk[1] = 1'b0;
    assign proc_50_input_sync_blk[1] = 1'b0;
    assign proc_50_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_50[1] = dl_detect_out ? proc_dep_vld_vec_50_reg[1] : (proc_50_data_FIFO_blk[1] | proc_50_data_PIPO_blk[1] | proc_50_start_FIFO_blk[1] | proc_50_TLF_FIFO_blk[1] | proc_50_input_sync_blk[1] | proc_50_output_sync_blk[1]);
    assign proc_50_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n);
    assign proc_50_data_PIPO_blk[2] = 1'b0;
    assign proc_50_start_FIFO_blk[2] = 1'b0;
    assign proc_50_TLF_FIFO_blk[2] = 1'b0;
    assign proc_50_input_sync_blk[2] = 1'b0;
    assign proc_50_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_50[2] = dl_detect_out ? proc_dep_vld_vec_50_reg[2] : (proc_50_data_FIFO_blk[2] | proc_50_data_PIPO_blk[2] | proc_50_start_FIFO_blk[2] | proc_50_TLF_FIFO_blk[2] | proc_50_input_sync_blk[2] | proc_50_output_sync_blk[2]);
    assign proc_50_data_FIFO_blk[3] = 1'b0;
    assign proc_50_data_PIPO_blk[3] = 1'b0;
    assign proc_50_start_FIFO_blk[3] = 1'b0;
    assign proc_50_TLF_FIFO_blk[3] = 1'b0;
    assign proc_50_input_sync_blk[3] = 1'b0 | (compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready);
    assign proc_50_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_50[3] = dl_detect_out ? proc_dep_vld_vec_50_reg[3] : (proc_50_data_FIFO_blk[3] | proc_50_data_PIPO_blk[3] | proc_50_start_FIFO_blk[3] | proc_50_TLF_FIFO_blk[3] | proc_50_input_sync_blk[3] | proc_50_output_sync_blk[3]);
    assign proc_50_data_FIFO_blk[4] = 1'b0;
    assign proc_50_data_PIPO_blk[4] = 1'b0;
    assign proc_50_start_FIFO_blk[4] = 1'b0;
    assign proc_50_TLF_FIFO_blk[4] = 1'b0;
    assign proc_50_input_sync_blk[4] = 1'b0;
    assign proc_50_output_sync_blk[4] = 1'b0 | (ap_done_reg_20 & compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done);
    assign proc_dep_vld_vec_50[4] = dl_detect_out ? proc_dep_vld_vec_50_reg[4] : (proc_50_data_FIFO_blk[4] | proc_50_data_PIPO_blk[4] | proc_50_start_FIFO_blk[4] | proc_50_TLF_FIFO_blk[4] | proc_50_input_sync_blk[4] | proc_50_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_50_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_50_reg <= proc_dep_vld_vec_50;
        end
    end
    assign in_chan_dep_vld_vec_50[0] = dep_chan_vld_47_50;
    assign in_chan_dep_data_vec_50[54 : 0] = dep_chan_data_47_50;
    assign token_in_vec_50[0] = token_47_50;
    assign in_chan_dep_vld_vec_50[1] = dep_chan_vld_49_50;
    assign in_chan_dep_data_vec_50[109 : 55] = dep_chan_data_49_50;
    assign token_in_vec_50[1] = token_49_50;
    assign in_chan_dep_vld_vec_50[2] = dep_chan_vld_51_50;
    assign in_chan_dep_data_vec_50[164 : 110] = dep_chan_data_51_50;
    assign token_in_vec_50[2] = token_51_50;
    assign in_chan_dep_vld_vec_50[3] = dep_chan_vld_52_50;
    assign in_chan_dep_data_vec_50[219 : 165] = dep_chan_data_52_50;
    assign token_in_vec_50[3] = token_52_50;
    assign in_chan_dep_vld_vec_50[4] = dep_chan_vld_53_50;
    assign in_chan_dep_data_vec_50[274 : 220] = dep_chan_data_53_50;
    assign token_in_vec_50[4] = token_53_50;
    assign dep_chan_vld_50_47 = out_chan_dep_vld_vec_50[0];
    assign dep_chan_data_50_47 = out_chan_dep_data_50;
    assign token_50_47 = token_out_vec_50[0];
    assign dep_chan_vld_50_51 = out_chan_dep_vld_vec_50[1];
    assign dep_chan_data_50_51 = out_chan_dep_data_50;
    assign token_50_51 = token_out_vec_50[1];
    assign dep_chan_vld_50_53 = out_chan_dep_vld_vec_50[2];
    assign dep_chan_data_50_53 = out_chan_dep_data_50;
    assign token_50_53 = token_out_vec_50[2];
    assign dep_chan_vld_50_49 = out_chan_dep_vld_vec_50[3];
    assign dep_chan_data_50_49 = out_chan_dep_data_50;
    assign token_50_49 = token_out_vec_50[3];
    assign dep_chan_vld_50_52 = out_chan_dep_vld_vec_50[4];
    assign dep_chan_data_50_52 = out_chan_dep_data_50;
    assign token_50_52 = token_out_vec_50[4];

    // Process: compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 51, 4, 4) synthesis_top_hls_deadlock_detect_unit_51 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_51),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_51),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_51),
        .token_in_vec(token_in_vec_51),
        .dl_detect_in(dl_detect_out),
        .origin(origin[51]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_51),
        .out_chan_dep_data(out_chan_dep_data_51),
        .token_out_vec(token_out_vec_51),
        .dl_detect_out(dl_in_vec[51]));

    assign proc_51_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n);
    assign proc_51_data_PIPO_blk[0] = 1'b0;
    assign proc_51_start_FIFO_blk[0] = 1'b0;
    assign proc_51_TLF_FIFO_blk[0] = 1'b0;
    assign proc_51_input_sync_blk[0] = 1'b0;
    assign proc_51_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_51[0] = dl_detect_out ? proc_dep_vld_vec_51_reg[0] : (proc_51_data_FIFO_blk[0] | proc_51_data_PIPO_blk[0] | proc_51_start_FIFO_blk[0] | proc_51_TLF_FIFO_blk[0] | proc_51_input_sync_blk[0] | proc_51_output_sync_blk[0]);
    assign proc_51_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.win_s_4_blk_n);
    assign proc_51_data_PIPO_blk[1] = 1'b0;
    assign proc_51_start_FIFO_blk[1] = 1'b0;
    assign proc_51_TLF_FIFO_blk[1] = 1'b0;
    assign proc_51_input_sync_blk[1] = 1'b0;
    assign proc_51_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_51[1] = dl_detect_out ? proc_dep_vld_vec_51_reg[1] : (proc_51_data_FIFO_blk[1] | proc_51_data_PIPO_blk[1] | proc_51_start_FIFO_blk[1] | proc_51_TLF_FIFO_blk[1] | proc_51_input_sync_blk[1] | proc_51_output_sync_blk[1]);
    assign proc_51_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.load_weights_blk_n);
    assign proc_51_data_PIPO_blk[2] = 1'b0;
    assign proc_51_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_write);
    assign proc_51_TLF_FIFO_blk[2] = 1'b0;
    assign proc_51_input_sync_blk[2] = 1'b0;
    assign proc_51_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_51[2] = dl_detect_out ? proc_dep_vld_vec_51_reg[2] : (proc_51_data_FIFO_blk[2] | proc_51_data_PIPO_blk[2] | proc_51_start_FIFO_blk[2] | proc_51_TLF_FIFO_blk[2] | proc_51_input_sync_blk[2] | proc_51_output_sync_blk[2]);
    assign proc_51_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_c_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.out_vec_s_4_blk_n);
    assign proc_51_data_PIPO_blk[3] = 1'b0;
    assign proc_51_start_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.real_start & (trans_in_cnt_25 == trans_out_cnt_25) & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_read);
    assign proc_51_TLF_FIFO_blk[3] = 1'b0;
    assign proc_51_input_sync_blk[3] = 1'b0;
    assign proc_51_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_51[3] = dl_detect_out ? proc_dep_vld_vec_51_reg[3] : (proc_51_data_FIFO_blk[3] | proc_51_data_PIPO_blk[3] | proc_51_start_FIFO_blk[3] | proc_51_TLF_FIFO_blk[3] | proc_51_input_sync_blk[3] | proc_51_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_51_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_51_reg <= proc_dep_vld_vec_51;
        end
    end
    assign in_chan_dep_vld_vec_51[0] = dep_chan_vld_1_51;
    assign in_chan_dep_data_vec_51[54 : 0] = dep_chan_data_1_51;
    assign token_in_vec_51[0] = token_1_51;
    assign in_chan_dep_vld_vec_51[1] = dep_chan_vld_49_51;
    assign in_chan_dep_data_vec_51[109 : 55] = dep_chan_data_49_51;
    assign token_in_vec_51[1] = token_49_51;
    assign in_chan_dep_vld_vec_51[2] = dep_chan_vld_50_51;
    assign in_chan_dep_data_vec_51[164 : 110] = dep_chan_data_50_51;
    assign token_in_vec_51[2] = token_50_51;
    assign in_chan_dep_vld_vec_51[3] = dep_chan_vld_52_51;
    assign in_chan_dep_data_vec_51[219 : 165] = dep_chan_data_52_51;
    assign token_in_vec_51[3] = token_52_51;
    assign dep_chan_vld_51_1 = out_chan_dep_vld_vec_51[0];
    assign dep_chan_data_51_1 = out_chan_dep_data_51;
    assign token_51_1 = token_out_vec_51[0];
    assign dep_chan_vld_51_50 = out_chan_dep_vld_vec_51[1];
    assign dep_chan_data_51_50 = out_chan_dep_data_51;
    assign token_51_50 = token_out_vec_51[1];
    assign dep_chan_vld_51_49 = out_chan_dep_vld_vec_51[2];
    assign dep_chan_data_51_49 = out_chan_dep_data_51;
    assign token_51_49 = token_out_vec_51[2];
    assign dep_chan_vld_51_52 = out_chan_dep_vld_vec_51[3];
    assign dep_chan_data_51_52 = out_chan_dep_data_51;
    assign token_51_52 = token_out_vec_51[3];

    // Process: compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 52, 3, 3) synthesis_top_hls_deadlock_detect_unit_52 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_52),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_52),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_52),
        .token_in_vec(token_in_vec_52),
        .dl_detect_in(dl_detect_out),
        .origin(origin[52]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_52),
        .out_chan_dep_data(out_chan_dep_data_52),
        .token_out_vec(token_out_vec_52),
        .dl_detect_out(dl_in_vec[52]));

    assign proc_52_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n);
    assign proc_52_data_PIPO_blk[0] = 1'b0;
    assign proc_52_start_FIFO_blk[0] = 1'b0;
    assign proc_52_TLF_FIFO_blk[0] = 1'b0;
    assign proc_52_input_sync_blk[0] = 1'b0;
    assign proc_52_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_52[0] = dl_detect_out ? proc_dep_vld_vec_52_reg[0] : (proc_52_data_FIFO_blk[0] | proc_52_data_PIPO_blk[0] | proc_52_start_FIFO_blk[0] | proc_52_TLF_FIFO_blk[0] | proc_52_input_sync_blk[0] | proc_52_output_sync_blk[0]);
    assign proc_52_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.reps_blk_n) | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.out_vec_s_4_blk_n);
    assign proc_52_data_PIPO_blk[1] = 1'b0;
    assign proc_52_start_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_write);
    assign proc_52_TLF_FIFO_blk[1] = 1'b0;
    assign proc_52_input_sync_blk[1] = 1'b0;
    assign proc_52_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_52[1] = dl_detect_out ? proc_dep_vld_vec_52_reg[1] : (proc_52_data_FIFO_blk[1] | proc_52_data_PIPO_blk[1] | proc_52_start_FIFO_blk[1] | proc_52_TLF_FIFO_blk[1] | proc_52_input_sync_blk[1] | proc_52_output_sync_blk[1]);
    assign proc_52_data_FIFO_blk[2] = 1'b0;
    assign proc_52_data_PIPO_blk[2] = 1'b0;
    assign proc_52_start_FIFO_blk[2] = 1'b0;
    assign proc_52_TLF_FIFO_blk[2] = 1'b0;
    assign proc_52_input_sync_blk[2] = 1'b0;
    assign proc_52_output_sync_blk[2] = 1'b0 | (ap_done_reg_21 & compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done);
    assign proc_dep_vld_vec_52[2] = dl_detect_out ? proc_dep_vld_vec_52_reg[2] : (proc_52_data_FIFO_blk[2] | proc_52_data_PIPO_blk[2] | proc_52_start_FIFO_blk[2] | proc_52_TLF_FIFO_blk[2] | proc_52_input_sync_blk[2] | proc_52_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_52_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_52_reg <= proc_dep_vld_vec_52;
        end
    end
    assign in_chan_dep_vld_vec_52[0] = dep_chan_vld_50_52;
    assign in_chan_dep_data_vec_52[54 : 0] = dep_chan_data_50_52;
    assign token_in_vec_52[0] = token_50_52;
    assign in_chan_dep_vld_vec_52[1] = dep_chan_vld_51_52;
    assign in_chan_dep_data_vec_52[109 : 55] = dep_chan_data_51_52;
    assign token_in_vec_52[1] = token_51_52;
    assign in_chan_dep_vld_vec_52[2] = dep_chan_vld_53_52;
    assign in_chan_dep_data_vec_52[164 : 110] = dep_chan_data_53_52;
    assign token_in_vec_52[2] = token_53_52;
    assign dep_chan_vld_52_53 = out_chan_dep_vld_vec_52[0];
    assign dep_chan_data_52_53 = out_chan_dep_data_52;
    assign token_52_53 = token_out_vec_52[0];
    assign dep_chan_vld_52_51 = out_chan_dep_vld_vec_52[1];
    assign dep_chan_data_52_51 = out_chan_dep_data_52;
    assign token_52_51 = token_out_vec_52[1];
    assign dep_chan_vld_52_50 = out_chan_dep_vld_vec_52[2];
    assign dep_chan_data_52_50 = out_chan_dep_data_52;
    assign token_52_50 = token_out_vec_52[2];

    // Process: compute_engine_U0.stream_width_adjust_flex_8_32_4_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 53, 4, 4) synthesis_top_hls_deadlock_detect_unit_53 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_53),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_53),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_53),
        .token_in_vec(token_in_vec_53),
        .dl_detect_in(dl_detect_out),
        .origin(origin[53]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_53),
        .out_chan_dep_data(out_chan_dep_data_53),
        .token_out_vec(token_out_vec_53),
        .dl_detect_out(dl_in_vec[53]));

    assign proc_53_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n);
    assign proc_53_data_PIPO_blk[0] = 1'b0;
    assign proc_53_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_write);
    assign proc_53_TLF_FIFO_blk[0] = 1'b0;
    assign proc_53_input_sync_blk[0] = 1'b0;
    assign proc_53_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_53[0] = dl_detect_out ? proc_dep_vld_vec_53_reg[0] : (proc_53_data_FIFO_blk[0] | proc_53_data_PIPO_blk[0] | proc_53_start_FIFO_blk[0] | proc_53_TLF_FIFO_blk[0] | proc_53_input_sync_blk[0] | proc_53_output_sync_blk[0]);
    assign proc_53_data_FIFO_blk[1] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n);
    assign proc_53_data_PIPO_blk[1] = 1'b0;
    assign proc_53_start_FIFO_blk[1] = 1'b0;
    assign proc_53_TLF_FIFO_blk[1] = 1'b0;
    assign proc_53_input_sync_blk[1] = 1'b0;
    assign proc_53_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_53[1] = dl_detect_out ? proc_dep_vld_vec_53_reg[1] : (proc_53_data_FIFO_blk[1] | proc_53_data_PIPO_blk[1] | proc_53_start_FIFO_blk[1] | proc_53_TLF_FIFO_blk[1] | proc_53_input_sync_blk[1] | proc_53_output_sync_blk[1]);
    assign proc_53_data_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_out_packed_blk_n) | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.num_samples_c_blk_n);
    assign proc_53_data_PIPO_blk[2] = 1'b0;
    assign proc_53_start_FIFO_blk[2] = 1'b0 | (~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_full_n & compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_start & ~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.real_start & (trans_in_cnt_27 == trans_out_cnt_27) & ~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_read);
    assign proc_53_TLF_FIFO_blk[2] = 1'b0;
    assign proc_53_input_sync_blk[2] = 1'b0;
    assign proc_53_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_53[2] = dl_detect_out ? proc_dep_vld_vec_53_reg[2] : (proc_53_data_FIFO_blk[2] | proc_53_data_PIPO_blk[2] | proc_53_start_FIFO_blk[2] | proc_53_TLF_FIFO_blk[2] | proc_53_input_sync_blk[2] | proc_53_output_sync_blk[2]);
    assign proc_53_data_FIFO_blk[3] = 1'b0 | (~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n);
    assign proc_53_data_PIPO_blk[3] = 1'b0;
    assign proc_53_start_FIFO_blk[3] = 1'b0;
    assign proc_53_TLF_FIFO_blk[3] = 1'b0;
    assign proc_53_input_sync_blk[3] = 1'b0;
    assign proc_53_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_53[3] = dl_detect_out ? proc_dep_vld_vec_53_reg[3] : (proc_53_data_FIFO_blk[3] | proc_53_data_PIPO_blk[3] | proc_53_start_FIFO_blk[3] | proc_53_TLF_FIFO_blk[3] | proc_53_input_sync_blk[3] | proc_53_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_53_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_53_reg <= proc_dep_vld_vec_53;
        end
    end
    assign in_chan_dep_vld_vec_53[0] = dep_chan_vld_48_53;
    assign in_chan_dep_data_vec_53[54 : 0] = dep_chan_data_48_53;
    assign token_in_vec_53[0] = token_48_53;
    assign in_chan_dep_vld_vec_53[1] = dep_chan_vld_50_53;
    assign in_chan_dep_data_vec_53[109 : 55] = dep_chan_data_50_53;
    assign token_in_vec_53[1] = token_50_53;
    assign in_chan_dep_vld_vec_53[2] = dep_chan_vld_52_53;
    assign in_chan_dep_data_vec_53[164 : 110] = dep_chan_data_52_53;
    assign token_in_vec_53[2] = token_52_53;
    assign in_chan_dep_vld_vec_53[3] = dep_chan_vld_54_53;
    assign in_chan_dep_data_vec_53[219 : 165] = dep_chan_data_54_53;
    assign token_in_vec_53[3] = token_54_53;
    assign dep_chan_vld_53_48 = out_chan_dep_vld_vec_53[0];
    assign dep_chan_data_53_48 = out_chan_dep_data_53;
    assign token_53_48 = token_out_vec_53[0];
    assign dep_chan_vld_53_52 = out_chan_dep_vld_vec_53[1];
    assign dep_chan_data_53_52 = out_chan_dep_data_53;
    assign token_53_52 = token_out_vec_53[1];
    assign dep_chan_vld_53_54 = out_chan_dep_vld_vec_53[2];
    assign dep_chan_data_53_54 = out_chan_dep_data_53;
    assign token_53_54 = token_out_vec_53[2];
    assign dep_chan_vld_53_50 = out_chan_dep_vld_vec_53[3];
    assign dep_chan_data_53_50 = out_chan_dep_data_53;
    assign token_53_50 = token_out_vec_53[3];

    // Process: compute_engine_U0.hls_stream_to_axis_32_1_U0
    synthesis_top_hls_deadlock_detect_unit #(55, 54, 1, 1) synthesis_top_hls_deadlock_detect_unit_54 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_54),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_54),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_54),
        .token_in_vec(token_in_vec_54),
        .dl_detect_in(dl_detect_out),
        .origin(origin[54]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_54),
        .out_chan_dep_data(out_chan_dep_data_54),
        .token_out_vec(token_out_vec_54),
        .dl_detect_out(dl_in_vec[54]));

    assign proc_54_data_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.hls_stream_to_axis_32_1_U0.grp_hls_stream_to_axis_32_1_Pipeline_VITIS_LOOP_36_1_fu_54.s_out_packed_blk_n) | (~compute_engine_U0.hls_stream_to_axis_32_1_U0.reps_blk_n);
    assign proc_54_data_PIPO_blk[0] = 1'b0;
    assign proc_54_start_FIFO_blk[0] = 1'b0 | (~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_empty_n & compute_engine_U0.hls_stream_to_axis_32_1_U0.ap_idle & ~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_write);
    assign proc_54_TLF_FIFO_blk[0] = 1'b0;
    assign proc_54_input_sync_blk[0] = 1'b0;
    assign proc_54_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_54[0] = dl_detect_out ? proc_dep_vld_vec_54_reg[0] : (proc_54_data_FIFO_blk[0] | proc_54_data_PIPO_blk[0] | proc_54_start_FIFO_blk[0] | proc_54_TLF_FIFO_blk[0] | proc_54_input_sync_blk[0] | proc_54_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_54_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_54_reg <= proc_dep_vld_vec_54;
        end
    end
    assign in_chan_dep_vld_vec_54[0] = dep_chan_vld_53_54;
    assign in_chan_dep_data_vec_54[54 : 0] = dep_chan_data_53_54;
    assign token_in_vec_54[0] = token_53_54;
    assign dep_chan_vld_54_53 = out_chan_dep_vld_vec_54[0];
    assign dep_chan_data_54_53 = out_chan_dep_data_54;
    assign token_54_53 = token_out_vec_54[0];


`include "synthesis_top_hls_deadlock_report_unit.vh"
