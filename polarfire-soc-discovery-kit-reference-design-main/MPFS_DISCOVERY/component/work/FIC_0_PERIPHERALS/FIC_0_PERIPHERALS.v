//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Apr  7 02:45:49 2026
// Version: 2025.2 2025.2.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// FIC_0_PERIPHERALS
module FIC_0_PERIPHERALS(
    // Inputs
    ACLK,
    ARESETN,
    AXI4mmaster0_MASTER0_ARADDR,
    AXI4mmaster0_MASTER0_ARBURST,
    AXI4mmaster0_MASTER0_ARCACHE,
    AXI4mmaster0_MASTER0_ARID,
    AXI4mmaster0_MASTER0_ARLEN,
    AXI4mmaster0_MASTER0_ARLOCK,
    AXI4mmaster0_MASTER0_ARPROT,
    AXI4mmaster0_MASTER0_ARQOS,
    AXI4mmaster0_MASTER0_ARREGION,
    AXI4mmaster0_MASTER0_ARSIZE,
    AXI4mmaster0_MASTER0_ARUSER,
    AXI4mmaster0_MASTER0_ARVALID,
    AXI4mmaster0_MASTER0_AWADDR,
    AXI4mmaster0_MASTER0_AWBURST,
    AXI4mmaster0_MASTER0_AWCACHE,
    AXI4mmaster0_MASTER0_AWID,
    AXI4mmaster0_MASTER0_AWLEN,
    AXI4mmaster0_MASTER0_AWLOCK,
    AXI4mmaster0_MASTER0_AWPROT,
    AXI4mmaster0_MASTER0_AWQOS,
    AXI4mmaster0_MASTER0_AWREGION,
    AXI4mmaster0_MASTER0_AWSIZE,
    AXI4mmaster0_MASTER0_AWUSER,
    AXI4mmaster0_MASTER0_AWVALID,
    AXI4mmaster0_MASTER0_BREADY,
    AXI4mmaster0_MASTER0_RREADY,
    AXI4mmaster0_MASTER0_WDATA,
    AXI4mmaster0_MASTER0_WLAST,
    AXI4mmaster0_MASTER0_WSTRB,
    AXI4mmaster0_MASTER0_WUSER,
    AXI4mmaster0_MASTER0_WVALID,
    AXI4mslave0_SLAVE0_ARREADY,
    AXI4mslave0_SLAVE0_AWREADY,
    AXI4mslave0_SLAVE0_BID,
    AXI4mslave0_SLAVE0_BRESP,
    AXI4mslave0_SLAVE0_BUSER,
    AXI4mslave0_SLAVE0_BVALID,
    AXI4mslave0_SLAVE0_RDATA,
    AXI4mslave0_SLAVE0_RID,
    AXI4mslave0_SLAVE0_RLAST,
    AXI4mslave0_SLAVE0_RRESP,
    AXI4mslave0_SLAVE0_RUSER,
    AXI4mslave0_SLAVE0_RVALID,
    AXI4mslave0_SLAVE0_WREADY,
    AXI4mslave3_SLAVE3_ARREADY,
    AXI4mslave3_SLAVE3_AWREADY,
    AXI4mslave3_SLAVE3_BID,
    AXI4mslave3_SLAVE3_BRESP,
    AXI4mslave3_SLAVE3_BUSER,
    AXI4mslave3_SLAVE3_BVALID,
    AXI4mslave3_SLAVE3_RDATA,
    AXI4mslave3_SLAVE3_RID,
    AXI4mslave3_SLAVE3_RLAST,
    AXI4mslave3_SLAVE3_RRESP,
    AXI4mslave3_SLAVE3_RUSER,
    AXI4mslave3_SLAVE3_RVALID,
    AXI4mslave3_SLAVE3_WREADY,
    AXI4mslave4_SLAVE4_ARREADY,
    AXI4mslave4_SLAVE4_AWREADY,
    AXI4mslave4_SLAVE4_BID,
    AXI4mslave4_SLAVE4_BRESP,
    AXI4mslave4_SLAVE4_BUSER,
    AXI4mslave4_SLAVE4_BVALID,
    AXI4mslave4_SLAVE4_RDATA,
    AXI4mslave4_SLAVE4_RID,
    AXI4mslave4_SLAVE4_RLAST,
    AXI4mslave4_SLAVE4_RRESP,
    AXI4mslave4_SLAVE4_RUSER,
    AXI4mslave4_SLAVE4_RVALID,
    AXI4mslave4_SLAVE4_WREADY,
    // Outputs
    AXI4mmaster0_MASTER0_ARREADY,
    AXI4mmaster0_MASTER0_AWREADY,
    AXI4mmaster0_MASTER0_BID,
    AXI4mmaster0_MASTER0_BRESP,
    AXI4mmaster0_MASTER0_BUSER,
    AXI4mmaster0_MASTER0_BVALID,
    AXI4mmaster0_MASTER0_RDATA,
    AXI4mmaster0_MASTER0_RID,
    AXI4mmaster0_MASTER0_RLAST,
    AXI4mmaster0_MASTER0_RRESP,
    AXI4mmaster0_MASTER0_RUSER,
    AXI4mmaster0_MASTER0_RVALID,
    AXI4mmaster0_MASTER0_WREADY,
    AXI4mslave0_SLAVE0_ARADDR,
    AXI4mslave0_SLAVE0_ARBURST,
    AXI4mslave0_SLAVE0_ARCACHE,
    AXI4mslave0_SLAVE0_ARID,
    AXI4mslave0_SLAVE0_ARLEN,
    AXI4mslave0_SLAVE0_ARLOCK,
    AXI4mslave0_SLAVE0_ARPROT,
    AXI4mslave0_SLAVE0_ARQOS,
    AXI4mslave0_SLAVE0_ARREGION,
    AXI4mslave0_SLAVE0_ARSIZE,
    AXI4mslave0_SLAVE0_ARUSER,
    AXI4mslave0_SLAVE0_ARVALID,
    AXI4mslave0_SLAVE0_AWADDR,
    AXI4mslave0_SLAVE0_AWBURST,
    AXI4mslave0_SLAVE0_AWCACHE,
    AXI4mslave0_SLAVE0_AWID,
    AXI4mslave0_SLAVE0_AWLEN,
    AXI4mslave0_SLAVE0_AWLOCK,
    AXI4mslave0_SLAVE0_AWPROT,
    AXI4mslave0_SLAVE0_AWQOS,
    AXI4mslave0_SLAVE0_AWREGION,
    AXI4mslave0_SLAVE0_AWSIZE,
    AXI4mslave0_SLAVE0_AWUSER,
    AXI4mslave0_SLAVE0_AWVALID,
    AXI4mslave0_SLAVE0_BREADY,
    AXI4mslave0_SLAVE0_RREADY,
    AXI4mslave0_SLAVE0_WDATA,
    AXI4mslave0_SLAVE0_WLAST,
    AXI4mslave0_SLAVE0_WSTRB,
    AXI4mslave0_SLAVE0_WUSER,
    AXI4mslave0_SLAVE0_WVALID,
    AXI4mslave3_SLAVE3_ARADDR,
    AXI4mslave3_SLAVE3_ARBURST,
    AXI4mslave3_SLAVE3_ARCACHE,
    AXI4mslave3_SLAVE3_ARID,
    AXI4mslave3_SLAVE3_ARLEN,
    AXI4mslave3_SLAVE3_ARLOCK,
    AXI4mslave3_SLAVE3_ARPROT,
    AXI4mslave3_SLAVE3_ARQOS,
    AXI4mslave3_SLAVE3_ARREGION,
    AXI4mslave3_SLAVE3_ARSIZE,
    AXI4mslave3_SLAVE3_ARUSER,
    AXI4mslave3_SLAVE3_ARVALID,
    AXI4mslave3_SLAVE3_AWADDR,
    AXI4mslave3_SLAVE3_AWBURST,
    AXI4mslave3_SLAVE3_AWCACHE,
    AXI4mslave3_SLAVE3_AWID,
    AXI4mslave3_SLAVE3_AWLEN,
    AXI4mslave3_SLAVE3_AWLOCK,
    AXI4mslave3_SLAVE3_AWPROT,
    AXI4mslave3_SLAVE3_AWQOS,
    AXI4mslave3_SLAVE3_AWREGION,
    AXI4mslave3_SLAVE3_AWSIZE,
    AXI4mslave3_SLAVE3_AWUSER,
    AXI4mslave3_SLAVE3_AWVALID,
    AXI4mslave3_SLAVE3_BREADY,
    AXI4mslave3_SLAVE3_RREADY,
    AXI4mslave3_SLAVE3_WDATA,
    AXI4mslave3_SLAVE3_WLAST,
    AXI4mslave3_SLAVE3_WSTRB,
    AXI4mslave3_SLAVE3_WUSER,
    AXI4mslave3_SLAVE3_WVALID,
    AXI4mslave4_SLAVE4_ARADDR,
    AXI4mslave4_SLAVE4_ARBURST,
    AXI4mslave4_SLAVE4_ARCACHE,
    AXI4mslave4_SLAVE4_ARID,
    AXI4mslave4_SLAVE4_ARLEN,
    AXI4mslave4_SLAVE4_ARLOCK,
    AXI4mslave4_SLAVE4_ARPROT,
    AXI4mslave4_SLAVE4_ARQOS,
    AXI4mslave4_SLAVE4_ARREGION,
    AXI4mslave4_SLAVE4_ARSIZE,
    AXI4mslave4_SLAVE4_ARUSER,
    AXI4mslave4_SLAVE4_ARVALID,
    AXI4mslave4_SLAVE4_AWADDR,
    AXI4mslave4_SLAVE4_AWBURST,
    AXI4mslave4_SLAVE4_AWCACHE,
    AXI4mslave4_SLAVE4_AWID,
    AXI4mslave4_SLAVE4_AWLEN,
    AXI4mslave4_SLAVE4_AWLOCK,
    AXI4mslave4_SLAVE4_AWPROT,
    AXI4mslave4_SLAVE4_AWQOS,
    AXI4mslave4_SLAVE4_AWREGION,
    AXI4mslave4_SLAVE4_AWSIZE,
    AXI4mslave4_SLAVE4_AWUSER,
    AXI4mslave4_SLAVE4_AWVALID,
    AXI4mslave4_SLAVE4_BREADY,
    AXI4mslave4_SLAVE4_RREADY,
    AXI4mslave4_SLAVE4_WDATA,
    AXI4mslave4_SLAVE4_WLAST,
    AXI4mslave4_SLAVE4_WSTRB,
    AXI4mslave4_SLAVE4_WUSER,
    AXI4mslave4_SLAVE4_WVALID,
    DMA_CONTROLLER_IRQ
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         ACLK;
input         ARESETN;
input  [37:0] AXI4mmaster0_MASTER0_ARADDR;
input  [1:0]  AXI4mmaster0_MASTER0_ARBURST;
input  [3:0]  AXI4mmaster0_MASTER0_ARCACHE;
input  [7:0]  AXI4mmaster0_MASTER0_ARID;
input  [7:0]  AXI4mmaster0_MASTER0_ARLEN;
input  [1:0]  AXI4mmaster0_MASTER0_ARLOCK;
input  [2:0]  AXI4mmaster0_MASTER0_ARPROT;
input  [3:0]  AXI4mmaster0_MASTER0_ARQOS;
input  [3:0]  AXI4mmaster0_MASTER0_ARREGION;
input  [2:0]  AXI4mmaster0_MASTER0_ARSIZE;
input  [0:0]  AXI4mmaster0_MASTER0_ARUSER;
input         AXI4mmaster0_MASTER0_ARVALID;
input  [37:0] AXI4mmaster0_MASTER0_AWADDR;
input  [1:0]  AXI4mmaster0_MASTER0_AWBURST;
input  [3:0]  AXI4mmaster0_MASTER0_AWCACHE;
input  [7:0]  AXI4mmaster0_MASTER0_AWID;
input  [7:0]  AXI4mmaster0_MASTER0_AWLEN;
input  [1:0]  AXI4mmaster0_MASTER0_AWLOCK;
input  [2:0]  AXI4mmaster0_MASTER0_AWPROT;
input  [3:0]  AXI4mmaster0_MASTER0_AWQOS;
input  [3:0]  AXI4mmaster0_MASTER0_AWREGION;
input  [2:0]  AXI4mmaster0_MASTER0_AWSIZE;
input  [0:0]  AXI4mmaster0_MASTER0_AWUSER;
input         AXI4mmaster0_MASTER0_AWVALID;
input         AXI4mmaster0_MASTER0_BREADY;
input         AXI4mmaster0_MASTER0_RREADY;
input  [63:0] AXI4mmaster0_MASTER0_WDATA;
input         AXI4mmaster0_MASTER0_WLAST;
input  [7:0]  AXI4mmaster0_MASTER0_WSTRB;
input  [0:0]  AXI4mmaster0_MASTER0_WUSER;
input         AXI4mmaster0_MASTER0_WVALID;
input         AXI4mslave0_SLAVE0_ARREADY;
input         AXI4mslave0_SLAVE0_AWREADY;
input  [8:0]  AXI4mslave0_SLAVE0_BID;
input  [1:0]  AXI4mslave0_SLAVE0_BRESP;
input  [0:0]  AXI4mslave0_SLAVE0_BUSER;
input         AXI4mslave0_SLAVE0_BVALID;
input  [63:0] AXI4mslave0_SLAVE0_RDATA;
input  [8:0]  AXI4mslave0_SLAVE0_RID;
input         AXI4mslave0_SLAVE0_RLAST;
input  [1:0]  AXI4mslave0_SLAVE0_RRESP;
input  [0:0]  AXI4mslave0_SLAVE0_RUSER;
input         AXI4mslave0_SLAVE0_RVALID;
input         AXI4mslave0_SLAVE0_WREADY;
input         AXI4mslave3_SLAVE3_ARREADY;
input         AXI4mslave3_SLAVE3_AWREADY;
input  [8:0]  AXI4mslave3_SLAVE3_BID;
input  [1:0]  AXI4mslave3_SLAVE3_BRESP;
input  [0:0]  AXI4mslave3_SLAVE3_BUSER;
input         AXI4mslave3_SLAVE3_BVALID;
input  [31:0] AXI4mslave3_SLAVE3_RDATA;
input  [8:0]  AXI4mslave3_SLAVE3_RID;
input         AXI4mslave3_SLAVE3_RLAST;
input  [1:0]  AXI4mslave3_SLAVE3_RRESP;
input  [0:0]  AXI4mslave3_SLAVE3_RUSER;
input         AXI4mslave3_SLAVE3_RVALID;
input         AXI4mslave3_SLAVE3_WREADY;
input         AXI4mslave4_SLAVE4_ARREADY;
input         AXI4mslave4_SLAVE4_AWREADY;
input  [8:0]  AXI4mslave4_SLAVE4_BID;
input  [1:0]  AXI4mslave4_SLAVE4_BRESP;
input  [0:0]  AXI4mslave4_SLAVE4_BUSER;
input         AXI4mslave4_SLAVE4_BVALID;
input  [31:0] AXI4mslave4_SLAVE4_RDATA;
input  [8:0]  AXI4mslave4_SLAVE4_RID;
input         AXI4mslave4_SLAVE4_RLAST;
input  [1:0]  AXI4mslave4_SLAVE4_RRESP;
input  [0:0]  AXI4mslave4_SLAVE4_RUSER;
input         AXI4mslave4_SLAVE4_RVALID;
input         AXI4mslave4_SLAVE4_WREADY;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        AXI4mmaster0_MASTER0_ARREADY;
output        AXI4mmaster0_MASTER0_AWREADY;
output [7:0]  AXI4mmaster0_MASTER0_BID;
output [1:0]  AXI4mmaster0_MASTER0_BRESP;
output [0:0]  AXI4mmaster0_MASTER0_BUSER;
output        AXI4mmaster0_MASTER0_BVALID;
output [63:0] AXI4mmaster0_MASTER0_RDATA;
output [7:0]  AXI4mmaster0_MASTER0_RID;
output        AXI4mmaster0_MASTER0_RLAST;
output [1:0]  AXI4mmaster0_MASTER0_RRESP;
output [0:0]  AXI4mmaster0_MASTER0_RUSER;
output        AXI4mmaster0_MASTER0_RVALID;
output        AXI4mmaster0_MASTER0_WREADY;
output [31:0] AXI4mslave0_SLAVE0_ARADDR;
output [1:0]  AXI4mslave0_SLAVE0_ARBURST;
output [3:0]  AXI4mslave0_SLAVE0_ARCACHE;
output [8:0]  AXI4mslave0_SLAVE0_ARID;
output [7:0]  AXI4mslave0_SLAVE0_ARLEN;
output [1:0]  AXI4mslave0_SLAVE0_ARLOCK;
output [2:0]  AXI4mslave0_SLAVE0_ARPROT;
output [3:0]  AXI4mslave0_SLAVE0_ARQOS;
output [3:0]  AXI4mslave0_SLAVE0_ARREGION;
output [2:0]  AXI4mslave0_SLAVE0_ARSIZE;
output [0:0]  AXI4mslave0_SLAVE0_ARUSER;
output        AXI4mslave0_SLAVE0_ARVALID;
output [31:0] AXI4mslave0_SLAVE0_AWADDR;
output [1:0]  AXI4mslave0_SLAVE0_AWBURST;
output [3:0]  AXI4mslave0_SLAVE0_AWCACHE;
output [8:0]  AXI4mslave0_SLAVE0_AWID;
output [7:0]  AXI4mslave0_SLAVE0_AWLEN;
output [1:0]  AXI4mslave0_SLAVE0_AWLOCK;
output [2:0]  AXI4mslave0_SLAVE0_AWPROT;
output [3:0]  AXI4mslave0_SLAVE0_AWQOS;
output [3:0]  AXI4mslave0_SLAVE0_AWREGION;
output [2:0]  AXI4mslave0_SLAVE0_AWSIZE;
output [0:0]  AXI4mslave0_SLAVE0_AWUSER;
output        AXI4mslave0_SLAVE0_AWVALID;
output        AXI4mslave0_SLAVE0_BREADY;
output        AXI4mslave0_SLAVE0_RREADY;
output [63:0] AXI4mslave0_SLAVE0_WDATA;
output        AXI4mslave0_SLAVE0_WLAST;
output [7:0]  AXI4mslave0_SLAVE0_WSTRB;
output [0:0]  AXI4mslave0_SLAVE0_WUSER;
output        AXI4mslave0_SLAVE0_WVALID;
output [37:0] AXI4mslave3_SLAVE3_ARADDR;
output [1:0]  AXI4mslave3_SLAVE3_ARBURST;
output [3:0]  AXI4mslave3_SLAVE3_ARCACHE;
output [8:0]  AXI4mslave3_SLAVE3_ARID;
output [7:0]  AXI4mslave3_SLAVE3_ARLEN;
output [1:0]  AXI4mslave3_SLAVE3_ARLOCK;
output [2:0]  AXI4mslave3_SLAVE3_ARPROT;
output [3:0]  AXI4mslave3_SLAVE3_ARQOS;
output [3:0]  AXI4mslave3_SLAVE3_ARREGION;
output [2:0]  AXI4mslave3_SLAVE3_ARSIZE;
output [0:0]  AXI4mslave3_SLAVE3_ARUSER;
output        AXI4mslave3_SLAVE3_ARVALID;
output [37:0] AXI4mslave3_SLAVE3_AWADDR;
output [1:0]  AXI4mslave3_SLAVE3_AWBURST;
output [3:0]  AXI4mslave3_SLAVE3_AWCACHE;
output [8:0]  AXI4mslave3_SLAVE3_AWID;
output [7:0]  AXI4mslave3_SLAVE3_AWLEN;
output [1:0]  AXI4mslave3_SLAVE3_AWLOCK;
output [2:0]  AXI4mslave3_SLAVE3_AWPROT;
output [3:0]  AXI4mslave3_SLAVE3_AWQOS;
output [3:0]  AXI4mslave3_SLAVE3_AWREGION;
output [2:0]  AXI4mslave3_SLAVE3_AWSIZE;
output [0:0]  AXI4mslave3_SLAVE3_AWUSER;
output        AXI4mslave3_SLAVE3_AWVALID;
output        AXI4mslave3_SLAVE3_BREADY;
output        AXI4mslave3_SLAVE3_RREADY;
output [31:0] AXI4mslave3_SLAVE3_WDATA;
output        AXI4mslave3_SLAVE3_WLAST;
output [3:0]  AXI4mslave3_SLAVE3_WSTRB;
output [0:0]  AXI4mslave3_SLAVE3_WUSER;
output        AXI4mslave3_SLAVE3_WVALID;
output [37:0] AXI4mslave4_SLAVE4_ARADDR;
output [1:0]  AXI4mslave4_SLAVE4_ARBURST;
output [3:0]  AXI4mslave4_SLAVE4_ARCACHE;
output [8:0]  AXI4mslave4_SLAVE4_ARID;
output [7:0]  AXI4mslave4_SLAVE4_ARLEN;
output [1:0]  AXI4mslave4_SLAVE4_ARLOCK;
output [2:0]  AXI4mslave4_SLAVE4_ARPROT;
output [3:0]  AXI4mslave4_SLAVE4_ARQOS;
output [3:0]  AXI4mslave4_SLAVE4_ARREGION;
output [2:0]  AXI4mslave4_SLAVE4_ARSIZE;
output [0:0]  AXI4mslave4_SLAVE4_ARUSER;
output        AXI4mslave4_SLAVE4_ARVALID;
output [37:0] AXI4mslave4_SLAVE4_AWADDR;
output [1:0]  AXI4mslave4_SLAVE4_AWBURST;
output [3:0]  AXI4mslave4_SLAVE4_AWCACHE;
output [8:0]  AXI4mslave4_SLAVE4_AWID;
output [7:0]  AXI4mslave4_SLAVE4_AWLEN;
output [1:0]  AXI4mslave4_SLAVE4_AWLOCK;
output [2:0]  AXI4mslave4_SLAVE4_AWPROT;
output [3:0]  AXI4mslave4_SLAVE4_AWQOS;
output [3:0]  AXI4mslave4_SLAVE4_AWREGION;
output [2:0]  AXI4mslave4_SLAVE4_AWSIZE;
output [0:0]  AXI4mslave4_SLAVE4_AWUSER;
output        AXI4mslave4_SLAVE4_AWVALID;
output        AXI4mslave4_SLAVE4_BREADY;
output        AXI4mslave4_SLAVE4_RREADY;
output [31:0] AXI4mslave4_SLAVE4_WDATA;
output        AXI4mslave4_SLAVE4_WLAST;
output [3:0]  AXI4mslave4_SLAVE4_WSTRB;
output [0:0]  AXI4mslave4_SLAVE4_WUSER;
output        AXI4mslave4_SLAVE4_WVALID;
output        DMA_CONTROLLER_IRQ;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          ACLK;
wire          ARESETN;
wire   [37:0] AXI4mmaster0_MASTER0_ARADDR;
wire   [1:0]  AXI4mmaster0_MASTER0_ARBURST;
wire   [3:0]  AXI4mmaster0_MASTER0_ARCACHE;
wire   [7:0]  AXI4mmaster0_MASTER0_ARID;
wire   [7:0]  AXI4mmaster0_MASTER0_ARLEN;
wire   [1:0]  AXI4mmaster0_MASTER0_ARLOCK;
wire   [2:0]  AXI4mmaster0_MASTER0_ARPROT;
wire   [3:0]  AXI4mmaster0_MASTER0_ARQOS;
wire          AXI4mmaster0_ARREADY;
wire   [3:0]  AXI4mmaster0_MASTER0_ARREGION;
wire   [2:0]  AXI4mmaster0_MASTER0_ARSIZE;
wire   [0:0]  AXI4mmaster0_MASTER0_ARUSER;
wire          AXI4mmaster0_MASTER0_ARVALID;
wire   [37:0] AXI4mmaster0_MASTER0_AWADDR;
wire   [1:0]  AXI4mmaster0_MASTER0_AWBURST;
wire   [3:0]  AXI4mmaster0_MASTER0_AWCACHE;
wire   [7:0]  AXI4mmaster0_MASTER0_AWID;
wire   [7:0]  AXI4mmaster0_MASTER0_AWLEN;
wire   [1:0]  AXI4mmaster0_MASTER0_AWLOCK;
wire   [2:0]  AXI4mmaster0_MASTER0_AWPROT;
wire   [3:0]  AXI4mmaster0_MASTER0_AWQOS;
wire          AXI4mmaster0_AWREADY;
wire   [3:0]  AXI4mmaster0_MASTER0_AWREGION;
wire   [2:0]  AXI4mmaster0_MASTER0_AWSIZE;
wire   [0:0]  AXI4mmaster0_MASTER0_AWUSER;
wire          AXI4mmaster0_MASTER0_AWVALID;
wire   [7:0]  AXI4mmaster0_BID;
wire          AXI4mmaster0_MASTER0_BREADY;
wire   [1:0]  AXI4mmaster0_BRESP;
wire   [0:0]  AXI4mmaster0_BUSER;
wire          AXI4mmaster0_BVALID;
wire   [63:0] AXI4mmaster0_RDATA;
wire   [7:0]  AXI4mmaster0_RID;
wire          AXI4mmaster0_RLAST;
wire          AXI4mmaster0_MASTER0_RREADY;
wire   [1:0]  AXI4mmaster0_RRESP;
wire   [0:0]  AXI4mmaster0_RUSER;
wire          AXI4mmaster0_RVALID;
wire   [63:0] AXI4mmaster0_MASTER0_WDATA;
wire          AXI4mmaster0_MASTER0_WLAST;
wire          AXI4mmaster0_WREADY;
wire   [7:0]  AXI4mmaster0_MASTER0_WSTRB;
wire   [0:0]  AXI4mmaster0_MASTER0_WUSER;
wire          AXI4mmaster0_MASTER0_WVALID;
wire   [31:0] AXI4mslave0_ARADDR;
wire   [1:0]  AXI4mslave0_ARBURST;
wire   [3:0]  AXI4mslave0_ARCACHE;
wire   [8:0]  AXI4mslave0_ARID;
wire   [7:0]  AXI4mslave0_ARLEN;
wire   [1:0]  AXI4mslave0_ARLOCK;
wire   [2:0]  AXI4mslave0_ARPROT;
wire   [3:0]  AXI4mslave0_ARQOS;
wire          AXI4mslave0_SLAVE0_ARREADY;
wire   [3:0]  AXI4mslave0_ARREGION;
wire   [2:0]  AXI4mslave0_ARSIZE;
wire   [0:0]  AXI4mslave0_ARUSER;
wire          AXI4mslave0_ARVALID;
wire   [31:0] AXI4mslave0_AWADDR;
wire   [1:0]  AXI4mslave0_AWBURST;
wire   [3:0]  AXI4mslave0_AWCACHE;
wire   [8:0]  AXI4mslave0_AWID;
wire   [7:0]  AXI4mslave0_AWLEN;
wire   [1:0]  AXI4mslave0_AWLOCK;
wire   [2:0]  AXI4mslave0_AWPROT;
wire   [3:0]  AXI4mslave0_AWQOS;
wire          AXI4mslave0_SLAVE0_AWREADY;
wire   [3:0]  AXI4mslave0_AWREGION;
wire   [2:0]  AXI4mslave0_AWSIZE;
wire   [0:0]  AXI4mslave0_AWUSER;
wire          AXI4mslave0_AWVALID;
wire   [8:0]  AXI4mslave0_SLAVE0_BID;
wire          AXI4mslave0_BREADY;
wire   [1:0]  AXI4mslave0_SLAVE0_BRESP;
wire   [0:0]  AXI4mslave0_SLAVE0_BUSER;
wire          AXI4mslave0_SLAVE0_BVALID;
wire   [63:0] AXI4mslave0_SLAVE0_RDATA;
wire   [8:0]  AXI4mslave0_SLAVE0_RID;
wire          AXI4mslave0_SLAVE0_RLAST;
wire          AXI4mslave0_RREADY;
wire   [1:0]  AXI4mslave0_SLAVE0_RRESP;
wire   [0:0]  AXI4mslave0_SLAVE0_RUSER;
wire          AXI4mslave0_SLAVE0_RVALID;
wire   [63:0] AXI4mslave0_WDATA;
wire          AXI4mslave0_WLAST;
wire          AXI4mslave0_SLAVE0_WREADY;
wire   [7:0]  AXI4mslave0_WSTRB;
wire   [0:0]  AXI4mslave0_WUSER;
wire          AXI4mslave0_WVALID;
wire   [37:0] AXI4mslave3_0_ARADDR;
wire   [1:0]  AXI4mslave3_0_ARBURST;
wire   [3:0]  AXI4mslave3_0_ARCACHE;
wire   [8:0]  AXI4mslave3_0_ARID;
wire   [7:0]  AXI4mslave3_0_ARLEN;
wire   [1:0]  AXI4mslave3_0_ARLOCK;
wire   [2:0]  AXI4mslave3_0_ARPROT;
wire   [3:0]  AXI4mslave3_0_ARQOS;
wire          AXI4mslave3_SLAVE3_ARREADY;
wire   [3:0]  AXI4mslave3_0_ARREGION;
wire   [2:0]  AXI4mslave3_0_ARSIZE;
wire   [0:0]  AXI4mslave3_0_ARUSER;
wire          AXI4mslave3_0_ARVALID;
wire   [37:0] AXI4mslave3_0_AWADDR;
wire   [1:0]  AXI4mslave3_0_AWBURST;
wire   [3:0]  AXI4mslave3_0_AWCACHE;
wire   [8:0]  AXI4mslave3_0_AWID;
wire   [7:0]  AXI4mslave3_0_AWLEN;
wire   [1:0]  AXI4mslave3_0_AWLOCK;
wire   [2:0]  AXI4mslave3_0_AWPROT;
wire   [3:0]  AXI4mslave3_0_AWQOS;
wire          AXI4mslave3_SLAVE3_AWREADY;
wire   [3:0]  AXI4mslave3_0_AWREGION;
wire   [2:0]  AXI4mslave3_0_AWSIZE;
wire   [0:0]  AXI4mslave3_0_AWUSER;
wire          AXI4mslave3_0_AWVALID;
wire   [8:0]  AXI4mslave3_SLAVE3_BID;
wire          AXI4mslave3_0_BREADY;
wire   [1:0]  AXI4mslave3_SLAVE3_BRESP;
wire   [0:0]  AXI4mslave3_SLAVE3_BUSER;
wire          AXI4mslave3_SLAVE3_BVALID;
wire   [31:0] AXI4mslave3_SLAVE3_RDATA;
wire   [8:0]  AXI4mslave3_SLAVE3_RID;
wire          AXI4mslave3_SLAVE3_RLAST;
wire          AXI4mslave3_0_RREADY;
wire   [1:0]  AXI4mslave3_SLAVE3_RRESP;
wire   [0:0]  AXI4mslave3_SLAVE3_RUSER;
wire          AXI4mslave3_SLAVE3_RVALID;
wire   [31:0] AXI4mslave3_0_WDATA;
wire          AXI4mslave3_0_WLAST;
wire          AXI4mslave3_SLAVE3_WREADY;
wire   [3:0]  AXI4mslave3_0_WSTRB;
wire   [0:0]  AXI4mslave3_0_WUSER;
wire          AXI4mslave3_0_WVALID;
wire   [37:0] AXI4mslave4_0_ARADDR;
wire   [1:0]  AXI4mslave4_0_ARBURST;
wire   [3:0]  AXI4mslave4_0_ARCACHE;
wire   [8:0]  AXI4mslave4_0_ARID;
wire   [7:0]  AXI4mslave4_0_ARLEN;
wire   [1:0]  AXI4mslave4_0_ARLOCK;
wire   [2:0]  AXI4mslave4_0_ARPROT;
wire   [3:0]  AXI4mslave4_0_ARQOS;
wire          AXI4mslave4_SLAVE4_ARREADY;
wire   [3:0]  AXI4mslave4_0_ARREGION;
wire   [2:0]  AXI4mslave4_0_ARSIZE;
wire   [0:0]  AXI4mslave4_0_ARUSER;
wire          AXI4mslave4_0_ARVALID;
wire   [37:0] AXI4mslave4_0_AWADDR;
wire   [1:0]  AXI4mslave4_0_AWBURST;
wire   [3:0]  AXI4mslave4_0_AWCACHE;
wire   [8:0]  AXI4mslave4_0_AWID;
wire   [7:0]  AXI4mslave4_0_AWLEN;
wire   [1:0]  AXI4mslave4_0_AWLOCK;
wire   [2:0]  AXI4mslave4_0_AWPROT;
wire   [3:0]  AXI4mslave4_0_AWQOS;
wire          AXI4mslave4_SLAVE4_AWREADY;
wire   [3:0]  AXI4mslave4_0_AWREGION;
wire   [2:0]  AXI4mslave4_0_AWSIZE;
wire   [0:0]  AXI4mslave4_0_AWUSER;
wire          AXI4mslave4_0_AWVALID;
wire   [8:0]  AXI4mslave4_SLAVE4_BID;
wire          AXI4mslave4_0_BREADY;
wire   [1:0]  AXI4mslave4_SLAVE4_BRESP;
wire   [0:0]  AXI4mslave4_SLAVE4_BUSER;
wire          AXI4mslave4_SLAVE4_BVALID;
wire   [31:0] AXI4mslave4_SLAVE4_RDATA;
wire   [8:0]  AXI4mslave4_SLAVE4_RID;
wire          AXI4mslave4_SLAVE4_RLAST;
wire          AXI4mslave4_0_RREADY;
wire   [1:0]  AXI4mslave4_SLAVE4_RRESP;
wire   [0:0]  AXI4mslave4_SLAVE4_RUSER;
wire          AXI4mslave4_SLAVE4_RVALID;
wire   [31:0] AXI4mslave4_0_WDATA;
wire          AXI4mslave4_0_WLAST;
wire          AXI4mslave4_SLAVE4_WREADY;
wire   [3:0]  AXI4mslave4_0_WSTRB;
wire   [0:0]  AXI4mslave4_0_WUSER;
wire          AXI4mslave4_0_WVALID;
wire   [31:0] DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARADDR;
wire   [1:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARBURST;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARID;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARLEN;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARREADY;
wire   [2:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARSIZE;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARVALID;
wire   [31:0] DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWADDR;
wire   [1:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWBURST;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWID;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWLEN;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWREADY;
wire   [2:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWSIZE;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWVALID;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_BID;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_BREADY;
wire   [1:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_BRESP;
wire   [0:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_BUSER;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_BVALID;
wire   [31:0] DMA_CONTROLLER_AXI4InitiatorDMA_IF_RDATA;
wire   [7:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_RID;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_RLAST;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_RREADY;
wire   [1:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_RRESP;
wire   [0:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_RUSER;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_RVALID;
wire   [31:0] DMA_CONTROLLER_AXI4InitiatorDMA_IF_WDATA;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_WLAST;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_WREADY;
wire   [3:0]  DMA_CONTROLLER_AXI4InitiatorDMA_IF_WSTRB;
wire          DMA_CONTROLLER_AXI4InitiatorDMA_IF_WVALID;
wire   [0:0]  DMA_CONTROLLER_IRQ_net_0;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_ARBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARCACHE;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_ARID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave0_ARLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_ARLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_ARPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARQOS;
wire          FIC0_INITIATOR_AXI4mslave0_ARREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_ARREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_ARSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_ARUSER;
wire          FIC0_INITIATOR_AXI4mslave0_ARVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_AWBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWCACHE;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave0_AWID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave0_AWLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_AWLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_AWPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWQOS;
wire          FIC0_INITIATOR_AXI4mslave0_AWREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_AWREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave0_AWSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_AWUSER;
wire          FIC0_INITIATOR_AXI4mslave0_AWVALID;
wire          FIC0_INITIATOR_AXI4mslave0_BREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_BRESP;
wire          FIC0_INITIATOR_AXI4mslave0_BVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_RDATA;
wire          FIC0_INITIATOR_AXI4mslave0_RREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave0_RRESP;
wire          FIC0_INITIATOR_AXI4mslave0_RVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave0_WDATA;
wire          FIC0_INITIATOR_AXI4mslave0_WLAST;
wire          FIC0_INITIATOR_AXI4mslave0_WREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave0_WSTRB;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave0_WUSER;
wire          FIC0_INITIATOR_AXI4mslave0_WVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_ARBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_ARCACHE;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_ARLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_ARLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave1_ARPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_ARQOS;
wire          FIC0_INITIATOR_AXI4mslave1_ARREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_ARREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave1_ARSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave1_ARUSER;
wire          FIC0_INITIATOR_AXI4mslave1_ARVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_AWBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_AWCACHE;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_AWLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_AWLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave1_AWPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_AWQOS;
wire          FIC0_INITIATOR_AXI4mslave1_AWREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave1_AWREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave1_AWSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave1_AWUSER;
wire          FIC0_INITIATOR_AXI4mslave1_AWVALID;
wire          FIC0_INITIATOR_AXI4mslave1_BREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_BRESP;
wire          FIC0_INITIATOR_AXI4mslave1_BVALID;
wire   [63:0] FIC0_INITIATOR_AXI4mslave1_RDATA;
wire          FIC0_INITIATOR_AXI4mslave1_RLAST;
wire          FIC0_INITIATOR_AXI4mslave1_RREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave1_RRESP;
wire          FIC0_INITIATOR_AXI4mslave1_RVALID;
wire   [63:0] FIC0_INITIATOR_AXI4mslave1_WDATA;
wire          FIC0_INITIATOR_AXI4mslave1_WLAST;
wire          FIC0_INITIATOR_AXI4mslave1_WREADY;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_WSTRB;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave1_WUSER;
wire          FIC0_INITIATOR_AXI4mslave1_WVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_ARBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_ARCACHE;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave2_0_ARID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave2_0_ARLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_ARLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave2_0_ARPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_ARQOS;
wire          FIC0_INITIATOR_AXI4mslave2_0_ARREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_ARREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave2_0_ARSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave2_0_ARUSER;
wire          FIC0_INITIATOR_AXI4mslave2_0_ARVALID;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_AWBURST;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_AWCACHE;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave2_0_AWID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave2_0_AWLEN;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_AWLOCK;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave2_0_AWPROT;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_AWQOS;
wire          FIC0_INITIATOR_AXI4mslave2_0_AWREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_AWREGION;
wire   [2:0]  FIC0_INITIATOR_AXI4mslave2_0_AWSIZE;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave2_0_AWUSER;
wire          FIC0_INITIATOR_AXI4mslave2_0_AWVALID;
wire          FIC0_INITIATOR_AXI4mslave2_0_BREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_BRESP;
wire          FIC0_INITIATOR_AXI4mslave2_0_BVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_RDATA;
wire          FIC0_INITIATOR_AXI4mslave2_0_RREADY;
wire   [1:0]  FIC0_INITIATOR_AXI4mslave2_0_RRESP;
wire          FIC0_INITIATOR_AXI4mslave2_0_RVALID;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_WDATA;
wire          FIC0_INITIATOR_AXI4mslave2_0_WLAST;
wire          FIC0_INITIATOR_AXI4mslave2_0_WREADY;
wire   [3:0]  FIC0_INITIATOR_AXI4mslave2_0_WSTRB;
wire   [0:0]  FIC0_INITIATOR_AXI4mslave2_0_WUSER;
wire          FIC0_INITIATOR_AXI4mslave2_0_WVALID;
wire          DMA_CONTROLLER_IRQ_net_1;
wire          AXI4mslave0_AWVALID_net_0;
wire          AXI4mslave0_WLAST_net_0;
wire          AXI4mslave0_WVALID_net_0;
wire          AXI4mslave0_BREADY_net_0;
wire          AXI4mslave0_ARVALID_net_0;
wire          AXI4mslave0_RREADY_net_0;
wire   [8:0]  AXI4mslave0_AWID_net_0;
wire   [31:0] AXI4mslave0_AWADDR_net_0;
wire   [7:0]  AXI4mslave0_AWLEN_net_0;
wire   [2:0]  AXI4mslave0_AWSIZE_net_0;
wire   [1:0]  AXI4mslave0_AWBURST_net_0;
wire   [1:0]  AXI4mslave0_AWLOCK_net_0;
wire   [3:0]  AXI4mslave0_AWCACHE_net_0;
wire   [2:0]  AXI4mslave0_AWPROT_net_0;
wire   [3:0]  AXI4mslave0_AWQOS_net_0;
wire   [3:0]  AXI4mslave0_AWREGION_net_0;
wire   [63:0] AXI4mslave0_WDATA_net_0;
wire   [7:0]  AXI4mslave0_WSTRB_net_0;
wire   [8:0]  AXI4mslave0_ARID_net_0;
wire   [31:0] AXI4mslave0_ARADDR_net_0;
wire   [7:0]  AXI4mslave0_ARLEN_net_0;
wire   [2:0]  AXI4mslave0_ARSIZE_net_0;
wire   [1:0]  AXI4mslave0_ARBURST_net_0;
wire   [1:0]  AXI4mslave0_ARLOCK_net_0;
wire   [3:0]  AXI4mslave0_ARCACHE_net_0;
wire   [2:0]  AXI4mslave0_ARPROT_net_0;
wire   [3:0]  AXI4mslave0_ARQOS_net_0;
wire   [3:0]  AXI4mslave0_ARREGION_net_0;
wire   [0:0]  AXI4mslave0_AWUSER_net_0;
wire   [0:0]  AXI4mslave0_WUSER_net_0;
wire   [0:0]  AXI4mslave0_ARUSER_net_0;
wire   [8:0]  AXI4mslave3_0_AWID_net_0;
wire   [37:0] AXI4mslave3_0_AWADDR_net_0;
wire   [7:0]  AXI4mslave3_0_AWLEN_net_0;
wire   [2:0]  AXI4mslave3_0_AWSIZE_net_0;
wire   [1:0]  AXI4mslave3_0_AWBURST_net_0;
wire   [1:0]  AXI4mslave3_0_AWLOCK_net_0;
wire   [3:0]  AXI4mslave3_0_AWCACHE_net_0;
wire   [2:0]  AXI4mslave3_0_AWPROT_net_0;
wire   [3:0]  AXI4mslave3_0_AWQOS_net_0;
wire   [3:0]  AXI4mslave3_0_AWREGION_net_0;
wire          AXI4mslave3_0_AWVALID_net_0;
wire   [31:0] AXI4mslave3_0_WDATA_net_0;
wire   [3:0]  AXI4mslave3_0_WSTRB_net_0;
wire          AXI4mslave3_0_WLAST_net_0;
wire          AXI4mslave3_0_WVALID_net_0;
wire          AXI4mslave3_0_BREADY_net_0;
wire   [8:0]  AXI4mslave3_0_ARID_net_0;
wire   [37:0] AXI4mslave3_0_ARADDR_net_0;
wire   [7:0]  AXI4mslave3_0_ARLEN_net_0;
wire   [2:0]  AXI4mslave3_0_ARSIZE_net_0;
wire   [1:0]  AXI4mslave3_0_ARBURST_net_0;
wire   [1:0]  AXI4mslave3_0_ARLOCK_net_0;
wire   [3:0]  AXI4mslave3_0_ARCACHE_net_0;
wire   [2:0]  AXI4mslave3_0_ARPROT_net_0;
wire   [3:0]  AXI4mslave3_0_ARQOS_net_0;
wire   [3:0]  AXI4mslave3_0_ARREGION_net_0;
wire          AXI4mslave3_0_ARVALID_net_0;
wire          AXI4mslave3_0_RREADY_net_0;
wire   [0:0]  AXI4mslave3_0_AWUSER_net_0;
wire   [0:0]  AXI4mslave3_0_WUSER_net_0;
wire   [0:0]  AXI4mslave3_0_ARUSER_net_0;
wire   [8:0]  AXI4mslave4_0_AWID_net_0;
wire   [37:0] AXI4mslave4_0_AWADDR_net_0;
wire   [7:0]  AXI4mslave4_0_AWLEN_net_0;
wire   [2:0]  AXI4mslave4_0_AWSIZE_net_0;
wire   [1:0]  AXI4mslave4_0_AWBURST_net_0;
wire   [1:0]  AXI4mslave4_0_AWLOCK_net_0;
wire   [3:0]  AXI4mslave4_0_AWCACHE_net_0;
wire   [2:0]  AXI4mslave4_0_AWPROT_net_0;
wire   [3:0]  AXI4mslave4_0_AWQOS_net_0;
wire   [3:0]  AXI4mslave4_0_AWREGION_net_0;
wire          AXI4mslave4_0_AWVALID_net_0;
wire   [31:0] AXI4mslave4_0_WDATA_net_0;
wire   [3:0]  AXI4mslave4_0_WSTRB_net_0;
wire          AXI4mslave4_0_WLAST_net_0;
wire          AXI4mslave4_0_WVALID_net_0;
wire          AXI4mslave4_0_BREADY_net_0;
wire   [8:0]  AXI4mslave4_0_ARID_net_0;
wire   [37:0] AXI4mslave4_0_ARADDR_net_0;
wire   [7:0]  AXI4mslave4_0_ARLEN_net_0;
wire   [2:0]  AXI4mslave4_0_ARSIZE_net_0;
wire   [1:0]  AXI4mslave4_0_ARBURST_net_0;
wire   [1:0]  AXI4mslave4_0_ARLOCK_net_0;
wire   [3:0]  AXI4mslave4_0_ARCACHE_net_0;
wire   [2:0]  AXI4mslave4_0_ARPROT_net_0;
wire   [3:0]  AXI4mslave4_0_ARQOS_net_0;
wire   [3:0]  AXI4mslave4_0_ARREGION_net_0;
wire          AXI4mslave4_0_ARVALID_net_0;
wire          AXI4mslave4_0_RREADY_net_0;
wire   [0:0]  AXI4mslave4_0_AWUSER_net_0;
wire   [0:0]  AXI4mslave4_0_WUSER_net_0;
wire   [0:0]  AXI4mslave4_0_ARUSER_net_0;
wire          AXI4mmaster0_AWREADY_net_0;
wire          AXI4mmaster0_WREADY_net_0;
wire   [7:0]  AXI4mmaster0_BID_net_0;
wire   [1:0]  AXI4mmaster0_BRESP_net_0;
wire          AXI4mmaster0_BVALID_net_0;
wire          AXI4mmaster0_ARREADY_net_0;
wire   [7:0]  AXI4mmaster0_RID_net_0;
wire   [63:0] AXI4mmaster0_RDATA_net_0;
wire   [1:0]  AXI4mmaster0_RRESP_net_0;
wire          AXI4mmaster0_RLAST_net_0;
wire          AXI4mmaster0_RVALID_net_0;
wire   [0:0]  AXI4mmaster0_BUSER_net_0;
wire   [0:0]  AXI4mmaster0_RUSER_net_0;
wire   [0:0]  INTERRUPT_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [3:0]  STRTDMAOP_const_net_0;
wire   [1:0]  MASTER0_AWLOCK_const_net_0;
wire   [3:0]  MASTER0_AWCACHE_const_net_0;
wire   [2:0]  MASTER0_AWPROT_const_net_0;
wire   [3:0]  MASTER0_AWQOS_const_net_0;
wire   [3:0]  MASTER0_AWREGION_const_net_0;
wire   [1:0]  MASTER0_ARLOCK_const_net_0;
wire   [3:0]  MASTER0_ARCACHE_const_net_0;
wire   [2:0]  MASTER0_ARPROT_const_net_0;
wire   [3:0]  MASTER0_ARQOS_const_net_0;
wire   [3:0]  MASTER0_ARREGION_const_net_0;
wire          GND_net;
wire   [8:0]  SLAVE0_BID_const_net_0;
wire   [8:0]  SLAVE0_RID_const_net_0;
wire   [8:0]  SLAVE2_BID_const_net_0;
wire   [8:0]  SLAVE2_RID_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [37:0] FIC0_INITIATOR_AXI4mslave0_ARADDR;
wire   [10:0] FIC0_INITIATOR_AXI4mslave0_ARADDR_0;
wire   [10:0] FIC0_INITIATOR_AXI4mslave0_ARADDR_0_10to0;
wire   [37:0] FIC0_INITIATOR_AXI4mslave0_AWADDR;
wire   [10:0] FIC0_INITIATOR_AXI4mslave0_AWADDR_0;
wire   [10:0] FIC0_INITIATOR_AXI4mslave0_AWADDR_0_10to0;
wire   [37:0] FIC0_INITIATOR_AXI4mslave1_ARADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave1_ARADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave1_ARADDR_0_31to0;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave1_ARID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_ARID_0;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_ARID_0_7to0;
wire   [37:0] FIC0_INITIATOR_AXI4mslave1_AWADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave1_AWADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave1_AWADDR_0_31to0;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave1_AWID;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_AWID_0;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_AWID_0_7to0;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_BID;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave1_BID_0;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_BID_0_7to0;
wire   [8:8]  FIC0_INITIATOR_AXI4mslave1_BID_0_8to8;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_RID;
wire   [8:0]  FIC0_INITIATOR_AXI4mslave1_RID_0;
wire   [7:0]  FIC0_INITIATOR_AXI4mslave1_RID_0_7to0;
wire   [8:8]  FIC0_INITIATOR_AXI4mslave1_RID_0_8to8;
wire   [37:0] FIC0_INITIATOR_AXI4mslave2_0_ARADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0_31to0;
wire   [37:0] FIC0_INITIATOR_AXI4mslave2_0_AWADDR;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0;
wire   [31:0] FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0_31to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign STRTDMAOP_const_net_0        = 4'h0;
assign MASTER0_AWLOCK_const_net_0   = 2'h0;
assign MASTER0_AWCACHE_const_net_0  = 4'h0;
assign MASTER0_AWPROT_const_net_0   = 3'h0;
assign MASTER0_AWQOS_const_net_0    = 4'h0;
assign MASTER0_AWREGION_const_net_0 = 4'h0;
assign MASTER0_ARLOCK_const_net_0   = 2'h0;
assign MASTER0_ARCACHE_const_net_0  = 4'h0;
assign MASTER0_ARPROT_const_net_0   = 3'h0;
assign MASTER0_ARQOS_const_net_0    = 4'h0;
assign MASTER0_ARREGION_const_net_0 = 4'h0;
assign GND_net                      = 1'b0;
assign SLAVE0_BID_const_net_0       = 9'h000;
assign SLAVE0_RID_const_net_0       = 9'h000;
assign SLAVE2_BID_const_net_0       = 9'h000;
assign SLAVE2_RID_const_net_0       = 9'h000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign DMA_CONTROLLER_IRQ_net_1         = DMA_CONTROLLER_IRQ_net_0[0];
assign DMA_CONTROLLER_IRQ               = DMA_CONTROLLER_IRQ_net_1;
assign AXI4mslave0_AWVALID_net_0        = AXI4mslave0_AWVALID;
assign AXI4mslave0_SLAVE0_AWVALID       = AXI4mslave0_AWVALID_net_0;
assign AXI4mslave0_WLAST_net_0          = AXI4mslave0_WLAST;
assign AXI4mslave0_SLAVE0_WLAST         = AXI4mslave0_WLAST_net_0;
assign AXI4mslave0_WVALID_net_0         = AXI4mslave0_WVALID;
assign AXI4mslave0_SLAVE0_WVALID        = AXI4mslave0_WVALID_net_0;
assign AXI4mslave0_BREADY_net_0         = AXI4mslave0_BREADY;
assign AXI4mslave0_SLAVE0_BREADY        = AXI4mslave0_BREADY_net_0;
assign AXI4mslave0_ARVALID_net_0        = AXI4mslave0_ARVALID;
assign AXI4mslave0_SLAVE0_ARVALID       = AXI4mslave0_ARVALID_net_0;
assign AXI4mslave0_RREADY_net_0         = AXI4mslave0_RREADY;
assign AXI4mslave0_SLAVE0_RREADY        = AXI4mslave0_RREADY_net_0;
assign AXI4mslave0_AWID_net_0           = AXI4mslave0_AWID;
assign AXI4mslave0_SLAVE0_AWID[8:0]     = AXI4mslave0_AWID_net_0;
assign AXI4mslave0_AWADDR_net_0         = AXI4mslave0_AWADDR;
assign AXI4mslave0_SLAVE0_AWADDR[31:0]  = AXI4mslave0_AWADDR_net_0;
assign AXI4mslave0_AWLEN_net_0          = AXI4mslave0_AWLEN;
assign AXI4mslave0_SLAVE0_AWLEN[7:0]    = AXI4mslave0_AWLEN_net_0;
assign AXI4mslave0_AWSIZE_net_0         = AXI4mslave0_AWSIZE;
assign AXI4mslave0_SLAVE0_AWSIZE[2:0]   = AXI4mslave0_AWSIZE_net_0;
assign AXI4mslave0_AWBURST_net_0        = AXI4mslave0_AWBURST;
assign AXI4mslave0_SLAVE0_AWBURST[1:0]  = AXI4mslave0_AWBURST_net_0;
assign AXI4mslave0_AWLOCK_net_0         = AXI4mslave0_AWLOCK;
assign AXI4mslave0_SLAVE0_AWLOCK[1:0]   = AXI4mslave0_AWLOCK_net_0;
assign AXI4mslave0_AWCACHE_net_0        = AXI4mslave0_AWCACHE;
assign AXI4mslave0_SLAVE0_AWCACHE[3:0]  = AXI4mslave0_AWCACHE_net_0;
assign AXI4mslave0_AWPROT_net_0         = AXI4mslave0_AWPROT;
assign AXI4mslave0_SLAVE0_AWPROT[2:0]   = AXI4mslave0_AWPROT_net_0;
assign AXI4mslave0_AWQOS_net_0          = AXI4mslave0_AWQOS;
assign AXI4mslave0_SLAVE0_AWQOS[3:0]    = AXI4mslave0_AWQOS_net_0;
assign AXI4mslave0_AWREGION_net_0       = AXI4mslave0_AWREGION;
assign AXI4mslave0_SLAVE0_AWREGION[3:0] = AXI4mslave0_AWREGION_net_0;
assign AXI4mslave0_WDATA_net_0          = AXI4mslave0_WDATA;
assign AXI4mslave0_SLAVE0_WDATA[63:0]   = AXI4mslave0_WDATA_net_0;
assign AXI4mslave0_WSTRB_net_0          = AXI4mslave0_WSTRB;
assign AXI4mslave0_SLAVE0_WSTRB[7:0]    = AXI4mslave0_WSTRB_net_0;
assign AXI4mslave0_ARID_net_0           = AXI4mslave0_ARID;
assign AXI4mslave0_SLAVE0_ARID[8:0]     = AXI4mslave0_ARID_net_0;
assign AXI4mslave0_ARADDR_net_0         = AXI4mslave0_ARADDR;
assign AXI4mslave0_SLAVE0_ARADDR[31:0]  = AXI4mslave0_ARADDR_net_0;
assign AXI4mslave0_ARLEN_net_0          = AXI4mslave0_ARLEN;
assign AXI4mslave0_SLAVE0_ARLEN[7:0]    = AXI4mslave0_ARLEN_net_0;
assign AXI4mslave0_ARSIZE_net_0         = AXI4mslave0_ARSIZE;
assign AXI4mslave0_SLAVE0_ARSIZE[2:0]   = AXI4mslave0_ARSIZE_net_0;
assign AXI4mslave0_ARBURST_net_0        = AXI4mslave0_ARBURST;
assign AXI4mslave0_SLAVE0_ARBURST[1:0]  = AXI4mslave0_ARBURST_net_0;
assign AXI4mslave0_ARLOCK_net_0         = AXI4mslave0_ARLOCK;
assign AXI4mslave0_SLAVE0_ARLOCK[1:0]   = AXI4mslave0_ARLOCK_net_0;
assign AXI4mslave0_ARCACHE_net_0        = AXI4mslave0_ARCACHE;
assign AXI4mslave0_SLAVE0_ARCACHE[3:0]  = AXI4mslave0_ARCACHE_net_0;
assign AXI4mslave0_ARPROT_net_0         = AXI4mslave0_ARPROT;
assign AXI4mslave0_SLAVE0_ARPROT[2:0]   = AXI4mslave0_ARPROT_net_0;
assign AXI4mslave0_ARQOS_net_0          = AXI4mslave0_ARQOS;
assign AXI4mslave0_SLAVE0_ARQOS[3:0]    = AXI4mslave0_ARQOS_net_0;
assign AXI4mslave0_ARREGION_net_0       = AXI4mslave0_ARREGION;
assign AXI4mslave0_SLAVE0_ARREGION[3:0] = AXI4mslave0_ARREGION_net_0;
assign AXI4mslave0_AWUSER_net_0[0]      = AXI4mslave0_AWUSER[0];
assign AXI4mslave0_SLAVE0_AWUSER[0:0]   = AXI4mslave0_AWUSER_net_0[0];
assign AXI4mslave0_WUSER_net_0[0]       = AXI4mslave0_WUSER[0];
assign AXI4mslave0_SLAVE0_WUSER[0:0]    = AXI4mslave0_WUSER_net_0[0];
assign AXI4mslave0_ARUSER_net_0[0]      = AXI4mslave0_ARUSER[0];
assign AXI4mslave0_SLAVE0_ARUSER[0:0]   = AXI4mslave0_ARUSER_net_0[0];
assign AXI4mslave3_0_AWID_net_0         = AXI4mslave3_0_AWID;
assign AXI4mslave3_SLAVE3_AWID[8:0]     = AXI4mslave3_0_AWID_net_0;
assign AXI4mslave3_0_AWADDR_net_0       = AXI4mslave3_0_AWADDR;
assign AXI4mslave3_SLAVE3_AWADDR[37:0]  = AXI4mslave3_0_AWADDR_net_0;
assign AXI4mslave3_0_AWLEN_net_0        = AXI4mslave3_0_AWLEN;
assign AXI4mslave3_SLAVE3_AWLEN[7:0]    = AXI4mslave3_0_AWLEN_net_0;
assign AXI4mslave3_0_AWSIZE_net_0       = AXI4mslave3_0_AWSIZE;
assign AXI4mslave3_SLAVE3_AWSIZE[2:0]   = AXI4mslave3_0_AWSIZE_net_0;
assign AXI4mslave3_0_AWBURST_net_0      = AXI4mslave3_0_AWBURST;
assign AXI4mslave3_SLAVE3_AWBURST[1:0]  = AXI4mslave3_0_AWBURST_net_0;
assign AXI4mslave3_0_AWLOCK_net_0       = AXI4mslave3_0_AWLOCK;
assign AXI4mslave3_SLAVE3_AWLOCK[1:0]   = AXI4mslave3_0_AWLOCK_net_0;
assign AXI4mslave3_0_AWCACHE_net_0      = AXI4mslave3_0_AWCACHE;
assign AXI4mslave3_SLAVE3_AWCACHE[3:0]  = AXI4mslave3_0_AWCACHE_net_0;
assign AXI4mslave3_0_AWPROT_net_0       = AXI4mslave3_0_AWPROT;
assign AXI4mslave3_SLAVE3_AWPROT[2:0]   = AXI4mslave3_0_AWPROT_net_0;
assign AXI4mslave3_0_AWQOS_net_0        = AXI4mslave3_0_AWQOS;
assign AXI4mslave3_SLAVE3_AWQOS[3:0]    = AXI4mslave3_0_AWQOS_net_0;
assign AXI4mslave3_0_AWREGION_net_0     = AXI4mslave3_0_AWREGION;
assign AXI4mslave3_SLAVE3_AWREGION[3:0] = AXI4mslave3_0_AWREGION_net_0;
assign AXI4mslave3_0_AWVALID_net_0      = AXI4mslave3_0_AWVALID;
assign AXI4mslave3_SLAVE3_AWVALID       = AXI4mslave3_0_AWVALID_net_0;
assign AXI4mslave3_0_WDATA_net_0        = AXI4mslave3_0_WDATA;
assign AXI4mslave3_SLAVE3_WDATA[31:0]   = AXI4mslave3_0_WDATA_net_0;
assign AXI4mslave3_0_WSTRB_net_0        = AXI4mslave3_0_WSTRB;
assign AXI4mslave3_SLAVE3_WSTRB[3:0]    = AXI4mslave3_0_WSTRB_net_0;
assign AXI4mslave3_0_WLAST_net_0        = AXI4mslave3_0_WLAST;
assign AXI4mslave3_SLAVE3_WLAST         = AXI4mslave3_0_WLAST_net_0;
assign AXI4mslave3_0_WVALID_net_0       = AXI4mslave3_0_WVALID;
assign AXI4mslave3_SLAVE3_WVALID        = AXI4mslave3_0_WVALID_net_0;
assign AXI4mslave3_0_BREADY_net_0       = AXI4mslave3_0_BREADY;
assign AXI4mslave3_SLAVE3_BREADY        = AXI4mslave3_0_BREADY_net_0;
assign AXI4mslave3_0_ARID_net_0         = AXI4mslave3_0_ARID;
assign AXI4mslave3_SLAVE3_ARID[8:0]     = AXI4mslave3_0_ARID_net_0;
assign AXI4mslave3_0_ARADDR_net_0       = AXI4mslave3_0_ARADDR;
assign AXI4mslave3_SLAVE3_ARADDR[37:0]  = AXI4mslave3_0_ARADDR_net_0;
assign AXI4mslave3_0_ARLEN_net_0        = AXI4mslave3_0_ARLEN;
assign AXI4mslave3_SLAVE3_ARLEN[7:0]    = AXI4mslave3_0_ARLEN_net_0;
assign AXI4mslave3_0_ARSIZE_net_0       = AXI4mslave3_0_ARSIZE;
assign AXI4mslave3_SLAVE3_ARSIZE[2:0]   = AXI4mslave3_0_ARSIZE_net_0;
assign AXI4mslave3_0_ARBURST_net_0      = AXI4mslave3_0_ARBURST;
assign AXI4mslave3_SLAVE3_ARBURST[1:0]  = AXI4mslave3_0_ARBURST_net_0;
assign AXI4mslave3_0_ARLOCK_net_0       = AXI4mslave3_0_ARLOCK;
assign AXI4mslave3_SLAVE3_ARLOCK[1:0]   = AXI4mslave3_0_ARLOCK_net_0;
assign AXI4mslave3_0_ARCACHE_net_0      = AXI4mslave3_0_ARCACHE;
assign AXI4mslave3_SLAVE3_ARCACHE[3:0]  = AXI4mslave3_0_ARCACHE_net_0;
assign AXI4mslave3_0_ARPROT_net_0       = AXI4mslave3_0_ARPROT;
assign AXI4mslave3_SLAVE3_ARPROT[2:0]   = AXI4mslave3_0_ARPROT_net_0;
assign AXI4mslave3_0_ARQOS_net_0        = AXI4mslave3_0_ARQOS;
assign AXI4mslave3_SLAVE3_ARQOS[3:0]    = AXI4mslave3_0_ARQOS_net_0;
assign AXI4mslave3_0_ARREGION_net_0     = AXI4mslave3_0_ARREGION;
assign AXI4mslave3_SLAVE3_ARREGION[3:0] = AXI4mslave3_0_ARREGION_net_0;
assign AXI4mslave3_0_ARVALID_net_0      = AXI4mslave3_0_ARVALID;
assign AXI4mslave3_SLAVE3_ARVALID       = AXI4mslave3_0_ARVALID_net_0;
assign AXI4mslave3_0_RREADY_net_0       = AXI4mslave3_0_RREADY;
assign AXI4mslave3_SLAVE3_RREADY        = AXI4mslave3_0_RREADY_net_0;
assign AXI4mslave3_0_AWUSER_net_0[0]    = AXI4mslave3_0_AWUSER[0];
assign AXI4mslave3_SLAVE3_AWUSER[0:0]   = AXI4mslave3_0_AWUSER_net_0[0];
assign AXI4mslave3_0_WUSER_net_0[0]     = AXI4mslave3_0_WUSER[0];
assign AXI4mslave3_SLAVE3_WUSER[0:0]    = AXI4mslave3_0_WUSER_net_0[0];
assign AXI4mslave3_0_ARUSER_net_0[0]    = AXI4mslave3_0_ARUSER[0];
assign AXI4mslave3_SLAVE3_ARUSER[0:0]   = AXI4mslave3_0_ARUSER_net_0[0];
assign AXI4mslave4_0_AWID_net_0         = AXI4mslave4_0_AWID;
assign AXI4mslave4_SLAVE4_AWID[8:0]     = AXI4mslave4_0_AWID_net_0;
assign AXI4mslave4_0_AWADDR_net_0       = AXI4mslave4_0_AWADDR;
assign AXI4mslave4_SLAVE4_AWADDR[37:0]  = AXI4mslave4_0_AWADDR_net_0;
assign AXI4mslave4_0_AWLEN_net_0        = AXI4mslave4_0_AWLEN;
assign AXI4mslave4_SLAVE4_AWLEN[7:0]    = AXI4mslave4_0_AWLEN_net_0;
assign AXI4mslave4_0_AWSIZE_net_0       = AXI4mslave4_0_AWSIZE;
assign AXI4mslave4_SLAVE4_AWSIZE[2:0]   = AXI4mslave4_0_AWSIZE_net_0;
assign AXI4mslave4_0_AWBURST_net_0      = AXI4mslave4_0_AWBURST;
assign AXI4mslave4_SLAVE4_AWBURST[1:0]  = AXI4mslave4_0_AWBURST_net_0;
assign AXI4mslave4_0_AWLOCK_net_0       = AXI4mslave4_0_AWLOCK;
assign AXI4mslave4_SLAVE4_AWLOCK[1:0]   = AXI4mslave4_0_AWLOCK_net_0;
assign AXI4mslave4_0_AWCACHE_net_0      = AXI4mslave4_0_AWCACHE;
assign AXI4mslave4_SLAVE4_AWCACHE[3:0]  = AXI4mslave4_0_AWCACHE_net_0;
assign AXI4mslave4_0_AWPROT_net_0       = AXI4mslave4_0_AWPROT;
assign AXI4mslave4_SLAVE4_AWPROT[2:0]   = AXI4mslave4_0_AWPROT_net_0;
assign AXI4mslave4_0_AWQOS_net_0        = AXI4mslave4_0_AWQOS;
assign AXI4mslave4_SLAVE4_AWQOS[3:0]    = AXI4mslave4_0_AWQOS_net_0;
assign AXI4mslave4_0_AWREGION_net_0     = AXI4mslave4_0_AWREGION;
assign AXI4mslave4_SLAVE4_AWREGION[3:0] = AXI4mslave4_0_AWREGION_net_0;
assign AXI4mslave4_0_AWVALID_net_0      = AXI4mslave4_0_AWVALID;
assign AXI4mslave4_SLAVE4_AWVALID       = AXI4mslave4_0_AWVALID_net_0;
assign AXI4mslave4_0_WDATA_net_0        = AXI4mslave4_0_WDATA;
assign AXI4mslave4_SLAVE4_WDATA[31:0]   = AXI4mslave4_0_WDATA_net_0;
assign AXI4mslave4_0_WSTRB_net_0        = AXI4mslave4_0_WSTRB;
assign AXI4mslave4_SLAVE4_WSTRB[3:0]    = AXI4mslave4_0_WSTRB_net_0;
assign AXI4mslave4_0_WLAST_net_0        = AXI4mslave4_0_WLAST;
assign AXI4mslave4_SLAVE4_WLAST         = AXI4mslave4_0_WLAST_net_0;
assign AXI4mslave4_0_WVALID_net_0       = AXI4mslave4_0_WVALID;
assign AXI4mslave4_SLAVE4_WVALID        = AXI4mslave4_0_WVALID_net_0;
assign AXI4mslave4_0_BREADY_net_0       = AXI4mslave4_0_BREADY;
assign AXI4mslave4_SLAVE4_BREADY        = AXI4mslave4_0_BREADY_net_0;
assign AXI4mslave4_0_ARID_net_0         = AXI4mslave4_0_ARID;
assign AXI4mslave4_SLAVE4_ARID[8:0]     = AXI4mslave4_0_ARID_net_0;
assign AXI4mslave4_0_ARADDR_net_0       = AXI4mslave4_0_ARADDR;
assign AXI4mslave4_SLAVE4_ARADDR[37:0]  = AXI4mslave4_0_ARADDR_net_0;
assign AXI4mslave4_0_ARLEN_net_0        = AXI4mslave4_0_ARLEN;
assign AXI4mslave4_SLAVE4_ARLEN[7:0]    = AXI4mslave4_0_ARLEN_net_0;
assign AXI4mslave4_0_ARSIZE_net_0       = AXI4mslave4_0_ARSIZE;
assign AXI4mslave4_SLAVE4_ARSIZE[2:0]   = AXI4mslave4_0_ARSIZE_net_0;
assign AXI4mslave4_0_ARBURST_net_0      = AXI4mslave4_0_ARBURST;
assign AXI4mslave4_SLAVE4_ARBURST[1:0]  = AXI4mslave4_0_ARBURST_net_0;
assign AXI4mslave4_0_ARLOCK_net_0       = AXI4mslave4_0_ARLOCK;
assign AXI4mslave4_SLAVE4_ARLOCK[1:0]   = AXI4mslave4_0_ARLOCK_net_0;
assign AXI4mslave4_0_ARCACHE_net_0      = AXI4mslave4_0_ARCACHE;
assign AXI4mslave4_SLAVE4_ARCACHE[3:0]  = AXI4mslave4_0_ARCACHE_net_0;
assign AXI4mslave4_0_ARPROT_net_0       = AXI4mslave4_0_ARPROT;
assign AXI4mslave4_SLAVE4_ARPROT[2:0]   = AXI4mslave4_0_ARPROT_net_0;
assign AXI4mslave4_0_ARQOS_net_0        = AXI4mslave4_0_ARQOS;
assign AXI4mslave4_SLAVE4_ARQOS[3:0]    = AXI4mslave4_0_ARQOS_net_0;
assign AXI4mslave4_0_ARREGION_net_0     = AXI4mslave4_0_ARREGION;
assign AXI4mslave4_SLAVE4_ARREGION[3:0] = AXI4mslave4_0_ARREGION_net_0;
assign AXI4mslave4_0_ARVALID_net_0      = AXI4mslave4_0_ARVALID;
assign AXI4mslave4_SLAVE4_ARVALID       = AXI4mslave4_0_ARVALID_net_0;
assign AXI4mslave4_0_RREADY_net_0       = AXI4mslave4_0_RREADY;
assign AXI4mslave4_SLAVE4_RREADY        = AXI4mslave4_0_RREADY_net_0;
assign AXI4mslave4_0_AWUSER_net_0[0]    = AXI4mslave4_0_AWUSER[0];
assign AXI4mslave4_SLAVE4_AWUSER[0:0]   = AXI4mslave4_0_AWUSER_net_0[0];
assign AXI4mslave4_0_WUSER_net_0[0]     = AXI4mslave4_0_WUSER[0];
assign AXI4mslave4_SLAVE4_WUSER[0:0]    = AXI4mslave4_0_WUSER_net_0[0];
assign AXI4mslave4_0_ARUSER_net_0[0]    = AXI4mslave4_0_ARUSER[0];
assign AXI4mslave4_SLAVE4_ARUSER[0:0]   = AXI4mslave4_0_ARUSER_net_0[0];
assign AXI4mmaster0_AWREADY_net_0       = AXI4mmaster0_AWREADY;
assign AXI4mmaster0_MASTER0_AWREADY     = AXI4mmaster0_AWREADY_net_0;
assign AXI4mmaster0_WREADY_net_0        = AXI4mmaster0_WREADY;
assign AXI4mmaster0_MASTER0_WREADY      = AXI4mmaster0_WREADY_net_0;
assign AXI4mmaster0_BID_net_0           = AXI4mmaster0_BID;
assign AXI4mmaster0_MASTER0_BID[7:0]    = AXI4mmaster0_BID_net_0;
assign AXI4mmaster0_BRESP_net_0         = AXI4mmaster0_BRESP;
assign AXI4mmaster0_MASTER0_BRESP[1:0]  = AXI4mmaster0_BRESP_net_0;
assign AXI4mmaster0_BVALID_net_0        = AXI4mmaster0_BVALID;
assign AXI4mmaster0_MASTER0_BVALID      = AXI4mmaster0_BVALID_net_0;
assign AXI4mmaster0_ARREADY_net_0       = AXI4mmaster0_ARREADY;
assign AXI4mmaster0_MASTER0_ARREADY     = AXI4mmaster0_ARREADY_net_0;
assign AXI4mmaster0_RID_net_0           = AXI4mmaster0_RID;
assign AXI4mmaster0_MASTER0_RID[7:0]    = AXI4mmaster0_RID_net_0;
assign AXI4mmaster0_RDATA_net_0         = AXI4mmaster0_RDATA;
assign AXI4mmaster0_MASTER0_RDATA[63:0] = AXI4mmaster0_RDATA_net_0;
assign AXI4mmaster0_RRESP_net_0         = AXI4mmaster0_RRESP;
assign AXI4mmaster0_MASTER0_RRESP[1:0]  = AXI4mmaster0_RRESP_net_0;
assign AXI4mmaster0_RLAST_net_0         = AXI4mmaster0_RLAST;
assign AXI4mmaster0_MASTER0_RLAST       = AXI4mmaster0_RLAST_net_0;
assign AXI4mmaster0_RVALID_net_0        = AXI4mmaster0_RVALID;
assign AXI4mmaster0_MASTER0_RVALID      = AXI4mmaster0_RVALID_net_0;
assign AXI4mmaster0_BUSER_net_0[0]      = AXI4mmaster0_BUSER[0];
assign AXI4mmaster0_MASTER0_BUSER[0:0]  = AXI4mmaster0_BUSER_net_0[0];
assign AXI4mmaster0_RUSER_net_0[0]      = AXI4mmaster0_RUSER[0];
assign AXI4mmaster0_MASTER0_RUSER[0:0]  = AXI4mmaster0_RUSER_net_0[0];
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign DMA_CONTROLLER_IRQ_net_0[0] = INTERRUPT_net_0[0];
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign FIC0_INITIATOR_AXI4mslave0_ARADDR_0 = { FIC0_INITIATOR_AXI4mslave0_ARADDR_0_10to0 };
assign FIC0_INITIATOR_AXI4mslave0_ARADDR_0_10to0 = FIC0_INITIATOR_AXI4mslave0_ARADDR[10:0];

assign FIC0_INITIATOR_AXI4mslave0_AWADDR_0 = { FIC0_INITIATOR_AXI4mslave0_AWADDR_0_10to0 };
assign FIC0_INITIATOR_AXI4mslave0_AWADDR_0_10to0 = FIC0_INITIATOR_AXI4mslave0_AWADDR[10:0];

assign FIC0_INITIATOR_AXI4mslave1_ARADDR_0 = { FIC0_INITIATOR_AXI4mslave1_ARADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave1_ARADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave1_ARADDR[31:0];

assign FIC0_INITIATOR_AXI4mslave1_ARID_0 = { FIC0_INITIATOR_AXI4mslave1_ARID_0_7to0 };
assign FIC0_INITIATOR_AXI4mslave1_ARID_0_7to0 = FIC0_INITIATOR_AXI4mslave1_ARID[7:0];

assign FIC0_INITIATOR_AXI4mslave1_AWADDR_0 = { FIC0_INITIATOR_AXI4mslave1_AWADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave1_AWADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave1_AWADDR[31:0];

assign FIC0_INITIATOR_AXI4mslave1_AWID_0 = { FIC0_INITIATOR_AXI4mslave1_AWID_0_7to0 };
assign FIC0_INITIATOR_AXI4mslave1_AWID_0_7to0 = FIC0_INITIATOR_AXI4mslave1_AWID[7:0];

assign FIC0_INITIATOR_AXI4mslave1_BID_0 = { FIC0_INITIATOR_AXI4mslave1_BID_0_8to8, FIC0_INITIATOR_AXI4mslave1_BID_0_7to0 };
assign FIC0_INITIATOR_AXI4mslave1_BID_0_7to0 = FIC0_INITIATOR_AXI4mslave1_BID[7:0];
assign FIC0_INITIATOR_AXI4mslave1_BID_0_8to8 = 1'b0;

assign FIC0_INITIATOR_AXI4mslave1_RID_0 = { FIC0_INITIATOR_AXI4mslave1_RID_0_8to8, FIC0_INITIATOR_AXI4mslave1_RID_0_7to0 };
assign FIC0_INITIATOR_AXI4mslave1_RID_0_7to0 = FIC0_INITIATOR_AXI4mslave1_RID[7:0];
assign FIC0_INITIATOR_AXI4mslave1_RID_0_8to8 = 1'b0;

assign FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0 = { FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave2_0_ARADDR[31:0];

assign FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0 = { FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0_31to0 };
assign FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0_31to0 = FIC0_INITIATOR_AXI4mslave2_0_AWADDR[31:0];

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DMA_CONTROLLER
DMA_CONTROLLER DMA_CONTROLLER_inst_0(
        // Inputs
        .RESETN       ( ARESETN ),
        .CLOCK        ( ACLK ),
        .DMA_AWREADY  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWREADY ),
        .DMA_WREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WREADY ),
        .DMA_BVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BVALID ),
        .DMA_ARREADY  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARREADY ),
        .DMA_RLAST    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RLAST ),
        .DMA_RVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RVALID ),
        .CTRL_AWVALID ( FIC0_INITIATOR_AXI4mslave0_AWVALID ),
        .CTRL_WVALID  ( FIC0_INITIATOR_AXI4mslave0_WVALID ),
        .CTRL_BREADY  ( FIC0_INITIATOR_AXI4mslave0_BREADY ),
        .CTRL_ARVALID ( FIC0_INITIATOR_AXI4mslave0_ARVALID ),
        .CTRL_RREADY  ( FIC0_INITIATOR_AXI4mslave0_RREADY ),
        .STRTDMAOP    ( STRTDMAOP_const_net_0 ),
        .DMA_BID      ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BID ),
        .DMA_BRESP    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BRESP ),
        .DMA_RID      ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RID ),
        .DMA_RDATA    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RDATA ),
        .DMA_RRESP    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RRESP ),
        .CTRL_AWADDR  ( FIC0_INITIATOR_AXI4mslave0_AWADDR_0 ),
        .CTRL_WDATA   ( FIC0_INITIATOR_AXI4mslave0_WDATA ),
        .CTRL_WSTRB   ( FIC0_INITIATOR_AXI4mslave0_WSTRB ),
        .CTRL_ARADDR  ( FIC0_INITIATOR_AXI4mslave0_ARADDR_0 ),
        // Outputs
        .DMA_AWVALID  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWVALID ),
        .DMA_WLAST    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WLAST ),
        .DMA_WVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WVALID ),
        .DMA_BREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BREADY ),
        .DMA_ARVALID  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARVALID ),
        .DMA_RREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RREADY ),
        .CTRL_AWREADY ( FIC0_INITIATOR_AXI4mslave0_AWREADY ),
        .CTRL_WREADY  ( FIC0_INITIATOR_AXI4mslave0_WREADY ),
        .CTRL_BVALID  ( FIC0_INITIATOR_AXI4mslave0_BVALID ),
        .CTRL_ARREADY ( FIC0_INITIATOR_AXI4mslave0_ARREADY ),
        .CTRL_RVALID  ( FIC0_INITIATOR_AXI4mslave0_RVALID ),
        .INTERRUPT    ( INTERRUPT_net_0 ),
        .DMA_AWID     ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWID ),
        .DMA_AWADDR   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWADDR ),
        .DMA_AWLEN    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWLEN ),
        .DMA_AWSIZE   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWSIZE ),
        .DMA_AWBURST  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWBURST ),
        .DMA_WDATA    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WDATA ),
        .DMA_WSTRB    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WSTRB ),
        .DMA_ARID     ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARID ),
        .DMA_ARADDR   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARADDR ),
        .DMA_ARLEN    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARLEN ),
        .DMA_ARSIZE   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARSIZE ),
        .DMA_ARBURST  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARBURST ),
        .CTRL_BRESP   ( FIC0_INITIATOR_AXI4mslave0_BRESP ),
        .CTRL_RDATA   ( FIC0_INITIATOR_AXI4mslave0_RDATA ),
        .CTRL_RRESP   ( FIC0_INITIATOR_AXI4mslave0_RRESP ) 
        );

