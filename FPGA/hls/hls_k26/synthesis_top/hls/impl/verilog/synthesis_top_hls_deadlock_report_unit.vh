   
    parameter PROC_NUM = 55;
    parameter ST_IDLE = 3'b000;
    parameter ST_FILTER_FAKE = 3'b001;
    parameter ST_DL_DETECTED = 3'b010;
    parameter ST_DL_REPORT = 3'b100;
   

    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    reg stop_report_path;
    reg [PROC_NUM - 1:0] reported_proc;
    integer i;
    integer fp;

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            reported_proc <= 'b0;
        end
        else if (CS_fsm == ST_DL_REPORT) begin
            reported_proc <= reported_proc | dl_in_vec;
        end
        else if (CS_fsm == ST_DL_DETECTED) begin
            reported_proc <= 'b0;
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            stop_report_path <= 1'b0;
        end
        else if (CS_fsm == ST_DL_REPORT && (|(dl_in_vec & reported_proc))) begin
            stop_report_path <= 1'b1;
        end
        else if (CS_fsm == ST_IDLE) begin
            stop_report_path <= 1'b0;
        end
    end

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end

    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if ((dl_detect_reg != dl_done_reg) && stop_report_path == 1'b0) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                // avoid report deadlock ring.
                else if (|(dl_in_vec & reported_proc)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && ((dl_detect_reg == dl_done_reg) || (stop_report_path == 1'b1))) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [1184:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "synthesis_top_synthesis_top.entry_proc11_U0";
                end
                1 : begin
                    proc_path = "synthesis_top_synthesis_top.load_weights_wrapper_U0";
                end
                2 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0";
                end
                3 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0";
                end
                4 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0";
                end
                5 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0";
                end
                6 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0";
                end
                7 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0";
                end
                8 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0";
                end
                9 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0";
                end
                10 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0";
                end
                11 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0";
                end
                12 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0";
                end
                13 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0";
                end
                14 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0";
                end
                15 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0";
                end
                16 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0";
                end
                17 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0";
                end
                18 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0";
                end
                19 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0";
                end
                20 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0";
                end
                21 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0";
                end
                22 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0";
                end
                23 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0";
                end
                24 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0";
                end
                25 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0";
                end
                26 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0";
                end
                27 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0";
                end
                28 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0";
                end
                29 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0";
                end
                30 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0";
                end
                31 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0";
                end
                32 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0";
                end
                33 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0";
                end
                34 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0";
                end
                35 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0";
                end
                36 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0";
                end
                37 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0";
                end
                38 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0";
                end
                39 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0";
                end
                40 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0";
                end
                41 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0";
                end
                42 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0";
                end
                43 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0";
                end
                44 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0";
                end
                45 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0";
                end
                46 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0";
                end
                47 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0";
                end
                48 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0";
                end
                49 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0";
                end
                50 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0";
                end
                51 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0";
                end
                52 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0";
                end
                53 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0";
                end
                54 : begin
                    proc_path = "synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [1184:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [1184:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [1216:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin // for proc 'synthesis_top_synthesis_top.entry_proc11_U0'
                    case(index2)
                    2: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0'
// for dep channel 'synthesis_top_synthesis_top.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.entry_proc11_U0.num_samples_c_blk_n data_FIFO}
                        if ((~entry_proc11_U0.num_samples_c_blk_n)) begin
                            if (~num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.num_samples_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.num_samples_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.start_for_compute_engine_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.start_for_compute_engine_U0_U.if_full_n & synthesis_top_synthesis_top_inst.entry_proc11_U0.ap_start & ~synthesis_top_synthesis_top_inst.entry_proc11_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~synthesis_top_synthesis_top_inst.start_for_compute_engine_U0_U.if_read} start_FIFO}
                        if ((~start_for_compute_engine_U0_U.if_full_n & entry_proc11_U0.ap_start & ~entry_proc11_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_compute_engine_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.start_for_compute_engine_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0',");
                        end
                    end
                    4: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'
// for dep channel 'synthesis_top_synthesis_top.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.entry_proc11_U0.num_samples_c_blk_n data_FIFO}
                        if ((~entry_proc11_U0.num_samples_c_blk_n)) begin
                            if (~num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.num_samples_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.num_samples_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.ap_sync_entry_proc11_U0_ap_ready & synthesis_top_synthesis_top_inst.entry_proc11_U0.ap_idle & ~synthesis_top_synthesis_top_inst.ap_sync_load_weights_wrapper_U0_ap_ready} input_sync}
                        if ((ap_sync_entry_proc11_U0_ap_ready & entry_proc11_U0.ap_idle & ~ap_sync_load_weights_wrapper_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                        end
                    end
                    endcase
                end
                1 : begin // for proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
                    case(index2)
                    2: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n)) begin
                            if (~s_w1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n)) begin
                            if (~s_i1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n)) begin
                            if (~s_b1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.reload_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.reload_weights_c_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.reload_weights_c_blk_n)) begin
                            if (~reload_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~reload_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_27_3_fu_110.s_w1_blk_n)) begin
                            if (~s_w1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_19_1_fu_91.s_i1_blk_n)) begin
                            if (~s_i1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_s_fu_278.grp_layer_loader_8_16_32_Pipeline_VITIS_LOOP_23_2_fu_101.s_b1_blk_n)) begin
                            if (~s_b1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_27_3_fu_110.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_19_1_fu_91.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_2_fu_298.grp_layer_loader_8_16_32_2_Pipeline_VITIS_LOOP_23_2_fu_101.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_27_3_fu_110.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_19_1_fu_91.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_3_fu_317.grp_layer_loader_8_16_32_3_Pipeline_VITIS_LOOP_23_2_fu_101.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    29: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    37: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_27_3_fu_110.s_w4_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_19_1_fu_91.s_i4_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_4_fu_336.grp_layer_loader_8_16_32_4_Pipeline_VITIS_LOOP_23_2_fu_101.s_b4_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    45: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_27_3_fu_110.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_19_1_fu_91.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_5_fu_361.grp_layer_loader_8_16_32_5_Pipeline_VITIS_LOOP_23_2_fu_101.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    48: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    51: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_27_3_fu_110.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_19_1_fu_91.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.grp_layer_loader_8_16_32_6_fu_380.grp_layer_loader_8_16_32_6_Pipeline_VITIS_LOOP_23_2_fu_101.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'
// for dep channel 'synthesis_top_synthesis_top.reload_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.reload_weights_c_blk_n data_FIFO}
                        if ((~load_weights_wrapper_U0.reload_weights_c_blk_n)) begin
                            if (~reload_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~reload_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'synthesis_top_synthesis_top.entry_proc11_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.ap_sync_load_weights_wrapper_U0_ap_ready & synthesis_top_synthesis_top_inst.load_weights_wrapper_U0.ap_idle & ~synthesis_top_synthesis_top_inst.ap_sync_entry_proc11_U0_ap_ready} input_sync}
                        if ((ap_sync_load_weights_wrapper_U0_ap_ready & load_weights_wrapper_U0.ap_idle & ~ap_sync_entry_proc11_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.entry_proc11_U0'");
                        end
                    end
                    endcase
                end
                2 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n)) begin
                            if (~s_w1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n)) begin
                            if (~s_i1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n)) begin
                            if (~s_b1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.reload_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.entry_proc10_U0.load_weights_blk_n)) begin
                            if (~reload_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~reload_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'synthesis_top_synthesis_top.entry_proc11_U0'
// for dep channel 'synthesis_top_synthesis_top.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n)) begin
                            if (~num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.num_samples_c_U' written by process 'synthesis_top_synthesis_top.entry_proc11_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.num_samples_c_U' read by process 'synthesis_top_synthesis_top.entry_proc11_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.start_for_compute_engine_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.start_for_compute_engine_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.ap_idle & ~synthesis_top_synthesis_top_inst.start_for_compute_engine_U0_U.if_write} start_FIFO}
                        if ((~start_for_compute_engine_U0_U.if_empty_n & compute_engine_U0.ap_idle & ~start_for_compute_engine_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.start_for_compute_engine_U0_U' written by process 'synthesis_top_synthesis_top.entry_proc11_U0',");
                        end
                    end
                    endcase
                end
                3 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.reload_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.entry_proc10_U0.load_weights_blk_n)) begin
                            if (~reload_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~reload_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.reload_weights_c_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.reload_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.load_weights_c26_blk_n data_FIFO}
                        if ((~compute_engine_U0.entry_proc10_U0.load_weights_c26_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c26_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c26_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_full_n & compute_engine_U0.entry_proc10_U0.ap_start & ~compute_engine_U0.entry_proc10_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0',");
                        end
                    end
                    4: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.entry_proc10_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready & compute_engine_U0.entry_proc10_U0.ap_idle & ~compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                        end
                    end
                    endcase
                end
                4 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'
                    case(index2)
                    5: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.grp_axis_512_to_hls_stream_8_5120_Pipeline_VITIS_LOOP_20_3_fu_113.s_raw_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.grp_axis_512_to_hls_stream_8_5120_Pipeline_VITIS_LOOP_20_3_fu_113.s_raw_in_blk_n)) begin
                            if (~compute_engine_U0.s_raw_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_raw_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.num_samples_c20_blk_n data_FIFO}
                        if ((~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.num_samples_c20_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c20_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c20_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_full_n & compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_start & ~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0',");
                        end
                    end
                    0: begin //  for dep proc 'synthesis_top_synthesis_top.entry_proc11_U0'
// for dep channel 'synthesis_top_synthesis_top.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.reps_blk_n)) begin
                            if (~num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.num_samples_c_U' written by process 'synthesis_top_synthesis_top.entry_proc11_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.num_samples_c_U' read by process 'synthesis_top_synthesis_top.entry_proc11_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.ap_sync_axis_512_to_hls_stream_8_5120_U0_ap_ready & compute_engine_U0.axis_512_to_hls_stream_8_5120_U0.ap_idle & ~compute_engine_U0.ap_sync_entry_proc10_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'");
                        end
                    end
                    endcase
                end
                5 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'
                    case(index2)
                    4: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_raw_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_raw_in_blk_n)) begin
                            if (~compute_engine_U0.s_raw_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_raw_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_raw_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c20_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c20_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c20_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_5120_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.axis_512_to_hls_stream_8_5120_U0',");
                        end
                    end
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_l1_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.grp_stream_width_adjust_flex_8_8_5120_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_56.s_l1_in_blk_n)) begin
                            if (~compute_engine_U0.s_l1_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.num_samples_c19_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0.num_samples_c19_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c19_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c19_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                6 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
                    case(index2)
                    5: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_69_6_fu_403.s_l1_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_69_6_fu_403.s_l1_in_blk_n)) begin
                            if (~compute_engine_U0.s_l1_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c19_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c19_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_5120_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c19_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_58_3_VITIS_LOOP_59_4_fu_365.s_w1_blk_n)) begin
                            if (~s_w1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_48_1_fu_289.s_i1_blk_n)) begin
                            if (~s_i1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_53_2_fu_327.s_b1_blk_n)) begin
                            if (~s_b1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b1_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b1_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_98_11_fu_466.s_l1_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.grp_conv1_accelerator_specialized_Pipeline_VITIS_LOOP_98_11_fu_466.s_l1_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l1_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.num_samples_c18_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.num_samples_c18_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c18_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c18_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    3: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c26_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c26_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c26_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_empty_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_idle & ~compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_conv1_accelerator_specialized_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.entry_proc10_U0',");
                        end
                    end
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_full_n & compute_engine_U0.conv1_accelerator_specialized_U0.ap_start & ~compute_engine_U0.conv1_accelerator_specialized_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0',");
                        end
                    end
                    10: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n data_FIFO}
                        if ((~compute_engine_U0.conv1_accelerator_specialized_U0.load_weights_c25_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                7 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'
                    case(index2)
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l1_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c18_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c18_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c18_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0',");
                        end
                    end
                    8: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_1_fu_74.s_l1_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l1_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c17_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c17_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c17_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c17_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0',");
                        end
                    end
                    endcase
                end
                8 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'
                    case(index2)
                    7: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l1_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l1_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l1_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l1_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l1_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c17_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c17_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c17_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5776_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_723u_16u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n)) begin
                            if (~compute_engine_U0.s_l2_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.grp_stream_width_adjust_flex_8_32_5776_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_68.s_l2_in_blk_n)) begin
                            if (~compute_engine_U0.s_l2_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0.num_samples_c16_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                9 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
                    case(index2)
                    8: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n)) begin
                            if (~compute_engine_U0.s_l2_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    15: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l2_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_2_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0',");
                        end
                    end
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0',");
                        end
                    end
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                10 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
                    case(index2)
                    6: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.conv1_accelerator_specialized_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    11: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_done & ap_done_reg_0 & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_read} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_done & ap_done_reg_0 & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_read)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.load_weights_c24_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                11 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'
                    case(index2)
                    10: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_write} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_write)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                12 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
                    case(index2)
                    8: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.s_l2_in_blk_n)) begin
                            if (~compute_engine_U0.s_l2_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5776_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.win_s_2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_2_fu_82.win_s_2_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0',");
                        end
                    end
                    15: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.num_samples_c15_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    10: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.ap_sync_entry_proc2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                        end
                    end
                    14: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_10 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done} output_sync}
                        if ((ap_done_reg_10 & compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                        end
                    end
                    endcase
                end
                13 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w2_blk_n)) begin
                            if (~s_w2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i2_blk_n)) begin
                            if (~s_i2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b2_blk_n)) begin
                            if (~s_b2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b2_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b2_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.win_s_2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.win_s_2_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.win_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_compute_unit_1d_emitlast_general_2_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0',");
                        end
                    end
                    11: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.transform9_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    14: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.out_vec_s_2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.grp_compute_unit_1d_emitlast_general_2_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_134.out_vec_s_2_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0',");
                        end
                    end
                    endcase
                end
                14 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'
                    case(index2)
                    15: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.s_l2_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l2_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.out_vec_s_2_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_2_fu_56.out_vec_s_2_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.out_vec_s_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.start_for_serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.compute_unit_1d_emitlast_general_2_U0',");
                        end
                    end
                    12: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_11 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_11 & compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                15 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'
                    case(index2)
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l2_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0',");
                        end
                    end
                    14: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l2_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.serialize_packed_outputs_1d_general_1u_361u_32u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    16: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_3_fu_70.s_l2_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l2_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c14_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c14_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0',");
                        end
                    end
                    12: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.sliding_window_1d_general_1u_361u_1u_3u_1u_1u_0u_1u_16u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                16 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'
                    case(index2)
                    15: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l2_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l2_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l2_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l2_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l2_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_1_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_361u_32u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n)) begin
                            if (~compute_engine_U0.s_l3_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    20: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.grp_stream_width_adjust_flex_1_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_in_blk_n)) begin
                            if (~compute_engine_U0.s_l3_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0.num_samples_c13_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                17 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
                    case(index2)
                    16: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n)) begin
                            if (~compute_engine_U0.s_l3_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    23: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l3_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_5_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0',");
                        end
                    end
                    10: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0',");
                        end
                    end
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                18 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
                    case(index2)
                    9: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    10: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_2_U0.entry_proc2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    19: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_done & ap_done_reg_2 & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_read} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_done & ap_done_reg_2 & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_read)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.load_weights_c23_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    20: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                19 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'
                    case(index2)
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_write} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_write)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                20 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
                    case(index2)
                    16: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.s_l3_in_blk_n)) begin
                            if (~compute_engine_U0.s_l3_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.win_s_5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_3_fu_78.win_s_5_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0',");
                        end
                    end
                    23: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.num_samples_c12_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.ap_sync_entry_proc5_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                        end
                    end
                    22: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_12 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done} output_sync}
                        if ((ap_done_reg_12 & compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                        end
                    end
                    endcase
                end
                21 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_144.s_w3_blk_n)) begin
                            if (~s_w3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i3_blk_n)) begin
                            if (~s_i3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b3_blk_n)) begin
                            if (~s_b3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b3_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b3_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    20: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.win_s_5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.win_s_5_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.win_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_compute_unit_1d_emitlast_general_5_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0',");
                        end
                    end
                    19: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.transform8_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    22: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.out_vec_s_5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.grp_compute_unit_1d_emitlast_general_5_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_158.out_vec_s_5_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.real_start & (trans_in_cnt_10 == trans_out_cnt_10) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0.real_start & (trans_in_cnt_10 == trans_out_cnt_10) & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0',");
                        end
                    end
                    endcase
                end
                22 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'
                    case(index2)
                    23: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.s_l3_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l3_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.out_vec_s_5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_3_fu_52.out_vec_s_5_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.out_vec_s_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.start_for_serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.compute_unit_1d_emitlast_general_5_U0',");
                        end
                    end
                    20: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_13 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_13 & compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                23 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'
                    case(index2)
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l3_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0',");
                        end
                    end
                    22: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l3_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.serialize_packed_outputs_1d_general_1u_180u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    24: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_4_fu_66.s_l3_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l3_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c11_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c11_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_12 == trans_out_cnt_12) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_12 == trans_out_cnt_12) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0',");
                        end
                    end
                    20: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.sliding_window_1d_general_1u_180u_1u_3u_1u_1u_0u_1u_32u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                24 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'
                    case(index2)
                    23: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l3_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l3_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l3_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l3_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_5760_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_180u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n)) begin
                            if (~compute_engine_U0.s_l4_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    28: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.grp_stream_width_adjust_flex_8_32_5760_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_in_blk_n)) begin
                            if (~compute_engine_U0.s_l4_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0.num_samples_c10_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                25 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
                    case(index2)
                    24: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n)) begin
                            if (~compute_engine_U0.s_l4_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    31: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l4_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0',");
                        end
                    end
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0',");
                        end
                    end
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                26 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
                    case(index2)
                    17: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    18: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_5_U0.entry_proc5_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    27: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_done & ap_done_reg_4 & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_read} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_done & ap_done_reg_4 & ~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_read)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.load_weights_c22_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    28: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                27 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'
                    case(index2)
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_write} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_write)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    29: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                28 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
                    case(index2)
                    24: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.s_l4_in_blk_n)) begin
                            if (~compute_engine_U0.s_l4_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_5760_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    29: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.win_s_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_fu_74.win_s_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.real_start & (trans_in_cnt_13 == trans_out_cnt_13) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.real_start & (trans_in_cnt_13 == trans_out_cnt_13) & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0',");
                        end
                    end
                    31: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.num_samples_c9_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                        end
                    end
                    30: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_14 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done} output_sync}
                        if ((ap_done_reg_14 & compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                        end
                    end
                    endcase
                end
                29 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VITI_fu_144.s_w4_blk_n)) begin
                            if (~s_w4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_116.s_i4_blk_n)) begin
                            if (~s_i4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_130.s_b4_blk_n)) begin
                            if (~s_b4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b4_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b4_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    28: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.win_s_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.win_s_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.win_s_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_compute_unit_1d_emitlast_general_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0',");
                        end
                    end
                    27: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.transform7_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    30: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.out_vec_s_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.grp_compute_unit_1d_emitlast_general_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_VIT_fu_158.out_vec_s_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.real_start & (trans_in_cnt_14 == trans_out_cnt_14) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0.real_start & (trans_in_cnt_14 == trans_out_cnt_14) & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0',");
                        end
                    end
                    endcase
                end
                30 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'
                    case(index2)
                    31: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.s_l4_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l4_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    29: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.out_vec_s_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_fu_52.out_vec_s_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.out_vec_s_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.start_for_serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.compute_unit_1d_emitlast_general_U0',");
                        end
                    end
                    28: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_15 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_15 & compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                        end
                    end
                    endcase
                end
                31 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'
                    case(index2)
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l4_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0',");
                        end
                    end
                    30: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l4_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.serialize_packed_outputs_1d_general_1u_90u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    32: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_fu_66.s_l4_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l4_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c8_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c8_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c8_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c8_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_16 == trans_out_cnt_16) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_16 == trans_out_cnt_16) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0',");
                        end
                    end
                    28: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.sliding_window_1d_general_1u_90u_1u_3u_1u_1u_0u_1u_64u_4u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                32 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'
                    case(index2)
                    31: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l4_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l4_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l4_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l4_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c8_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c8_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_16_2880_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_90u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n)) begin
                            if (~compute_engine_U0.s_l5_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    36: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.grp_stream_width_adjust_flex_8_16_2880_Pipeline_VITIS_LOOP_123_3_VITIS_LOOP_124_4_fu_64.s_l5_in_blk_n)) begin
                            if (~compute_engine_U0.s_l5_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0.num_samples_c7_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                33 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
                    case(index2)
                    32: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n)) begin
                            if (~compute_engine_U0.s_l5_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    39: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l5_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_1_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0',");
                        end
                    end
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0',");
                        end
                    end
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                34 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
                    case(index2)
                    25: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    26: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_U0.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    35: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_done & ap_done_reg_6 & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_read} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_done & ap_done_reg_6 & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_read)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.load_weights_c21_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    36: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                        end
                    end
                    endcase
                end
                35 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'
                    case(index2)
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_write} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_write)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    37: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                36 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
                    case(index2)
                    32: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.s_l5_in_blk_n)) begin
                            if (~compute_engine_U0.s_l5_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_16_2880_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    37: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.win_s_1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_35_3_VITIS_LOOP_39_1_fu_78.win_s_1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.real_start & (trans_in_cnt_17 == trans_out_cnt_17) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.real_start & (trans_in_cnt_17 == trans_out_cnt_17) & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0',");
                        end
                    end
                    39: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.num_samples_c6_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.ap_sync_entry_proc1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                        end
                    end
                    38: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_16 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done} output_sync}
                        if ((ap_done_reg_16 & compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                        end
                    end
                    endcase
                end
                37 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_140.s_w5_blk_n)) begin
                            if (~s_w5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_112.s_i5_blk_n)) begin
                            if (~s_i5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_126.s_b5_blk_n)) begin
                            if (~s_b5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b5_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b5_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    36: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.win_s_1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.win_s_1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.win_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_compute_unit_1d_emitlast_general_1_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0',");
                        end
                    end
                    35: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.transform6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    38: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.out_vec_s_1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.grp_compute_unit_1d_emitlast_general_1_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_163_11_V_fu_154.out_vec_s_1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.real_start & (trans_in_cnt_18 == trans_out_cnt_18) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0.real_start & (trans_in_cnt_18 == trans_out_cnt_18) & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0',");
                        end
                    end
                    endcase
                end
                38 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'
                    case(index2)
                    39: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.s_l5_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l5_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    37: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.out_vec_s_1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_226_3_V_1_fu_52.out_vec_s_1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.out_vec_s_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.start_for_serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.compute_unit_1d_emitlast_general_1_U0',");
                        end
                    end
                    36: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_17 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_17 & compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                        end
                    end
                    endcase
                end
                39 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'
                    case(index2)
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l5_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_empty_n & compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_idle & ~compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0',");
                        end
                    end
                    38: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l5_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.serialize_packed_outputs_1d_general_1u_43u_64u_8u_4u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    40: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.grp_pool_accelerator_Pipeline_VITIS_LOOP_25_1_VITIS_LOOP_27_3_VITIS_LOOP_28_4_2_fu_66.s_l5_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l5_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c5_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.num_samples_c5_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_20 == trans_out_cnt_20) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_full_n & compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.ap_start & ~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.real_start & (trans_in_cnt_20 == trans_out_cnt_20) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0',");
                        end
                    end
                    36: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.sliding_window_1d_general_1u_45u_1u_3u_1u_1u_0u_0u_64u_2u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                40 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'
                    case(index2)
                    39: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l5_pool1_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l5_pool1_blk_n)) begin
                            if (~compute_engine_U0.s_l5_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l5_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l5_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_1344_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.pool_accelerator_1u_43u_64u_8u_1u_2u_1u_2u_true_false_U0',");
                        end
                    end
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n)) begin
                            if (~compute_engine_U0.s_l6_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    44: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.grp_stream_width_adjust_flex_8_8_1344_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_in_blk_n)) begin
                            if (~compute_engine_U0.s_l6_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0.num_samples_c4_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                41 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
                    case(index2)
                    40: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n)) begin
                            if (~compute_engine_U0.s_l6_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    47: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l6_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0',");
                        end
                    end
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_3_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0',");
                        end
                    end
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    48: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0',");
                        end
                    end
                    49: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                42 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
                    case(index2)
                    33: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    34: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_1_U0.entry_proc1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    43: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_done & ap_done_reg_8 & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_read} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_done & ap_done_reg_8 & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_read)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    48: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    49: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.load_weights_c_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    44: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                        end
                    end
                    endcase
                end
                43 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'
                    case(index2)
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_write} TLF_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_write)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_tmp_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    45: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                44 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
                    case(index2)
                    40: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.s_l6_in_blk_n)) begin
                            if (~compute_engine_U0.s_l6_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_1344_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    45: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.win_s_3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_fu_70.win_s_3_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.real_start & (trans_in_cnt_21 == trans_out_cnt_21) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.real_start & (trans_in_cnt_21 == trans_out_cnt_21) & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0',");
                        end
                    end
                    47: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.num_samples_c3_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.ap_sync_entry_proc3_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                        end
                    end
                    46: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_18 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done} output_sync}
                        if ((ap_done_reg_18 & compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                        end
                    end
                    endcase
                end
                45 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_146_6_VI_fu_124.s_w6_blk_n)) begin
                            if (~s_w6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_131_1_VITIS_LOOP_132_2_fu_104.s_i6_blk_n)) begin
                            if (~s_i6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b6_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_138_3_VITIS_LOOP_139_4_fu_114.s_b6_blk_n)) begin
                            if (~s_b6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b6_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b6_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    44: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.win_s_3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.win_s_3_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.win_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_compute_unit_1d_emitlast_general_3_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0',");
                        end
                    end
                    43: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.transform_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    46: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.out_vec_s_3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.grp_compute_unit_1d_emitlast_general_3_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_134.out_vec_s_3_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.real_start & (trans_in_cnt_22 == trans_out_cnt_22) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0.real_start & (trans_in_cnt_22 == trans_out_cnt_22) & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0',");
                        end
                    end
                    endcase
                end
                46 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'
                    case(index2)
                    47: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.s_l6_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l6_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    45: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.out_vec_s_3_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_V_fu_48.out_vec_s_3_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.out_vec_s_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.compute_unit_1d_emitlast_general_3_U0',");
                        end
                    end
                    44: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_19 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_19 & compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                        end
                    end
                    endcase
                end
                47 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
                    case(index2)
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l6_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_8_100_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0',");
                        end
                    end
                    46: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l6_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l6_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l6_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.serialize_packed_outputs_1d_general_1u_1u_100u_8u_2u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l6_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    48: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n)) begin
                            if (~compute_engine_U0.s_l7_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    50: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.grp_stream_width_adjust_flex_8_8_100_Pipeline_VITIS_LOOP_113_1_VITIS_LOOP_114_2_fu_60.s_l7_in_blk_n)) begin
                            if (~compute_engine_U0.s_l7_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.num_samples_c2_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    44: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_8_100_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_1344u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                48 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
                    case(index2)
                    47: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n)) begin
                            if (~compute_engine_U0.s_l7_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    53: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l7_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.real_start & (trans_in_cnt_26 == trans_out_cnt_26) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.real_start & (trans_in_cnt_26 == trans_out_cnt_26) & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0',");
                        end
                    end
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_idle & ~compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_general_1d_conv_accelerator_4_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0',");
                        end
                    end
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                49 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'
                    case(index2)
                    41: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    42: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_blk_n)) begin
                            if (~compute_engine_U0.load_weights_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.load_weights_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_3_U0.entry_proc3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.load_weights_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    51: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.load_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.real_start & (trans_in_cnt_24 == trans_out_cnt_24) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.real_start & (trans_in_cnt_24 == trans_out_cnt_24) & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0',");
                        end
                    end
                    50: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                        end
                    end
                    endcase
                end
                50 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
                    case(index2)
                    47: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.s_l7_in_blk_n)) begin
                            if (~compute_engine_U0.s_l7_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_8_100_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    51: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.reps_c1_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.win_s_4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.grp_sliding_window_1d_general_Pipeline_VITIS_LOOP_33_1_VITIS_LOOP_39_4_1_fu_70.win_s_4_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    53: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.num_samples_c1_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    49: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'
// for dep channel '' info is :
// blk sig is {{synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready} input_sync}
                        if ((compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0_ap_ready & compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.ap_sync_entry_proc4_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                        end
                    end
                    52: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_20 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done} output_sync}
                        if ((ap_done_reg_20 & compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                        end
                    end
                    endcase
                end
                51 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'
                    case(index2)
                    1: begin //  for dep proc 'synthesis_top_synthesis_top.load_weights_wrapper_U0'
// for dep channel 'synthesis_top_synthesis_top.s_w7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_145_5_VITIS_LOOP_147_7_fu_108.s_w7_blk_n)) begin
                            if (~s_w7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_w7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_w7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_w7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_w7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_i7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_131_1_fu_92.s_i7_blk_n)) begin
                            if (~s_i7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_i7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_i7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_i7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_i7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.s_b7_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_138_3_fu_100.s_b7_blk_n)) begin
                            if (~s_b7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.s_b7_U' written by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~s_b7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.s_b7_U' read by process 'synthesis_top_synthesis_top.load_weights_wrapper_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.s_b7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    50: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.win_s_4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.win_s_4_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.win_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    49: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.load_weights_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.load_weights_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.load_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_compute_unit_1d_emitlast_general_4_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.entry_proc4_U0',");
                        end
                    end
                    52: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.reps_c_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.out_vec_s_4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.grp_compute_unit_1d_emitlast_general_4_Pipeline_VITIS_LOOP_161_9_VITIS_LOOP_166_12_fu_116.out_vec_s_4_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.real_start & (trans_in_cnt_25 == trans_out_cnt_25) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_full_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.ap_start & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0.real_start & (trans_in_cnt_25 == trans_out_cnt_25) & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0',");
                        end
                    end
                    endcase
                end
                52 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'
                    case(index2)
                    53: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.s_l7_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l7_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    51: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.reps_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.out_vec_s_4_blk_n data_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.grp_serialize_packed_outputs_1d_general_Pipeline_VITIS_LOOP_224_1_VITIS_LOOP_227_4_fu_40.out_vec_s_4_blk_n)) begin
                            if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.out_vec_s_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_empty_n & compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_idle & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.start_for_serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.compute_unit_1d_emitlast_general_4_U0',");
                        end
                    end
                    50: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_21 & synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done & ~synthesis_top_synthesis_top_inst.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done} output_sync}
                        if ((ap_done_reg_21 & compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0.ap_done & ~compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                        end
                    end
                    endcase
                end
                53 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'
                    case(index2)
                    48: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l7_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_empty_n & compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_idle & ~compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_stream_width_adjust_flex_8_32_4_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0',");
                        end
                    end
                    52: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_l7_conv_blk_n)) begin
                            if (~compute_engine_U0.s_l7_conv_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_l7_conv_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.serialize_packed_outputs_1d_general_1u_1u_4u_8u_1u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_l7_conv_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    54: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_out_packed_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.grp_stream_width_adjust_flex_8_32_4_Pipeline_VITIS_LOOP_123_3_fu_48.s_out_packed_blk_n)) begin
                            if (~compute_engine_U0.s_out_packed_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_out_packed_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.num_samples_c_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.num_samples_c_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_full_n & synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_start & ~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.real_start & (trans_in_cnt_27 == trans_out_cnt_27) & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_read} start_FIFO}
                        if ((~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_full_n & compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.ap_start & ~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.real_start & (trans_in_cnt_27 == trans_out_cnt_27) & ~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0',");
                        end
                    end
                    50: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.stream_width_adjust_flex_8_32_4_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.general_1d_conv_accelerator_4_U0.sliding_window_1d_general_1u_1u_1u_1u_1u_1u_0u_0u_100u_1u_8u_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                54 : begin // for proc 'synthesis_top_synthesis_top.compute_engine_U0.hls_stream_to_axis_32_1_U0'
                    case(index2)
                    53: begin //  for dep proc 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.hls_stream_to_axis_32_1_U0.grp_hls_stream_to_axis_32_1_Pipeline_VITIS_LOOP_36_1_fu_54.s_out_packed_blk_n data_FIFO}
                        if ((~compute_engine_U0.hls_stream_to_axis_32_1_U0.grp_hls_stream_to_axis_32_1_Pipeline_VITIS_LOOP_36_1_fu_54.s_out_packed_blk_n)) begin
                            if (~compute_engine_U0.s_out_packed_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.s_out_packed_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.s_out_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' info is :
// blk sig is {~synthesis_top_synthesis_top_inst.compute_engine_U0.hls_stream_to_axis_32_1_U0.reps_blk_n data_FIFO}
                        if ((~compute_engine_U0.hls_stream_to_axis_32_1_U0.reps_blk_n)) begin
                            if (~compute_engine_U0.num_samples_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~compute_engine_U0.num_samples_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U' read by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path synthesis_top_synthesis_top.compute_engine_U0.num_samples_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'synthesis_top_synthesis_top.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U' info is :
// blk sig is {{~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_empty_n & synthesis_top_synthesis_top_inst.compute_engine_U0.hls_stream_to_axis_32_1_U0.ap_idle & ~synthesis_top_synthesis_top_inst.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_write} start_FIFO}
                        if ((~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_empty_n & compute_engine_U0.hls_stream_to_axis_32_1_U0.ap_idle & ~compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'synthesis_top_synthesis_top.compute_engine_U0.start_for_hls_stream_to_axis_32_1_U0_U' written by process 'synthesis_top_synthesis_top.compute_engine_U0.stream_width_adjust_flex_8_32_4_U0',");
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg && stop_report_path == 1'b0) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg)) & ~(|(reported_proc & dl_in_vec))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
