
//module RISC_V
module PIPE_IF_ID
#(parameter DATA_W =32 , ALU_SEL_W=4  , ADDR_W=5, DMEM_ADDR_W=8, INST_W=32, ADDR_W_IMEM=12, CONTROL_WORD_W=22)
(
input flush,
input clock,
input stall,

input [INST_W-1:0]instr_IF,
input [ADDR_W_IMEM-1:0]PC_IF,
input [ADDR_W_IMEM-1:0]PC_4_IF,
input [CONTROL_WORD_W-1:0]control_IF,

output reg [INST_W-1:0]instr_ID,
output reg [ADDR_W_IMEM-1:0]PC_ID,
output reg [ADDR_W_IMEM-1:0]PC_4_ID,
output reg  [CONTROL_WORD_W-1:0] control_ID

);

initial begin

instr_ID   <= 0;
PC_ID      <= 0;
PC_4_ID    <= 0;
control_ID <= 20'h002;

end

always @(posedge clock)
begin

    
	  
    if(stall)
     begin
       instr_ID   <= instr_ID;
       PC_ID      <= PC_ID;
       PC_4_ID    <= PC_4_ID;
       control_ID <= control_ID;
     end 
	  
	  else if (flush)
     begin
       instr_ID   <= 32'h33;
       PC_ID      <= PC_IF;
       PC_4_ID    <= PC_4_IF;
       control_ID <= 20'h103;
     end 
  
  else 
     begin
       instr_ID   <= instr_IF;
       PC_ID      <= PC_IF;
       PC_4_ID    <= PC_4_IF;
       control_ID <= control_IF;
     end 
end

endmodule



//module RISC_V
module PIPE_ID_EX
#(parameter DATA_W =32 , ALU_SEL_W=4  , ADDR_W=5, DMEM_ADDR_W=8, INST_W=32, ADDR_W_IMEM=12, CONTROL_WORD_W=22)
(
input flush,
input clock,stall,

input [ADDR_W_IMEM-1:0]PC_4_ID,
input [ADDR_W_IMEM-1:0]PC_ID,
input [ADDR_W-1:0]rd_ID,rs1_ID,rs2_ID,
input signed [DATA_W-1:0]read_data_A_ID,read_data_B_ID,imm_ID,
input [INST_W-1:0]instr_ID,
input [CONTROL_WORD_W-1:0]control_ID,

output reg [ADDR_W_IMEM-1:0]PC_4_EX,
output reg [ADDR_W_IMEM-1:0]PC_EX,
output reg [ADDR_W-1:0]rd_EX,rs1_EX,rs2_EX,
output reg signed [DATA_W-1:0]read_data_A_EX,read_data_B_EX,imm_EX,
output reg [INST_W-1:0]instr_EX,
output reg  [CONTROL_WORD_W-1:0] control_EX

);

initial begin

PC_4_EX        = 0;
PC_EX          = 0;
rd_EX          = 0;
rs1_EX         = 0;
rs2_EX         = 0;
read_data_A_EX = 0;
read_data_B_EX = 0;
imm_EX         = 0;
instr_EX       = 0; 
control_EX     = 20'h002;

end

always @(posedge clock)
begin

 if(stall)
     begin
          PC_4_EX         <= PC_4_EX;
          PC_EX           <= PC_EX; 
          rd_EX           <= rd_EX;
			 rs1_EX          <= rs1_EX;
			 rs2_EX          <= rs2_EX;
          read_data_A_EX  <= read_data_A_EX;
          read_data_B_EX  <= read_data_B_EX;
          imm_EX          <= imm_EX;
			 instr_EX        <= instr_EX;
          control_EX      <= control_EX;
     end 
	  

 else if (flush)
     begin
          PC_4_EX         <= PC_4_ID;
          PC_EX           <= PC_ID; 
          rd_EX           <= 0;
          rs1_EX          <= 0;
          rs2_EX          <= 0;
          read_data_A_EX  <= 0;
          read_data_B_EX  <= 0;
          imm_EX          <= 0;
			 instr_EX        <= 32'h33; 
          control_EX      <= 20'h103;
     end

  


	  
  else
     begin
          PC_4_EX         <= PC_4_ID;
          PC_EX           <= PC_ID; 
          rd_EX           <= rd_ID;
			 rs1_EX          <= rs1_ID;
			 rs2_EX          <= rs2_ID;
          read_data_A_EX  <= read_data_A_ID;
          read_data_B_EX  <= read_data_B_ID;
          imm_EX          <= imm_ID;
			 instr_EX        <= instr_ID;
          control_EX      <= control_ID;
     end 
end

endmodule