//--------DMA_INITIATOR
DMA_INITIATOR DMA_INITIATOR_inst_0(
        // Inputs
        .ACLK             ( ACLK ),
        .ARESETN          ( ARESETN ),
        .SLAVE0_AWREADY   ( AXI4mslave0_SLAVE0_AWREADY ),
        .SLAVE0_WREADY    ( AXI4mslave0_SLAVE0_WREADY ),
        .SLAVE0_BVALID    ( AXI4mslave0_SLAVE0_BVALID ),
        .SLAVE0_ARREADY   ( AXI4mslave0_SLAVE0_ARREADY ),
        .SLAVE0_RLAST     ( AXI4mslave0_SLAVE0_RLAST ),
        .SLAVE0_RVALID    ( AXI4mslave0_SLAVE0_RVALID ),
        .MASTER0_AWVALID  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWVALID ),
        .MASTER0_WLAST    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WLAST ),
        .MASTER0_WVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WVALID ),
        .MASTER0_BREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BREADY ),
        .MASTER0_ARVALID  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARVALID ),
        .MASTER0_RREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RREADY ),
        .SLAVE0_BID       ( AXI4mslave0_SLAVE0_BID ),
        .SLAVE0_BRESP     ( AXI4mslave0_SLAVE0_BRESP ),
        .SLAVE0_RID       ( AXI4mslave0_SLAVE0_RID ),
        .SLAVE0_RDATA     ( AXI4mslave0_SLAVE0_RDATA ),
        .SLAVE0_RRESP     ( AXI4mslave0_SLAVE0_RRESP ),
        .SLAVE0_BUSER     ( AXI4mslave0_SLAVE0_BUSER ),
        .SLAVE0_RUSER     ( AXI4mslave0_SLAVE0_RUSER ),
        .MASTER0_AWID     ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWID ),
        .MASTER0_AWADDR   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWADDR ),
        .MASTER0_AWLEN    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWLEN ),
        .MASTER0_AWSIZE   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWSIZE ),
        .MASTER0_AWBURST  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWBURST ),
        .MASTER0_AWLOCK   ( MASTER0_AWLOCK_const_net_0 ), // tied to 2'h0 from definition
        .MASTER0_AWCACHE  ( MASTER0_AWCACHE_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWPROT   ( MASTER0_AWPROT_const_net_0 ), // tied to 3'h0 from definition
        .MASTER0_AWQOS    ( MASTER0_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWREGION ( MASTER0_AWREGION_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_WDATA    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WDATA ),
        .MASTER0_WSTRB    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WSTRB ),
        .MASTER0_ARID     ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARID ),
        .MASTER0_ARADDR   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARADDR ),
        .MASTER0_ARLEN    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARLEN ),
        .MASTER0_ARSIZE   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARSIZE ),
        .MASTER0_ARBURST  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARBURST ),
        .MASTER0_ARLOCK   ( MASTER0_ARLOCK_const_net_0 ), // tied to 2'h0 from definition
        .MASTER0_ARCACHE  ( MASTER0_ARCACHE_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_ARPROT   ( MASTER0_ARPROT_const_net_0 ), // tied to 3'h0 from definition
        .MASTER0_ARQOS    ( MASTER0_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_ARREGION ( MASTER0_ARREGION_const_net_0 ), // tied to 4'h0 from definition
        .MASTER0_AWUSER   ( GND_net ), // tied to 1'b0 from definition
        .MASTER0_WUSER    ( GND_net ), // tied to 1'b0 from definition
        .MASTER0_ARUSER   ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .SLAVE0_AWVALID   ( AXI4mslave0_AWVALID ),
        .SLAVE0_WLAST     ( AXI4mslave0_WLAST ),
        .SLAVE0_WVALID    ( AXI4mslave0_WVALID ),
        .SLAVE0_BREADY    ( AXI4mslave0_BREADY ),
        .SLAVE0_ARVALID   ( AXI4mslave0_ARVALID ),
        .SLAVE0_RREADY    ( AXI4mslave0_RREADY ),
        .MASTER0_AWREADY  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_AWREADY ),
        .MASTER0_WREADY   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_WREADY ),
        .MASTER0_BVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BVALID ),
        .MASTER0_ARREADY  ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_ARREADY ),
        .MASTER0_RLAST    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RLAST ),
        .MASTER0_RVALID   ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RVALID ),
        .SLAVE0_AWID      ( AXI4mslave0_AWID ),
        .SLAVE0_AWADDR    ( AXI4mslave0_AWADDR ),
        .SLAVE0_AWLEN     ( AXI4mslave0_AWLEN ),
        .SLAVE0_AWSIZE    ( AXI4mslave0_AWSIZE ),
        .SLAVE0_AWBURST   ( AXI4mslave0_AWBURST ),
        .SLAVE0_AWLOCK    ( AXI4mslave0_AWLOCK ),
        .SLAVE0_AWCACHE   ( AXI4mslave0_AWCACHE ),
        .SLAVE0_AWPROT    ( AXI4mslave0_AWPROT ),
        .SLAVE0_AWQOS     ( AXI4mslave0_AWQOS ),
        .SLAVE0_AWREGION  ( AXI4mslave0_AWREGION ),
        .SLAVE0_WDATA     ( AXI4mslave0_WDATA ),
        .SLAVE0_WSTRB     ( AXI4mslave0_WSTRB ),
        .SLAVE0_ARID      ( AXI4mslave0_ARID ),
        .SLAVE0_ARADDR    ( AXI4mslave0_ARADDR ),
        .SLAVE0_ARLEN     ( AXI4mslave0_ARLEN ),
        .SLAVE0_ARSIZE    ( AXI4mslave0_ARSIZE ),
        .SLAVE0_ARBURST   ( AXI4mslave0_ARBURST ),
        .SLAVE0_ARLOCK    ( AXI4mslave0_ARLOCK ),
        .SLAVE0_ARCACHE   ( AXI4mslave0_ARCACHE ),
        .SLAVE0_ARPROT    ( AXI4mslave0_ARPROT ),
        .SLAVE0_ARQOS     ( AXI4mslave0_ARQOS ),
        .SLAVE0_ARREGION  ( AXI4mslave0_ARREGION ),
        .SLAVE0_AWUSER    ( AXI4mslave0_AWUSER ),
        .SLAVE0_WUSER     ( AXI4mslave0_WUSER ),
        .SLAVE0_ARUSER    ( AXI4mslave0_ARUSER ),
        .MASTER0_BID      ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BID ),
        .MASTER0_BRESP    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BRESP ),
        .MASTER0_RID      ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RID ),
        .MASTER0_RDATA    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RDATA ),
        .MASTER0_RRESP    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RRESP ),
        .MASTER0_BUSER    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_BUSER ),
        .MASTER0_RUSER    ( DMA_CONTROLLER_AXI4InitiatorDMA_IF_RUSER ) 
        );

