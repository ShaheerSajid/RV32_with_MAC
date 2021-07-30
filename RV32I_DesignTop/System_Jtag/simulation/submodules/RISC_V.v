module RV32_core
#(parameter DATA_W =32 , ALU_SEL_W=4  , ADDR_W=5, DMEM_ADDR_W=12, INST_W=32, ADDR_W_IMEM=12, CONTROL_WORD_W=22 )
(
input  clock,reset,
input [4:0]disp_sel,
output signed [31:0]display,
//for uart
output [31:0]av_address,
input  [31:0]av_readdata,
output [31:0]av_writedata,
output [31:0]av_writedata_reg,
output av_write_n,
output av_read_n,
input  av_waitrequest
);

//wire clock;

/////////////////////////////// LOCAL VARIABLES ///////////////////////////
 
 wire pc_en;
 wire [INST_W-1:0]inst; 
 wire [ADDR_W_IMEM-1:0]count;
 wire signed [DATA_W-1:0]write_data_dest;
 wire signed [DATA_W-1:0]read_data_A;
 wire signed [DATA_W-1:0]read_data_B;
 wire signed [DATA_W-1:0] immediate_out;

 wire signed [DATA_W-1:0]alu_out,alu_out0;
 wire signed [DATA_W-1:0]B_out;

 wire signed [DATA_W-1:0]DataMEM_read;

         wire [1:0]whb_sel;
         
		   wire PCSel;
		   wire [2:0] ImmSel;
		   wire RegWEn;
		   wire BSel;
		   wire ASel;
		   wire [(ALU_SEL_W-1):0]ALUSel;
		   wire MemRW;
		   wire WBSel;

    wire [ADDR_W-1:0]rs1,rs2,rd;

    wire  BrEQ,BrLT,BrEQ_MEM,BrLT_MEM;
	 wire  BrUN;
	 wire signed [DATA_W-1:0]A_out;
   
	 wire [ADDR_W_IMEM-1:0]PC_mux_out;
	 wire [ADDR_W_IMEM-1:0] res_add4 ;
	 wire [DATA_W-1:0]J_out;
	 wire Jsel;

/////////////////////////////// PIPELINING VARIABLES ///////////////////////////

wire  [CONTROL_WORD_W-1:0] control_IF;
wire PCsel_MEM,PCsel_WB; 


wire  [INST_W-1:0]instr_ID,instr_EX,instr_MEM;
wire [ADDR_W_IMEM-1:0]PC_ID;
wire [ADDR_W_IMEM-1:0]PC_4_ID;
wire  [CONTROL_WORD_W-1:0] control_ID;


wire [ADDR_W_IMEM-1:0]PC_4_EX;
wire [ADDR_W_IMEM-1:0]PC_EX;
wire [ADDR_W-1:0]rd_EX,rs1_EX,rs2_EX;
wire signed [DATA_W-1:0]read_data_A_EX,read_data_B_EX,imm_EX;
wire  [CONTROL_WORD_W-1:0] control_EX;


wire [ADDR_W_IMEM-1:0]PC_4_MEM;
wire [ADDR_W-1:0]rd_MEM,rs1_MEM,rs2_MEM;
wire signed [DATA_W-1:0]ALU_MEM,read_data_B_MEM;
wire  [CONTROL_WORD_W-1:0] control_MEM;


wire [ADDR_W-1:0]rd_WB,rs1_WB,rs2_WB;
wire [ADDR_W_IMEM-1:0]PC_4_WB;
wire signed [DATA_W-1:0]ALU_WB, DMEM_Read_WB; 
wire  [CONTROL_WORD_W-1:0] control_WB;

wire flush;
wire signed [DATA_W-1:0]WriteBack_Data_WB;
wire [2:0]ForwardA,ForwardB;
wire RegWEn_MEM,RegWEn_EX;
wire signed [DATA_W-1:0]read_data_A_ID_CORR,read_data_B_ID_CORR;

wire LoadSel_EX,LoadSel_MEM,LoadSel_IF,LoadSel_ID;
wire mac_en;
wire [2:0]mac_op;
wire [DATA_W-1:0] mac_out;
wire stall_core;


wire [DATA_W -1:0]uart_writedata;
wire HEX_display; 
//wire uart_data_en;

//wire PCSel_reg;

//Register_n   #(1'b1) PCSelForStall (PCSel,clock,reset,~stall_core,PCSel_reg);

