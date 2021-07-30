//module RISC_V
module PCSel_compute
(
	input [6:0]opcode,
   input [2:0]func3,
	input brEQ,brLT,
	input clock,	
	output reg pcsel,PCsel_MEM,PCsel_WB

);


always@(*)
begin
case(opcode)
7'b1100011:begin
           case(func3)
			  3'b000:begin
						if((brEQ==1'b1)&&(brLT==1'b0))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  3'b001:begin
						if (((brEQ==1'b0)&&(brLT==1'b1))||((brEQ==1'b0)&&(brLT==1'b0)))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  3'b100:begin
						if ((brEQ==1'b0)&&(brLT==1'b1))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  3'b101:begin
						if (((brEQ==1'b1)&&(brLT==1'b0))||((brEQ==1'b0)&&(brLT==1'b0)))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  3'b110:begin
						if ((brEQ==1'b0)&&(brLT==1'b1))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  3'b111:begin
						if (((brEQ==1'b1)&&(brLT==1'b0))||((brEQ==1'b0)&&(brLT==1'b0)))
						pcsel=1'b1;
						else 
						pcsel=1'b0;
						end
			  default:pcsel=0;
			  endcase
           end
			  
7'b1100111:begin																//I format
             case(func3)
			       3'b000:pcsel=1'b1;				//jalr
			       default:pcsel=0;
			    endcase
			  end
			  
7'b1101111:pcsel=1'b1;						//jal

default:pcsel=0;

endcase
end


initial begin
pcsel<=0;
PCsel_MEM<=0;
PCsel_WB<=0;
end

always @(posedge clock)
begin


PCsel_MEM<=pcsel;
PCsel_WB<=PCsel_MEM;

end

endmodule