//module RISC_V
module PIPE_EX_MEM
#(parameter DATA_W =32 , ALU_SEL_W=4  , ADDR_W=5, DMEM_ADDR_W=8, INST_W=32, ADDR_W_IMEM=12, CONTROL_WORD_W=22)
(
input flush,clock,stall,

input [ADDR_W_IMEM-1:0]PC_4_EX,
input [ADDR_W-1:0]rd_EX,rs1_EX,rs2_EX,
input signed [DATA_W-1:0]ALU_EX,read_data_B_EX,
input BrEQ_EX, BrLT_EX,
input [INST_W-1:0]instr_EX,
input [CONTROL_WORD_W-1:0]control_EX,

output reg [ADDR_W_IMEM-1:0]PC_4_MEM,
output reg[ADDR_W-1:0]rd_MEM,rs1_MEM,rs2_MEM,
output  reg signed [DATA_W-1:0]ALU_MEM,read_data_B_MEM,
output reg BrEQ_MEM, BrLT_MEM,
output reg [INST_W-1:0]instr_MEM,
output reg  [CONTROL_WORD_W-1:0] control_MEM

);

initial begin
PC_4_MEM        = 0;
rd_MEM          = 0;
rs1_MEM         = 0;
rs2_MEM         = 0;
ALU_MEM         = 0;
read_data_B_MEM = 0;
BrEQ_MEM        = 0;
BrLT_MEM        = 0;
instr_MEM       = 0;
control_MEM     = 20'h002;
end

always @(posedge clock)
begin

if (stall)
begin
       PC_4_MEM        <= PC_4_MEM;
       rd_MEM          <= rd_MEM;
		 rs1_MEM         <= rs1_MEM;
		 rs2_MEM         <= rs2_MEM;
       ALU_MEM         <= ALU_MEM;
       read_data_B_MEM <= read_data_B_MEM;
		 BrEQ_MEM        <= BrEQ_MEM;
       BrLT_MEM        <= BrLT_MEM;	 
		 instr_MEM       <= instr_MEM;
       control_MEM     <= control_MEM ;
end

else if(flush)
begin
       PC_4_MEM        <= PC_4_EX;
       rd_MEM          <= 0;
		 rs1_MEM         <= 0;
		 rs2_MEM         <= 0;
       ALU_MEM         <= ALU_EX;
       read_data_B_MEM <= 0;
		 BrEQ_MEM        <= 0;
       BrLT_MEM        <= 0;
		 instr_MEM       <= 32'h33;
       control_MEM     <= 20'h103 ;
  end

  
  




else

begin
       PC_4_MEM        <= PC_4_EX;
       rd_MEM          <= rd_EX;
		 rs1_MEM         <= rs1_EX;
		 rs2_MEM         <= rs2_EX;
       ALU_MEM         <= ALU_EX;
       read_data_B_MEM <= read_data_B_EX;
		 BrEQ_MEM        <= BrEQ_EX;
       BrLT_MEM        <= BrLT_EX;	
		 instr_MEM       <= instr_EX;
       control_MEM     <= control_EX ;
  end
end

endmodule



//module RISC_V
module PIPE_MEM_WB
#(parameter DATA_W =32 , ALU_SEL_W=4  , ADDR_W=5, DMEM_ADDR_W=8, INST_W=32, ADDR_W_IMEM=12 , CONTROL_WORD_W=22)
(
input clock,stall,

input [ADDR_W-1:0]rd_MEM,rs1_MEM,rs2_MEM,
input [ADDR_W_IMEM-1:0]PC_4_MEM,
input signed [DATA_W-1:0]ALU_MEM, DMEM_Read_MEM, 
input [CONTROL_WORD_W-1:0]control_MEM,

output reg[ADDR_W-1:0]rd_WB,rs1_WB,rs2_WB,
output reg [ADDR_W_IMEM-1:0]PC_4_WB,
output  reg signed[DATA_W-1:0]ALU_WB, DMEM_Read_WB, 
output reg  [CONTROL_WORD_W-1:0] control_WB

);

initial begin
rd_WB      = 0;
rs1_WB     = 0;
rs2_WB     = 0;
PC_4_WB    = 0;
ALU_WB     = 0;
DMEM_Read_WB=0;
control_WB = 20'h002;
end

always @(posedge clock)
begin
if (stall)

begin
        rd_WB      <= rd_WB;
        rs1_WB     <= rs1_WB;
        rs2_WB     <= rs2_WB;
        PC_4_WB    <= PC_4_WB;
        ALU_WB     <= ALU_WB;
        DMEM_Read_WB<=DMEM_Read_WB;
        control_WB <= control_WB;
end

else 
begin

        rd_WB      <= rd_MEM;
        rs1_WB     <= rs1_MEM;
        rs2_WB     <= rs2_MEM;
        PC_4_WB    <= PC_4_MEM;
        ALU_WB     <= ALU_MEM;
        DMEM_Read_WB<=DMEM_Read_MEM;
        control_WB <= control_MEM;
     end
end

endmodule







