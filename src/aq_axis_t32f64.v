module aq_axis_t32f64
  (
   input         ARESETN,

   input         I_AXIS_TCLK,
   input [64:0]  I_AXIS_TDATA,
   input         I_AXIS_TVALID,
   output        I_AXIS_TREADY,
   input [7:0]   I_AXIS_TSTRB,
   input         I_AXIS_TKEEP,
   input         I_AXIS_TLAST,

   output        O_AXIS_TCLK,
   output [31:0] O_AXIS_TDATA,
   output        O_AXIS_TVALID,
   input         O_AXIS_TREADY,
   output [3:0]  O_AXIS_TSTRB,
   output        O_AXIS_TKEEP,
   output        O_AXIS_TLAST
   );

   reg           odd_even;
   reg [31:0]    buff;
   reg [3:0]     strb;

   always @(posedge I_AXIS_TCLK or negedge ARESETN) begin
      if(!ARESETN) begin
         odd_even <= 1'b0;
         buff <= 32'd0;
         strb <= 4'd0;
      end else begin
         if(I_AXIS_TVALID | (!I_AXIS_TVALID & O_AXIS_TREADY)) begin
            odd_even <= ~odd_even;
         end
         if(!odd_even) begin
            buff <= I_AXIS_TDATA[63:32];
            strb <= I_AXIS_TSTRB[7:4];
         end
      end
   end

   assign O_AXIS_TDATA[31:0] = (odd_even)?buff:I_AXIS_TDATA[31:0];
   assign O_AXIS_TSTRB[3:0]  = (odd_even)?strb:I_AXIS_TSTRB[3:0];
   assign O_AXIS_TVALID      = I_AXIS_TVALID;
   assign O_AXIS_TLAST       = I_AXIS_TLAST;
   assign O_AXIS_TKEEP       = I_AXIS_TKEEP;
   assign O_AXIS_TCLK        = I_AXIS_TCLK;

   assign I_AXIS_TREADY      = O_AXIS_TREADY & ~odd_even;
endmodule
