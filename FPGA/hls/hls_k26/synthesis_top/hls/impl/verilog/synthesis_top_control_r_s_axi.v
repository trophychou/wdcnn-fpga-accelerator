// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
(* DowngradeIPIdentifiedWarnings="yes" *) module synthesis_top_control_r_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 9,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire [63:0]                   w1,
    output wire [63:0]                   inc1,
    output wire [63:0]                   b1,
    output wire [63:0]                   w2,
    output wire [63:0]                   inc2,
    output wire [63:0]                   b2,
    output wire [63:0]                   w3,
    output wire [63:0]                   inc3,
    output wire [63:0]                   b3,
    output wire [63:0]                   w4,
    output wire [63:0]                   inc4,
    output wire [63:0]                   b4,
    output wire [63:0]                   w5,
    output wire [63:0]                   inc5,
    output wire [63:0]                   b5,
    output wire [63:0]                   w6,
    output wire [63:0]                   inc6,
    output wire [63:0]                   b6,
    output wire [63:0]                   w7,
    output wire [63:0]                   inc7,
    output wire [63:0]                   b7
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_none
//
// 0x000 : reserved
// 0x004 : reserved
// 0x008 : reserved
// 0x00c : reserved
// 0x010 : Data signal of w1
//         bit 31~0 - w1[31:0] (Read/Write)
// 0x014 : Data signal of w1
//         bit 31~0 - w1[63:32] (Read/Write)
// 0x018 : reserved
// 0x01c : Data signal of inc1
//         bit 31~0 - inc1[31:0] (Read/Write)
// 0x020 : Data signal of inc1
//         bit 31~0 - inc1[63:32] (Read/Write)
// 0x024 : reserved
// 0x028 : Data signal of b1
//         bit 31~0 - b1[31:0] (Read/Write)
// 0x02c : Data signal of b1
//         bit 31~0 - b1[63:32] (Read/Write)
// 0x030 : reserved
// 0x034 : Data signal of w2
//         bit 31~0 - w2[31:0] (Read/Write)
// 0x038 : Data signal of w2
//         bit 31~0 - w2[63:32] (Read/Write)
// 0x03c : reserved
// 0x040 : Data signal of inc2
//         bit 31~0 - inc2[31:0] (Read/Write)
// 0x044 : Data signal of inc2
//         bit 31~0 - inc2[63:32] (Read/Write)
// 0x048 : reserved
// 0x04c : Data signal of b2
//         bit 31~0 - b2[31:0] (Read/Write)
// 0x050 : Data signal of b2
//         bit 31~0 - b2[63:32] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of w3
//         bit 31~0 - w3[31:0] (Read/Write)
// 0x05c : Data signal of w3
//         bit 31~0 - w3[63:32] (Read/Write)
// 0x060 : reserved
// 0x064 : Data signal of inc3
//         bit 31~0 - inc3[31:0] (Read/Write)
// 0x068 : Data signal of inc3
//         bit 31~0 - inc3[63:32] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of b3
//         bit 31~0 - b3[31:0] (Read/Write)
// 0x074 : Data signal of b3
//         bit 31~0 - b3[63:32] (Read/Write)
// 0x078 : reserved
// 0x07c : Data signal of w4
//         bit 31~0 - w4[31:0] (Read/Write)
// 0x080 : Data signal of w4
//         bit 31~0 - w4[63:32] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of inc4
//         bit 31~0 - inc4[31:0] (Read/Write)
// 0x08c : Data signal of inc4
//         bit 31~0 - inc4[63:32] (Read/Write)
// 0x090 : reserved
// 0x094 : Data signal of b4
//         bit 31~0 - b4[31:0] (Read/Write)
// 0x098 : Data signal of b4
//         bit 31~0 - b4[63:32] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of w5
//         bit 31~0 - w5[31:0] (Read/Write)
// 0x0a4 : Data signal of w5
//         bit 31~0 - w5[63:32] (Read/Write)
// 0x0a8 : reserved
// 0x0ac : Data signal of inc5
//         bit 31~0 - inc5[31:0] (Read/Write)
// 0x0b0 : Data signal of inc5
//         bit 31~0 - inc5[63:32] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of b5
//         bit 31~0 - b5[31:0] (Read/Write)
// 0x0bc : Data signal of b5
//         bit 31~0 - b5[63:32] (Read/Write)
// 0x0c0 : reserved
// 0x0c4 : Data signal of w6
//         bit 31~0 - w6[31:0] (Read/Write)
// 0x0c8 : Data signal of w6
//         bit 31~0 - w6[63:32] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of inc6
//         bit 31~0 - inc6[31:0] (Read/Write)
// 0x0d4 : Data signal of inc6
//         bit 31~0 - inc6[63:32] (Read/Write)
// 0x0d8 : reserved
// 0x0dc : Data signal of b6
//         bit 31~0 - b6[31:0] (Read/Write)
// 0x0e0 : Data signal of b6
//         bit 31~0 - b6[63:32] (Read/Write)
// 0x0e4 : reserved
// 0x0e8 : Data signal of w7
//         bit 31~0 - w7[31:0] (Read/Write)
// 0x0ec : Data signal of w7
//         bit 31~0 - w7[63:32] (Read/Write)
// 0x0f0 : reserved
// 0x0f4 : Data signal of inc7
//         bit 31~0 - inc7[31:0] (Read/Write)
// 0x0f8 : Data signal of inc7
//         bit 31~0 - inc7[63:32] (Read/Write)
// 0x0fc : reserved
// 0x100 : Data signal of b7
//         bit 31~0 - b7[31:0] (Read/Write)
// 0x104 : Data signal of b7
//         bit 31~0 - b7[63:32] (Read/Write)
// 0x108 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_W1_DATA_0   = 9'h010,
    ADDR_W1_DATA_1   = 9'h014,
    ADDR_W1_CTRL     = 9'h018,
    ADDR_INC1_DATA_0 = 9'h01c,
    ADDR_INC1_DATA_1 = 9'h020,
    ADDR_INC1_CTRL   = 9'h024,
    ADDR_B1_DATA_0   = 9'h028,
    ADDR_B1_DATA_1   = 9'h02c,
    ADDR_B1_CTRL     = 9'h030,
    ADDR_W2_DATA_0   = 9'h034,
    ADDR_W2_DATA_1   = 9'h038,
    ADDR_W2_CTRL     = 9'h03c,
    ADDR_INC2_DATA_0 = 9'h040,
    ADDR_INC2_DATA_1 = 9'h044,
    ADDR_INC2_CTRL   = 9'h048,
    ADDR_B2_DATA_0   = 9'h04c,
    ADDR_B2_DATA_1   = 9'h050,
    ADDR_B2_CTRL     = 9'h054,
    ADDR_W3_DATA_0   = 9'h058,
    ADDR_W3_DATA_1   = 9'h05c,
    ADDR_W3_CTRL     = 9'h060,
    ADDR_INC3_DATA_0 = 9'h064,
    ADDR_INC3_DATA_1 = 9'h068,
    ADDR_INC3_CTRL   = 9'h06c,
    ADDR_B3_DATA_0   = 9'h070,
    ADDR_B3_DATA_1   = 9'h074,
    ADDR_B3_CTRL     = 9'h078,
    ADDR_W4_DATA_0   = 9'h07c,
    ADDR_W4_DATA_1   = 9'h080,
    ADDR_W4_CTRL     = 9'h084,
    ADDR_INC4_DATA_0 = 9'h088,
    ADDR_INC4_DATA_1 = 9'h08c,
    ADDR_INC4_CTRL   = 9'h090,
    ADDR_B4_DATA_0   = 9'h094,
    ADDR_B4_DATA_1   = 9'h098,
    ADDR_B4_CTRL     = 9'h09c,
    ADDR_W5_DATA_0   = 9'h0a0,
    ADDR_W5_DATA_1   = 9'h0a4,
    ADDR_W5_CTRL     = 9'h0a8,
    ADDR_INC5_DATA_0 = 9'h0ac,
    ADDR_INC5_DATA_1 = 9'h0b0,
    ADDR_INC5_CTRL   = 9'h0b4,
    ADDR_B5_DATA_0   = 9'h0b8,
    ADDR_B5_DATA_1   = 9'h0bc,
    ADDR_B5_CTRL     = 9'h0c0,
    ADDR_W6_DATA_0   = 9'h0c4,
    ADDR_W6_DATA_1   = 9'h0c8,
    ADDR_W6_CTRL     = 9'h0cc,
    ADDR_INC6_DATA_0 = 9'h0d0,
    ADDR_INC6_DATA_1 = 9'h0d4,
    ADDR_INC6_CTRL   = 9'h0d8,
    ADDR_B6_DATA_0   = 9'h0dc,
    ADDR_B6_DATA_1   = 9'h0e0,
    ADDR_B6_CTRL     = 9'h0e4,
    ADDR_W7_DATA_0   = 9'h0e8,
    ADDR_W7_DATA_1   = 9'h0ec,
    ADDR_W7_CTRL     = 9'h0f0,
    ADDR_INC7_DATA_0 = 9'h0f4,
    ADDR_INC7_DATA_1 = 9'h0f8,
    ADDR_INC7_CTRL   = 9'h0fc,
    ADDR_B7_DATA_0   = 9'h100,
    ADDR_B7_DATA_1   = 9'h104,
    ADDR_B7_CTRL     = 9'h108,
    WRIDLE           = 2'd0,
    WRDATA           = 2'd1,
    WRRESP           = 2'd2,
    WRRESET          = 2'd3,
    RDIDLE           = 2'd0,
    RDDATA           = 2'd1,
    RDRESET          = 2'd2,
    ADDR_BITS                = 9;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg  [63:0]                   int_w1 = 'b0;
    reg  [63:0]                   int_inc1 = 'b0;
    reg  [63:0]                   int_b1 = 'b0;
    reg  [63:0]                   int_w2 = 'b0;
    reg  [63:0]                   int_inc2 = 'b0;
    reg  [63:0]                   int_b2 = 'b0;
    reg  [63:0]                   int_w3 = 'b0;
    reg  [63:0]                   int_inc3 = 'b0;
    reg  [63:0]                   int_b3 = 'b0;
    reg  [63:0]                   int_w4 = 'b0;
    reg  [63:0]                   int_inc4 = 'b0;
    reg  [63:0]                   int_b4 = 'b0;
    reg  [63:0]                   int_w5 = 'b0;
    reg  [63:0]                   int_inc5 = 'b0;
    reg  [63:0]                   int_b5 = 'b0;
    reg  [63:0]                   int_w6 = 'b0;
    reg  [63:0]                   int_inc6 = 'b0;
    reg  [63:0]                   int_b6 = 'b0;
    reg  [63:0]                   int_w7 = 'b0;
    reg  [63:0]                   int_inc7 = 'b0;
    reg  [63:0]                   int_b7 = 'b0;