//--------FIC0_INITIATOR
FIC0_INITIATOR FIC0_INITIATOR_inst_0(
        // Inputs
        .ACLK             ( ACLK ),
        .ARESETN          ( ARESETN ),
        .SLAVE0_AWREADY   ( FIC0_INITIATOR_AXI4mslave0_AWREADY ),
        .SLAVE0_WREADY    ( FIC0_INITIATOR_AXI4mslave0_WREADY ),
        .SLAVE0_BID       ( SLAVE0_BID_const_net_0 ), // tied to 9'h000 from definition
        .SLAVE0_BRESP     ( FIC0_INITIATOR_AXI4mslave0_BRESP ),
        .SLAVE0_BVALID    ( FIC0_INITIATOR_AXI4mslave0_BVALID ),
        .SLAVE0_ARREADY   ( FIC0_INITIATOR_AXI4mslave0_ARREADY ),
        .SLAVE0_RID       ( SLAVE0_RID_const_net_0 ), // tied to 9'h000 from definition
        .SLAVE0_RDATA     ( FIC0_INITIATOR_AXI4mslave0_RDATA ),
        .SLAVE0_RRESP     ( FIC0_INITIATOR_AXI4mslave0_RRESP ),
        .SLAVE0_RLAST     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE0_RVALID    ( FIC0_INITIATOR_AXI4mslave0_RVALID ),
        .SLAVE0_BUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE0_RUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE1_AWREADY   ( FIC0_INITIATOR_AXI4mslave1_AWREADY ),
        .SLAVE1_WREADY    ( FIC0_INITIATOR_AXI4mslave1_WREADY ),
        .SLAVE1_BID       ( FIC0_INITIATOR_AXI4mslave1_BID_0 ),
        .SLAVE1_BRESP     ( FIC0_INITIATOR_AXI4mslave1_BRESP ),
        .SLAVE1_BVALID    ( FIC0_INITIATOR_AXI4mslave1_BVALID ),
        .SLAVE1_ARREADY   ( FIC0_INITIATOR_AXI4mslave1_ARREADY ),
        .SLAVE1_RID       ( FIC0_INITIATOR_AXI4mslave1_RID_0 ),
        .SLAVE1_RDATA     ( FIC0_INITIATOR_AXI4mslave1_RDATA ),
        .SLAVE1_RRESP     ( FIC0_INITIATOR_AXI4mslave1_RRESP ),
        .SLAVE1_RLAST     ( FIC0_INITIATOR_AXI4mslave1_RLAST ),
        .SLAVE1_RVALID    ( FIC0_INITIATOR_AXI4mslave1_RVALID ),
        .SLAVE1_BUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE1_RUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE2_AWREADY   ( FIC0_INITIATOR_AXI4mslave2_0_AWREADY ),
        .SLAVE2_WREADY    ( FIC0_INITIATOR_AXI4mslave2_0_WREADY ),
        .SLAVE2_BID       ( SLAVE2_BID_const_net_0 ), // tied to 9'h000 from definition
        .SLAVE2_BRESP     ( FIC0_INITIATOR_AXI4mslave2_0_BRESP ),
        .SLAVE2_BVALID    ( FIC0_INITIATOR_AXI4mslave2_0_BVALID ),
        .SLAVE2_ARREADY   ( FIC0_INITIATOR_AXI4mslave2_0_ARREADY ),
        .SLAVE2_RID       ( SLAVE2_RID_const_net_0 ), // tied to 9'h000 from definition
        .SLAVE2_RDATA     ( FIC0_INITIATOR_AXI4mslave2_0_RDATA ),
        .SLAVE2_RRESP     ( FIC0_INITIATOR_AXI4mslave2_0_RRESP ),
        .SLAVE2_RLAST     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE2_RVALID    ( FIC0_INITIATOR_AXI4mslave2_0_RVALID ),
        .SLAVE2_BUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE2_RUSER     ( GND_net ), // tied to 1'b0 from definition
        .SLAVE3_AWREADY   ( AXI4mslave3_SLAVE3_AWREADY ),
        .SLAVE3_WREADY    ( AXI4mslave3_SLAVE3_WREADY ),
        .SLAVE3_BID       ( AXI4mslave3_SLAVE3_BID ),
        .SLAVE3_BRESP     ( AXI4mslave3_SLAVE3_BRESP ),
        .SLAVE3_BVALID    ( AXI4mslave3_SLAVE3_BVALID ),
        .SLAVE3_ARREADY   ( AXI4mslave3_SLAVE3_ARREADY ),
        .SLAVE3_RID       ( AXI4mslave3_SLAVE3_RID ),
        .SLAVE3_RDATA     ( AXI4mslave3_SLAVE3_RDATA ),
        .SLAVE3_RRESP     ( AXI4mslave3_SLAVE3_RRESP ),
        .SLAVE3_RLAST     ( AXI4mslave3_SLAVE3_RLAST ),
        .SLAVE3_RVALID    ( AXI4mslave3_SLAVE3_RVALID ),
        .SLAVE3_BUSER     ( AXI4mslave3_SLAVE3_BUSER ),
        .SLAVE3_RUSER     ( AXI4mslave3_SLAVE3_RUSER ),
        .SLAVE4_AWREADY   ( AXI4mslave4_SLAVE4_AWREADY ),
        .SLAVE4_WREADY    ( AXI4mslave4_SLAVE4_WREADY ),
        .SLAVE4_BID       ( AXI4mslave4_SLAVE4_BID ),
        .SLAVE4_BRESP     ( AXI4mslave4_SLAVE4_BRESP ),
        .SLAVE4_BVALID    ( AXI4mslave4_SLAVE4_BVALID ),
        .SLAVE4_ARREADY   ( AXI4mslave4_SLAVE4_ARREADY ),
        .SLAVE4_RID       ( AXI4mslave4_SLAVE4_RID ),
        .SLAVE4_RDATA     ( AXI4mslave4_SLAVE4_RDATA ),
        .SLAVE4_RRESP     ( AXI4mslave4_SLAVE4_RRESP ),
        .SLAVE4_RLAST     ( AXI4mslave4_SLAVE4_RLAST ),
        .SLAVE4_RVALID    ( AXI4mslave4_SLAVE4_RVALID ),
        .SLAVE4_BUSER     ( AXI4mslave4_SLAVE4_BUSER ),
        .SLAVE4_RUSER     ( AXI4mslave4_SLAVE4_RUSER ),
        .MASTER0_AWID     ( AXI4mmaster0_MASTER0_AWID ),
        .MASTER0_AWADDR   ( AXI4mmaster0_MASTER0_AWADDR ),
        .MASTER0_AWLEN    ( AXI4mmaster0_MASTER0_AWLEN ),
        .MASTER0_AWSIZE   ( AXI4mmaster0_MASTER0_AWSIZE ),
        .MASTER0_AWBURST  ( AXI4mmaster0_MASTER0_AWBURST ),
        .MASTER0_AWLOCK   ( AXI4mmaster0_MASTER0_AWLOCK ),
        .MASTER0_AWCACHE  ( AXI4mmaster0_MASTER0_AWCACHE ),
        .MASTER0_AWPROT   ( AXI4mmaster0_MASTER0_AWPROT ),
        .MASTER0_AWQOS    ( AXI4mmaster0_MASTER0_AWQOS ),
        .MASTER0_AWREGION ( AXI4mmaster0_MASTER0_AWREGION ),
        .MASTER0_AWVALID  ( AXI4mmaster0_MASTER0_AWVALID ),
        .MASTER0_WDATA    ( AXI4mmaster0_MASTER0_WDATA ),
        .MASTER0_WSTRB    ( AXI4mmaster0_MASTER0_WSTRB ),
        .MASTER0_WLAST    ( AXI4mmaster0_MASTER0_WLAST ),
        .MASTER0_WVALID   ( AXI4mmaster0_MASTER0_WVALID ),
        .MASTER0_BREADY   ( AXI4mmaster0_MASTER0_BREADY ),
        .MASTER0_ARID     ( AXI4mmaster0_MASTER0_ARID ),
        .MASTER0_ARADDR   ( AXI4mmaster0_MASTER0_ARADDR ),
        .MASTER0_ARLEN    ( AXI4mmaster0_MASTER0_ARLEN ),
        .MASTER0_ARSIZE   ( AXI4mmaster0_MASTER0_ARSIZE ),
        .MASTER0_ARBURST  ( AXI4mmaster0_MASTER0_ARBURST ),
        .MASTER0_ARLOCK   ( AXI4mmaster0_MASTER0_ARLOCK ),
        .MASTER0_ARCACHE  ( AXI4mmaster0_MASTER0_ARCACHE ),
        .MASTER0_ARPROT   ( AXI4mmaster0_MASTER0_ARPROT ),
        .MASTER0_ARQOS    ( AXI4mmaster0_MASTER0_ARQOS ),
        .MASTER0_ARREGION ( AXI4mmaster0_MASTER0_ARREGION ),
        .MASTER0_ARVALID  ( AXI4mmaster0_MASTER0_ARVALID ),
        .MASTER0_RREADY   ( AXI4mmaster0_MASTER0_RREADY ),
        .MASTER0_AWUSER   ( AXI4mmaster0_MASTER0_AWUSER ),
        .MASTER0_WUSER    ( AXI4mmaster0_MASTER0_WUSER ),
        .MASTER0_ARUSER   ( AXI4mmaster0_MASTER0_ARUSER ),
        // Outputs
        .SLAVE0_AWID      ( FIC0_INITIATOR_AXI4mslave0_AWID ),
        .SLAVE0_AWADDR    ( FIC0_INITIATOR_AXI4mslave0_AWADDR ),
        .SLAVE0_AWLEN     ( FIC0_INITIATOR_AXI4mslave0_AWLEN ),
        .SLAVE0_AWSIZE    ( FIC0_INITIATOR_AXI4mslave0_AWSIZE ),
        .SLAVE0_AWBURST   ( FIC0_INITIATOR_AXI4mslave0_AWBURST ),
        .SLAVE0_AWLOCK    ( FIC0_INITIATOR_AXI4mslave0_AWLOCK ),
        .SLAVE0_AWCACHE   ( FIC0_INITIATOR_AXI4mslave0_AWCACHE ),
        .SLAVE0_AWPROT    ( FIC0_INITIATOR_AXI4mslave0_AWPROT ),
        .SLAVE0_AWQOS     ( FIC0_INITIATOR_AXI4mslave0_AWQOS ),
        .SLAVE0_AWREGION  ( FIC0_INITIATOR_AXI4mslave0_AWREGION ),
        .SLAVE0_AWVALID   ( FIC0_INITIATOR_AXI4mslave0_AWVALID ),
        .SLAVE0_WDATA     ( FIC0_INITIATOR_AXI4mslave0_WDATA ),
        .SLAVE0_WSTRB     ( FIC0_INITIATOR_AXI4mslave0_WSTRB ),
        .SLAVE0_WLAST     ( FIC0_INITIATOR_AXI4mslave0_WLAST ),
        .SLAVE0_WVALID    ( FIC0_INITIATOR_AXI4mslave0_WVALID ),
        .SLAVE0_BREADY    ( FIC0_INITIATOR_AXI4mslave0_BREADY ),
        .SLAVE0_ARID      ( FIC0_INITIATOR_AXI4mslave0_ARID ),
        .SLAVE0_ARADDR    ( FIC0_INITIATOR_AXI4mslave0_ARADDR ),
        .SLAVE0_ARLEN     ( FIC0_INITIATOR_AXI4mslave0_ARLEN ),
        .SLAVE0_ARSIZE    ( FIC0_INITIATOR_AXI4mslave0_ARSIZE ),
        .SLAVE0_ARBURST   ( FIC0_INITIATOR_AXI4mslave0_ARBURST ),
        .SLAVE0_ARLOCK    ( FIC0_INITIATOR_AXI4mslave0_ARLOCK ),
        .SLAVE0_ARCACHE   ( FIC0_INITIATOR_AXI4mslave0_ARCACHE ),
        .SLAVE0_ARPROT    ( FIC0_INITIATOR_AXI4mslave0_ARPROT ),
        .SLAVE0_ARQOS     ( FIC0_INITIATOR_AXI4mslave0_ARQOS ),
        .SLAVE0_ARREGION  ( FIC0_INITIATOR_AXI4mslave0_ARREGION ),
        .SLAVE0_ARVALID   ( FIC0_INITIATOR_AXI4mslave0_ARVALID ),
        .SLAVE0_RREADY    ( FIC0_INITIATOR_AXI4mslave0_RREADY ),
        .SLAVE0_AWUSER    ( FIC0_INITIATOR_AXI4mslave0_AWUSER ),
        .SLAVE0_WUSER     ( FIC0_INITIATOR_AXI4mslave0_WUSER ),
        .SLAVE0_ARUSER    ( FIC0_INITIATOR_AXI4mslave0_ARUSER ),
        .SLAVE1_AWID      ( FIC0_INITIATOR_AXI4mslave1_AWID ),
        .SLAVE1_AWADDR    ( FIC0_INITIATOR_AXI4mslave1_AWADDR ),
        .SLAVE1_AWLEN     ( FIC0_INITIATOR_AXI4mslave1_AWLEN ),
        .SLAVE1_AWSIZE    ( FIC0_INITIATOR_AXI4mslave1_AWSIZE ),
        .SLAVE1_AWBURST   ( FIC0_INITIATOR_AXI4mslave1_AWBURST ),
        .SLAVE1_AWLOCK    ( FIC0_INITIATOR_AXI4mslave1_AWLOCK ),
        .SLAVE1_AWCACHE   ( FIC0_INITIATOR_AXI4mslave1_AWCACHE ),
        .SLAVE1_AWPROT    ( FIC0_INITIATOR_AXI4mslave1_AWPROT ),
        .SLAVE1_AWQOS     ( FIC0_INITIATOR_AXI4mslave1_AWQOS ),
        .SLAVE1_AWREGION  ( FIC0_INITIATOR_AXI4mslave1_AWREGION ),
        .SLAVE1_AWVALID   ( FIC0_INITIATOR_AXI4mslave1_AWVALID ),
        .SLAVE1_WDATA     ( FIC0_INITIATOR_AXI4mslave1_WDATA ),
        .SLAVE1_WSTRB     ( FIC0_INITIATOR_AXI4mslave1_WSTRB ),
        .SLAVE1_WLAST     ( FIC0_INITIATOR_AXI4mslave1_WLAST ),
        .SLAVE1_WVALID    ( FIC0_INITIATOR_AXI4mslave1_WVALID ),
        .SLAVE1_BREADY    ( FIC0_INITIATOR_AXI4mslave1_BREADY ),
        .SLAVE1_ARID      ( FIC0_INITIATOR_AXI4mslave1_ARID ),
        .SLAVE1_ARADDR    ( FIC0_INITIATOR_AXI4mslave1_ARADDR ),
        .SLAVE1_ARLEN     ( FIC0_INITIATOR_AXI4mslave1_ARLEN ),
        .SLAVE1_ARSIZE    ( FIC0_INITIATOR_AXI4mslave1_ARSIZE ),
        .SLAVE1_ARBURST   ( FIC0_INITIATOR_AXI4mslave1_ARBURST ),
        .SLAVE1_ARLOCK    ( FIC0_INITIATOR_AXI4mslave1_ARLOCK ),
        .SLAVE1_ARCACHE   ( FIC0_INITIATOR_AXI4mslave1_ARCACHE ),
        .SLAVE1_ARPROT    ( FIC0_INITIATOR_AXI4mslave1_ARPROT ),
        .SLAVE1_ARQOS     ( FIC0_INITIATOR_AXI4mslave1_ARQOS ),
        .SLAVE1_ARREGION  ( FIC0_INITIATOR_AXI4mslave1_ARREGION ),
        .SLAVE1_ARVALID   ( FIC0_INITIATOR_AXI4mslave1_ARVALID ),
        .SLAVE1_RREADY    ( FIC0_INITIATOR_AXI4mslave1_RREADY ),
        .SLAVE1_AWUSER    ( FIC0_INITIATOR_AXI4mslave1_AWUSER ),
        .SLAVE1_WUSER     ( FIC0_INITIATOR_AXI4mslave1_WUSER ),
        .SLAVE1_ARUSER    ( FIC0_INITIATOR_AXI4mslave1_ARUSER ),
        .SLAVE2_AWID      ( FIC0_INITIATOR_AXI4mslave2_0_AWID ),
        .SLAVE2_AWADDR    ( FIC0_INITIATOR_AXI4mslave2_0_AWADDR ),
        .SLAVE2_AWLEN     ( FIC0_INITIATOR_AXI4mslave2_0_AWLEN ),
        .SLAVE2_AWSIZE    ( FIC0_INITIATOR_AXI4mslave2_0_AWSIZE ),
        .SLAVE2_AWBURST   ( FIC0_INITIATOR_AXI4mslave2_0_AWBURST ),
        .SLAVE2_AWLOCK    ( FIC0_INITIATOR_AXI4mslave2_0_AWLOCK ),
        .SLAVE2_AWCACHE   ( FIC0_INITIATOR_AXI4mslave2_0_AWCACHE ),
        .SLAVE2_AWPROT    ( FIC0_INITIATOR_AXI4mslave2_0_AWPROT ),
        .SLAVE2_AWQOS     ( FIC0_INITIATOR_AXI4mslave2_0_AWQOS ),
        .SLAVE2_AWREGION  ( FIC0_INITIATOR_AXI4mslave2_0_AWREGION ),
        .SLAVE2_AWVALID   ( FIC0_INITIATOR_AXI4mslave2_0_AWVALID ),
        .SLAVE2_WDATA     ( FIC0_INITIATOR_AXI4mslave2_0_WDATA ),
        .SLAVE2_WSTRB     ( FIC0_INITIATOR_AXI4mslave2_0_WSTRB ),
        .SLAVE2_WLAST     ( FIC0_INITIATOR_AXI4mslave2_0_WLAST ),
        .SLAVE2_WVALID    ( FIC0_INITIATOR_AXI4mslave2_0_WVALID ),
        .SLAVE2_BREADY    ( FIC0_INITIATOR_AXI4mslave2_0_BREADY ),
        .SLAVE2_ARID      ( FIC0_INITIATOR_AXI4mslave2_0_ARID ),
        .SLAVE2_ARADDR    ( FIC0_INITIATOR_AXI4mslave2_0_ARADDR ),
        .SLAVE2_ARLEN     ( FIC0_INITIATOR_AXI4mslave2_0_ARLEN ),
        .SLAVE2_ARSIZE    ( FIC0_INITIATOR_AXI4mslave2_0_ARSIZE ),
        .SLAVE2_ARBURST   ( FIC0_INITIATOR_AXI4mslave2_0_ARBURST ),
        .SLAVE2_ARLOCK    ( FIC0_INITIATOR_AXI4mslave2_0_ARLOCK ),
        .SLAVE2_ARCACHE   ( FIC0_INITIATOR_AXI4mslave2_0_ARCACHE ),
        .SLAVE2_ARPROT    ( FIC0_INITIATOR_AXI4mslave2_0_ARPROT ),
        .SLAVE2_ARQOS     ( FIC0_INITIATOR_AXI4mslave2_0_ARQOS ),
        .SLAVE2_ARREGION  ( FIC0_INITIATOR_AXI4mslave2_0_ARREGION ),
        .SLAVE2_ARVALID   ( FIC0_INITIATOR_AXI4mslave2_0_ARVALID ),
        .SLAVE2_RREADY    ( FIC0_INITIATOR_AXI4mslave2_0_RREADY ),
        .SLAVE2_AWUSER    ( FIC0_INITIATOR_AXI4mslave2_0_AWUSER ),
        .SLAVE2_WUSER     ( FIC0_INITIATOR_AXI4mslave2_0_WUSER ),
        .SLAVE2_ARUSER    ( FIC0_INITIATOR_AXI4mslave2_0_ARUSER ),
        .SLAVE3_AWID      ( AXI4mslave3_0_AWID ),
        .SLAVE3_AWADDR    ( AXI4mslave3_0_AWADDR ),
        .SLAVE3_AWLEN     ( AXI4mslave3_0_AWLEN ),
        .SLAVE3_AWSIZE    ( AXI4mslave3_0_AWSIZE ),
        .SLAVE3_AWBURST   ( AXI4mslave3_0_AWBURST ),
        .SLAVE3_AWLOCK    ( AXI4mslave3_0_AWLOCK ),
        .SLAVE3_AWCACHE   ( AXI4mslave3_0_AWCACHE ),
        .SLAVE3_AWPROT    ( AXI4mslave3_0_AWPROT ),
        .SLAVE3_AWQOS     ( AXI4mslave3_0_AWQOS ),
        .SLAVE3_AWREGION  ( AXI4mslave3_0_AWREGION ),
        .SLAVE3_AWVALID   ( AXI4mslave3_0_AWVALID ),
        .SLAVE3_WDATA     ( AXI4mslave3_0_WDATA ),
        .SLAVE3_WSTRB     ( AXI4mslave3_0_WSTRB ),
        .SLAVE3_WLAST     ( AXI4mslave3_0_WLAST ),
        .SLAVE3_WVALID    ( AXI4mslave3_0_WVALID ),
        .SLAVE3_BREADY    ( AXI4mslave3_0_BREADY ),
        .SLAVE3_ARID      ( AXI4mslave3_0_ARID ),
        .SLAVE3_ARADDR    ( AXI4mslave3_0_ARADDR ),
        .SLAVE3_ARLEN     ( AXI4mslave3_0_ARLEN ),
        .SLAVE3_ARSIZE    ( AXI4mslave3_0_ARSIZE ),
        .SLAVE3_ARBURST   ( AXI4mslave3_0_ARBURST ),
        .SLAVE3_ARLOCK    ( AXI4mslave3_0_ARLOCK ),
        .SLAVE3_ARCACHE   ( AXI4mslave3_0_ARCACHE ),
        .SLAVE3_ARPROT    ( AXI4mslave3_0_ARPROT ),
        .SLAVE3_ARQOS     ( AXI4mslave3_0_ARQOS ),
        .SLAVE3_ARREGION  ( AXI4mslave3_0_ARREGION ),
        .SLAVE3_ARVALID   ( AXI4mslave3_0_ARVALID ),
        .SLAVE3_RREADY    ( AXI4mslave3_0_RREADY ),
        .SLAVE3_AWUSER    ( AXI4mslave3_0_AWUSER ),
        .SLAVE3_WUSER     ( AXI4mslave3_0_WUSER ),
        .SLAVE3_ARUSER    ( AXI4mslave3_0_ARUSER ),
        .SLAVE4_AWID      ( AXI4mslave4_0_AWID ),
        .SLAVE4_AWADDR    ( AXI4mslave4_0_AWADDR ),
        .SLAVE4_AWLEN     ( AXI4mslave4_0_AWLEN ),
        .SLAVE4_AWSIZE    ( AXI4mslave4_0_AWSIZE ),
        .SLAVE4_AWBURST   ( AXI4mslave4_0_AWBURST ),
        .SLAVE4_AWLOCK    ( AXI4mslave4_0_AWLOCK ),
        .SLAVE4_AWCACHE   ( AXI4mslave4_0_AWCACHE ),
        .SLAVE4_AWPROT    ( AXI4mslave4_0_AWPROT ),
        .SLAVE4_AWQOS     ( AXI4mslave4_0_AWQOS ),
        .SLAVE4_AWREGION  ( AXI4mslave4_0_AWREGION ),
        .SLAVE4_AWVALID   ( AXI4mslave4_0_AWVALID ),
        .SLAVE4_WDATA     ( AXI4mslave4_0_WDATA ),
        .SLAVE4_WSTRB     ( AXI4mslave4_0_WSTRB ),
        .SLAVE4_WLAST     ( AXI4mslave4_0_WLAST ),
        .SLAVE4_WVALID    ( AXI4mslave4_0_WVALID ),
        .SLAVE4_BREADY    ( AXI4mslave4_0_BREADY ),
        .SLAVE4_ARID      ( AXI4mslave4_0_ARID ),
        .SLAVE4_ARADDR    ( AXI4mslave4_0_ARADDR ),
        .SLAVE4_ARLEN     ( AXI4mslave4_0_ARLEN ),
        .SLAVE4_ARSIZE    ( AXI4mslave4_0_ARSIZE ),
        .SLAVE4_ARBURST   ( AXI4mslave4_0_ARBURST ),
        .SLAVE4_ARLOCK    ( AXI4mslave4_0_ARLOCK ),
        .SLAVE4_ARCACHE   ( AXI4mslave4_0_ARCACHE ),
        .SLAVE4_ARPROT    ( AXI4mslave4_0_ARPROT ),
        .SLAVE4_ARQOS     ( AXI4mslave4_0_ARQOS ),
        .SLAVE4_ARREGION  ( AXI4mslave4_0_ARREGION ),
        .SLAVE4_ARVALID   ( AXI4mslave4_0_ARVALID ),
        .SLAVE4_RREADY    ( AXI4mslave4_0_RREADY ),
        .SLAVE4_AWUSER    ( AXI4mslave4_0_AWUSER ),
        .SLAVE4_WUSER     ( AXI4mslave4_0_WUSER ),
        .SLAVE4_ARUSER    ( AXI4mslave4_0_ARUSER ),
        .MASTER0_AWREADY  ( AXI4mmaster0_AWREADY ),
        .MASTER0_WREADY   ( AXI4mmaster0_WREADY ),
        .MASTER0_BID      ( AXI4mmaster0_BID ),
        .MASTER0_BRESP    ( AXI4mmaster0_BRESP ),
        .MASTER0_BVALID   ( AXI4mmaster0_BVALID ),
        .MASTER0_ARREADY  ( AXI4mmaster0_ARREADY ),
        .MASTER0_RID      ( AXI4mmaster0_RID ),
        .MASTER0_RDATA    ( AXI4mmaster0_RDATA ),
        .MASTER0_RRESP    ( AXI4mmaster0_RRESP ),
        .MASTER0_RLAST    ( AXI4mmaster0_RLAST ),
        .MASTER0_RVALID   ( AXI4mmaster0_RVALID ),
        .MASTER0_BUSER    ( AXI4mmaster0_BUSER ),
        .MASTER0_RUSER    ( AXI4mmaster0_RUSER ) 
        );

