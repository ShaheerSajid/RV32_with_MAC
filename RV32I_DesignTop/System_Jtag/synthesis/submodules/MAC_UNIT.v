
module MAC_UNIT
#(parameter DATA_W = 32, ACC_W = 64)
(
 input [DATA_W-1:0]M,N,
 input clock,reset,mac_en,
 input [2:0]mac_op,
 output [DATA_W-1:0]mac_out
);


wire [ACC_W - 1:0]product,sum;
wire [ACC_W - 1:0]acc_out;
reg [ACC_W - 1:0]add_comp1,add_comp2;



booth_multiplier  #(DATA_W)   mul   (M,N,product);



always @(*)
begin
case(mac_op[1:0])
2'd0: begin add_comp1 = acc_out; add_comp2= product; end // MAC
2'd1: begin add_comp1 = 0; 		add_comp2= product; end // MTA
2'd2: begin add_comp1 = 0; 		add_comp2= product; end // MTAN
2'd3: begin add_comp1 = acc_out; add_comp2= product; end // MSC

endcase

end


add_sub      #(ACC_W) add_   (add_comp1,add_comp2,mac_op[1],sum);
assign mac_out = mac_op[2] ? sum [ACC_W-1:DATA_W] : sum [DATA_W-1:0];
Register   #(ACC_W) R_ACC (sum,clock,reset,mac_en,acc_out);

endmodule








module Register  
#(parameter n=8) 
(D,clk,async_reset,en,Q);                        
input [n-1:0]D;                                                 // Data input 
input clk;                                                     // clock input 
input async_reset; 
input en;                                            // asynchronous reset low level
output reg [n-1:0]Q = 'd0;                                      // output Q 
always @(posedge clk or posedge async_reset) 
begin
 if(async_reset==1'b1)
  Q <= 'd0; 
 else if(async_reset==1'b0 && en ==1'b1)
  Q <= D; 
 else 
  Q <= Q; 
end 
endmodule


module Register_n  
#(parameter n=8) 
(D,clk,async_reset,en,Q);                        
input [n-1:0]D;                                                 // Data input 
input clk;                                                     // clock input 
input async_reset; 
input en;                                            // asynchronous reset low level
output reg [n-1:0]Q = 'd0;                                      // output Q 
always @(negedge clk or posedge async_reset) 
begin
 if(async_reset==1'b1)
  Q <= 'd0; 
 else if(async_reset==1'b0 && en ==1'b1)
  Q <= D; 
 else 
  Q <= Q; 
end 
endmodule



module add_sub
#(parameter n=32)
(
input signed [n-1:0]A,B,
input sel,
output signed [n - 1:0]S
);


assign S = sel? A-B : A+B;

endmodule




module normal_multiplier 
#(parameter n = 32)
(X, Y, Z);

input   signed [ n-1     : 0] X, Y;
output  signed [ 2*n - 1 : 0] Z;

assign Z = X*Y;


endmodule


module booth_multiplier 
#(parameter n = 32)
(X, Y, Z);

input      signed [ n-1     : 0] X, Y;
output reg signed [ 2*n - 1 : 0] Z;
reg [1:0] temp;
integer i;
reg E1;
reg [n-1:0] Y1;

always @ (X, Y)
	begin
     Z = 'd0;
     E1 = 'd0;
   for (i = 0; i < n; i = i + 1)
     begin
        temp = {X[i], E1};
        Y1 = ~Y + 1;
         case (temp)
			     
				  2'd1 : Z [2*n - 1 : n] = Z [2*n - 1: n] + Y;  // add
              2'd2 : Z [2*n - 1 : n] = Z [2*n - 1: n] + Y1; // subtract

           default : Z = Z;
		               
         endcase
		 
       Z = Z >> 1;
       Z[2*n - 1] = Z[2*n - 2];  // RSA
       E1 = X[i];
     end
  end
      
endmodule




