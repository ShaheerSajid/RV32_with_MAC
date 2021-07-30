//module RISC_V
module CONTROL_UNIT

# (parameter INST_W = 32 , ALU_SEL_W=4, CONTROL_WORD_W=22 )

(
        input  [(INST_W -1):0] instruction,
		  output reg [CONTROL_WORD_W-1:0]control_word

);


localparam OPCODE_W=7, FUNC3_W=3, FUNC7_W=7;

wire [OPCODE_W-1:0]opcode;
wire [FUNC3_W-1:0]func3in;
wire [FUNC7_W-1:0]func7in;
reg [FUNC7_W-1:0]func7out;
reg [FUNC3_W-1:0]func3out;


reg BrEQ_out,BrLT_out;
wire [16:0]f7_f3_op;


assign opcode = instruction[6:0];
assign func3in  = instruction[14:12];
assign func7in  = instruction[31:25];

always@(opcode,func7in)
begin
if (opcode==7'h33)
func7out=func7in;

else func7out=7'd0;

end


always@(opcode,func3in)
begin
if (opcode==7'h6f || opcode==7'h37 )
 func3out=3'd0;


else func3out=func3in;

end


assign f7_f3_op={func7out,func3out,opcode};

initial begin
control_word='h103;
end


always@(f7_f3_op)
begin
case(f7_f3_op)

17'h33   : control_word='h103;   //add
17'h3b3  : control_word='h107;   //and
17'h333  : control_word='h10b;   //or
17'h233  : control_word='h10f;   //xor
17'h2b3  : control_word='h113;   //srl
17'h82b3 : control_word='h117;   //sra
17'h00b3 : control_word='h11b;   //sll
17'h133  : control_word='h11f;   //slt
17'h8033 : control_word='h123;   //sub

17'h10033 : control_word='h200103; //mac
17'h100b3 : control_word='h300103; //mach
17'h10133 : control_word='h240103; //mta
17'h101b3 : control_word='h340103; //mtah
17'h10233 : control_word='h280103; //mtan
17'h102b3 : control_word='h380103; //mtanh
17'h10333 : control_word='h2c0103; //msc
17'h103b3 : control_word='h3c0103; //msch


17'h0123 : control_word='h280;   //sw
17'ha3   : control_word='h4280;  //sh
17'h23   : control_word='h8280;  //sb

17'h0003 : control_word='ha182;  //lb
17'h0083 : control_word='h6182;  //lh
17'h0103 : control_word='h2182;  //lw

17'h0203 : control_word='h2182;  //lbu
17'h0283 : control_word='h2182;  //lhu

17'h0013 : control_word='h183;   //addi
17'h0093 : control_word='h19b;   //slli
17'h0113 : control_word='h19f;   //slti
17'h0213 : control_word='h18f;   //xori
17'h0293 : control_word='h193;   //srli
17'h8293 : control_word='h197;   //srai
17'h0313 : control_word='h18b;   //ori
17'h0393 : control_word='h187;   //andi

17'h067 : control_word='h21183;   // jalr
17'h06f : control_word='h219c3;   //jal

17'h0063 : control_word='h14c2   ;     //BEQ
17'h00e3 : control_word='h14c2   ;     //BNE
17'h0263 : control_word='h14c2   ;     //BLT
17'h02e3 : control_word='h14c2   ;     //BGE
17'h0363 : control_word='h114c2  ;     //BLTU
17'h03e3 : control_word='h114c2  ;     //BGEU

17'h037  : control_word='h7a7;  //lui

default  : control_word='h002;

endcase


end






endmodule




module Find_Rs1_rs2_rd 
#(parameter ADDR_W=5, INST_W=32)
(
  input [INST_W-1:0] inst,
  output reg [ADDR_W-1:0] rs1,rs2,rd

);

always@(*)
begin
case (inst[6:0])

7'b0110011 : begin //////////////// R- format /////////////
             rs1= inst[19:15];
				 rs2= inst[24:20];
				 rd = inst[11:7];
             end
7'b0000011 : begin /////////////// Load Instructions //////////////
             rs1= inst[19:15];
				 rs2= 5'd0;
				 rd = inst[11:7];
             end
7'b1100111 : begin /////////////// JalR //////////////
             rs1= inst[19:15];
				 rs2= 5'd0;
				 rd = inst[11:7];
             end				 
7'b0010011 : begin /////////////// Remaining I- Format //////////////
             rs1= inst[19:15];
				 rs2= 5'd0;
				 rd = inst[11:7];
             end
				 
7'b0100011 : begin /////////////// S- Format //////////////
             rs1= inst[19:15];
				 rs2= inst[24:20];
				 rd = 5'd0;
             end
				 
7'b1100011 : begin /////////////// SB- Format //////////////
             rs1= inst[19:15];
				 rs2= inst[24:20];
				 rd = 5'd0;
             end
default :  begin /////////////// U and UJ - Format //////////////
             rs1= 5'd0;
				 rs2= 5'd0;
				 rd = inst[11:7];
             end
endcase


end

endmodule
