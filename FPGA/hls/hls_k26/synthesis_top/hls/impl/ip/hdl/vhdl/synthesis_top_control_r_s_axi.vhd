-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
-- Tool Version Limit: 2025.11
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- 
-- ==============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity synthesis_top_control_r_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 9;
    C_S_AXI_DATA_WIDTH    : INTEGER := 32);
port (
    ACLK                  :in   STD_LOGIC;
    ARESET                :in   STD_LOGIC;
    ACLK_EN               :in   STD_LOGIC;
    AWADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    AWVALID               :in   STD_LOGIC;
    AWREADY               :out  STD_LOGIC;
    WDATA                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    WSTRB                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    WVALID                :in   STD_LOGIC;
    WREADY                :out  STD_LOGIC;
    BRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    BVALID                :out  STD_LOGIC;
    BREADY                :in   STD_LOGIC;
    ARADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    ARVALID               :in   STD_LOGIC;
    ARREADY               :out  STD_LOGIC;
    RDATA                 :out  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    RRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    RVALID                :out  STD_LOGIC;
    RREADY                :in   STD_LOGIC;
    w1                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc1                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b1                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w2                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc2                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b2                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w3                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc3                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b3                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w4                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc4                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b4                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w5                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc5                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b5                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w6                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc6                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b6                    :out  STD_LOGIC_VECTOR(63 downto 0);
    w7                    :out  STD_LOGIC_VECTOR(63 downto 0);
    inc7                  :out  STD_LOGIC_VECTOR(63 downto 0);
    b7                    :out  STD_LOGIC_VECTOR(63 downto 0)
);
end entity synthesis_top_control_r_s_axi;

