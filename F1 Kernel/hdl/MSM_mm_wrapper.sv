// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
module MSM_mm_wrapper #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 256,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH = 512,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M02_AXI_DATA_WIDTH = 512,
  parameter integer C_M03_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M03_AXI_DATA_WIDTH = 512,
  parameter integer C_M04_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M04_AXI_DATA_WIDTH = 512,
  parameter integer C_M05_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M05_AXI_DATA_WIDTH = 512
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // AXI4 master interface m01_axi
  output wire                              m01_axi_awvalid,
  input  wire                              m01_axi_awready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_awaddr ,
  output wire [8-1:0]                      m01_axi_awlen  ,
  output wire                              m01_axi_wvalid ,
  input  wire                              m01_axi_wready ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_wdata  ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb  ,
  output wire                              m01_axi_wlast  ,
  input  wire                              m01_axi_bvalid ,
  output wire                              m01_axi_bready ,
  output wire                              m01_axi_arvalid,
  input  wire                              m01_axi_arready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_araddr ,
  output wire [8-1:0]                      m01_axi_arlen  ,
  input  wire                              m01_axi_rvalid ,
  output wire                              m01_axi_rready ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_rdata  ,
  input  wire                              m01_axi_rlast  ,
  // AXI4 master interface m02_axi
  output wire                              m02_axi_awvalid,
  input  wire                              m02_axi_awready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_awaddr ,
  output wire [8-1:0]                      m02_axi_awlen  ,
  output wire                              m02_axi_wvalid ,
  input  wire                              m02_axi_wready ,
  output wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_wdata  ,
  output wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb  ,
  output wire                              m02_axi_wlast  ,
  input  wire                              m02_axi_bvalid ,
  output wire                              m02_axi_bready ,
  output wire                              m02_axi_arvalid,
  input  wire                              m02_axi_arready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_araddr ,
  output wire [8-1:0]                      m02_axi_arlen  ,
  input  wire                              m02_axi_rvalid ,
  output wire                              m02_axi_rready ,
  input  wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_rdata  ,
  input  wire                              m02_axi_rlast  ,
  // AXI4 master interface m03_axi
  output wire                              m03_axi_awvalid,
  input  wire                              m03_axi_awready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_awaddr ,
  output wire [8-1:0]                      m03_axi_awlen  ,
  output wire                              m03_axi_wvalid ,
  input  wire                              m03_axi_wready ,
  output wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_wdata  ,
  output wire [C_M03_AXI_DATA_WIDTH/8-1:0] m03_axi_wstrb  ,
  output wire                              m03_axi_wlast  ,
  input  wire                              m03_axi_bvalid ,
  output wire                              m03_axi_bready ,
  output wire                              m03_axi_arvalid,
  input  wire                              m03_axi_arready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_araddr ,
  output wire [8-1:0]                      m03_axi_arlen  ,
  input  wire                              m03_axi_rvalid ,
  output wire                              m03_axi_rready ,
  input  wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_rdata  ,
  input  wire                              m03_axi_rlast  ,
  // AXI4 master interface m04_axi
  output wire                              m04_axi_awvalid,
  input  wire                              m04_axi_awready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_awaddr ,
  output wire [8-1:0]                      m04_axi_awlen  ,
  output wire                              m04_axi_wvalid ,
  input  wire                              m04_axi_wready ,
  output wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_wdata  ,
  output wire [C_M04_AXI_DATA_WIDTH/8-1:0] m04_axi_wstrb  ,
  output wire                              m04_axi_wlast  ,
  input  wire                              m04_axi_bvalid ,
  output wire                              m04_axi_bready ,
  output wire                              m04_axi_arvalid,
  input  wire                              m04_axi_arready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_araddr ,
  output wire [8-1:0]                      m04_axi_arlen  ,
  input  wire                              m04_axi_rvalid ,
  output wire                              m04_axi_rready ,
  input  wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_rdata  ,
  input  wire                              m04_axi_rlast  ,
  // AXI4 master interface m05_axi
  output wire                              m05_axi_awvalid,
  input  wire                              m05_axi_awready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_awaddr ,
  output wire [8-1:0]                      m05_axi_awlen  ,
  output wire                              m05_axi_wvalid ,
  input  wire                              m05_axi_wready ,
  output wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_wdata  ,
  output wire [C_M05_AXI_DATA_WIDTH/8-1:0] m05_axi_wstrb  ,
  output wire                              m05_axi_wlast  ,
  input  wire                              m05_axi_bvalid ,
  output wire                              m05_axi_bready ,
  output wire                              m05_axi_arvalid,
  input  wire                              m05_axi_arready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_araddr ,
  output wire [8-1:0]                      m05_axi_arlen  ,
  input  wire                              m05_axi_rvalid ,
  output wire                              m05_axi_rready ,
  input  wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_rdata  ,
  input  wire                              m05_axi_rlast  ,
  // Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  output wire                              ap_ready       ,
  input  wire [32-1:0]                     n              ,
  input  wire [64-1:0]                     x_n            ,
  input  wire [64-1:0]                     G_x            ,
  input  wire [64-1:0]                     G_y            ,
  input  wire [64-1:0]                     R_x            ,
  input  wire [64-1:0]                     R_y            ,
  input  wire [64-1:0]                     R_z            
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 2048; //16384;
localparam integer  XFER_SIZE_FROM_HOST = 8192; //131072;
localparam integer  LOG_XFER_SIZE_FROM_HOST = $clog2(XFER_SIZE_FROM_HOST);
localparam integer  XFER_SIZE_TO_HOST = 2048; //65536;
localparam integer  LOG_XFER_SIZE_TO_HOST = $clog2(XFER_SIZE_TO_HOST);
localparam integer  LP_NUM_EXAMPLES    = 6;
localparam integer  CE_XFER_SIZE_WIDTH = C_M00_AXI_DATA_WIDTH;
localparam integer  CV_XFER_SIZE_WIDTH = C_M01_AXI_DATA_WIDTH;



