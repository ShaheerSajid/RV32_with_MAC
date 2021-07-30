//module RISC_V
module REG_FILE
#( parameter DATA_W =32 , ADDR_W=5 )
(
       
        input  [(ADDR_W -1):0] addr_a,
        input  [(ADDR_W -1):0] addr_b,
		  input  [(ADDR_W -1):0] addr_dest,
		  input signed [(DATA_W -1):0] data_dest,
		  input  wEn,
		  input  clk,
		  input reset,
		  output signed [(DATA_W -1):0] data_a,
		  output signed [(DATA_W -1):0] data_b,
		  input  [(ADDR_W -1):0]disp_sel,
        output signed [(DATA_W -1):0] display
		  
);		  

		  
reg  [(DATA_W -1):0] x [(2**ADDR_W -1):0];


integer i;
initial begin

for(i=0 ; i< (2**ADDR_W) ;i=i+1)
begin
x[i]= {(DATA_W){1'b0}};	

end
end

always @ (posedge clk or posedge reset)
begin
	
	if (reset)
	  begin
         for(i=0 ; i< (2**ADDR_W) ;i=i+1)
           begin
             x[i]= {(DATA_W){1'b0}};	
           end
     end
	
	else 
	   begin 
	       if (wEn==1'b1 && addr_dest>0 )
			     x[addr_dest] <= data_dest;	
	      else 
	           x[addr_dest] <= x[addr_dest] ;
	
	   end
end
	
	
assign   data_a = x[addr_a];
assign   data_b = x[addr_b];
assign   display = x[disp_sel];

		  
endmodule