//--------MSS_LSRAM
MSS_LSRAM MSS_LSRAM_inst_0(
        // Inputs
        .ACLK    ( ACLK ),
        .ARESETN ( ARESETN ),
        .AWVALID ( FIC0_INITIATOR_AXI4mslave1_AWVALID ),
        .WLAST   ( FIC0_INITIATOR_AXI4mslave1_WLAST ),
        .WVALID  ( FIC0_INITIATOR_AXI4mslave1_WVALID ),
        .BREADY  ( FIC0_INITIATOR_AXI4mslave1_BREADY ),
        .ARVALID ( FIC0_INITIATOR_AXI4mslave1_ARVALID ),
        .RREADY  ( FIC0_INITIATOR_AXI4mslave1_RREADY ),
        .AWADDR  ( FIC0_INITIATOR_AXI4mslave1_AWADDR_0 ),
        .AWLEN   ( FIC0_INITIATOR_AXI4mslave1_AWLEN ),
        .AWSIZE  ( FIC0_INITIATOR_AXI4mslave1_AWSIZE ),
        .AWBURST ( FIC0_INITIATOR_AXI4mslave1_AWBURST ),
        .AWLOCK  ( FIC0_INITIATOR_AXI4mslave1_AWLOCK ),
        .AWCACHE ( FIC0_INITIATOR_AXI4mslave1_AWCACHE ),
        .AWPROT  ( FIC0_INITIATOR_AXI4mslave1_AWPROT ),
        .WDATA   ( FIC0_INITIATOR_AXI4mslave1_WDATA ),
        .WSTRB   ( FIC0_INITIATOR_AXI4mslave1_WSTRB ),
        .ARADDR  ( FIC0_INITIATOR_AXI4mslave1_ARADDR_0 ),
        .ARLEN   ( FIC0_INITIATOR_AXI4mslave1_ARLEN ),
        .ARSIZE  ( FIC0_INITIATOR_AXI4mslave1_ARSIZE ),
        .ARBURST ( FIC0_INITIATOR_AXI4mslave1_ARBURST ),
        .ARLOCK  ( FIC0_INITIATOR_AXI4mslave1_ARLOCK ),
        .ARCACHE ( FIC0_INITIATOR_AXI4mslave1_ARCACHE ),
        .ARPROT  ( FIC0_INITIATOR_AXI4mslave1_ARPROT ),
        .AWID    ( FIC0_INITIATOR_AXI4mslave1_AWID_0 ),
        .ARID    ( FIC0_INITIATOR_AXI4mslave1_ARID_0 ),
        // Outputs
        .AWREADY ( FIC0_INITIATOR_AXI4mslave1_AWREADY ),
        .WREADY  ( FIC0_INITIATOR_AXI4mslave1_WREADY ),
        .BVALID  ( FIC0_INITIATOR_AXI4mslave1_BVALID ),
        .ARREADY ( FIC0_INITIATOR_AXI4mslave1_ARREADY ),
        .RLAST   ( FIC0_INITIATOR_AXI4mslave1_RLAST ),
        .RVALID  ( FIC0_INITIATOR_AXI4mslave1_RVALID ),
        .RDATA   ( FIC0_INITIATOR_AXI4mslave1_RDATA ),
        .RRESP   ( FIC0_INITIATOR_AXI4mslave1_RRESP ),
        .BRESP   ( FIC0_INITIATOR_AXI4mslave1_BRESP ),
        .BID     ( FIC0_INITIATOR_AXI4mslave1_BID ),
        .RID     ( FIC0_INITIATOR_AXI4mslave1_RID ) 
        );

