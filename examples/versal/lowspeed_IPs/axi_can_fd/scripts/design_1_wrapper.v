//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Sun Jul 25 21:49:46 2021
//Host        : xhdapps52 running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (ddr4_dimm1_act_n,
    ddr4_dimm1_adr,
    ddr4_dimm1_ba,
    ddr4_dimm1_bg,
    ddr4_dimm1_ck_c,
    ddr4_dimm1_ck_t,
    ddr4_dimm1_cke,
    ddr4_dimm1_cs_n,
    ddr4_dimm1_dm_n,
    ddr4_dimm1_dq,
    ddr4_dimm1_dqs_c,
    ddr4_dimm1_dqs_t,
    ddr4_dimm1_odt,
    ddr4_dimm1_reset_n,
    ddr4_dimm1_sma_clk_clk_n,
    ddr4_dimm1_sma_clk_clk_p,
    iic_rtl_scl_io,
    iic_rtl_sda_io);
  output ddr4_dimm1_act_n;
  output [16:0]ddr4_dimm1_adr;
  output [1:0]ddr4_dimm1_ba;
  output [1:0]ddr4_dimm1_bg;
  output ddr4_dimm1_ck_c;
  output ddr4_dimm1_ck_t;
  output ddr4_dimm1_cke;
  output ddr4_dimm1_cs_n;
  inout [7:0]ddr4_dimm1_dm_n;
  inout [63:0]ddr4_dimm1_dq;
  inout [7:0]ddr4_dimm1_dqs_c;
  inout [7:0]ddr4_dimm1_dqs_t;
  output ddr4_dimm1_odt;
  output ddr4_dimm1_reset_n;
  input ddr4_dimm1_sma_clk_clk_n;
  input ddr4_dimm1_sma_clk_clk_p;
  inout iic_rtl_scl_io;
  inout iic_rtl_sda_io;

  wire ddr4_dimm1_act_n;
  wire [16:0]ddr4_dimm1_adr;
  wire [1:0]ddr4_dimm1_ba;
  wire [1:0]ddr4_dimm1_bg;
  wire ddr4_dimm1_ck_c;
  wire ddr4_dimm1_ck_t;
  wire ddr4_dimm1_cke;
  wire ddr4_dimm1_cs_n;
  wire [7:0]ddr4_dimm1_dm_n;
  wire [63:0]ddr4_dimm1_dq;
  wire [7:0]ddr4_dimm1_dqs_c;
  wire [7:0]ddr4_dimm1_dqs_t;
  wire ddr4_dimm1_odt;
  wire ddr4_dimm1_reset_n;
  wire ddr4_dimm1_sma_clk_clk_n;
  wire ddr4_dimm1_sma_clk_clk_p;
  wire iic_rtl_scl_i;
  wire iic_rtl_scl_io;
  wire iic_rtl_scl_o;
  wire iic_rtl_scl_t;
  wire iic_rtl_sda_i;
  wire iic_rtl_sda_io;
  wire iic_rtl_sda_o;
  wire iic_rtl_sda_t;

  design_1 design_1_i
       (.ddr4_dimm1_act_n(ddr4_dimm1_act_n),
        .ddr4_dimm1_adr(ddr4_dimm1_adr),
        .ddr4_dimm1_ba(ddr4_dimm1_ba),
        .ddr4_dimm1_bg(ddr4_dimm1_bg),
        .ddr4_dimm1_ck_c(ddr4_dimm1_ck_c),
        .ddr4_dimm1_ck_t(ddr4_dimm1_ck_t),
        .ddr4_dimm1_cke(ddr4_dimm1_cke),
        .ddr4_dimm1_cs_n(ddr4_dimm1_cs_n),
        .ddr4_dimm1_dm_n(ddr4_dimm1_dm_n),
        .ddr4_dimm1_dq(ddr4_dimm1_dq),
        .ddr4_dimm1_dqs_c(ddr4_dimm1_dqs_c),
        .ddr4_dimm1_dqs_t(ddr4_dimm1_dqs_t),
        .ddr4_dimm1_odt(ddr4_dimm1_odt),
        .ddr4_dimm1_reset_n(ddr4_dimm1_reset_n),
        .ddr4_dimm1_sma_clk_clk_n(ddr4_dimm1_sma_clk_clk_n),
        .ddr4_dimm1_sma_clk_clk_p(ddr4_dimm1_sma_clk_clk_p),
        .iic_rtl_scl_i(iic_rtl_scl_i),
        .iic_rtl_scl_o(iic_rtl_scl_o),
        .iic_rtl_scl_t(iic_rtl_scl_t),
        .iic_rtl_sda_i(iic_rtl_sda_i),
        .iic_rtl_sda_o(iic_rtl_sda_o),
        .iic_rtl_sda_t(iic_rtl_sda_t));
  IOBUF iic_rtl_scl_iobuf
       (.I(iic_rtl_scl_o),
        .IO(iic_rtl_scl_io),
        .O(iic_rtl_scl_i),
        .T(iic_rtl_scl_t));
  IOBUF iic_rtl_sda_iobuf
       (.I(iic_rtl_sda_o),
        .IO(iic_rtl_sda_io),
        .O(iic_rtl_sda_i),
        .T(iic_rtl_sda_t));
endmodule
