//module RISC_V
module PROGRAM_COUNTER
# (parameter ADDR_W_IMEM=12)
(
 input [ADDR_W_IMEM-1:0]inp_addr,
 input clock,async_reset,
 input en,
 output reg [ADDR_W_IMEM-1:0]outp_addr
);

initial outp_addr = {(ADDR_W_IMEM){1'b0}};

always @(posedge clock or posedge async_reset) 
 begin
  if(async_reset==1'b1)
    outp_addr <= 8'b0;
  else if(async_reset==1'b0 && en ==1'b1)
          outp_addr<=inp_addr;	 
	else 	 
          outp_addr<= outp_addr;
  
 end 

endmodule

//module RISC_V
module ADD4
# (parameter ADDR_W_IMEM=12)
(
 input [ADDR_W_IMEM-1:0]in_addr,
 output [ADDR_W_IMEM-1:0]out_addr
);

assign out_addr = in_addr + 8'd4;

endmodule