///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [64-1:0]                       ctrl_xfer_size_fh_in_bytes     ;//= XFER_SIZE_FROM_HOST;
logic [64-1:0]                       ctrl_xfer_size_th_in_bytes     = XFER_SIZE_TO_HOST;
logic [32-1:0]                       ctrl_constant                  = 32'd1;

assign ctrl_xfer_size_fh_in_bytes = {{26{1'b0}}, n, {6{1'b0}}}; // n: number of points, 64 bytes per coordinate.
 
///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_done); //? '0 : ap_done_r | ap_done_i;
  end
end


// Ready Logic (non-pipelined case)
assign ap_ready = ap_done;

/////////////////////////////////////////////
// MSM IP Core
/////////////////////////////////////////////

msm_axis_wrapper #(
    .C(12),
    .U(512),
    .M(8)
)
msm_axis_wrapper_inst (
    .clk  ( ap_clk  ),
    .rst  ( areset  ),
    .done ( ap_done ),
    //.m ( ctrl_constant ), // TODO: implement
    .s00_axis_tdata  ( s00_axis_tdata  ),
    .s00_axis_tvalid ( s00_axis_tvalid ),
    .s00_axis_tlast  ( s00_axis_tlast  ),
    .s01_axis_tdata  ( s01_axis_tdata  ),
    .s01_axis_tvalid ( s01_axis_tvalid ),
    .s01_axis_tlast  ( s01_axis_tlast  ),
    .s02_axis_tdata  ( s02_axis_tdata  ),
    .s02_axis_tvalid ( s02_axis_tvalid ),
    .s02_axis_tlast  ( s02_axis_tlast  ),
    .m00_axis_tdata  ( m00_axis_tdata  ),
    .m00_axis_tready ( m00_axis_tready ),
    .m00_axis_tvalid ( m00_axis_tvalid ),
    .m01_axis_tdata  ( m01_axis_tdata  ),
    .m01_axis_tready ( m01_axis_tready ),
    .m01_axis_tvalid ( m01_axis_tvalid ),
    .m02_axis_tdata  ( m02_axis_tdata  ),
    .m02_axis_tready ( m02_axis_tready ),
    .m02_axis_tvalid ( m02_axis_tvalid )
);

