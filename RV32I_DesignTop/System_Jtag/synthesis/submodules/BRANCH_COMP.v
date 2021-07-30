//module RISC_V
module BRANCH_COMP
 #(parameter DATA_W =32)
(
input [DATA_W-1:0] rs1,rs2,
input BrUN,
output reg BrEQ=1'b0,
output reg BrLT=1'b0
);


always@(rs1,rs2,BrUN)
begin
 if(BrUN==1'b1)
   begin
	  if ($unsigned(rs1)<$unsigned(rs2))  ///////////// BLTU
	      begin
			  BrEQ=1'b0;
			  BrLT=1'b1;
			end	 
      else                    ///////////////////////  BGEU
	      begin
			  BrEQ=1'b0;
			  BrLT=1'b0;
			end

   end
	
else// if(BrUN==1'b0)
   begin
	  if (rs1==rs2)  /////////////////// BEQ
	      begin
			  BrEQ=1'b1;
			  BrLT=1'b0;
			end
     else if ($signed(rs1)<$signed(rs2))  ///////////// BLT and BNE
	      begin
			  BrEQ=1'b0;
			  BrLT=1'b1;
          end

	 else              ////////////////////BGE
	      begin
			  BrEQ=1'b0;
			  BrLT=1'b0;
			end
   end
	
end


endmodule