-- ------------------------Address Info-------------------
-- Protocol Used: ap_ctrl_none
--
-- 0x000 : reserved
-- 0x004 : reserved
-- 0x008 : reserved
-- 0x00c : reserved
-- 0x010 : Data signal of w1
--         bit 31~0 - w1[31:0] (Read/Write)
-- 0x014 : Data signal of w1
--         bit 31~0 - w1[63:32] (Read/Write)
-- 0x018 : reserved
-- 0x01c : Data signal of inc1
--         bit 31~0 - inc1[31:0] (Read/Write)
-- 0x020 : Data signal of inc1
--         bit 31~0 - inc1[63:32] (Read/Write)
-- 0x024 : reserved
-- 0x028 : Data signal of b1
--         bit 31~0 - b1[31:0] (Read/Write)
-- 0x02c : Data signal of b1
--         bit 31~0 - b1[63:32] (Read/Write)
-- 0x030 : reserved
-- 0x034 : Data signal of w2
--         bit 31~0 - w2[31:0] (Read/Write)
-- 0x038 : Data signal of w2
--         bit 31~0 - w2[63:32] (Read/Write)
-- 0x03c : reserved
-- 0x040 : Data signal of inc2
--         bit 31~0 - inc2[31:0] (Read/Write)
-- 0x044 : Data signal of inc2
--         bit 31~0 - inc2[63:32] (Read/Write)
-- 0x048 : reserved
-- 0x04c : Data signal of b2
--         bit 31~0 - b2[31:0] (Read/Write)
-- 0x050 : Data signal of b2
--         bit 31~0 - b2[63:32] (Read/Write)
-- 0x054 : reserved
-- 0x058 : Data signal of w3
--         bit 31~0 - w3[31:0] (Read/Write)
-- 0x05c : Data signal of w3
--         bit 31~0 - w3[63:32] (Read/Write)
-- 0x060 : reserved
-- 0x064 : Data signal of inc3
--         bit 31~0 - inc3[31:0] (Read/Write)
-- 0x068 : Data signal of inc3
--         bit 31~0 - inc3[63:32] (Read/Write)
-- 0x06c : reserved
-- 0x070 : Data signal of b3
--         bit 31~0 - b3[31:0] (Read/Write)
-- 0x074 : Data signal of b3
--         bit 31~0 - b3[63:32] (Read/Write)
-- 0x078 : reserved
-- 0x07c : Data signal of w4
--         bit 31~0 - w4[31:0] (Read/Write)
-- 0x080 : Data signal of w4
--         bit 31~0 - w4[63:32] (Read/Write)
-- 0x084 : reserved
-- 0x088 : Data signal of inc4
--         bit 31~0 - inc4[31:0] (Read/Write)
-- 0x08c : Data signal of inc4
--         bit 31~0 - inc4[63:32] (Read/Write)
-- 0x090 : reserved
-- 0x094 : Data signal of b4
--         bit 31~0 - b4[31:0] (Read/Write)
-- 0x098 : Data signal of b4
--         bit 31~0 - b4[63:32] (Read/Write)
-- 0x09c : reserved
-- 0x0a0 : Data signal of w5
--         bit 31~0 - w5[31:0] (Read/Write)
-- 0x0a4 : Data signal of w5
--         bit 31~0 - w5[63:32] (Read/Write)
-- 0x0a8 : reserved
-- 0x0ac : Data signal of inc5
--         bit 31~0 - inc5[31:0] (Read/Write)
-- 0x0b0 : Data signal of inc5
--         bit 31~0 - inc5[63:32] (Read/Write)
-- 0x0b4 : reserved
-- 0x0b8 : Data signal of b5
--         bit 31~0 - b5[31:0] (Read/Write)
-- 0x0bc : Data signal of b5
--         bit 31~0 - b5[63:32] (Read/Write)
-- 0x0c0 : reserved
-- 0x0c4 : Data signal of w6
--         bit 31~0 - w6[31:0] (Read/Write)
-- 0x0c8 : Data signal of w6
--         bit 31~0 - w6[63:32] (Read/Write)
-- 0x0cc : reserved
-- 0x0d0 : Data signal of inc6
--         bit 31~0 - inc6[31:0] (Read/Write)
-- 0x0d4 : Data signal of inc6
--         bit 31~0 - inc6[63:32] (Read/Write)
-- 0x0d8 : reserved
-- 0x0dc : Data signal of b6
--         bit 31~0 - b6[31:0] (Read/Write)
-- 0x0e0 : Data signal of b6
--         bit 31~0 - b6[63:32] (Read/Write)
-- 0x0e4 : reserved
-- 0x0e8 : Data signal of w7
--         bit 31~0 - w7[31:0] (Read/Write)
-- 0x0ec : Data signal of w7
--         bit 31~0 - w7[63:32] (Read/Write)
-- 0x0f0 : reserved
-- 0x0f4 : Data signal of inc7
--         bit 31~0 - inc7[31:0] (Read/Write)
-- 0x0f8 : Data signal of inc7
--         bit 31~0 - inc7[63:32] (Read/Write)
-- 0x0fc : reserved
-- 0x100 : Data signal of b7
--         bit 31~0 - b7[31:0] (Read/Write)
-- 0x104 : Data signal of b7
--         bit 31~0 - b7[63:32] (Read/Write)
-- 0x108 : reserved
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of synthesis_top_control_r_s_axi is
attribute DowngradeIPIdentifiedWarnings : STRING;
attribute DowngradeIPIdentifiedWarnings of behave : architecture is "yes";
    type states is (wridle, wrdata, wrresp, wrreset, rdidle, rddata, rdreset);  -- read and write fsm states
    signal wstate  : states := wrreset;
    signal rstate  : states := rdreset;
    signal wnext, rnext: states;
    constant ADDR_W1_DATA_0   : INTEGER := 16#010#;
    constant ADDR_W1_DATA_1   : INTEGER := 16#014#;
    constant ADDR_W1_CTRL     : INTEGER := 16#018#;
    constant ADDR_INC1_DATA_0 : INTEGER := 16#01c#;
    constant ADDR_INC1_DATA_1 : INTEGER := 16#020#;
    constant ADDR_INC1_CTRL   : INTEGER := 16#024#;
    constant ADDR_B1_DATA_0   : INTEGER := 16#028#;
    constant ADDR_B1_DATA_1   : INTEGER := 16#02c#;
    constant ADDR_B1_CTRL     : INTEGER := 16#030#;
    constant ADDR_W2_DATA_0   : INTEGER := 16#034#;
    constant ADDR_W2_DATA_1   : INTEGER := 16#038#;
    constant ADDR_W2_CTRL     : INTEGER := 16#03c#;
    constant ADDR_INC2_DATA_0 : INTEGER := 16#040#;
    constant ADDR_INC2_DATA_1 : INTEGER := 16#044#;
    constant ADDR_INC2_CTRL   : INTEGER := 16#048#;
    constant ADDR_B2_DATA_0   : INTEGER := 16#04c#;
    constant ADDR_B2_DATA_1   : INTEGER := 16#050#;
    constant ADDR_B2_CTRL     : INTEGER := 16#054#;
    constant ADDR_W3_DATA_0   : INTEGER := 16#058#;
    constant ADDR_W3_DATA_1   : INTEGER := 16#05c#;
    constant ADDR_W3_CTRL     : INTEGER := 16#060#;
    constant ADDR_INC3_DATA_0 : INTEGER := 16#064#;
    constant ADDR_INC3_DATA_1 : INTEGER := 16#068#;
    constant ADDR_INC3_CTRL   : INTEGER := 16#06c#;
    constant ADDR_B3_DATA_0   : INTEGER := 16#070#;
    constant ADDR_B3_DATA_1   : INTEGER := 16#074#;
    constant ADDR_B3_CTRL     : INTEGER := 16#078#;
    constant ADDR_W4_DATA_0   : INTEGER := 16#07c#;
    constant ADDR_W4_DATA_1   : INTEGER := 16#080#;
    constant ADDR_W4_CTRL     : INTEGER := 16#084#;
    constant ADDR_INC4_DATA_0 : INTEGER := 16#088#;
    constant ADDR_INC4_DATA_1 : INTEGER := 16#08c#;
    constant ADDR_INC4_CTRL   : INTEGER := 16#090#;
    constant ADDR_B4_DATA_0   : INTEGER := 16#094#;
    constant ADDR_B4_DATA_1   : INTEGER := 16#098#;
    constant ADDR_B4_CTRL     : INTEGER := 16#09c#;
    constant ADDR_W5_DATA_0   : INTEGER := 16#0a0#;
    constant ADDR_W5_DATA_1   : INTEGER := 16#0a4#;
    constant ADDR_W5_CTRL     : INTEGER := 16#0a8#;
    constant ADDR_INC5_DATA_0 : INTEGER := 16#0ac#;
    constant ADDR_INC5_DATA_1 : INTEGER := 16#0b0#;
    constant ADDR_INC5_CTRL   : INTEGER := 16#0b4#;
    constant ADDR_B5_DATA_0   : INTEGER := 16#0b8#;
    constant ADDR_B5_DATA_1   : INTEGER := 16#0bc#;
    constant ADDR_B5_CTRL     : INTEGER := 16#0c0#;
    constant ADDR_W6_DATA_0   : INTEGER := 16#0c4#;
    constant ADDR_W6_DATA_1   : INTEGER := 16#0c8#;
    constant ADDR_W6_CTRL     : INTEGER := 16#0cc#;
    constant ADDR_INC6_DATA_0 : INTEGER := 16#0d0#;
    constant ADDR_INC6_DATA_1 : INTEGER := 16#0d4#;
    constant ADDR_INC6_CTRL   : INTEGER := 16#0d8#;
    constant ADDR_B6_DATA_0   : INTEGER := 16#0dc#;
    constant ADDR_B6_DATA_1   : INTEGER := 16#0e0#;
    constant ADDR_B6_CTRL     : INTEGER := 16#0e4#;
    constant ADDR_W7_DATA_0   : INTEGER := 16#0e8#;
    constant ADDR_W7_DATA_1   : INTEGER := 16#0ec#;
    constant ADDR_W7_CTRL     : INTEGER := 16#0f0#;
    constant ADDR_INC7_DATA_0 : INTEGER := 16#0f4#;
    constant ADDR_INC7_DATA_1 : INTEGER := 16#0f8#;
    constant ADDR_INC7_CTRL   : INTEGER := 16#0fc#;
    constant ADDR_B7_DATA_0   : INTEGER := 16#100#;
    constant ADDR_B7_DATA_1   : INTEGER := 16#104#;
    constant ADDR_B7_CTRL     : INTEGER := 16#108#;
    constant ADDR_BITS         : INTEGER := 9;

    signal AWREADY_t           : STD_LOGIC;
    signal WREADY_t            : STD_LOGIC;
    signal ARREADY_t           : STD_LOGIC;
    signal RVALID_t            : STD_LOGIC;
    signal BVALID_t            : STD_LOGIC;
    signal waddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal wmask               : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal aw_hs               : STD_LOGIC;
    signal w_hs                : STD_LOGIC;
    signal rdata_data          : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal ar_hs               : STD_LOGIC;
    signal raddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    -- internal registers
    signal int_w1              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc1            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b1              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w2              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc2            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b2              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w3              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc3            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b3              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w4              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc4            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b4              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w5              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc5            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b5              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w6              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc6            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b6              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_w7              : UNSIGNED(63 downto 0) := (others => '0');
    signal int_inc7            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b7              : UNSIGNED(63 downto 0) := (others => '0');


