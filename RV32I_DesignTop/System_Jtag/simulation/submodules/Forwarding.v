
module FORWARDING_BLOCK
(
	input [4:0]rs1_ID,rs2_ID,
	input [4:0]rd_ex,rd_mem,rd_wb,
	input RegWrite_ex,RegWrite_mem,RegWrite_wb,
   input LoadSel_ex,LoadSel_mem,
	
	output reg [2:0]ForwardA,ForwardB

);

always@(*) 
begin

if ((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs1_ID) && (LoadSel_ex!=1)) 
	 
			ForwardA = 3'b001;


else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs1_ID)&& (LoadSel_mem!=1))  
	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs1_ID)   && (LoadSel_ex!=1)) )
	 
	 		ForwardA = 3'b010;

else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs1_ID)&& (LoadSel_mem==1))  
	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs1_ID)   && (LoadSel_ex!=1)))
	 
	 		ForwardA = 3'b011;
			
else if  (((RegWrite_wb == 1'b1) && (rd_wb != 0) && (rd_wb == rs1_ID))
      && ! ((RegWrite_mem==1'b1)&& (rd_mem != 0)&& (rd_mem == rs1_ID)&& (LoadSel_mem!=1)) 
	   && !((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs1_ID)&& (LoadSel_ex!=1))	)			 
			
				 
			ForwardA = 3'b100;
else 
			ForwardA = 3'b000;



///////////////////////////////////////////////////////////

if ((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs2_ID) && (LoadSel_ex!=1)) 
	 
			ForwardB = 3'b001;


else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs2_ID)&& (LoadSel_mem!=1))  
	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs2_ID)   && (LoadSel_ex!=1)) )
	 
	 		ForwardB = 3'b010;

else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs2_ID)&& (LoadSel_mem==1))  
	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs2_ID)   && (LoadSel_ex!=1)))
	 
	 		ForwardB = 3'b011;
			
else if  (((RegWrite_wb == 1'b1) && (rd_wb != 0) && (rd_wb == rs2_ID))
      && ! ((RegWrite_mem==1'b1)&& (rd_mem != 0)&& (rd_mem == rs2_ID)&& (LoadSel_mem!=1)) 
	   && !((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs2_ID)&& (LoadSel_ex!=1))	)			 
			
				 
			ForwardB = 3'b100;
else 
			ForwardB = 3'b000;


end
endmodule











module LOAD_HAZARD_DETECTION
(
input clock,LoadSel,LoadSel_ID,
input PCSel,
output reg pc_en =1'b1
);

parameter st0=2'd0,st1=2'd1,st2=2'd2;
reg [1:0] PS,NS;

always @ (negedge clock)
begin
if (!PCSel )
PS <= NS;
else
PS <= PS;
end


always@(*)
begin
if (!PCSel)
begin
case(PS) 
st0: if (!LoadSel) NS = st0; else NS = st1;
st1: NS = st2;
st2:  if ((LoadSel_ID ) && (LoadSel) )NS = st1; else NS =st0; 
default: NS =st0;
endcase
end

else NS =st0;
			
end

always@(*)
begin

if (!PCSel)
begin
case(PS) 
st0: if (!LoadSel) pc_en = 1'b1; else pc_en = 1'b0;
st1: pc_en = 1'b0;
st2: pc_en = 1'b1; 
default: pc_en = 1'b1 ;
endcase
end

else pc_en = 1'b1 ;
			
end


endmodule






//module FORWARDING_BLOCK
//(
//	input [4:0]rs1_ID,rs2_ID,
//	input [4:0]rd_ex,rd_mem,rd_wb,
//	input RegWrite_ex,RegWrite_mem,RegWrite_wb,
//
//	
//	output reg [1:0]ForwardA,ForwardB
//
//);
//
//always@(*) 
//begin
//
//if ((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs1_ID))
//	 
//			ForwardA = 2'b01;
//
//
//else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs1_ID))  
//	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs1_ID)) )
//	 
//	 		ForwardA = 2'b10;
//			
//else if  (((RegWrite_wb == 1'b1) && (rd_wb != 0) && (rd_wb == rs1_ID))
//      && ! ((RegWrite_mem==1'b1)&& (rd_mem != 0)&& (rd_mem == rs1_ID)) 
//	   && !((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs1_ID))	)			 
//			
//				 
//			ForwardA = 2'b11;
//else 
//			ForwardA = 2'b00;
//
//
//
/////////////////////////////////////////////////////////////
//
//if ((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs2_ID))
//	 
//			ForwardB = 2'b01;
//
//
//else if      (((RegWrite_mem==1'b1) && (rd_mem != 0) &&(rd_mem == rs2_ID))  
//	      && !((RegWrite_ex==1'b1) && (rd_ex != 0)  &&(rd_ex == rs2_ID)) )
//	 
//	 		ForwardB = 2'b10;
//			
//else if  (((RegWrite_wb == 1'b1) && (rd_wb != 0) && (rd_wb == rs2_ID))
//      && ! ((RegWrite_mem==1'b1)&& (rd_mem != 0)&& (rd_mem == rs2_ID)) 
//	   && !((RegWrite_ex==1'b1) && (rd_ex != 0) && (rd_ex == rs2_ID))	)			 
//			
//				 
//			ForwardB = 2'b11;
//else 
//			ForwardB = 2'b00;
//
//
//end
//endmodule
//
