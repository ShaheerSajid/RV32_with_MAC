//module RISC_V
module ALU
# (parameter DATA_W =32 , ALU_SEL_W=4) 
(
    input signed [(DATA_W -1):0] inp_a,
    input signed [(DATA_W -1):0] inp_b,
    input signed [(ALU_SEL_W -1):0] alu_sel,
	 output reg signed [(DATA_W -1):0] out
);		  


always @(inp_a,inp_b,alu_sel)
begin
case(alu_sel)

4'b0000 : out = inp_a + inp_b;             //add
4'b0001 : out = inp_a & inp_b;             //and
4'b0010 : out = inp_a | inp_b;             //or
4'b0011 : out = inp_a ^ inp_b;             //xor
4'b0100 : out = inp_a >> inp_b[4:0];       //srl
4'b0101 : out = inp_a >>>inp_b[4:0];       //sra
4'b0110 : out = inp_a << inp_b[4:0];       //sll
4'b0111 : out = (inp_a < inp_b) ? 
          {{(DATA_W-1){1'b0}},1'b1} : 
			 {(DATA_W){1'b0}};                //slt
4'b1000 : out = inp_a - inp_b;             //sub
4'b1001 : out = inp_b;                     //bsel

default : out =  {(DATA_W){1'b0}};	
endcase



end
endmodule