begin
-- ----------------------- Instantiation------------------


-- ----------------------- AXI WRITE ---------------------
    AWREADY_t <=  '1' when wstate = wridle else '0';
    AWREADY   <=  AWREADY_t;
    WREADY_t  <=  '1' when wstate = wrdata else '0';
    WREADY    <=  WREADY_t;
    BVALID_t  <=  '1' when wstate = wrresp else '0';
    BVALID    <=  BVALID_t;
    BRESP     <=  "00";  -- OKAY
    wmask     <=  (31 downto 24 => WSTRB(3), 23 downto 16 => WSTRB(2), 15 downto 8 => WSTRB(1), 7 downto 0 => WSTRB(0));
    aw_hs     <=  AWVALID and AWREADY_t;
    w_hs      <=  WVALID and WREADY_t;

    -- write FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                wstate <= wrreset;
            elsif (ACLK_EN = '1') then
                wstate <= wnext;
            end if;
        end if;
    end process;

    process (wstate, AWVALID, WVALID, BREADY, BVALID_t)
    begin
        case (wstate) is
        when wridle =>
            if (AWVALID = '1') then
                wnext <= wrdata;
            else
                wnext <= wridle;
            end if;
        when wrdata =>
            if (WVALID = '1') then
                wnext <= wrresp;
            else
                wnext <= wrdata;
            end if;
        when wrresp =>
            if (BREADY = '1' and BVALID_t = '1') then
                wnext <= wridle;
            else
                wnext <= wrresp;
            end if;
        when others =>
            wnext <= wridle;
        end case;
    end process;

    waddr_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (aw_hs = '1') then
                    waddr <= UNSIGNED(AWADDR(ADDR_BITS-1 downto 2) & (1 downto 0 => '0'));
                end if;
            end if;
        end if;
    end process;

