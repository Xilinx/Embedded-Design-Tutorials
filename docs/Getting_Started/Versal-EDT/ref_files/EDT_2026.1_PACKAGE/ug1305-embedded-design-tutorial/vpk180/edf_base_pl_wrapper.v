//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2026.1 (lin64) Build 6480050 Sun May 17 12:21:46 MDT 2026
//Date        : Mon May 25 11:01:25 2026
//Host        : xhdrdevl238 running 64-bit Red Hat Enterprise Linux release 8.10 (Ootpa)
//Command     : generate_target edf_base_pl_wrapper.bd
//Design      : edf_base_pl_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module edf_base_pl_wrapper
   (ch0_lpddr4_trip1_ca_a,
    ch0_lpddr4_trip1_ca_b,
    ch0_lpddr4_trip1_ck_c_a,
    ch0_lpddr4_trip1_ck_c_b,
    ch0_lpddr4_trip1_ck_t_a,
    ch0_lpddr4_trip1_ck_t_b,
    ch0_lpddr4_trip1_cke_a,
    ch0_lpddr4_trip1_cke_b,
    ch0_lpddr4_trip1_cs_a,
    ch0_lpddr4_trip1_cs_b,
    ch0_lpddr4_trip1_dmi_a,
    ch0_lpddr4_trip1_dmi_b,
    ch0_lpddr4_trip1_dq_a,
    ch0_lpddr4_trip1_dq_b,
    ch0_lpddr4_trip1_dqs_c_a,
    ch0_lpddr4_trip1_dqs_c_b,
    ch0_lpddr4_trip1_dqs_t_a,
    ch0_lpddr4_trip1_dqs_t_b,
    ch0_lpddr4_trip1_reset_n,
    ch0_lpddr4_trip2_ca_a,
    ch0_lpddr4_trip2_ca_b,
    ch0_lpddr4_trip2_ck_c_a,
    ch0_lpddr4_trip2_ck_c_b,
    ch0_lpddr4_trip2_ck_t_a,
    ch0_lpddr4_trip2_ck_t_b,
    ch0_lpddr4_trip2_cke_a,
    ch0_lpddr4_trip2_cke_b,
    ch0_lpddr4_trip2_cs_a,
    ch0_lpddr4_trip2_cs_b,
    ch0_lpddr4_trip2_dmi_a,
    ch0_lpddr4_trip2_dmi_b,
    ch0_lpddr4_trip2_dq_a,
    ch0_lpddr4_trip2_dq_b,
    ch0_lpddr4_trip2_dqs_c_a,
    ch0_lpddr4_trip2_dqs_c_b,
    ch0_lpddr4_trip2_dqs_t_a,
    ch0_lpddr4_trip2_dqs_t_b,
    ch0_lpddr4_trip2_reset_n,
    ch0_lpddr4_trip3_ca_a,
    ch0_lpddr4_trip3_ca_b,
    ch0_lpddr4_trip3_ck_c_a,
    ch0_lpddr4_trip3_ck_c_b,
    ch0_lpddr4_trip3_ck_t_a,
    ch0_lpddr4_trip3_ck_t_b,
    ch0_lpddr4_trip3_cke_a,
    ch0_lpddr4_trip3_cke_b,
    ch0_lpddr4_trip3_cs_a,
    ch0_lpddr4_trip3_cs_b,
    ch0_lpddr4_trip3_dmi_a,
    ch0_lpddr4_trip3_dmi_b,
    ch0_lpddr4_trip3_dq_a,
    ch0_lpddr4_trip3_dq_b,
    ch0_lpddr4_trip3_dqs_c_a,
    ch0_lpddr4_trip3_dqs_c_b,
    ch0_lpddr4_trip3_dqs_t_a,
    ch0_lpddr4_trip3_dqs_t_b,
    ch0_lpddr4_trip3_reset_n,
    ch1_lpddr4_trip1_ca_a,
    ch1_lpddr4_trip1_ca_b,
    ch1_lpddr4_trip1_ck_c_a,
    ch1_lpddr4_trip1_ck_c_b,
    ch1_lpddr4_trip1_ck_t_a,
    ch1_lpddr4_trip1_ck_t_b,
    ch1_lpddr4_trip1_cke_a,
    ch1_lpddr4_trip1_cke_b,
    ch1_lpddr4_trip1_cs_a,
    ch1_lpddr4_trip1_cs_b,
    ch1_lpddr4_trip1_dmi_a,
    ch1_lpddr4_trip1_dmi_b,
    ch1_lpddr4_trip1_dq_a,
    ch1_lpddr4_trip1_dq_b,
    ch1_lpddr4_trip1_dqs_c_a,
    ch1_lpddr4_trip1_dqs_c_b,
    ch1_lpddr4_trip1_dqs_t_a,
    ch1_lpddr4_trip1_dqs_t_b,
    ch1_lpddr4_trip1_reset_n,
    ch1_lpddr4_trip2_ca_a,
    ch1_lpddr4_trip2_ca_b,
    ch1_lpddr4_trip2_ck_c_a,
    ch1_lpddr4_trip2_ck_c_b,
    ch1_lpddr4_trip2_ck_t_a,
    ch1_lpddr4_trip2_ck_t_b,
    ch1_lpddr4_trip2_cke_a,
    ch1_lpddr4_trip2_cke_b,
    ch1_lpddr4_trip2_cs_a,
    ch1_lpddr4_trip2_cs_b,
    ch1_lpddr4_trip2_dmi_a,
    ch1_lpddr4_trip2_dmi_b,
    ch1_lpddr4_trip2_dq_a,
    ch1_lpddr4_trip2_dq_b,
    ch1_lpddr4_trip2_dqs_c_a,
    ch1_lpddr4_trip2_dqs_c_b,
    ch1_lpddr4_trip2_dqs_t_a,
    ch1_lpddr4_trip2_dqs_t_b,
    ch1_lpddr4_trip2_reset_n,
    ch1_lpddr4_trip3_ca_a,
    ch1_lpddr4_trip3_ca_b,
    ch1_lpddr4_trip3_ck_c_a,
    ch1_lpddr4_trip3_ck_c_b,
    ch1_lpddr4_trip3_ck_t_a,
    ch1_lpddr4_trip3_ck_t_b,
    ch1_lpddr4_trip3_cke_a,
    ch1_lpddr4_trip3_cke_b,
    ch1_lpddr4_trip3_cs_a,
    ch1_lpddr4_trip3_cs_b,
    ch1_lpddr4_trip3_dmi_a,
    ch1_lpddr4_trip3_dmi_b,
    ch1_lpddr4_trip3_dq_a,
    ch1_lpddr4_trip3_dq_b,
    ch1_lpddr4_trip3_dqs_c_a,
    ch1_lpddr4_trip3_dqs_c_b,
    ch1_lpddr4_trip3_dqs_t_a,
    ch1_lpddr4_trip3_dqs_t_b,
    ch1_lpddr4_trip3_reset_n,
    gpio_dp_tri_i,
    gpio_led_tri_o,
    gpio_pb_tri_i,
    lpddr4_clk1_clk_n,
    lpddr4_clk1_clk_p,
    lpddr4_clk2_clk_n,
    lpddr4_clk2_clk_p,
    lpddr4_clk3_clk_n,
    lpddr4_clk3_clk_p,
    sysctrl_uart_rxd,
    sysctrl_uart_txd);
  output [5:0]ch0_lpddr4_trip1_ca_a;
  output [5:0]ch0_lpddr4_trip1_ca_b;
  output ch0_lpddr4_trip1_ck_c_a;
  output ch0_lpddr4_trip1_ck_c_b;
  output ch0_lpddr4_trip1_ck_t_a;
  output ch0_lpddr4_trip1_ck_t_b;
  output ch0_lpddr4_trip1_cke_a;
  output ch0_lpddr4_trip1_cke_b;
  output ch0_lpddr4_trip1_cs_a;
  output ch0_lpddr4_trip1_cs_b;
  inout [1:0]ch0_lpddr4_trip1_dmi_a;
  inout [1:0]ch0_lpddr4_trip1_dmi_b;
  inout [15:0]ch0_lpddr4_trip1_dq_a;
  inout [15:0]ch0_lpddr4_trip1_dq_b;
  inout [1:0]ch0_lpddr4_trip1_dqs_c_a;
  inout [1:0]ch0_lpddr4_trip1_dqs_c_b;
  inout [1:0]ch0_lpddr4_trip1_dqs_t_a;
  inout [1:0]ch0_lpddr4_trip1_dqs_t_b;
  output ch0_lpddr4_trip1_reset_n;
  output [5:0]ch0_lpddr4_trip2_ca_a;
  output [5:0]ch0_lpddr4_trip2_ca_b;
  output ch0_lpddr4_trip2_ck_c_a;
  output ch0_lpddr4_trip2_ck_c_b;
  output ch0_lpddr4_trip2_ck_t_a;
  output ch0_lpddr4_trip2_ck_t_b;
  output ch0_lpddr4_trip2_cke_a;
  output ch0_lpddr4_trip2_cke_b;
  output ch0_lpddr4_trip2_cs_a;
  output ch0_lpddr4_trip2_cs_b;
  inout [1:0]ch0_lpddr4_trip2_dmi_a;
  inout [1:0]ch0_lpddr4_trip2_dmi_b;
  inout [15:0]ch0_lpddr4_trip2_dq_a;
  inout [15:0]ch0_lpddr4_trip2_dq_b;
  inout [1:0]ch0_lpddr4_trip2_dqs_c_a;
  inout [1:0]ch0_lpddr4_trip2_dqs_c_b;
  inout [1:0]ch0_lpddr4_trip2_dqs_t_a;
  inout [1:0]ch0_lpddr4_trip2_dqs_t_b;
  output ch0_lpddr4_trip2_reset_n;
  output [5:0]ch0_lpddr4_trip3_ca_a;
  output [5:0]ch0_lpddr4_trip3_ca_b;
  output ch0_lpddr4_trip3_ck_c_a;
  output ch0_lpddr4_trip3_ck_c_b;
  output ch0_lpddr4_trip3_ck_t_a;
  output ch0_lpddr4_trip3_ck_t_b;
  output ch0_lpddr4_trip3_cke_a;
  output ch0_lpddr4_trip3_cke_b;
  output ch0_lpddr4_trip3_cs_a;
  output ch0_lpddr4_trip3_cs_b;
  inout [1:0]ch0_lpddr4_trip3_dmi_a;
  inout [1:0]ch0_lpddr4_trip3_dmi_b;
  inout [15:0]ch0_lpddr4_trip3_dq_a;
  inout [15:0]ch0_lpddr4_trip3_dq_b;
  inout [1:0]ch0_lpddr4_trip3_dqs_c_a;
  inout [1:0]ch0_lpddr4_trip3_dqs_c_b;
  inout [1:0]ch0_lpddr4_trip3_dqs_t_a;
  inout [1:0]ch0_lpddr4_trip3_dqs_t_b;
  output ch0_lpddr4_trip3_reset_n;
  output [5:0]ch1_lpddr4_trip1_ca_a;
  output [5:0]ch1_lpddr4_trip1_ca_b;
  output ch1_lpddr4_trip1_ck_c_a;
  output ch1_lpddr4_trip1_ck_c_b;
  output ch1_lpddr4_trip1_ck_t_a;
  output ch1_lpddr4_trip1_ck_t_b;
  output ch1_lpddr4_trip1_cke_a;
  output ch1_lpddr4_trip1_cke_b;
  output ch1_lpddr4_trip1_cs_a;
  output ch1_lpddr4_trip1_cs_b;
  inout [1:0]ch1_lpddr4_trip1_dmi_a;
  inout [1:0]ch1_lpddr4_trip1_dmi_b;
  inout [15:0]ch1_lpddr4_trip1_dq_a;
  inout [15:0]ch1_lpddr4_trip1_dq_b;
  inout [1:0]ch1_lpddr4_trip1_dqs_c_a;
  inout [1:0]ch1_lpddr4_trip1_dqs_c_b;
  inout [1:0]ch1_lpddr4_trip1_dqs_t_a;
  inout [1:0]ch1_lpddr4_trip1_dqs_t_b;
  output ch1_lpddr4_trip1_reset_n;
  output [5:0]ch1_lpddr4_trip2_ca_a;
  output [5:0]ch1_lpddr4_trip2_ca_b;
  output ch1_lpddr4_trip2_ck_c_a;
  output ch1_lpddr4_trip2_ck_c_b;
  output ch1_lpddr4_trip2_ck_t_a;
  output ch1_lpddr4_trip2_ck_t_b;
  output ch1_lpddr4_trip2_cke_a;
  output ch1_lpddr4_trip2_cke_b;
  output ch1_lpddr4_trip2_cs_a;
  output ch1_lpddr4_trip2_cs_b;
  inout [1:0]ch1_lpddr4_trip2_dmi_a;
  inout [1:0]ch1_lpddr4_trip2_dmi_b;
  inout [15:0]ch1_lpddr4_trip2_dq_a;
  inout [15:0]ch1_lpddr4_trip2_dq_b;
  inout [1:0]ch1_lpddr4_trip2_dqs_c_a;
  inout [1:0]ch1_lpddr4_trip2_dqs_c_b;
  inout [1:0]ch1_lpddr4_trip2_dqs_t_a;
  inout [1:0]ch1_lpddr4_trip2_dqs_t_b;
  output ch1_lpddr4_trip2_reset_n;
  output [5:0]ch1_lpddr4_trip3_ca_a;
  output [5:0]ch1_lpddr4_trip3_ca_b;
  output ch1_lpddr4_trip3_ck_c_a;
  output ch1_lpddr4_trip3_ck_c_b;
  output ch1_lpddr4_trip3_ck_t_a;
  output ch1_lpddr4_trip3_ck_t_b;
  output ch1_lpddr4_trip3_cke_a;
  output ch1_lpddr4_trip3_cke_b;
  output ch1_lpddr4_trip3_cs_a;
  output ch1_lpddr4_trip3_cs_b;
  inout [1:0]ch1_lpddr4_trip3_dmi_a;
  inout [1:0]ch1_lpddr4_trip3_dmi_b;
  inout [15:0]ch1_lpddr4_trip3_dq_a;
  inout [15:0]ch1_lpddr4_trip3_dq_b;
  inout [1:0]ch1_lpddr4_trip3_dqs_c_a;
  inout [1:0]ch1_lpddr4_trip3_dqs_c_b;
  inout [1:0]ch1_lpddr4_trip3_dqs_t_a;
  inout [1:0]ch1_lpddr4_trip3_dqs_t_b;
  output ch1_lpddr4_trip3_reset_n;
  input [3:0]gpio_dp_tri_i;
  output [3:0]gpio_led_tri_o;
  input [1:0]gpio_pb_tri_i;
  input lpddr4_clk1_clk_n;
  input lpddr4_clk1_clk_p;
  input lpddr4_clk2_clk_n;
  input lpddr4_clk2_clk_p;
  input lpddr4_clk3_clk_n;
  input lpddr4_clk3_clk_p;
  input sysctrl_uart_rxd;
  output sysctrl_uart_txd;

  wire [5:0]ch0_lpddr4_trip1_ca_a;
  wire [5:0]ch0_lpddr4_trip1_ca_b;
  wire ch0_lpddr4_trip1_ck_c_a;
  wire ch0_lpddr4_trip1_ck_c_b;
  wire ch0_lpddr4_trip1_ck_t_a;
  wire ch0_lpddr4_trip1_ck_t_b;
  wire ch0_lpddr4_trip1_cke_a;
  wire ch0_lpddr4_trip1_cke_b;
  wire ch0_lpddr4_trip1_cs_a;
  wire ch0_lpddr4_trip1_cs_b;
  wire [1:0]ch0_lpddr4_trip1_dmi_a;
  wire [1:0]ch0_lpddr4_trip1_dmi_b;
  wire [15:0]ch0_lpddr4_trip1_dq_a;
  wire [15:0]ch0_lpddr4_trip1_dq_b;
  wire [1:0]ch0_lpddr4_trip1_dqs_c_a;
  wire [1:0]ch0_lpddr4_trip1_dqs_c_b;
  wire [1:0]ch0_lpddr4_trip1_dqs_t_a;
  wire [1:0]ch0_lpddr4_trip1_dqs_t_b;
  wire ch0_lpddr4_trip1_reset_n;
  wire [5:0]ch0_lpddr4_trip2_ca_a;
  wire [5:0]ch0_lpddr4_trip2_ca_b;
  wire ch0_lpddr4_trip2_ck_c_a;
  wire ch0_lpddr4_trip2_ck_c_b;
  wire ch0_lpddr4_trip2_ck_t_a;
  wire ch0_lpddr4_trip2_ck_t_b;
  wire ch0_lpddr4_trip2_cke_a;
  wire ch0_lpddr4_trip2_cke_b;
  wire ch0_lpddr4_trip2_cs_a;
  wire ch0_lpddr4_trip2_cs_b;
  wire [1:0]ch0_lpddr4_trip2_dmi_a;
  wire [1:0]ch0_lpddr4_trip2_dmi_b;
  wire [15:0]ch0_lpddr4_trip2_dq_a;
  wire [15:0]ch0_lpddr4_trip2_dq_b;
  wire [1:0]ch0_lpddr4_trip2_dqs_c_a;
  wire [1:0]ch0_lpddr4_trip2_dqs_c_b;
  wire [1:0]ch0_lpddr4_trip2_dqs_t_a;
  wire [1:0]ch0_lpddr4_trip2_dqs_t_b;
  wire ch0_lpddr4_trip2_reset_n;
  wire [5:0]ch0_lpddr4_trip3_ca_a;
  wire [5:0]ch0_lpddr4_trip3_ca_b;
  wire ch0_lpddr4_trip3_ck_c_a;
  wire ch0_lpddr4_trip3_ck_c_b;
  wire ch0_lpddr4_trip3_ck_t_a;
  wire ch0_lpddr4_trip3_ck_t_b;
  wire ch0_lpddr4_trip3_cke_a;
  wire ch0_lpddr4_trip3_cke_b;
  wire ch0_lpddr4_trip3_cs_a;
  wire ch0_lpddr4_trip3_cs_b;
  wire [1:0]ch0_lpddr4_trip3_dmi_a;
  wire [1:0]ch0_lpddr4_trip3_dmi_b;
  wire [15:0]ch0_lpddr4_trip3_dq_a;
  wire [15:0]ch0_lpddr4_trip3_dq_b;
  wire [1:0]ch0_lpddr4_trip3_dqs_c_a;
  wire [1:0]ch0_lpddr4_trip3_dqs_c_b;
  wire [1:0]ch0_lpddr4_trip3_dqs_t_a;
  wire [1:0]ch0_lpddr4_trip3_dqs_t_b;
  wire ch0_lpddr4_trip3_reset_n;
  wire [5:0]ch1_lpddr4_trip1_ca_a;
  wire [5:0]ch1_lpddr4_trip1_ca_b;
  wire ch1_lpddr4_trip1_ck_c_a;
  wire ch1_lpddr4_trip1_ck_c_b;
  wire ch1_lpddr4_trip1_ck_t_a;
  wire ch1_lpddr4_trip1_ck_t_b;
  wire ch1_lpddr4_trip1_cke_a;
  wire ch1_lpddr4_trip1_cke_b;
  wire ch1_lpddr4_trip1_cs_a;
  wire ch1_lpddr4_trip1_cs_b;
  wire [1:0]ch1_lpddr4_trip1_dmi_a;
  wire [1:0]ch1_lpddr4_trip1_dmi_b;
  wire [15:0]ch1_lpddr4_trip1_dq_a;
  wire [15:0]ch1_lpddr4_trip1_dq_b;
  wire [1:0]ch1_lpddr4_trip1_dqs_c_a;
  wire [1:0]ch1_lpddr4_trip1_dqs_c_b;
  wire [1:0]ch1_lpddr4_trip1_dqs_t_a;
  wire [1:0]ch1_lpddr4_trip1_dqs_t_b;
  wire ch1_lpddr4_trip1_reset_n;
  wire [5:0]ch1_lpddr4_trip2_ca_a;
  wire [5:0]ch1_lpddr4_trip2_ca_b;
  wire ch1_lpddr4_trip2_ck_c_a;
  wire ch1_lpddr4_trip2_ck_c_b;
  wire ch1_lpddr4_trip2_ck_t_a;
  wire ch1_lpddr4_trip2_ck_t_b;
  wire ch1_lpddr4_trip2_cke_a;
  wire ch1_lpddr4_trip2_cke_b;
  wire ch1_lpddr4_trip2_cs_a;
  wire ch1_lpddr4_trip2_cs_b;
  wire [1:0]ch1_lpddr4_trip2_dmi_a;
  wire [1:0]ch1_lpddr4_trip2_dmi_b;
  wire [15:0]ch1_lpddr4_trip2_dq_a;
  wire [15:0]ch1_lpddr4_trip2_dq_b;
  wire [1:0]ch1_lpddr4_trip2_dqs_c_a;
  wire [1:0]ch1_lpddr4_trip2_dqs_c_b;
  wire [1:0]ch1_lpddr4_trip2_dqs_t_a;
  wire [1:0]ch1_lpddr4_trip2_dqs_t_b;
  wire ch1_lpddr4_trip2_reset_n;
  wire [5:0]ch1_lpddr4_trip3_ca_a;
  wire [5:0]ch1_lpddr4_trip3_ca_b;
  wire ch1_lpddr4_trip3_ck_c_a;
  wire ch1_lpddr4_trip3_ck_c_b;
  wire ch1_lpddr4_trip3_ck_t_a;
  wire ch1_lpddr4_trip3_ck_t_b;
  wire ch1_lpddr4_trip3_cke_a;
  wire ch1_lpddr4_trip3_cke_b;
  wire ch1_lpddr4_trip3_cs_a;
  wire ch1_lpddr4_trip3_cs_b;
  wire [1:0]ch1_lpddr4_trip3_dmi_a;
  wire [1:0]ch1_lpddr4_trip3_dmi_b;
  wire [15:0]ch1_lpddr4_trip3_dq_a;
  wire [15:0]ch1_lpddr4_trip3_dq_b;
  wire [1:0]ch1_lpddr4_trip3_dqs_c_a;
  wire [1:0]ch1_lpddr4_trip3_dqs_c_b;
  wire [1:0]ch1_lpddr4_trip3_dqs_t_a;
  wire [1:0]ch1_lpddr4_trip3_dqs_t_b;
  wire ch1_lpddr4_trip3_reset_n;
  wire [3:0]gpio_dp_tri_i;
  wire [3:0]gpio_led_tri_o;
  wire [1:0]gpio_pb_tri_i;
  wire lpddr4_clk1_clk_n;
  wire lpddr4_clk1_clk_p;
  wire lpddr4_clk2_clk_n;
  wire lpddr4_clk2_clk_p;
  wire lpddr4_clk3_clk_n;
  wire lpddr4_clk3_clk_p;
  wire sysctrl_uart_rxd;
  wire sysctrl_uart_txd;

  edf_base_pl edf_base_pl_i
       (.ch0_lpddr4_trip1_ca_a(ch0_lpddr4_trip1_ca_a),
        .ch0_lpddr4_trip1_ca_b(ch0_lpddr4_trip1_ca_b),
        .ch0_lpddr4_trip1_ck_c_a(ch0_lpddr4_trip1_ck_c_a),
        .ch0_lpddr4_trip1_ck_c_b(ch0_lpddr4_trip1_ck_c_b),
        .ch0_lpddr4_trip1_ck_t_a(ch0_lpddr4_trip1_ck_t_a),
        .ch0_lpddr4_trip1_ck_t_b(ch0_lpddr4_trip1_ck_t_b),
        .ch0_lpddr4_trip1_cke_a(ch0_lpddr4_trip1_cke_a),
        .ch0_lpddr4_trip1_cke_b(ch0_lpddr4_trip1_cke_b),
        .ch0_lpddr4_trip1_cs_a(ch0_lpddr4_trip1_cs_a),
        .ch0_lpddr4_trip1_cs_b(ch0_lpddr4_trip1_cs_b),
        .ch0_lpddr4_trip1_dmi_a(ch0_lpddr4_trip1_dmi_a),
        .ch0_lpddr4_trip1_dmi_b(ch0_lpddr4_trip1_dmi_b),
        .ch0_lpddr4_trip1_dq_a(ch0_lpddr4_trip1_dq_a),
        .ch0_lpddr4_trip1_dq_b(ch0_lpddr4_trip1_dq_b),
        .ch0_lpddr4_trip1_dqs_c_a(ch0_lpddr4_trip1_dqs_c_a),
        .ch0_lpddr4_trip1_dqs_c_b(ch0_lpddr4_trip1_dqs_c_b),
        .ch0_lpddr4_trip1_dqs_t_a(ch0_lpddr4_trip1_dqs_t_a),
        .ch0_lpddr4_trip1_dqs_t_b(ch0_lpddr4_trip1_dqs_t_b),
        .ch0_lpddr4_trip1_reset_n(ch0_lpddr4_trip1_reset_n),
        .ch0_lpddr4_trip2_ca_a(ch0_lpddr4_trip2_ca_a),
        .ch0_lpddr4_trip2_ca_b(ch0_lpddr4_trip2_ca_b),
        .ch0_lpddr4_trip2_ck_c_a(ch0_lpddr4_trip2_ck_c_a),
        .ch0_lpddr4_trip2_ck_c_b(ch0_lpddr4_trip2_ck_c_b),
        .ch0_lpddr4_trip2_ck_t_a(ch0_lpddr4_trip2_ck_t_a),
        .ch0_lpddr4_trip2_ck_t_b(ch0_lpddr4_trip2_ck_t_b),
        .ch0_lpddr4_trip2_cke_a(ch0_lpddr4_trip2_cke_a),
        .ch0_lpddr4_trip2_cke_b(ch0_lpddr4_trip2_cke_b),
        .ch0_lpddr4_trip2_cs_a(ch0_lpddr4_trip2_cs_a),
        .ch0_lpddr4_trip2_cs_b(ch0_lpddr4_trip2_cs_b),
        .ch0_lpddr4_trip2_dmi_a(ch0_lpddr4_trip2_dmi_a),
        .ch0_lpddr4_trip2_dmi_b(ch0_lpddr4_trip2_dmi_b),
        .ch0_lpddr4_trip2_dq_a(ch0_lpddr4_trip2_dq_a),
        .ch0_lpddr4_trip2_dq_b(ch0_lpddr4_trip2_dq_b),
        .ch0_lpddr4_trip2_dqs_c_a(ch0_lpddr4_trip2_dqs_c_a),
        .ch0_lpddr4_trip2_dqs_c_b(ch0_lpddr4_trip2_dqs_c_b),
        .ch0_lpddr4_trip2_dqs_t_a(ch0_lpddr4_trip2_dqs_t_a),
        .ch0_lpddr4_trip2_dqs_t_b(ch0_lpddr4_trip2_dqs_t_b),
        .ch0_lpddr4_trip2_reset_n(ch0_lpddr4_trip2_reset_n),
        .ch0_lpddr4_trip3_ca_a(ch0_lpddr4_trip3_ca_a),
        .ch0_lpddr4_trip3_ca_b(ch0_lpddr4_trip3_ca_b),
        .ch0_lpddr4_trip3_ck_c_a(ch0_lpddr4_trip3_ck_c_a),
        .ch0_lpddr4_trip3_ck_c_b(ch0_lpddr4_trip3_ck_c_b),
        .ch0_lpddr4_trip3_ck_t_a(ch0_lpddr4_trip3_ck_t_a),
        .ch0_lpddr4_trip3_ck_t_b(ch0_lpddr4_trip3_ck_t_b),
        .ch0_lpddr4_trip3_cke_a(ch0_lpddr4_trip3_cke_a),
        .ch0_lpddr4_trip3_cke_b(ch0_lpddr4_trip3_cke_b),
        .ch0_lpddr4_trip3_cs_a(ch0_lpddr4_trip3_cs_a),
        .ch0_lpddr4_trip3_cs_b(ch0_lpddr4_trip3_cs_b),
        .ch0_lpddr4_trip3_dmi_a(ch0_lpddr4_trip3_dmi_a),
        .ch0_lpddr4_trip3_dmi_b(ch0_lpddr4_trip3_dmi_b),
        .ch0_lpddr4_trip3_dq_a(ch0_lpddr4_trip3_dq_a),
        .ch0_lpddr4_trip3_dq_b(ch0_lpddr4_trip3_dq_b),
        .ch0_lpddr4_trip3_dqs_c_a(ch0_lpddr4_trip3_dqs_c_a),
        .ch0_lpddr4_trip3_dqs_c_b(ch0_lpddr4_trip3_dqs_c_b),
        .ch0_lpddr4_trip3_dqs_t_a(ch0_lpddr4_trip3_dqs_t_a),
        .ch0_lpddr4_trip3_dqs_t_b(ch0_lpddr4_trip3_dqs_t_b),
        .ch0_lpddr4_trip3_reset_n(ch0_lpddr4_trip3_reset_n),
        .ch1_lpddr4_trip1_ca_a(ch1_lpddr4_trip1_ca_a),
        .ch1_lpddr4_trip1_ca_b(ch1_lpddr4_trip1_ca_b),
        .ch1_lpddr4_trip1_ck_c_a(ch1_lpddr4_trip1_ck_c_a),
        .ch1_lpddr4_trip1_ck_c_b(ch1_lpddr4_trip1_ck_c_b),
        .ch1_lpddr4_trip1_ck_t_a(ch1_lpddr4_trip1_ck_t_a),
        .ch1_lpddr4_trip1_ck_t_b(ch1_lpddr4_trip1_ck_t_b),
        .ch1_lpddr4_trip1_cke_a(ch1_lpddr4_trip1_cke_a),
        .ch1_lpddr4_trip1_cke_b(ch1_lpddr4_trip1_cke_b),
        .ch1_lpddr4_trip1_cs_a(ch1_lpddr4_trip1_cs_a),
        .ch1_lpddr4_trip1_cs_b(ch1_lpddr4_trip1_cs_b),
        .ch1_lpddr4_trip1_dmi_a(ch1_lpddr4_trip1_dmi_a),
        .ch1_lpddr4_trip1_dmi_b(ch1_lpddr4_trip1_dmi_b),
        .ch1_lpddr4_trip1_dq_a(ch1_lpddr4_trip1_dq_a),
        .ch1_lpddr4_trip1_dq_b(ch1_lpddr4_trip1_dq_b),
        .ch1_lpddr4_trip1_dqs_c_a(ch1_lpddr4_trip1_dqs_c_a),
        .ch1_lpddr4_trip1_dqs_c_b(ch1_lpddr4_trip1_dqs_c_b),
        .ch1_lpddr4_trip1_dqs_t_a(ch1_lpddr4_trip1_dqs_t_a),
        .ch1_lpddr4_trip1_dqs_t_b(ch1_lpddr4_trip1_dqs_t_b),
        .ch1_lpddr4_trip1_reset_n(ch1_lpddr4_trip1_reset_n),
        .ch1_lpddr4_trip2_ca_a(ch1_lpddr4_trip2_ca_a),
        .ch1_lpddr4_trip2_ca_b(ch1_lpddr4_trip2_ca_b),
        .ch1_lpddr4_trip2_ck_c_a(ch1_lpddr4_trip2_ck_c_a),
        .ch1_lpddr4_trip2_ck_c_b(ch1_lpddr4_trip2_ck_c_b),
        .ch1_lpddr4_trip2_ck_t_a(ch1_lpddr4_trip2_ck_t_a),
        .ch1_lpddr4_trip2_ck_t_b(ch1_lpddr4_trip2_ck_t_b),
        .ch1_lpddr4_trip2_cke_a(ch1_lpddr4_trip2_cke_a),
        .ch1_lpddr4_trip2_cke_b(ch1_lpddr4_trip2_cke_b),
        .ch1_lpddr4_trip2_cs_a(ch1_lpddr4_trip2_cs_a),
        .ch1_lpddr4_trip2_cs_b(ch1_lpddr4_trip2_cs_b),
        .ch1_lpddr4_trip2_dmi_a(ch1_lpddr4_trip2_dmi_a),
        .ch1_lpddr4_trip2_dmi_b(ch1_lpddr4_trip2_dmi_b),
        .ch1_lpddr4_trip2_dq_a(ch1_lpddr4_trip2_dq_a),
        .ch1_lpddr4_trip2_dq_b(ch1_lpddr4_trip2_dq_b),
        .ch1_lpddr4_trip2_dqs_c_a(ch1_lpddr4_trip2_dqs_c_a),
        .ch1_lpddr4_trip2_dqs_c_b(ch1_lpddr4_trip2_dqs_c_b),
        .ch1_lpddr4_trip2_dqs_t_a(ch1_lpddr4_trip2_dqs_t_a),
        .ch1_lpddr4_trip2_dqs_t_b(ch1_lpddr4_trip2_dqs_t_b),
        .ch1_lpddr4_trip2_reset_n(ch1_lpddr4_trip2_reset_n),
        .ch1_lpddr4_trip3_ca_a(ch1_lpddr4_trip3_ca_a),
        .ch1_lpddr4_trip3_ca_b(ch1_lpddr4_trip3_ca_b),
        .ch1_lpddr4_trip3_ck_c_a(ch1_lpddr4_trip3_ck_c_a),
        .ch1_lpddr4_trip3_ck_c_b(ch1_lpddr4_trip3_ck_c_b),
        .ch1_lpddr4_trip3_ck_t_a(ch1_lpddr4_trip3_ck_t_a),
        .ch1_lpddr4_trip3_ck_t_b(ch1_lpddr4_trip3_ck_t_b),
        .ch1_lpddr4_trip3_cke_a(ch1_lpddr4_trip3_cke_a),
        .ch1_lpddr4_trip3_cke_b(ch1_lpddr4_trip3_cke_b),
        .ch1_lpddr4_trip3_cs_a(ch1_lpddr4_trip3_cs_a),
        .ch1_lpddr4_trip3_cs_b(ch1_lpddr4_trip3_cs_b),
        .ch1_lpddr4_trip3_dmi_a(ch1_lpddr4_trip3_dmi_a),
        .ch1_lpddr4_trip3_dmi_b(ch1_lpddr4_trip3_dmi_b),
        .ch1_lpddr4_trip3_dq_a(ch1_lpddr4_trip3_dq_a),
        .ch1_lpddr4_trip3_dq_b(ch1_lpddr4_trip3_dq_b),
        .ch1_lpddr4_trip3_dqs_c_a(ch1_lpddr4_trip3_dqs_c_a),
        .ch1_lpddr4_trip3_dqs_c_b(ch1_lpddr4_trip3_dqs_c_b),
        .ch1_lpddr4_trip3_dqs_t_a(ch1_lpddr4_trip3_dqs_t_a),
        .ch1_lpddr4_trip3_dqs_t_b(ch1_lpddr4_trip3_dqs_t_b),
        .ch1_lpddr4_trip3_reset_n(ch1_lpddr4_trip3_reset_n),
        .gpio_dp_tri_i(gpio_dp_tri_i),
        .gpio_led_tri_o(gpio_led_tri_o),
        .gpio_pb_tri_i(gpio_pb_tri_i),
        .lpddr4_clk1_clk_n(lpddr4_clk1_clk_n),
        .lpddr4_clk1_clk_p(lpddr4_clk1_clk_p),
        .lpddr4_clk2_clk_n(lpddr4_clk2_clk_n),
        .lpddr4_clk2_clk_p(lpddr4_clk2_clk_p),
        .lpddr4_clk3_clk_n(lpddr4_clk3_clk_n),
        .lpddr4_clk3_clk_p(lpddr4_clk3_clk_p),
        .sysctrl_uart_rxd(sysctrl_uart_rxd),
        .sysctrl_uart_txd(sysctrl_uart_txd));
endmodule