//------------------------Instantiation------------------


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BVALID  = (wstate == WRRESP);
assign BRESP   = 2'b00;  // OKAY
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY & BVALID)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= {AWADDR[ADDR_BITS-1:2], {2{1'b0}}};
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_W1_DATA_0: begin
                    rdata <= int_w1[31:0];
                end
                ADDR_W1_DATA_1: begin
                    rdata <= int_w1[63:32];
                end
                ADDR_INC1_DATA_0: begin
                    rdata <= int_inc1[31:0];
                end
                ADDR_INC1_DATA_1: begin
                    rdata <= int_inc1[63:32];
                end
                ADDR_B1_DATA_0: begin
                    rdata <= int_b1[31:0];
                end
                ADDR_B1_DATA_1: begin
                    rdata <= int_b1[63:32];
                end
                ADDR_W2_DATA_0: begin
                    rdata <= int_w2[31:0];
                end
                ADDR_W2_DATA_1: begin
                    rdata <= int_w2[63:32];
                end
                ADDR_INC2_DATA_0: begin
                    rdata <= int_inc2[31:0];
                end
                ADDR_INC2_DATA_1: begin
                    rdata <= int_inc2[63:32];
                end
                ADDR_B2_DATA_0: begin
                    rdata <= int_b2[31:0];
                end
                ADDR_B2_DATA_1: begin
                    rdata <= int_b2[63:32];
                end
                ADDR_W3_DATA_0: begin
                    rdata <= int_w3[31:0];
                end
                ADDR_W3_DATA_1: begin
                    rdata <= int_w3[63:32];
                end
                ADDR_INC3_DATA_0: begin
                    rdata <= int_inc3[31:0];
                end
                ADDR_INC3_DATA_1: begin
                    rdata <= int_inc3[63:32];
                end
                ADDR_B3_DATA_0: begin
                    rdata <= int_b3[31:0];
                end
                ADDR_B3_DATA_1: begin
                    rdata <= int_b3[63:32];
                end
                ADDR_W4_DATA_0: begin
                    rdata <= int_w4[31:0];
                end
                ADDR_W4_DATA_1: begin
                    rdata <= int_w4[63:32];
                end
                ADDR_INC4_DATA_0: begin
                    rdata <= int_inc4[31:0];
                end
                ADDR_INC4_DATA_1: begin
                    rdata <= int_inc4[63:32];
                end
                ADDR_B4_DATA_0: begin
                    rdata <= int_b4[31:0];
                end
                ADDR_B4_DATA_1: begin
                    rdata <= int_b4[63:32];
                end
                ADDR_W5_DATA_0: begin
                    rdata <= int_w5[31:0];
                end
                ADDR_W5_DATA_1: begin
                    rdata <= int_w5[63:32];
                end
                ADDR_INC5_DATA_0: begin
                    rdata <= int_inc5[31:0];
                end
                ADDR_INC5_DATA_1: begin
                    rdata <= int_inc5[63:32];
                end
                ADDR_B5_DATA_0: begin
                    rdata <= int_b5[31:0];
                end
                ADDR_B5_DATA_1: begin
                    rdata <= int_b5[63:32];
                end
                ADDR_W6_DATA_0: begin
                    rdata <= int_w6[31:0];
                end
                ADDR_W6_DATA_1: begin
                    rdata <= int_w6[63:32];
                end
                ADDR_INC6_DATA_0: begin
                    rdata <= int_inc6[31:0];
                end
                ADDR_INC6_DATA_1: begin
                    rdata <= int_inc6[63:32];
                end
                ADDR_B6_DATA_0: begin
                    rdata <= int_b6[31:0];
                end
                ADDR_B6_DATA_1: begin
                    rdata <= int_b6[63:32];
                end
                ADDR_W7_DATA_0: begin
                    rdata <= int_w7[31:0];
                end
                ADDR_W7_DATA_1: begin
                    rdata <= int_w7[63:32];
                end
                ADDR_INC7_DATA_0: begin
                    rdata <= int_inc7[31:0];
                end
                ADDR_INC7_DATA_1: begin
                    rdata <= int_inc7[63:32];
                end
                ADDR_B7_DATA_0: begin
                    rdata <= int_b7[31:0];
                end
                ADDR_B7_DATA_1: begin
                    rdata <= int_b7[63:32];
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign w1   = int_w1;
assign inc1 = int_inc1;
assign b1   = int_b1;
assign w2   = int_w2;
assign inc2 = int_inc2;
assign b2   = int_b2;
assign w3   = int_w3;
assign inc3 = int_inc3;
assign b3   = int_b3;
assign w4   = int_w4;
assign inc4 = int_inc4;
assign b4   = int_b4;
assign w5   = int_w5;
assign inc5 = int_inc5;
assign b5   = int_b5;
assign w6   = int_w6;
assign inc6 = int_inc6;
assign b6   = int_b6;
assign w7   = int_w7;
assign inc7 = int_inc7;
assign b7   = int_b7;
// int_w1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W1_DATA_0)
            int_w1[31:0] <= (WDATA[31:0] & wmask) | (int_w1[31:0] & ~wmask);
    end
end

// int_w1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W1_DATA_1)
            int_w1[63:32] <= (WDATA[31:0] & wmask) | (int_w1[63:32] & ~wmask);
    end
end

// int_inc1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC1_DATA_0)
            int_inc1[31:0] <= (WDATA[31:0] & wmask) | (int_inc1[31:0] & ~wmask);
    end
end

// int_inc1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC1_DATA_1)
            int_inc1[63:32] <= (WDATA[31:0] & wmask) | (int_inc1[63:32] & ~wmask);
    end
end

// int_b1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B1_DATA_0)
            int_b1[31:0] <= (WDATA[31:0] & wmask) | (int_b1[31:0] & ~wmask);
    end
end

// int_b1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B1_DATA_1)
            int_b1[63:32] <= (WDATA[31:0] & wmask) | (int_b1[63:32] & ~wmask);
    end
end

// int_w2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W2_DATA_0)
            int_w2[31:0] <= (WDATA[31:0] & wmask) | (int_w2[31:0] & ~wmask);
    end
end

// int_w2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W2_DATA_1)
            int_w2[63:32] <= (WDATA[31:0] & wmask) | (int_w2[63:32] & ~wmask);
    end
end

// int_inc2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC2_DATA_0)
            int_inc2[31:0] <= (WDATA[31:0] & wmask) | (int_inc2[31:0] & ~wmask);
    end
end

// int_inc2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC2_DATA_1)
            int_inc2[63:32] <= (WDATA[31:0] & wmask) | (int_inc2[63:32] & ~wmask);
    end
end

// int_b2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B2_DATA_0)
            int_b2[31:0] <= (WDATA[31:0] & wmask) | (int_b2[31:0] & ~wmask);
    end
end

// int_b2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B2_DATA_1)
            int_b2[63:32] <= (WDATA[31:0] & wmask) | (int_b2[63:32] & ~wmask);
    end
end

// int_w3[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w3[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W3_DATA_0)
            int_w3[31:0] <= (WDATA[31:0] & wmask) | (int_w3[31:0] & ~wmask);
    end
end

// int_w3[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w3[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W3_DATA_1)
            int_w3[63:32] <= (WDATA[31:0] & wmask) | (int_w3[63:32] & ~wmask);
    end
end

// int_inc3[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc3[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC3_DATA_0)
            int_inc3[31:0] <= (WDATA[31:0] & wmask) | (int_inc3[31:0] & ~wmask);
    end
end

// int_inc3[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc3[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC3_DATA_1)
            int_inc3[63:32] <= (WDATA[31:0] & wmask) | (int_inc3[63:32] & ~wmask);
    end
end

// int_b3[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b3[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B3_DATA_0)
            int_b3[31:0] <= (WDATA[31:0] & wmask) | (int_b3[31:0] & ~wmask);
    end
end

// int_b3[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b3[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B3_DATA_1)
            int_b3[63:32] <= (WDATA[31:0] & wmask) | (int_b3[63:32] & ~wmask);
    end
end

// int_w4[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w4[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W4_DATA_0)
            int_w4[31:0] <= (WDATA[31:0] & wmask) | (int_w4[31:0] & ~wmask);
    end
end

// int_w4[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w4[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W4_DATA_1)
            int_w4[63:32] <= (WDATA[31:0] & wmask) | (int_w4[63:32] & ~wmask);
    end
end

// int_inc4[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc4[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC4_DATA_0)
            int_inc4[31:0] <= (WDATA[31:0] & wmask) | (int_inc4[31:0] & ~wmask);
    end
end

// int_inc4[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc4[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC4_DATA_1)
            int_inc4[63:32] <= (WDATA[31:0] & wmask) | (int_inc4[63:32] & ~wmask);
    end
end

// int_b4[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b4[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B4_DATA_0)
            int_b4[31:0] <= (WDATA[31:0] & wmask) | (int_b4[31:0] & ~wmask);
    end
end

// int_b4[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b4[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B4_DATA_1)
            int_b4[63:32] <= (WDATA[31:0] & wmask) | (int_b4[63:32] & ~wmask);
    end
end

// int_w5[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w5[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W5_DATA_0)
            int_w5[31:0] <= (WDATA[31:0] & wmask) | (int_w5[31:0] & ~wmask);
    end
end

// int_w5[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w5[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W5_DATA_1)
            int_w5[63:32] <= (WDATA[31:0] & wmask) | (int_w5[63:32] & ~wmask);
    end
end

// int_inc5[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc5[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC5_DATA_0)
            int_inc5[31:0] <= (WDATA[31:0] & wmask) | (int_inc5[31:0] & ~wmask);
    end
end

// int_inc5[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc5[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC5_DATA_1)
            int_inc5[63:32] <= (WDATA[31:0] & wmask) | (int_inc5[63:32] & ~wmask);
    end
end

// int_b5[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b5[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B5_DATA_0)
            int_b5[31:0] <= (WDATA[31:0] & wmask) | (int_b5[31:0] & ~wmask);
    end
end

// int_b5[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b5[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B5_DATA_1)
            int_b5[63:32] <= (WDATA[31:0] & wmask) | (int_b5[63:32] & ~wmask);
    end
end

// int_w6[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w6[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W6_DATA_0)
            int_w6[31:0] <= (WDATA[31:0] & wmask) | (int_w6[31:0] & ~wmask);
    end
end

// int_w6[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w6[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W6_DATA_1)
            int_w6[63:32] <= (WDATA[31:0] & wmask) | (int_w6[63:32] & ~wmask);
    end
end

// int_inc6[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc6[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC6_DATA_0)
            int_inc6[31:0] <= (WDATA[31:0] & wmask) | (int_inc6[31:0] & ~wmask);
    end
end

// int_inc6[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc6[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC6_DATA_1)
            int_inc6[63:32] <= (WDATA[31:0] & wmask) | (int_inc6[63:32] & ~wmask);
    end
end

// int_b6[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b6[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B6_DATA_0)
            int_b6[31:0] <= (WDATA[31:0] & wmask) | (int_b6[31:0] & ~wmask);
    end
end

// int_b6[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b6[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B6_DATA_1)
            int_b6[63:32] <= (WDATA[31:0] & wmask) | (int_b6[63:32] & ~wmask);
    end
end

// int_w7[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_w7[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W7_DATA_0)
            int_w7[31:0] <= (WDATA[31:0] & wmask) | (int_w7[31:0] & ~wmask);
    end
end

// int_w7[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_w7[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_W7_DATA_1)
            int_w7[63:32] <= (WDATA[31:0] & wmask) | (int_w7[63:32] & ~wmask);
    end
end

// int_inc7[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc7[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC7_DATA_0)
            int_inc7[31:0] <= (WDATA[31:0] & wmask) | (int_inc7[31:0] & ~wmask);
    end
end

// int_inc7[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_inc7[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INC7_DATA_1)
            int_inc7[63:32] <= (WDATA[31:0] & wmask) | (int_inc7[63:32] & ~wmask);
    end
end

// int_b7[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_b7[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B7_DATA_0)
            int_b7[31:0] <= (WDATA[31:0] & wmask) | (int_b7[31:0] & ~wmask);
    end
end

// int_b7[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_b7[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_B7_DATA_1)
            int_b7[63:32] <= (WDATA[31:0] & wmask) | (int_b7[63:32] & ~wmask);
    end
end


//------------------------Memory logic-------------------

endmodule