-- ----------------------- AXI READ ----------------------
    ARREADY_t <= '1' when (rstate = rdidle) else '0';
    ARREADY <= ARREADY_t;
    RDATA   <= STD_LOGIC_VECTOR(rdata_data);
    RRESP   <= "00";  -- OKAY
    RVALID_t  <= '1' when (rstate = rddata) else '0';
    RVALID    <= RVALID_t;
    ar_hs   <= ARVALID and ARREADY_t;
    raddr   <= UNSIGNED(ARADDR(ADDR_BITS-1 downto 0));

    -- read FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                rstate <= rdreset;
            elsif (ACLK_EN = '1') then
                rstate <= rnext;
            end if;
        end if;
    end process;

    process (rstate, ARVALID, RREADY, RVALID_t)
    begin
        case (rstate) is
        when rdidle =>
            if (ARVALID = '1') then
                rnext <= rddata;
            else
                rnext <= rdidle;
            end if;
        when rddata =>
            if (RREADY = '1' and RVALID_t = '1') then
                rnext <= rdidle;
            else
                rnext <= rddata;
            end if;
        when others =>
            rnext <= rdidle;
        end case;
    end process;

    rdata_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (ar_hs = '1') then
                    rdata_data <= (others => '0');
                    case (TO_INTEGER(raddr)) is
                    when ADDR_W1_DATA_0 =>
                        rdata_data <= RESIZE(int_w1(31 downto 0), 32);
                    when ADDR_W1_DATA_1 =>
                        rdata_data <= RESIZE(int_w1(63 downto 32), 32);
                    when ADDR_INC1_DATA_0 =>
                        rdata_data <= RESIZE(int_inc1(31 downto 0), 32);
                    when ADDR_INC1_DATA_1 =>
                        rdata_data <= RESIZE(int_inc1(63 downto 32), 32);
                    when ADDR_B1_DATA_0 =>
                        rdata_data <= RESIZE(int_b1(31 downto 0), 32);
                    when ADDR_B1_DATA_1 =>
                        rdata_data <= RESIZE(int_b1(63 downto 32), 32);
                    when ADDR_W2_DATA_0 =>
                        rdata_data <= RESIZE(int_w2(31 downto 0), 32);
                    when ADDR_W2_DATA_1 =>
                        rdata_data <= RESIZE(int_w2(63 downto 32), 32);
                    when ADDR_INC2_DATA_0 =>
                        rdata_data <= RESIZE(int_inc2(31 downto 0), 32);
                    when ADDR_INC2_DATA_1 =>
                        rdata_data <= RESIZE(int_inc2(63 downto 32), 32);
                    when ADDR_B2_DATA_0 =>
                        rdata_data <= RESIZE(int_b2(31 downto 0), 32);
                    when ADDR_B2_DATA_1 =>
                        rdata_data <= RESIZE(int_b2(63 downto 32), 32);
                    when ADDR_W3_DATA_0 =>
                        rdata_data <= RESIZE(int_w3(31 downto 0), 32);
                    when ADDR_W3_DATA_1 =>
                        rdata_data <= RESIZE(int_w3(63 downto 32), 32);
                    when ADDR_INC3_DATA_0 =>
                        rdata_data <= RESIZE(int_inc3(31 downto 0), 32);
                    when ADDR_INC3_DATA_1 =>
                        rdata_data <= RESIZE(int_inc3(63 downto 32), 32);
                    when ADDR_B3_DATA_0 =>
                        rdata_data <= RESIZE(int_b3(31 downto 0), 32);
                    when ADDR_B3_DATA_1 =>
                        rdata_data <= RESIZE(int_b3(63 downto 32), 32);
                    when ADDR_W4_DATA_0 =>
                        rdata_data <= RESIZE(int_w4(31 downto 0), 32);
                    when ADDR_W4_DATA_1 =>
                        rdata_data <= RESIZE(int_w4(63 downto 32), 32);
                    when ADDR_INC4_DATA_0 =>
                        rdata_data <= RESIZE(int_inc4(31 downto 0), 32);
                    when ADDR_INC4_DATA_1 =>
                        rdata_data <= RESIZE(int_inc4(63 downto 32), 32);
                    when ADDR_B4_DATA_0 =>
                        rdata_data <= RESIZE(int_b4(31 downto 0), 32);
                    when ADDR_B4_DATA_1 =>
                        rdata_data <= RESIZE(int_b4(63 downto 32), 32);
                    when ADDR_W5_DATA_0 =>
                        rdata_data <= RESIZE(int_w5(31 downto 0), 32);
                    when ADDR_W5_DATA_1 =>
                        rdata_data <= RESIZE(int_w5(63 downto 32), 32);
                    when ADDR_INC5_DATA_0 =>
                        rdata_data <= RESIZE(int_inc5(31 downto 0), 32);
                    when ADDR_INC5_DATA_1 =>
                        rdata_data <= RESIZE(int_inc5(63 downto 32), 32);
                    when ADDR_B5_DATA_0 =>
                        rdata_data <= RESIZE(int_b5(31 downto 0), 32);
                    when ADDR_B5_DATA_1 =>
                        rdata_data <= RESIZE(int_b5(63 downto 32), 32);
                    when ADDR_W6_DATA_0 =>
                        rdata_data <= RESIZE(int_w6(31 downto 0), 32);
                    when ADDR_W6_DATA_1 =>
                        rdata_data <= RESIZE(int_w6(63 downto 32), 32);
                    when ADDR_INC6_DATA_0 =>
                        rdata_data <= RESIZE(int_inc6(31 downto 0), 32);
                    when ADDR_INC6_DATA_1 =>
                        rdata_data <= RESIZE(int_inc6(63 downto 32), 32);
                    when ADDR_B6_DATA_0 =>
                        rdata_data <= RESIZE(int_b6(31 downto 0), 32);
                    when ADDR_B6_DATA_1 =>
                        rdata_data <= RESIZE(int_b6(63 downto 32), 32);
                    when ADDR_W7_DATA_0 =>
                        rdata_data <= RESIZE(int_w7(31 downto 0), 32);
                    when ADDR_W7_DATA_1 =>
                        rdata_data <= RESIZE(int_w7(63 downto 32), 32);
                    when ADDR_INC7_DATA_0 =>
                        rdata_data <= RESIZE(int_inc7(31 downto 0), 32);
                    when ADDR_INC7_DATA_1 =>
                        rdata_data <= RESIZE(int_inc7(63 downto 32), 32);
                    when ADDR_B7_DATA_0 =>
                        rdata_data <= RESIZE(int_b7(31 downto 0), 32);
                    when ADDR_B7_DATA_1 =>
                        rdata_data <= RESIZE(int_b7(63 downto 32), 32);
                    when others =>
                        NULL;
                    end case;
                end if;
            end if;
        end if;
    end process;