//--------security_core
security_core #( 
        .SHARES ( 3 ) )
security_core_0(
        // Inputs
        .clk     ( ACLK ),
        .resetn  ( ARESETN ),
        .awvalid ( FIC0_INITIATOR_AXI4mslave2_0_AWVALID ),
        .wvalid  ( FIC0_INITIATOR_AXI4mslave2_0_WVALID ),
        .bready  ( FIC0_INITIATOR_AXI4mslave2_0_BREADY ),
        .arvalid ( FIC0_INITIATOR_AXI4mslave2_0_ARVALID ),
        .rready  ( FIC0_INITIATOR_AXI4mslave2_0_RREADY ),
        .awaddr  ( FIC0_INITIATOR_AXI4mslave2_0_AWADDR_0 ),
        .wdata   ( FIC0_INITIATOR_AXI4mslave2_0_WDATA ),
        .wstrb   ( FIC0_INITIATOR_AXI4mslave2_0_WSTRB ),
        .araddr  ( FIC0_INITIATOR_AXI4mslave2_0_ARADDR_0 ),
        // Outputs
        .awready ( FIC0_INITIATOR_AXI4mslave2_0_AWREADY ),
        .wready  ( FIC0_INITIATOR_AXI4mslave2_0_WREADY ),
        .bvalid  ( FIC0_INITIATOR_AXI4mslave2_0_BVALID ),
        .arready ( FIC0_INITIATOR_AXI4mslave2_0_ARREADY ),
        .rvalid  ( FIC0_INITIATOR_AXI4mslave2_0_RVALID ),
        .bresp   ( FIC0_INITIATOR_AXI4mslave2_0_BRESP ),
        .rdata   ( FIC0_INITIATOR_AXI4mslave2_0_RDATA ),
        .rresp   ( FIC0_INITIATOR_AXI4mslave2_0_RRESP ) 
        );


endmodule
