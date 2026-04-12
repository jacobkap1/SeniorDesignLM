//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Apr 12 01:02:14 2026
// Version: 2025.2 2025.2.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// MIPI_CAMERA
module MIPI_CAMERA(
    // Inputs
    ACLK_I,
    ARST_N,
    AXI4L_VDMA_araddr,
    AXI4L_VDMA_arvalid,
    AXI4L_VDMA_awaddr,
    AXI4L_VDMA_awvalid,
    AXI4L_VDMA_bready,
    AXI4L_VDMA_rready,
    AXI4L_VDMA_wdata,
    AXI4L_VDMA_wvalid,
    AXI4Lite_Target_IF_ARADDR_I,
    AXI4Lite_Target_IF_ARVALID_I,
    AXI4Lite_Target_IF_AWADDR_I,
    AXI4Lite_Target_IF_AWVALID_I,
    AXI4Lite_Target_IF_BREADY_I,
    AXI4Lite_Target_IF_RREADY_I,
    AXI4Lite_Target_IF_WDATA_I,
    AXI4Lite_Target_IF_WVALID_I,
    DDR_CLK_I,
    RXD,
    RXD_N,
    RX_CLK_N,
    RX_CLK_P,
    mAXI4_SLAVE_arready,
    mAXI4_SLAVE_awready,
    mAXI4_SLAVE_bid,
    mAXI4_SLAVE_bresp,
    mAXI4_SLAVE_bvalid,
    mAXI4_SLAVE_rdata,
    mAXI4_SLAVE_rid,
    mAXI4_SLAVE_rlast,
    mAXI4_SLAVE_rresp,
    mAXI4_SLAVE_rvalid,
    mAXI4_SLAVE_wready,
    // Outputs
    AXI4L_VDMA_arready,
    AXI4L_VDMA_awready,
    AXI4L_VDMA_bresp,
    AXI4L_VDMA_bvalid,
    AXI4L_VDMA_rdata,
    AXI4L_VDMA_rresp,
    AXI4L_VDMA_rvalid,
    AXI4L_VDMA_wready,
    AXI4Lite_Target_IF_ARREADY_O,
    AXI4Lite_Target_IF_AWREADY_O,
    AXI4Lite_Target_IF_BRESP_O,
    AXI4Lite_Target_IF_BVALID_O,
    AXI4Lite_Target_IF_RDATA_O,
    AXI4Lite_Target_IF_RRESP_O,
    AXI4Lite_Target_IF_RVALID_O,
    AXI4Lite_Target_IF_WREADY_O,
    INT_DMA_O,
    MIPI_INTERRUPT_O,
    mAXI4_SLAVE_araddr,
    mAXI4_SLAVE_arburst,
    mAXI4_SLAVE_arcache,
    mAXI4_SLAVE_arid,
    mAXI4_SLAVE_arlen,
    mAXI4_SLAVE_arlock,
    mAXI4_SLAVE_arprot,
    mAXI4_SLAVE_arsize,
    mAXI4_SLAVE_arvalid,
    mAXI4_SLAVE_awaddr,
    mAXI4_SLAVE_awburst,
    mAXI4_SLAVE_awcache,
    mAXI4_SLAVE_awid,
    mAXI4_SLAVE_awlen,
    mAXI4_SLAVE_awlock,
    mAXI4_SLAVE_awprot,
    mAXI4_SLAVE_awsize,
    mAXI4_SLAVE_awvalid,
    mAXI4_SLAVE_bready,
    mAXI4_SLAVE_rready,
    mAXI4_SLAVE_wdata,
    mAXI4_SLAVE_wlast,
    mAXI4_SLAVE_wstrb,
    mAXI4_SLAVE_wvalid
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         ACLK_I;
input         ARST_N;
input  [31:0] AXI4L_VDMA_araddr;
input         AXI4L_VDMA_arvalid;
input  [31:0] AXI4L_VDMA_awaddr;
input         AXI4L_VDMA_awvalid;
input         AXI4L_VDMA_bready;
input         AXI4L_VDMA_rready;
input  [31:0] AXI4L_VDMA_wdata;
input         AXI4L_VDMA_wvalid;
input  [31:0] AXI4Lite_Target_IF_ARADDR_I;
input         AXI4Lite_Target_IF_ARVALID_I;
input  [31:0] AXI4Lite_Target_IF_AWADDR_I;
input         AXI4Lite_Target_IF_AWVALID_I;
input         AXI4Lite_Target_IF_BREADY_I;
input         AXI4Lite_Target_IF_RREADY_I;
input  [31:0] AXI4Lite_Target_IF_WDATA_I;
input         AXI4Lite_Target_IF_WVALID_I;
input         DDR_CLK_I;
input  [1:0]  RXD;
input  [1:0]  RXD_N;
input         RX_CLK_N;
input         RX_CLK_P;
input         mAXI4_SLAVE_arready;
input         mAXI4_SLAVE_awready;
input  [3:0]  mAXI4_SLAVE_bid;
input  [1:0]  mAXI4_SLAVE_bresp;
input         mAXI4_SLAVE_bvalid;
input  [63:0] mAXI4_SLAVE_rdata;
input  [3:0]  mAXI4_SLAVE_rid;
input         mAXI4_SLAVE_rlast;
input  [1:0]  mAXI4_SLAVE_rresp;
input         mAXI4_SLAVE_rvalid;
input         mAXI4_SLAVE_wready;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        AXI4L_VDMA_arready;
output        AXI4L_VDMA_awready;
output [1:0]  AXI4L_VDMA_bresp;
output        AXI4L_VDMA_bvalid;
output [31:0] AXI4L_VDMA_rdata;
output [1:0]  AXI4L_VDMA_rresp;
output        AXI4L_VDMA_rvalid;
output        AXI4L_VDMA_wready;
output        AXI4Lite_Target_IF_ARREADY_O;
output        AXI4Lite_Target_IF_AWREADY_O;
output [1:0]  AXI4Lite_Target_IF_BRESP_O;
output        AXI4Lite_Target_IF_BVALID_O;
output [31:0] AXI4Lite_Target_IF_RDATA_O;
output [1:0]  AXI4Lite_Target_IF_RRESP_O;
output        AXI4Lite_Target_IF_RVALID_O;
output        AXI4Lite_Target_IF_WREADY_O;
output        INT_DMA_O;
output        MIPI_INTERRUPT_O;
output [37:0] mAXI4_SLAVE_araddr;
output [1:0]  mAXI4_SLAVE_arburst;
output [3:0]  mAXI4_SLAVE_arcache;
output [3:0]  mAXI4_SLAVE_arid;
output [7:0]  mAXI4_SLAVE_arlen;
output [1:0]  mAXI4_SLAVE_arlock;
output [2:0]  mAXI4_SLAVE_arprot;
output [2:0]  mAXI4_SLAVE_arsize;
output        mAXI4_SLAVE_arvalid;
output [37:0] mAXI4_SLAVE_awaddr;
output [1:0]  mAXI4_SLAVE_awburst;
output [3:0]  mAXI4_SLAVE_awcache;
output [3:0]  mAXI4_SLAVE_awid;
output [7:0]  mAXI4_SLAVE_awlen;
output [1:0]  mAXI4_SLAVE_awlock;
output [2:0]  mAXI4_SLAVE_awprot;
output [2:0]  mAXI4_SLAVE_awsize;
output        mAXI4_SLAVE_awvalid;
output        mAXI4_SLAVE_bready;
output        mAXI4_SLAVE_rready;
output [63:0] mAXI4_SLAVE_wdata;
output        mAXI4_SLAVE_wlast;
output [7:0]  mAXI4_SLAVE_wstrb;
output        mAXI4_SLAVE_wvalid;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ACLK_I;
wire          ARST_N;
wire   [31:0] AXI4L_VDMA_araddr;
wire          AXI4L_VDMA_ARREADY_net_0;
wire          AXI4L_VDMA_arvalid;
wire   [31:0] AXI4L_VDMA_awaddr;
wire          AXI4L_VDMA_AWREADY_net_0;
wire          AXI4L_VDMA_awvalid;
wire          AXI4L_VDMA_bready;
wire   [1:0]  AXI4L_VDMA_BRESP_net_0;
wire          AXI4L_VDMA_BVALID_net_0;
wire   [31:0] AXI4L_VDMA_RDATA_net_0;
wire          AXI4L_VDMA_rready;
wire   [1:0]  AXI4L_VDMA_RRESP_net_0;
wire          AXI4L_VDMA_RVALID_net_0;
wire   [31:0] AXI4L_VDMA_wdata;
wire          AXI4L_VDMA_WREADY_net_0;
wire          AXI4L_VDMA_wvalid;
wire   [31:0] AXI4Lite_Target_IF_ARADDR_I;
wire          AXI4Lite_Target_IF_ARREADY;
wire          AXI4Lite_Target_IF_ARVALID_I;
wire   [31:0] AXI4Lite_Target_IF_AWADDR_I;
wire          AXI4Lite_Target_IF_AWREADY;
wire          AXI4Lite_Target_IF_AWVALID_I;
wire          AXI4Lite_Target_IF_BREADY_I;
wire   [1:0]  AXI4Lite_Target_IF_BRESP;
wire          AXI4Lite_Target_IF_BVALID;
wire   [31:0] AXI4Lite_Target_IF_RDATA;
wire          AXI4Lite_Target_IF_RREADY_I;
wire   [1:0]  AXI4Lite_Target_IF_RRESP;
wire          AXI4Lite_Target_IF_RVALID;
wire   [31:0] AXI4Lite_Target_IF_WDATA_I;
wire          AXI4Lite_Target_IF_WREADY;
wire          AXI4Lite_Target_IF_WVALID_I;
wire          DDR_CLK_I;
wire          INT_DMA_O_net_0;
wire   [37:0] mAXI4_SLAVE_ARADDR_net_0;
wire   [1:0]  mAXI4_SLAVE_ARBURST_net_0;
wire   [3:0]  mAXI4_SLAVE_ARCACHE_net_0;
wire   [3:0]  mAXI4_SLAVE_ARID_net_0;
wire   [7:0]  mAXI4_SLAVE_ARLEN_net_0;
wire   [1:0]  mAXI4_SLAVE_ARLOCK_net_0;
wire   [2:0]  mAXI4_SLAVE_ARPROT_net_0;
wire          mAXI4_SLAVE_arready;
wire   [2:0]  mAXI4_SLAVE_ARSIZE_net_0;
wire          mAXI4_SLAVE_ARVALID_net_0;
wire   [37:0] mAXI4_SLAVE_AWADDR_net_0;
wire   [1:0]  mAXI4_SLAVE_AWBURST_net_0;
wire   [3:0]  mAXI4_SLAVE_AWCACHE_net_0;
wire   [3:0]  mAXI4_SLAVE_AWID_net_0;
wire   [7:0]  mAXI4_SLAVE_AWLEN_net_0;
wire   [1:0]  mAXI4_SLAVE_AWLOCK_net_0;
wire   [2:0]  mAXI4_SLAVE_AWPROT_net_0;
wire          mAXI4_SLAVE_awready;
wire   [2:0]  mAXI4_SLAVE_AWSIZE_net_0;
wire          mAXI4_SLAVE_AWVALID_net_0;
wire   [3:0]  mAXI4_SLAVE_bid;
wire          mAXI4_SLAVE_BREADY_net_0;
wire   [1:0]  mAXI4_SLAVE_bresp;
wire          mAXI4_SLAVE_bvalid;
wire   [63:0] mAXI4_SLAVE_rdata;
wire   [3:0]  mAXI4_SLAVE_rid;
wire          mAXI4_SLAVE_rlast;
wire          mAXI4_SLAVE_RREADY_net_0;
wire   [1:0]  mAXI4_SLAVE_rresp;
wire          mAXI4_SLAVE_rvalid;
wire   [63:0] mAXI4_SLAVE_WDATA_net_0;
wire          mAXI4_SLAVE_WLAST_net_0;
wire          mAXI4_SLAVE_wready;
wire   [7:0]  mAXI4_SLAVE_WSTRB_net_0;
wire          mAXI4_SLAVE_WVALID_net_0;
wire          MIPI_INTERRUPT_O_net_0;
wire   [9:0]  mipicsi2rxdecoderPF_C0_0_DATA_O;
wire          mipicsi2rxdecoderPF_C0_0_FRAME_START_O;
wire          mipicsi2rxdecoderPF_C0_0_LINE_VALID_O;
wire          PF_CCC_C1_0_OUT0_FABCLK_0;
wire          PF_CCC_C1_0_PLL_LOCK_0;
wire          PF_IOD_GENERIC_RX_C0_0_CLK_TRAIN_DONE;
wire          PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA;
wire          PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA_N;
wire   [7:0]  PF_IOD_GENERIC_RX_C0_0_L0_RXD_DATA;
wire          PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_0;
wire          PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_N_0;
wire   [7:0]  PF_IOD_GENERIC_RX_C0_0_L1_RXD_DATA_0;
wire          PF_IOD_GENERIC_RX_C0_0_RX_CLK_G;
wire          RX_CLK_N;
wire          RX_CLK_P;
wire   [1:0]  RXD;
wire   [1:0]  RXD_N;
wire          mAXI4_SLAVE_AWVALID_net_1;
wire          mAXI4_SLAVE_WLAST_net_1;
wire          mAXI4_SLAVE_WVALID_net_1;
wire          mAXI4_SLAVE_BREADY_net_1;
wire          mAXI4_SLAVE_ARVALID_net_1;
wire          mAXI4_SLAVE_RREADY_net_1;
wire          AXI4Lite_Target_IF_AWREADY_net_0;
wire          AXI4Lite_Target_IF_WREADY_net_0;
wire          AXI4Lite_Target_IF_BVALID_net_0;
wire          AXI4Lite_Target_IF_ARREADY_net_0;
wire          AXI4Lite_Target_IF_RVALID_net_0;
wire          INT_DMA_O_net_1;
wire          MIPI_INTERRUPT_O_net_1;
wire   [3:0]  mAXI4_SLAVE_AWID_net_1;
wire   [37:0] mAXI4_SLAVE_AWADDR_net_1;
wire   [7:0]  mAXI4_SLAVE_AWLEN_net_1;
wire   [2:0]  mAXI4_SLAVE_AWSIZE_net_1;
wire   [1:0]  mAXI4_SLAVE_AWBURST_net_1;
wire   [1:0]  mAXI4_SLAVE_AWLOCK_net_1;
wire   [3:0]  mAXI4_SLAVE_AWCACHE_net_1;
wire   [2:0]  mAXI4_SLAVE_AWPROT_net_1;
wire   [63:0] mAXI4_SLAVE_WDATA_net_1;
wire   [7:0]  mAXI4_SLAVE_WSTRB_net_1;
wire   [3:0]  mAXI4_SLAVE_ARID_net_1;
wire   [37:0] mAXI4_SLAVE_ARADDR_net_1;
wire   [7:0]  mAXI4_SLAVE_ARLEN_net_1;
wire   [2:0]  mAXI4_SLAVE_ARSIZE_net_1;
wire   [1:0]  mAXI4_SLAVE_ARBURST_net_1;
wire   [1:0]  mAXI4_SLAVE_ARLOCK_net_1;
wire   [3:0]  mAXI4_SLAVE_ARCACHE_net_1;
wire   [2:0]  mAXI4_SLAVE_ARPROT_net_1;
wire   [1:0]  AXI4Lite_Target_IF_BRESP_net_0;
wire   [31:0] AXI4Lite_Target_IF_RDATA_net_0;
wire   [1:0]  AXI4Lite_Target_IF_RRESP_net_0;
wire          AXI4L_VDMA_AWREADY_net_1;
wire          AXI4L_VDMA_WREADY_net_1;
wire   [1:0]  AXI4L_VDMA_BRESP_net_1;
wire          AXI4L_VDMA_BVALID_net_1;
wire          AXI4L_VDMA_ARREADY_net_1;
wire   [31:0] AXI4L_VDMA_RDATA_net_1;
wire   [1:0]  AXI4L_VDMA_RRESP_net_1;
wire          AXI4L_VDMA_RVALID_net_1;
wire   [15:0] DATA_I_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          VCC_net;
wire          GND_net;
wire   [15:10]DATA_I_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net            = 1'b1;
assign GND_net            = 1'b0;
assign DATA_I_const_net_0 = 6'h00;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign mAXI4_SLAVE_AWVALID_net_1        = mAXI4_SLAVE_AWVALID_net_0;
assign mAXI4_SLAVE_awvalid              = mAXI4_SLAVE_AWVALID_net_1;
assign mAXI4_SLAVE_WLAST_net_1          = mAXI4_SLAVE_WLAST_net_0;
assign mAXI4_SLAVE_wlast                = mAXI4_SLAVE_WLAST_net_1;
assign mAXI4_SLAVE_WVALID_net_1         = mAXI4_SLAVE_WVALID_net_0;
assign mAXI4_SLAVE_wvalid               = mAXI4_SLAVE_WVALID_net_1;
assign mAXI4_SLAVE_BREADY_net_1         = mAXI4_SLAVE_BREADY_net_0;
assign mAXI4_SLAVE_bready               = mAXI4_SLAVE_BREADY_net_1;
assign mAXI4_SLAVE_ARVALID_net_1        = mAXI4_SLAVE_ARVALID_net_0;
assign mAXI4_SLAVE_arvalid              = mAXI4_SLAVE_ARVALID_net_1;
assign mAXI4_SLAVE_RREADY_net_1         = mAXI4_SLAVE_RREADY_net_0;
assign mAXI4_SLAVE_rready               = mAXI4_SLAVE_RREADY_net_1;
assign AXI4Lite_Target_IF_AWREADY_net_0 = AXI4Lite_Target_IF_AWREADY;
assign AXI4Lite_Target_IF_AWREADY_O     = AXI4Lite_Target_IF_AWREADY_net_0;
assign AXI4Lite_Target_IF_WREADY_net_0  = AXI4Lite_Target_IF_WREADY;
assign AXI4Lite_Target_IF_WREADY_O      = AXI4Lite_Target_IF_WREADY_net_0;
assign AXI4Lite_Target_IF_BVALID_net_0  = AXI4Lite_Target_IF_BVALID;
assign AXI4Lite_Target_IF_BVALID_O      = AXI4Lite_Target_IF_BVALID_net_0;
assign AXI4Lite_Target_IF_ARREADY_net_0 = AXI4Lite_Target_IF_ARREADY;
assign AXI4Lite_Target_IF_ARREADY_O     = AXI4Lite_Target_IF_ARREADY_net_0;
assign AXI4Lite_Target_IF_RVALID_net_0  = AXI4Lite_Target_IF_RVALID;
assign AXI4Lite_Target_IF_RVALID_O      = AXI4Lite_Target_IF_RVALID_net_0;
assign INT_DMA_O_net_1                  = INT_DMA_O_net_0;
assign INT_DMA_O                        = INT_DMA_O_net_1;
assign MIPI_INTERRUPT_O_net_1           = MIPI_INTERRUPT_O_net_0;
assign MIPI_INTERRUPT_O                 = MIPI_INTERRUPT_O_net_1;
assign mAXI4_SLAVE_AWID_net_1           = mAXI4_SLAVE_AWID_net_0;
assign mAXI4_SLAVE_awid[3:0]            = mAXI4_SLAVE_AWID_net_1;
assign mAXI4_SLAVE_AWADDR_net_1         = mAXI4_SLAVE_AWADDR_net_0;
assign mAXI4_SLAVE_awaddr[37:0]         = mAXI4_SLAVE_AWADDR_net_1;
assign mAXI4_SLAVE_AWLEN_net_1          = mAXI4_SLAVE_AWLEN_net_0;
assign mAXI4_SLAVE_awlen[7:0]           = mAXI4_SLAVE_AWLEN_net_1;
assign mAXI4_SLAVE_AWSIZE_net_1         = mAXI4_SLAVE_AWSIZE_net_0;
assign mAXI4_SLAVE_awsize[2:0]          = mAXI4_SLAVE_AWSIZE_net_1;
assign mAXI4_SLAVE_AWBURST_net_1        = mAXI4_SLAVE_AWBURST_net_0;
assign mAXI4_SLAVE_awburst[1:0]         = mAXI4_SLAVE_AWBURST_net_1;
assign mAXI4_SLAVE_AWLOCK_net_1         = mAXI4_SLAVE_AWLOCK_net_0;
assign mAXI4_SLAVE_awlock[1:0]          = mAXI4_SLAVE_AWLOCK_net_1;
assign mAXI4_SLAVE_AWCACHE_net_1        = mAXI4_SLAVE_AWCACHE_net_0;
assign mAXI4_SLAVE_awcache[3:0]         = mAXI4_SLAVE_AWCACHE_net_1;
assign mAXI4_SLAVE_AWPROT_net_1         = mAXI4_SLAVE_AWPROT_net_0;
assign mAXI4_SLAVE_awprot[2:0]          = mAXI4_SLAVE_AWPROT_net_1;
assign mAXI4_SLAVE_WDATA_net_1          = mAXI4_SLAVE_WDATA_net_0;
assign mAXI4_SLAVE_wdata[63:0]          = mAXI4_SLAVE_WDATA_net_1;
assign mAXI4_SLAVE_WSTRB_net_1          = mAXI4_SLAVE_WSTRB_net_0;
assign mAXI4_SLAVE_wstrb[7:0]           = mAXI4_SLAVE_WSTRB_net_1;
assign mAXI4_SLAVE_ARID_net_1           = mAXI4_SLAVE_ARID_net_0;
assign mAXI4_SLAVE_arid[3:0]            = mAXI4_SLAVE_ARID_net_1;
assign mAXI4_SLAVE_ARADDR_net_1         = mAXI4_SLAVE_ARADDR_net_0;
assign mAXI4_SLAVE_araddr[37:0]         = mAXI4_SLAVE_ARADDR_net_1;
assign mAXI4_SLAVE_ARLEN_net_1          = mAXI4_SLAVE_ARLEN_net_0;
assign mAXI4_SLAVE_arlen[7:0]           = mAXI4_SLAVE_ARLEN_net_1;
assign mAXI4_SLAVE_ARSIZE_net_1         = mAXI4_SLAVE_ARSIZE_net_0;
assign mAXI4_SLAVE_arsize[2:0]          = mAXI4_SLAVE_ARSIZE_net_1;
assign mAXI4_SLAVE_ARBURST_net_1        = mAXI4_SLAVE_ARBURST_net_0;
assign mAXI4_SLAVE_arburst[1:0]         = mAXI4_SLAVE_ARBURST_net_1;
assign mAXI4_SLAVE_ARLOCK_net_1         = mAXI4_SLAVE_ARLOCK_net_0;
assign mAXI4_SLAVE_arlock[1:0]          = mAXI4_SLAVE_ARLOCK_net_1;
assign mAXI4_SLAVE_ARCACHE_net_1        = mAXI4_SLAVE_ARCACHE_net_0;
assign mAXI4_SLAVE_arcache[3:0]         = mAXI4_SLAVE_ARCACHE_net_1;
assign mAXI4_SLAVE_ARPROT_net_1         = mAXI4_SLAVE_ARPROT_net_0;
assign mAXI4_SLAVE_arprot[2:0]          = mAXI4_SLAVE_ARPROT_net_1;
assign AXI4Lite_Target_IF_BRESP_net_0   = AXI4Lite_Target_IF_BRESP;
assign AXI4Lite_Target_IF_BRESP_O[1:0]  = AXI4Lite_Target_IF_BRESP_net_0;
assign AXI4Lite_Target_IF_RDATA_net_0   = AXI4Lite_Target_IF_RDATA;
assign AXI4Lite_Target_IF_RDATA_O[31:0] = AXI4Lite_Target_IF_RDATA_net_0;
assign AXI4Lite_Target_IF_RRESP_net_0   = AXI4Lite_Target_IF_RRESP;
assign AXI4Lite_Target_IF_RRESP_O[1:0]  = AXI4Lite_Target_IF_RRESP_net_0;
assign AXI4L_VDMA_AWREADY_net_1         = AXI4L_VDMA_AWREADY_net_0;
assign AXI4L_VDMA_awready               = AXI4L_VDMA_AWREADY_net_1;
assign AXI4L_VDMA_WREADY_net_1          = AXI4L_VDMA_WREADY_net_0;
assign AXI4L_VDMA_wready                = AXI4L_VDMA_WREADY_net_1;
assign AXI4L_VDMA_BRESP_net_1           = AXI4L_VDMA_BRESP_net_0;
assign AXI4L_VDMA_bresp[1:0]            = AXI4L_VDMA_BRESP_net_1;
assign AXI4L_VDMA_BVALID_net_1          = AXI4L_VDMA_BVALID_net_0;
assign AXI4L_VDMA_bvalid                = AXI4L_VDMA_BVALID_net_1;
assign AXI4L_VDMA_ARREADY_net_1         = AXI4L_VDMA_ARREADY_net_0;
assign AXI4L_VDMA_arready               = AXI4L_VDMA_ARREADY_net_1;
assign AXI4L_VDMA_RDATA_net_1           = AXI4L_VDMA_RDATA_net_0;
assign AXI4L_VDMA_rdata[31:0]           = AXI4L_VDMA_RDATA_net_1;
assign AXI4L_VDMA_RRESP_net_1           = AXI4L_VDMA_RRESP_net_0;
assign AXI4L_VDMA_rresp[1:0]            = AXI4L_VDMA_RRESP_net_1;
assign AXI4L_VDMA_RVALID_net_1          = AXI4L_VDMA_RVALID_net_0;
assign AXI4L_VDMA_rvalid                = AXI4L_VDMA_RVALID_net_1;
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign DATA_I_net_0 = { 6'h00 , mipicsi2rxdecoderPF_C0_0_DATA_O };
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------mipicsi2rxdecoderPF_C0
mipicsi2rxdecoderPF_C0 mipicsi2rxdecoderPF_C0_0(
        // Inputs
        .CAM_CLOCK_I       ( PF_IOD_GENERIC_RX_C0_0_RX_CLK_G ),
        .PARALLEL_CLOCK_I  ( PF_CCC_C1_0_OUT0_FABCLK_0 ),
        .RESET_N_I         ( ARST_N ),
        .L0_LP_DATA_I      ( PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA ),
        .L0_LP_DATA_N_I    ( PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA_N ),
        .L1_LP_DATA_I      ( PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_0 ),
        .L1_LP_DATA_N_I    ( PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_N_0 ),
        .CAM_PLL_LOCK_I    ( PF_CCC_C1_0_PLL_LOCK_0 ),
        .TRAINING_DONE_I   ( PF_IOD_GENERIC_RX_C0_0_CLK_TRAIN_DONE ),
        .ACLK_I            ( ACLK_I ),
        .ARESETN_I         ( ARST_N ),
        .AWVALID_I         ( AXI4Lite_Target_IF_AWVALID_I ),
        .WVALID_I          ( AXI4Lite_Target_IF_WVALID_I ),
        .BREADY_I          ( AXI4Lite_Target_IF_BREADY_I ),
        .ARVALID_I         ( AXI4Lite_Target_IF_ARVALID_I ),
        .RREADY_I          ( AXI4Lite_Target_IF_RREADY_I ),
        .L0_HS_DATA_I      ( PF_IOD_GENERIC_RX_C0_0_L0_RXD_DATA ),
        .L1_HS_DATA_I      ( PF_IOD_GENERIC_RX_C0_0_L1_RXD_DATA_0 ),
        .AWADDR_I          ( AXI4Lite_Target_IF_AWADDR_I ),
        .WDATA_I           ( AXI4Lite_Target_IF_WDATA_I ),
        .ARADDR_I          ( AXI4Lite_Target_IF_ARADDR_I ),
        // Outputs
        .FRAME_VALID_O     (  ),
        .FRAME_START_O     ( mipicsi2rxdecoderPF_C0_0_FRAME_START_O ),
        .FRAME_END_O       (  ),
        .LINE_VALID_O      ( mipicsi2rxdecoderPF_C0_0_LINE_VALID_O ),
        .LINE_START_O      (  ),
        .LINE_END_O        (  ),
        .ECC_ERROR_O       (  ),
        .CRC_ERROR_O       (  ),
        .EBD_VALID_O       (  ),
        .MIPI_INTERRUPT_O  ( MIPI_INTERRUPT_O_net_0 ),
        .AWREADY_O         ( AXI4Lite_Target_IF_AWREADY ),
        .WREADY_O          ( AXI4Lite_Target_IF_WREADY ),
        .BVALID_O          ( AXI4Lite_Target_IF_BVALID ),
        .ARREADY_O         ( AXI4Lite_Target_IF_ARREADY ),
        .RVALID_O          ( AXI4Lite_Target_IF_RVALID ),
        .DATA_O            ( mipicsi2rxdecoderPF_C0_0_DATA_O ),
        .VIRTUAL_CHANNEL_O (  ),
        .DATA_TYPE_O       (  ),
        .WORD_COUNT_O      (  ),
        .BRESP_O           ( AXI4Lite_Target_IF_BRESP ),
        .RDATA_O           ( AXI4Lite_Target_IF_RDATA ),
        .RRESP_O           ( AXI4Lite_Target_IF_RRESP ) 
        );

//--------PF_CCC_C1
PF_CCC_C1 PF_CCC_C1_0(
        // Inputs
        .REF_CLK_0         ( PF_IOD_GENERIC_RX_C0_0_RX_CLK_G ),
        .PLL_POWERDOWN_N_0 ( VCC_net ),
        // Outputs
        .OUT0_FABCLK_0     ( PF_CCC_C1_0_OUT0_FABCLK_0 ),
        .PLL_LOCK_0        ( PF_CCC_C1_0_PLL_LOCK_0 ) 
        );

//--------PF_IOD_GENERIC_RX_C0
PF_IOD_GENERIC_RX_C0 PF_IOD_GENERIC_RX_C0_0(
        // Inputs
        .RX_CLK_P        ( RX_CLK_P ),
        .RX_CLK_N        ( RX_CLK_N ),
        .HS_SEL          ( VCC_net ),
        .ARST_N          ( ARST_N ),
        .HS_IO_CLK_PAUSE ( GND_net ),
        .RXD             ( RXD ),
        .RXD_N           ( RXD_N ),
        // Outputs
        .L0_LP_DATA      ( PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA ),
        .L0_LP_DATA_N    ( PF_IOD_GENERIC_RX_C0_0_L0_LP_DATA_N ),
        .L1_LP_DATA      ( PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_0 ),
        .L1_LP_DATA_N    ( PF_IOD_GENERIC_RX_C0_0_L1_LP_DATA_N_0 ),
        .RX_CLK_G        ( PF_IOD_GENERIC_RX_C0_0_RX_CLK_G ),
        .CLK_TRAIN_DONE  ( PF_IOD_GENERIC_RX_C0_0_CLK_TRAIN_DONE ),
        .CLK_TRAIN_ERROR (  ),
        .L0_RXD_DATA     ( PF_IOD_GENERIC_RX_C0_0_L0_RXD_DATA ),
        .L1_RXD_DATA     ( PF_IOD_GENERIC_RX_C0_0_L1_RXD_DATA_0 ) 
        );

//--------VDMA_C0
VDMA_C0 VDMA_C0_0(
        // Inputs
        .ACLK_I              ( ACLK_I ),
        .ARESETN_I           ( ARST_N ),
        .DDR_CLK_RSTN_I      ( ARST_N ),
        .DDR_CLK_I           ( DDR_CLK_I ),
        .VIDEO_CLK_RSTN_I    ( ARST_N ),
        .VIDEO_CLK_I         ( PF_CCC_C1_0_OUT0_FABCLK_0 ),
        .FRAME_START_I       ( mipicsi2rxdecoderPF_C0_0_FRAME_START_O ),
        .DDR_CTRL_READY_I    ( VCC_net ),
        .DATA_VALID_I        ( mipicsi2rxdecoderPF_C0_0_LINE_VALID_O ),
        .AXI4L_VDMA_awvalid  ( AXI4L_VDMA_awvalid ),
        .AXI4L_VDMA_wvalid   ( AXI4L_VDMA_wvalid ),
        .AXI4L_VDMA_bready   ( AXI4L_VDMA_bready ),
        .AXI4L_VDMA_arvalid  ( AXI4L_VDMA_arvalid ),
        .AXI4L_VDMA_rready   ( AXI4L_VDMA_rready ),
        .mAXI4_SLAVE_awready ( mAXI4_SLAVE_awready ),
        .mAXI4_SLAVE_wready  ( mAXI4_SLAVE_wready ),
        .mAXI4_SLAVE_bvalid  ( mAXI4_SLAVE_bvalid ),
        .mAXI4_SLAVE_arready ( mAXI4_SLAVE_arready ),
        .mAXI4_SLAVE_rvalid  ( mAXI4_SLAVE_rvalid ),
        .mAXI4_SLAVE_rlast   ( mAXI4_SLAVE_rlast ),
        .DATA_I              ( DATA_I_net_0 ),
        .AXI4L_VDMA_awaddr   ( AXI4L_VDMA_awaddr ),
        .AXI4L_VDMA_wdata    ( AXI4L_VDMA_wdata ),
        .AXI4L_VDMA_araddr   ( AXI4L_VDMA_araddr ),
        .mAXI4_SLAVE_bresp   ( mAXI4_SLAVE_bresp ),
        .mAXI4_SLAVE_rdata   ( mAXI4_SLAVE_rdata ),
        .mAXI4_SLAVE_rresp   ( mAXI4_SLAVE_rresp ),
        .mAXI4_SLAVE_bid     ( mAXI4_SLAVE_bid ),
        .mAXI4_SLAVE_rid     ( mAXI4_SLAVE_rid ),
        // Outputs
        .INT_DMA_O           ( INT_DMA_O_net_0 ),
        .AXI4L_VDMA_awready  ( AXI4L_VDMA_AWREADY_net_0 ),
        .AXI4L_VDMA_wready   ( AXI4L_VDMA_WREADY_net_0 ),
        .AXI4L_VDMA_bvalid   ( AXI4L_VDMA_BVALID_net_0 ),
        .AXI4L_VDMA_arready  ( AXI4L_VDMA_ARREADY_net_0 ),
        .AXI4L_VDMA_rvalid   ( AXI4L_VDMA_RVALID_net_0 ),
        .mAXI4_SLAVE_awvalid ( mAXI4_SLAVE_AWVALID_net_0 ),
        .mAXI4_SLAVE_wvalid  ( mAXI4_SLAVE_WVALID_net_0 ),
        .mAXI4_SLAVE_bready  ( mAXI4_SLAVE_BREADY_net_0 ),
        .mAXI4_SLAVE_arvalid ( mAXI4_SLAVE_ARVALID_net_0 ),
        .mAXI4_SLAVE_rready  ( mAXI4_SLAVE_RREADY_net_0 ),
        .mAXI4_SLAVE_wlast   ( mAXI4_SLAVE_WLAST_net_0 ),
        .AXI4L_VDMA_bresp    ( AXI4L_VDMA_BRESP_net_0 ),
        .AXI4L_VDMA_rdata    ( AXI4L_VDMA_RDATA_net_0 ),
        .AXI4L_VDMA_rresp    ( AXI4L_VDMA_RRESP_net_0 ),
        .mAXI4_SLAVE_awaddr  ( mAXI4_SLAVE_AWADDR_net_0 ),
        .mAXI4_SLAVE_awprot  ( mAXI4_SLAVE_AWPROT_net_0 ),
        .mAXI4_SLAVE_wdata   ( mAXI4_SLAVE_WDATA_net_0 ),
        .mAXI4_SLAVE_wstrb   ( mAXI4_SLAVE_WSTRB_net_0 ),
        .mAXI4_SLAVE_araddr  ( mAXI4_SLAVE_ARADDR_net_0 ),
        .mAXI4_SLAVE_arprot  ( mAXI4_SLAVE_ARPROT_net_0 ),
        .mAXI4_SLAVE_arburst ( mAXI4_SLAVE_ARBURST_net_0 ),
        .mAXI4_SLAVE_arcache ( mAXI4_SLAVE_ARCACHE_net_0 ),
        .mAXI4_SLAVE_arid    ( mAXI4_SLAVE_ARID_net_0 ),
        .mAXI4_SLAVE_arlen   ( mAXI4_SLAVE_ARLEN_net_0 ),
        .mAXI4_SLAVE_arlock  ( mAXI4_SLAVE_ARLOCK_net_0 ),
        .mAXI4_SLAVE_arsize  ( mAXI4_SLAVE_ARSIZE_net_0 ),
        .mAXI4_SLAVE_awburst ( mAXI4_SLAVE_AWBURST_net_0 ),
        .mAXI4_SLAVE_awcache ( mAXI4_SLAVE_AWCACHE_net_0 ),
        .mAXI4_SLAVE_awid    ( mAXI4_SLAVE_AWID_net_0 ),
        .mAXI4_SLAVE_awlen   ( mAXI4_SLAVE_AWLEN_net_0 ),
        .mAXI4_SLAVE_awlock  ( mAXI4_SLAVE_AWLOCK_net_0 ),
        .mAXI4_SLAVE_awsize  ( mAXI4_SLAVE_AWSIZE_net_0 ) 
        );


endmodule