-- ----------------------- Register logic ----------------
    w1                   <= STD_LOGIC_VECTOR(int_w1);
    inc1                 <= STD_LOGIC_VECTOR(int_inc1);
    b1                   <= STD_LOGIC_VECTOR(int_b1);
    w2                   <= STD_LOGIC_VECTOR(int_w2);
    inc2                 <= STD_LOGIC_VECTOR(int_inc2);
    b2                   <= STD_LOGIC_VECTOR(int_b2);
    w3                   <= STD_LOGIC_VECTOR(int_w3);
    inc3                 <= STD_LOGIC_VECTOR(int_inc3);
    b3                   <= STD_LOGIC_VECTOR(int_b3);
    w4                   <= STD_LOGIC_VECTOR(int_w4);
    inc4                 <= STD_LOGIC_VECTOR(int_inc4);
    b4                   <= STD_LOGIC_VECTOR(int_b4);
    w5                   <= STD_LOGIC_VECTOR(int_w5);
    inc5                 <= STD_LOGIC_VECTOR(int_inc5);
    b5                   <= STD_LOGIC_VECTOR(int_b5);
    w6                   <= STD_LOGIC_VECTOR(int_w6);
    inc6                 <= STD_LOGIC_VECTOR(int_inc6);
    b6                   <= STD_LOGIC_VECTOR(int_b6);
    w7                   <= STD_LOGIC_VECTOR(int_w7);
    inc7                 <= STD_LOGIC_VECTOR(int_inc7);
    b7                   <= STD_LOGIC_VECTOR(int_b7);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W1_DATA_0) then
                    int_w1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W1_DATA_1) then
                    int_w1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC1_DATA_0) then
                    int_inc1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC1_DATA_1) then
                    int_inc1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B1_DATA_0) then
                    int_b1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B1_DATA_1) then
                    int_b1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W2_DATA_0) then
                    int_w2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W2_DATA_1) then
                    int_w2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC2_DATA_0) then
                    int_inc2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC2_DATA_1) then
                    int_inc2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B2_DATA_0) then
                    int_b2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B2_DATA_1) then
                    int_b2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W3_DATA_0) then
                    int_w3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W3_DATA_1) then
                    int_w3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC3_DATA_0) then
                    int_inc3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC3_DATA_1) then
                    int_inc3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B3_DATA_0) then
                    int_b3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B3_DATA_1) then
                    int_b3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W4_DATA_0) then
                    int_w4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W4_DATA_1) then
                    int_w4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC4_DATA_0) then
                    int_inc4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC4_DATA_1) then
                    int_inc4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B4_DATA_0) then
                    int_b4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B4_DATA_1) then
                    int_b4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W5_DATA_0) then
                    int_w5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W5_DATA_1) then
                    int_w5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC5_DATA_0) then
                    int_inc5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC5_DATA_1) then
                    int_inc5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B5_DATA_0) then
                    int_b5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B5_DATA_1) then
                    int_b5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W6_DATA_0) then
                    int_w6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W6_DATA_1) then
                    int_w6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC6_DATA_0) then
                    int_inc6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC6_DATA_1) then
                    int_inc6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B6_DATA_0) then
                    int_b6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B6_DATA_1) then
                    int_b6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W7_DATA_0) then
                    int_w7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_w7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_W7_DATA_1) then
                    int_w7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_w7(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC7_DATA_0) then
                    int_inc7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_inc7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INC7_DATA_1) then
                    int_inc7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_inc7(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B7_DATA_0) then
                    int_b7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B7_DATA_1) then
                    int_b7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b7(63 downto 32));
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------

end architecture behave;
