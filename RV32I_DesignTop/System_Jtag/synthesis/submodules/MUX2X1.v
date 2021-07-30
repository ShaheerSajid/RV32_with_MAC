module MUX2X1
#(parameter DATA_W=32)
(
 input [DATA_W-1:0]mux_in0,mux_in1,
 input mux_sel,
 output reg[DATA_W-1:0]mux_out
 );
 
always@(*)
begin
case(mux_sel)
1'b0:mux_out=mux_in0;
1'b1:mux_out=mux_in1;
endcase
end
endmodule


module FORWARDING_MUX
#(parameter DATA_W=32)
(
 input [DATA_W-1:0]mux_in0,mux_in1,mux_in2,mux_in3,mux_in4,
 input [2:0]mux_sel,
 output reg [DATA_W-1:0]mux_out
 );
 
 
always@(*)
begin
case(mux_sel)
3'b000:mux_out=mux_in0;
3'b001:mux_out=mux_in1;
3'b010:mux_out=mux_in2;
3'b011:mux_out=mux_in3;
3'b100:mux_out=mux_in4;
default:mux_out=mux_in0;
endcase
end
endmodule