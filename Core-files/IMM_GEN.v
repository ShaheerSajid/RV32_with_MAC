
//module RISC_V
module IMM_GEN
# (parameter INST_W = 32 , DATA_W =32 )
(
 input [INST_W-8:0]inst_im_part,
 input [2:0]imm_sel,
 output reg [DATA_W-1:0]immediate_out
);



wire [11:0]I_format,S_format;
wire [12:0]B_format;
wire [DATA_W-1:0] U_format;
wire [20:0]UJ_format;

/////////////////////////////////////////////

assign I_format = inst_im_part[24:13];              //     I format

///////////////////////////////////////////

assign S_format[4:0] = inst_im_part[4:0];
assign S_format[11:5] = inst_im_part[24:18];         //     S format

///////////////////////////////////////////////

assign B_format[11]  = inst_im_part[0];
assign B_format[4:1] = inst_im_part[4:1];             //     SB format
assign B_format[10:5]= inst_im_part[23:18];
assign B_format[12]  = inst_im_part[24];
assign B_format[0]  = 1'b0;

/////////////////////////////////////////////////

assign U_format[31:12]  = inst_im_part[24:5];         //     U format
assign U_format[11:0]   = 12'b0;

/////////////////////////////////////////////////

assign UJ_format[19:12]  = inst_im_part[12:5];
assign UJ_format[11]  = inst_im_part[13];
assign UJ_format[10:1]= inst_im_part[23:14];         //     UJ format
assign UJ_format[20]  = inst_im_part[24];
assign UJ_format[0]   = 1'b0;


////////////////////////////////////////////////////

always @(I_format,S_format,B_format,U_format,UJ_format,imm_sel[2:0])
begin
 if (imm_sel[2:0]==3'b000)
   immediate_out = {{(20){I_format[11]}},I_format};
	
 else if (imm_sel[2:0]==3'b001)
   immediate_out = {{(20){S_format[11]}},S_format};
	
	
 else if (imm_sel[2:0]==3'b010)
   immediate_out = {{(19){B_format[12]}},B_format};	
	
  else if (imm_sel[2:0]==3'b011)
   immediate_out = U_format;	
	
	
 else if (imm_sel[2:0]==3'b100)
   immediate_out = {{(11){UJ_format[20]}},UJ_format};	
	
	else 
    immediate_out = 32'b0;
end


endmodule