////////////////////////////////////////////
// AXI interfaces
////////////////////////////////////////////

//////////////////////////////
// Port 0 is Input only to MSM

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP0_DW_BYTES             = C_M00_AXI_DATA_WIDTH/8;
localparam integer LP0_AXI_BURST_LEN        = 4096/LP0_DW_BYTES < 256 ? 4096/LP0_DW_BYTES : 256;
localparam integer LP0_LOG_BURST_LEN        = $clog2(LP0_AXI_BURST_LEN);
localparam integer LP0_BRAM_DEPTH           = 512;
localparam integer LP0_RD_MAX_OUTSTANDING   = LP0_BRAM_DEPTH / LP0_AXI_BURST_LEN;


// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                            s00_axis_tvalid;
logic                            s00_axis_tready;
logic                            s00_axis_tlast;
logic [C_M00_AXI_DATA_WIDTH-1:0] s00_axis_tdata;

// AXI write master stage
logic                          write_done;

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
MSM_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ),
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ),
  .C_XFER_SIZE_WIDTH   ( C_M00_AXI_ADDR_WIDTH    ),//CE_XFER_SIZE_WIDTH     ),
  .C_MAX_OUTSTANDING   ( LP0_RD_MAX_OUTSTANDING  ),
  .C_INCLUDE_DATA_FIFO ( 1                       )
)
inst_axi_read_master_01 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse          ) ,
  .ctrl_done               (                         ) ,  // Not used
  .ctrl_addr_offset        ( x_n                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_fh_in_bytes ) ,
  .m_axi_arvalid           ( m00_axi_arvalid         ) ,
  .m_axi_arready           ( m00_axi_arready         ) ,
  .m_axi_araddr            ( m00_axi_araddr          ) ,
  .m_axi_arlen             ( m00_axi_arlen           ) ,
  .m_axi_rvalid            ( m00_axi_rvalid          ) ,
  .m_axi_rready            ( m00_axi_rready          ) ,
  .m_axi_rdata             ( m00_axi_rdata           ) ,
  .m_axi_rlast             ( m00_axi_rlast           ) ,
  .m_axis_aclk             ( ap_clk                  ) ,
  .m_axis_areset           ( areset                  ) ,
  .m_axis_tvalid           ( s00_axis_tvalid         ) ,
  .m_axis_tready           ( 1'b1                    ) , // s00_axis_tready         ) , Fifo not full
  .m_axis_tlast            ( s00_axis_tlast          ) ,
  .m_axis_tdata            ( s00_axis_tdata          )
);