/////////////////////////////// UART CONNECTIONS /////////////////////////////////

Register   #(DATA_W) UartWriteData (read_data_B_MEM,clock,reset,HEX_display,uart_writedata);
assign HEX_display = (ALU_MEM == 32'h108)?1:0;


assign stall_core = ~av_waitrequest;

assign av_address = ALU_MEM; 

assign av_write_n = ~(~MemRW & HEX_display);
assign av_writedata_reg = uart_writedata;
assign av_read_n = ~(LoadSel_MEM & HEX_display);
assign av_writedata = read_data_B_MEM;

//assign clock = clock_in & stall_core;
////////////////////////////// CONTROL CONNECTIONS /////////////////////////////

CONTROL_UNIT CONTROLLER ( inst,
								  control_IF
								  );
		

assign mac_en = control_EX [21]; 
assign mac_op = control_EX [20:18]; 
								
assign Jsel    = control_WB [17];        
assign BrUN    = control_EX [16];       
assign whb_sel = control_MEM [15:14];   
assign ImmSel  = control_ID [11:9];
assign RegWEn  = control_WB [8];
assign BSel    = control_EX [7];
assign ASel    = control_EX [6];
assign ALUSel  = control_EX [5:2];
assign MemRW   = control_MEM [1];       
assign WBSel   = control_WB [0];         


assign RegWEn_MEM = control_MEM [8];
assign RegWEn_EX = control_EX [8];


assign LoadSel_IF = control_IF [13];
assign LoadSel_ID = control_ID [13];
assign LoadSel_EX = control_EX [13];
assign LoadSel_MEM= control_MEM [13];

PCSel_compute PC_Sel_5_stages

(
	instr_MEM[6:0],
   instr_MEM[14:12],
	BrEQ_MEM,BrLT_MEM,
	clock,	
	PCSel,PCsel_MEM,PCsel_WB

);

//assign flush = stall_core? PCSel_reg : PCSel;
assign flush = PCSel;

///////////////////////////// DATAPATH CONNECTIONS AHEAD ////////////////////////


Find_Rs1_rs2_rd  Find_Rs1_Rs2_Rd

(
  instr_ID,
  rs1,rs2,rd

);

////////////////////////////////////////  HAZARD DETECTION  ///////////////////////////////////////////
		

							
LOAD_HAZARD_DETECTION PROC_STALL  
                                 ( clock,
											  LoadSel_IF,
											  LoadSel_ID,
											  PCSel,
											  pc_en);
											  

////////////////////////////////// INSTRUCTION FETCH /////////////////////////////////////

MUX2X1    #(.DATA_W(ADDR_W_IMEM))     MUX_PC
                           (res_add4,
                            //alu_out[ADDR_W_IMEM-1:0],
									 ALU_MEM[ADDR_W_IMEM-1:0],
									 PCSel,
									 PC_mux_out);

PROGRAM_COUNTER PC( PC_mux_out,
                    clock,
						  reset,
						  pc_en &(~stall_core),
						  count);

ADD4  ADD_4(count,
            res_add4);

INSTRUCTION_MEM  IMEM(count,
                      inst);

							 
							 
							
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////


PIPE_IF_ID PIPE_1       (
                         flush,
								 clock,
								 ~(!stall_core),
								 //1'b0,
								 inst,
								 count,
								 res_add4,
								 control_IF,
								 
								 instr_ID,
								 PC_ID,
								 PC_4_ID,
								 control_ID
								 );

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// INSTRUCTION DEOCDE /////////////////////////////////////

REG_FILE     REG_F (rs1,
                    rs2,
						  rd_WB,
						  WriteBack_Data_WB,
						  RegWEn,
						  clock,
						  reset,
						  read_data_A,
						  read_data_B,
						  disp_sel,
						  display
						  );

IMM_GEN IMM_GENERATE(instr_ID[31:7],
                     ImmSel,
							immediate_out);



						
							
////////////////////////////////////////  FORWARDING  ///////////////////////////////////////////
				
FORWARDING_BLOCK  DATA_HAZARD_SOLN
                                    (rs1,
												 rs2,
												 rd_EX,
												 rd_MEM,
												 rd_WB,
												 RegWEn_EX,
												 RegWEn_MEM,
												 RegWEn,
												 LoadSel_EX,
												 LoadSel_MEM,
												 ForwardA,
												 ForwardB
												 );				
				
				
FORWARDING_MUX  FWD_MUX_CORRECTED_READ_DATA_A
                                              (
															 read_data_A,
															 alu_out,
															 ALU_MEM,
															 DataMEM_read,
															 WriteBack_Data_WB,
															 ForwardA,
															 read_data_A_ID_CORR
															 );
 			
				
FORWARDING_MUX  FWD_MUX_CORRECTED_READ_DATA_B
                                                (
																read_data_B,
																alu_out,
																ALU_MEM,
																DataMEM_read,
																WriteBack_Data_WB,
																ForwardB,
																read_data_B_ID_CORR
																);
 			
							
							
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

PIPE_ID_EX   PIPE_2
                     ( flush,
							  clock,
							  stall_core,
							  PC_4_ID,
							  PC_ID,
							  rd,
							  rs1,
							  rs2,
							  read_data_A_ID_CORR,
							  read_data_B_ID_CORR,
							  immediate_out,
							  instr_ID,
							  control_ID,
							  
							  PC_4_EX,
							  PC_EX,
							  rd_EX,
							  rs1_EX,
							  rs2_EX,
							  read_data_A_EX,
							  read_data_B_EX,
							  imm_EX,
							  instr_EX,
							  control_EX

);

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////		
				

				
				
////////////////////////////////// EXECUTE STAGE ///////////////////////////////////////////
				
BRANCH_COMP BR_COMP(read_data_A_EX,
                    read_data_B_EX,
						  BrUN,
						  BrEQ,
						  BrLT); 



MUX2X1 #(.DATA_W(32)) MUX_B
                                  (read_data_B_EX,
                                   imm_EX,
											  BSel,
											  B_out);

MUX2X1 #(.DATA_W(32)) MUX_A
                                  (read_data_A_EX,
                                   {{(DATA_W-ADDR_W_IMEM){1'b0}},PC_EX},
											  ASel,
											  A_out); 

ALU  ALU_(A_out,
          B_out,
			 ALUSel,
			 alu_out0);
			 
			 
			 
MAC_UNIT MAC_SS (A_out,
					  B_out,
					  clock,
					  reset,
					  mac_en,
					  mac_op,
					  mac_out );

MUX2X1 #(.DATA_W(32))  ALU_MAC_MUX
                             ( alu_out0,
									    mac_out,
										 mac_en,
										 alu_out);
			 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

PIPE_EX_MEM PIPE_3
                      ( flush,
							   clock,
								stall_core,
								PC_4_EX,
								rd_EX,
								rs1_EX,
								rs2_EX,
								alu_out,
								read_data_B_EX,
								BrEQ,BrLT,
								instr_EX,
								control_EX,
								
								PC_4_MEM,
								rd_MEM,
								rs1_MEM,
								rs2_MEM,
								ALU_MEM,
								read_data_B_MEM,
								BrEQ_MEM,
								BrLT_MEM,
								instr_MEM,
								control_MEM

);
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// MEMORY STAGE  /////////////////////////////////////

DRAM#(.width(DATA_W),.addrWidth(DMEM_ADDR_W)) dmem(
		.DOUT(DataMEM_read),
		.ADDR(ALU_MEM[DMEM_ADDR_W-1:0]),
		.DIN(read_data_B_MEM),
		.wren(MemRW),
		.clock(clock),
		.func3(instr_MEM[14:12])
	);




									  
									  
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

PIPE_MEM_WB  PIPE_4
                        ( clock,
							     stall_core,
								  rd_MEM,
								  rs1_MEM,
								  rs2_MEM,
								  PC_4_MEM,
								  ALU_MEM, 
								  DataMEM_read, 
								  control_MEM,
								  
								  rd_WB,
								  rs1_WB,
								  rs2_WB,
								  PC_4_WB,
								  ALU_WB, 
								  DMEM_Read_WB, 
								  control_WB

);

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// WRITE BACK STAGE /////////////////////////////////////

MUX2X1 #(.DATA_W(32))  WB_MUX
                             ( DMEM_Read_WB,
									    ALU_WB,
										 WBSel,
										 write_data_dest);

MUX2X1 #(.DATA_W(32))  J_MUX 
                             (write_data_dest,
									  {{(DATA_W-ADDR_W_IMEM){1'b0}},PC_4_WB},
									  Jsel,
									  J_out);




assign WriteBack_Data_WB = J_out;


 
endmodule