assign m00_axi_awvalid = 1'b0;
assign m00_axi_wvalid = 1'b0;
assign m00_axi_bready = 1'b0;
assign m00_axi_wlast = 1'b0;
assign m00_axi_wdata = {C_M00_AXI_DATA_WIDTH {1'b0}};
assign m00_axi_wstrb = {C_M00_AXI_DATA_WIDTH/8 {1'b0}};
assign m00_axi_awaddr = {C_M00_AXI_ADDR_WIDTH {1'b0}};
assign m00_axi_awlen = {C_M00_AXI_ADDR_WIDTH/8 {1'b0}};

//////////////////////////////
// Port 1 is Input only to MSM

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP1_DW_BYTES             = C_M01_AXI_DATA_WIDTH/8;
localparam integer LP1_AXI_BURST_LEN        = 4096/LP1_DW_BYTES < 256 ? 4096/LP1_DW_BYTES : 256;
localparam integer LP1_LOG_BURST_LEN        = $clog2(LP1_AXI_BURST_LEN);
localparam integer LP1_BRAM_DEPTH           = 512;
localparam integer LP1_RD_MAX_OUTSTANDING   = LP1_BRAM_DEPTH / LP1_AXI_BURST_LEN;

// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                          s01_axis_tvalid;
logic                          s01_axis_tready;
logic                          s01_axis_tlast;
logic [C_M01_AXI_DATA_WIDTH-1:0] s01_axis_tdata;

// AXI write master stage
//logic                          write_done;

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
MSM_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M01_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M01_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_M01_AXI_ADDR_WIDTH    ) , //CV_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP1_RD_MAX_OUTSTANDING  ) ,
  .C_INCLUDE_DATA_FIFO ( 1                       )
)
inst_axi_read_master_02 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse          ) ,
  .ctrl_done               (                         ) ,  // Not used
  .ctrl_addr_offset        ( G_x                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_fh_in_bytes ) ,
  .m_axi_arvalid           ( m01_axi_arvalid         ) ,
  .m_axi_arready           ( m01_axi_arready         ) ,
  .m_axi_araddr            ( m01_axi_araddr          ) ,
  .m_axi_arlen             ( m01_axi_arlen           ) ,
  .m_axi_rvalid            ( m01_axi_rvalid          ) ,
  .m_axi_rready            ( m01_axi_rready          ) ,
  .m_axi_rdata             ( m01_axi_rdata           ) ,
  .m_axi_rlast             ( m01_axi_rlast           ) ,
  .m_axis_aclk             ( ap_clk                  ) ,
  .m_axis_areset           ( areset                  ) ,
  .m_axis_tvalid           ( s01_axis_tvalid         ) ,
  .m_axis_tready           ( 1'b1                    ) , // s01_axis_tready         ) , Fifo not full
  .m_axis_tlast            ( s01_axis_tlast          ) ,
  .m_axis_tdata            ( s01_axis_tdata          )
);

assign m01_axi_awvalid = 1'b0;
assign m01_axi_wvalid = 1'b0;
assign m01_axi_bready = 1'b0;
assign m01_axi_wlast = 1'b0;
assign m01_axi_wdata = {C_M01_AXI_DATA_WIDTH {1'b0}};
assign m01_axi_wstrb = {C_M01_AXI_DATA_WIDTH/8 {1'b0}};
assign m01_axi_awaddr = {C_M01_AXI_ADDR_WIDTH {1'b0}};
assign m01_axi_awlen = {C_M01_AXI_ADDR_WIDTH/8 {1'b0}};

//////////////////////////////
// Port 2 is Input only to MSM

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP2_DW_BYTES             = C_M02_AXI_DATA_WIDTH/8;
localparam integer LP2_AXI_BURST_LEN        = 4096/LP2_DW_BYTES < 256 ? 4096/LP2_DW_BYTES : 256;
localparam integer LP2_LOG_BURST_LEN        = $clog2(LP2_AXI_BURST_LEN);
localparam integer LP2_BRAM_DEPTH           = 512;
localparam integer LP2_RD_MAX_OUTSTANDING   = LP2_BRAM_DEPTH / LP2_AXI_BURST_LEN;
// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                            s02_axis_tvalid;
logic                            s02_axis_tready;
logic                            s02_axis_tlast;
logic [C_M02_AXI_DATA_WIDTH-1:0] s02_axis_tdata;

// AXI write master stage
//logic                          write_done;

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
MSM_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M02_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M02_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_M02_AXI_ADDR_WIDTH    ), //CV_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP2_RD_MAX_OUTSTANDING  ) ,
  .C_INCLUDE_DATA_FIFO ( 1                       )
)
inst_axi_read_master_03 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse          ) ,
  .ctrl_done               (                         ) ,  // Not used
  .ctrl_addr_offset        ( G_y                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_fh_in_bytes ) ,
  .m_axi_arvalid           ( m02_axi_arvalid         ) ,
  .m_axi_arready           ( m02_axi_arready         ) ,
  .m_axi_araddr            ( m02_axi_araddr          ) ,
  .m_axi_arlen             ( m02_axi_arlen           ) ,
  .m_axi_rvalid            ( m02_axi_rvalid          ) ,
  .m_axi_rready            ( m02_axi_rready          ) ,
  .m_axi_rdata             ( m02_axi_rdata           ) ,
  .m_axi_rlast             ( m02_axi_rlast           ) ,
  .m_axis_aclk             ( ap_clk                  ) ,
  .m_axis_areset           ( areset                  ) ,
  .m_axis_tvalid           ( s02_axis_tvalid         ) ,
  .m_axis_tready           ( 1'b1                    ) , // s02_axis_tready         ) , Fifo not full
  .m_axis_tlast            ( s02_axis_tlast          ) ,
  .m_axis_tdata            ( s02_axis_tdata          )
);

assign m02_axi_awvalid = 1'b0;
assign m02_axi_wvalid = 1'b0;
assign m02_axi_bready = 1'b0;
assign m02_axi_wlast = 1'b0;
assign m02_axi_wdata = {C_M02_AXI_DATA_WIDTH {1'b0}};
assign m02_axi_wstrb = {C_M02_AXI_DATA_WIDTH/8 {1'b0}};
assign m02_axi_awaddr = {C_M02_AXI_ADDR_WIDTH {1'b0}};
assign m02_axi_awlen = {C_M02_AXI_ADDR_WIDTH/8 {1'b0}};

/////////////////////////////////
// Port 3 is Output only from MSM

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_WR_MAX_OUTSTANDING   = 32;

// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                          m00_axis_tvalid;
logic                          m00_axis_tready;
logic [C_M03_AXI_DATA_WIDTH-1:0] m00_axis_tdata;

// AXI write master stage
//logic                          write_done;

// AXI4 Write Master
MSM_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M03_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M03_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_M03_AXI_ADDR_WIDTH  ) ,//CV_XFER_SIZE_WIDTH    ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master_01 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               (                         ) , // Not used
  .ctrl_addr_offset        ( R_x                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_th_in_bytes ) ,
  .m_axi_awvalid           ( m03_axi_awvalid         ) ,
  .m_axi_awready           ( m03_axi_awready         ) ,
  .m_axi_awaddr            ( m03_axi_awaddr          ) ,
  .m_axi_awlen             ( m03_axi_awlen           ) ,
  .m_axi_wvalid            ( m03_axi_wvalid          ) ,
  .m_axi_wready            ( m03_axi_wready          ) ,
  .m_axi_wdata             ( m03_axi_wdata           ) ,
  .m_axi_wstrb             ( m03_axi_wstrb           ) ,
  .m_axi_wlast             ( m03_axi_wlast           ) ,
  .m_axi_bvalid            ( m03_axi_bvalid          ) ,
  .m_axi_bready            ( m03_axi_bready          ) ,
  .s_axis_aclk             ( ap_clk                  ) ,
  .s_axis_areset           ( areset                  ) ,
  .s_axis_tvalid           ( m00_axis_tvalid         ) ,
  .s_axis_tready           ( m00_axis_tready         ) ,  // Not used
  .s_axis_tdata            ( m00_axis_tdata          )
);

assign m03_axi_arvalid = 1'b0;
assign m03_axi_rready = 1'b0;
assign m03_axi_araddr = {C_M03_AXI_ADDR_WIDTH {1'b0}};
assign m03_axi_arlen = {C_M03_AXI_ADDR_WIDTH/8 {1'b0}};

/////////////////////////////////
// Port 4 is Output only from MSM

// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                            m01_axis_tvalid;
logic                            m01_axis_tready;
logic [C_M04_AXI_DATA_WIDTH-1:0] m01_axis_tdata;

// AXI write master stage
//logic                          write_done;

// AXI4 Write Master
MSM_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M04_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M04_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_M04_AXI_ADDR_WIDTH  ), //CV_XFER_SIZE_WIDTH    ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master_02 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               (                         ) , // Not used
  .ctrl_addr_offset        ( R_y                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_th_in_bytes ) ,
  .m_axi_awvalid           ( m04_axi_awvalid         ) ,
  .m_axi_awready           ( m04_axi_awready         ) ,
  .m_axi_awaddr            ( m04_axi_awaddr          ) ,
  .m_axi_awlen             ( m04_axi_awlen           ) ,
  .m_axi_wvalid            ( m04_axi_wvalid          ) ,
  .m_axi_wready            ( m04_axi_wready          ) ,
  .m_axi_wdata             ( m04_axi_wdata           ) ,
  .m_axi_wstrb             ( m04_axi_wstrb           ) ,
  .m_axi_wlast             ( m04_axi_wlast           ) ,
  .m_axi_bvalid            ( m04_axi_bvalid          ) ,
  .m_axi_bready            ( m04_axi_bready          ) ,
  .s_axis_aclk             ( ap_clk                  ) ,
  .s_axis_areset           ( areset                  ) ,
  .s_axis_tvalid           ( m01_axis_tvalid         ) ,
  .s_axis_tready           ( m01_axis_tready         ) ,  // Not used
  .s_axis_tdata            ( m01_axis_tdata          )
);

assign m04_axi_arvalid = 1'b0;
assign m04_axi_rready = 1'b0;
assign m04_axi_araddr = {C_M04_AXI_ADDR_WIDTH {1'b0}};
assign m04_axi_arlen = {C_M04_AXI_ADDR_WIDTH/8 {1'b0}};

/////////////////////////////////
// Port 5 is Output only from MSM

// Wires and Variables

// Control logic
//logic                          done = 1'b0;

logic                            m02_axis_tvalid;
logic                            m02_axis_tready;
logic [C_M05_AXI_DATA_WIDTH-1:0] m02_axis_tdata;

// AXI write master stage
//logic                          write_done;

// AXI4 Write Master
MSM_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M05_AXI_ADDR_WIDTH  ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M05_AXI_DATA_WIDTH  ) ,
  .C_XFER_SIZE_WIDTH   ( C_M05_AXI_ADDR_WIDTH  ), //CV_XFER_SIZE_WIDTH    ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master_03 (
  .aclk                    ( ap_clk                  ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               (                         ) , // Not used
  .ctrl_addr_offset        ( R_z                     ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_th_in_bytes ) ,
  .m_axi_awvalid           ( m05_axi_awvalid         ) ,
  .m_axi_awready           ( m05_axi_awready         ) ,
  .m_axi_awaddr            ( m05_axi_awaddr          ) ,
  .m_axi_awlen             ( m05_axi_awlen           ) ,
  .m_axi_wvalid            ( m05_axi_wvalid          ) ,
  .m_axi_wready            ( m05_axi_wready          ) ,
  .m_axi_wdata             ( m05_axi_wdata           ) ,
  .m_axi_wstrb             ( m05_axi_wstrb           ) ,
  .m_axi_wlast             ( m05_axi_wlast           ) ,
  .m_axi_bvalid            ( m05_axi_bvalid          ) ,
  .m_axi_bready            ( m05_axi_bready          ) ,
  .s_axis_aclk             ( ap_clk                  ) ,
  .s_axis_areset           ( areset                  ) ,
  .s_axis_tvalid           ( m02_axis_tvalid         ) ,
  .s_axis_tready           ( m02_axis_tready         ) ,  // Not used
  .s_axis_tdata            ( m02_axis_tdata          )
);

assign m05_axi_arvalid = 1'b0;
assign m05_axi_rready = 1'b0;
assign m05_axi_araddr = {C_M05_AXI_ADDR_WIDTH {1'b0}};
assign m05_axi_arlen = {C_M05_AXI_ADDR_WIDTH/8 {1'b0}};

endmodule : MSM_mm_wrapper
`default_nettype wire
