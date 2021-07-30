//module RISC_V
//module DATA_MEM
//# (parameter DATA_W=32, ADDR_W=12)
//(
//   input [(DATA_W-1):0] DataW,
//	input [(ADDR_W-1):0] addr,
//	input MemRW, clk,
//	input [1:0]whb_sel,
//	output reg[(DATA_W-1):0] DataR,
//   input [ ADDR_W-1:0] disp_sel_mem,
//   output[(DATA_W -1):0] display_mem
//);	
//localparam BYTE_W=8 ,HALF_W=16;
//
//	reg [DATA_W-1:0] data_memory[0:(2**(ADDR_W-2)-1)];
//	 
//   	 
//	wire [1:0]offs;
//   wire [(ADDR_W-3):0] mem_addr;
//	assign mem_addr=(addr/(6'd4));
//	assign offs=(addr%(6'd4));
//	
////initial begin : INIT
////		integer i;
////		for(i = 0; i < 2**(ADDR_W-2); i = i + 1)
////			data_memory[i] =  {(DATA_W){1'b0}};
////	end 
//
//
//initial
//	begin
//		$readmemh("D:\\ammaz study\\internship\\NU RV\\RV MAC Avalon\\RV MAC AValon Q\\data.txt",data_memory);
//	end
//
// //////////////////////////////////////////writing : for store/////////////////////////////////////////////////////////////
//always @(posedge clk)
// begin
//	     if (whb_sel==2'b00)  //word
//	        begin
//	          if (MemRW==1'b0)
//				          begin 
//				           if(offs==2'd0)
//		          	           data_memory[mem_addr] <= DataW;
//					        else if(offs==2'd1)
//							       begin 
//		          	           data_memory[mem_addr]  [DATA_W-1:BYTE_W] <= DataW[DATA_W-BYTE_W-1:0];
//									  data_memory[mem_addr+1][BYTE_W-1:0] <= DataW[DATA_W-1:DATA_W-BYTE_W];
//									 end 
//						     else if (offs==2'd2)
//					               begin 
//		          	           data_memory[mem_addr]  [DATA_W-1:HALF_W] <= DataW[HALF_W-1:0];
//									  data_memory[mem_addr+1][HALF_W-1:0] <= DataW[DATA_W-1:HALF_W];
//									 end 
//					        else// if (offs==2'd3)
//							       begin 
//		          	           data_memory[mem_addr]  [DATA_W-1:HALF_W+BYTE_W] <= DataW[BYTE_W-1:0];
//									  data_memory[mem_addr+1][HALF_W+BYTE_W-1:0] <= DataW[DATA_W-1:BYTE_W];
//									 end
//				 
//				 
//				           end
//				 
//		        else 
//		           data_memory[mem_addr] <= data_memory[mem_addr];
//	        end
//		
//	     else if (whb_sel==2'b01)	 //half
//	        begin
//	          if (MemRW==1'b0)
//			         begin 
//				           if(offs==2'd0)
//		          	           data_memory[mem_addr][HALF_W-1:0] <= DataW[HALF_W-1:0];
//					        else if(offs==2'd1)
//		          	           data_memory[mem_addr][HALF_W+BYTE_W-1:BYTE_W] <= DataW[HALF_W-1:0];
//						     else if (offs==2'd2)
//					              data_memory[mem_addr][DATA_W-1:HALF_W] <= DataW[HALF_W-1:0];
//					        else// if (offs==2'd3)
//							      begin
//					              data_memory[mem_addr][DATA_W-1:HALF_W+BYTE_W] <= DataW[BYTE_W-1:0];
//									  data_memory[mem_addr+1][BYTE_W-1:0] <= DataW[HALF_W-1:BYTE_W];
//									  end
//		            end
//				  
//		        else 
//		         data_memory[mem_addr] <= data_memory[mem_addr];
//	        end
//		  
//	       else if (whb_sel==2'b10)	 //byte
//	           begin
//	                 if (MemRW==1'b0)
//			                 begin 
//				                  if(offs==2'd0)
//		          	                data_memory[mem_addr][BYTE_W-1:0] <= DataW[BYTE_W-1:0];
//						
//					               else if (offs==2'd1)
//					                   data_memory[mem_addr][2*BYTE_W-1:BYTE_W] <= DataW[BYTE_W-1:0];
//						
//					               else if (offs==2'd2)
//					                   data_memory[mem_addr][3*BYTE_W-1:2*BYTE_W] <= DataW[BYTE_W-1:0];
//					
//					               else// if (offs==2'd3)
//					                   data_memory[mem_addr][4*BYTE_W-1:3*BYTE_W] <= DataW[BYTE_W-1:0];
//					 
//		                     end
//                      else 
//		                  data_memory[mem_addr] <= data_memory[mem_addr];
//	             end
//		
//          else 
//     data_memory[mem_addr] <= data_memory[mem_addr];
//	 //end
// end
//	
// //////////////////////////////////////////reading : for load/////////////////////////////////////////////////////////////
//	
//	
//always @(whb_sel,mem_addr,offs,MemRW)
////always @(posedge clk) 
// begin
//	
//	      if (whb_sel==2'b00)  /////////////////////////////////         //word
//	            begin
//	               if (MemRW==1'b1)                                               
//			               begin                                              
//				                  if(offs==2'd0)
//						                         begin
//						                            DataR[DATA_W-1:0] = data_memory[mem_addr][DATA_W-1:0];
//						                            
//						                         end
//					               else if(offs==2'd1)
//		          	                         begin
//														    DataR[HALF_W+BYTE_W-1:0] = data_memory[mem_addr][DATA_W-1:BYTE_W];
//						                            DataR[DATA_W-1:HALF_W+BYTE_W] = data_memory[mem_addr+1][BYTE_W-1:0];
//						                           
//						                         end
//						
//					               else if (offs==2'd2)
//					                            begin
//						                            DataR[HALF_W-1:0] = data_memory[mem_addr][DATA_W-1:HALF_W];
//						                            DataR[DATA_W-1:HALF_W] = data_memory[mem_addr+1][HALF_W-1:0];
//						                         end
//					               else //if (offs==2'd3)
//					                            begin
//														    DataR[BYTE_W-1:0] = data_memory[mem_addr][DATA_W-1:HALF_W+BYTE_W];
//						                            DataR[DATA_W-1:BYTE_W] = data_memory[mem_addr+1][HALF_W+BYTE_W-1:0];
//														  
//						                         end
//		                   end
//				  
//		               else 
//		                  DataR = {(DATA_W){1'b0}};
//	               end
//		  
//		             
//		
//		
//	       else if (whb_sel==2'b01)	 //                                   half                      
//	              begin                                              
//	                 if (MemRW==1'b1)                                               
//			               begin                                              
//				                  if(offs==2'd0)
//						                         begin
//						                            DataR[HALF_W-1:0] = data_memory[mem_addr][HALF_W-1:0];
//						                            DataR[DATA_W-1:HALF_W] = {(HALF_W){DataR[HALF_W-1]}};
//						                         end
//					               else if(offs==2'd1)
//		          	                         begin
//														    DataR[BYTE_W-1:0] = data_memory[mem_addr][HALF_W-1:BYTE_W];
//						                            DataR[HALF_W-1:BYTE_W] = data_memory[mem_addr][HALF_W+BYTE_W-1:HALF_W];
//						                            DataR[DATA_W-1:HALF_W] =  {(HALF_W){DataR[HALF_W-1]}};
//						                         end
//						
//					               else if (offs==2'd2)
//					                            begin
//						                            DataR[HALF_W-1:0] = data_memory[mem_addr][DATA_W-1:HALF_W];
//						                            DataR[DATA_W-1:HALF_W] =  {(HALF_W){DataR[HALF_W-1]}};
//						                         end
//					               else //if (offs==2'd3)
//					                            begin
//														    DataR[BYTE_W-1:0] = data_memory[mem_addr][DATA_W-1:HALF_W+BYTE_W];
//						                            DataR[HALF_W-1:BYTE_W] = data_memory[mem_addr+1][BYTE_W-1:0];
//														    DataR[DATA_W-1:HALF_W] = { (HALF_W){DataR[HALF_W-1]}};
//						                         end
//		                   end
//				  
//		               else 
//		                  DataR = {(DATA_W){1'b0}};
//	               end
//		  
//	       else if (whb_sel==2'b10)	 //byte
//	              begin
//	                 if (MemRW==1'b1)
//			               begin 
//				                 if(offs==2'd0)
//					                         begin
//						                         DataR[BYTE_W-1:0] = data_memory[mem_addr][BYTE_W-1:0];
//						                         DataR[DATA_W-1:BYTE_W] =  {(HALF_W+BYTE_W){DataR[BYTE_W-1]}};
//						                      end						
//					              else if (offs==2'd1)
//					                         begin
//						                         DataR[BYTE_W-1:0] = data_memory[mem_addr][2*BYTE_W-1:BYTE_W];
//						                         DataR[DATA_W-1:BYTE_W] =  {(HALF_W+BYTE_W){DataR[BYTE_W-1]}};
//						                      end
//						
//					              else if (offs==2'd2)
//					                         begin
//						                         DataR[BYTE_W-1:0] = data_memory[mem_addr][3*BYTE_W-1:2*BYTE_W];
//						                         DataR[DATA_W-1:BYTE_W] =  {(HALF_W+BYTE_W){DataR[BYTE_W-1]}};
//						                      end
//					
//				              	 else// if (offs==2'd3)
//					                          begin
//					 	                          DataR[BYTE_W-1:0] = data_memory[mem_addr][4*BYTE_W-1:3*BYTE_W];
//					                    	        DataR[DATA_W-1:BYTE_W] =  {(HALF_W+BYTE_W){DataR[BYTE_W-1]}};
//						                       end					  				 
//		                  end
//                   else 
//		                  DataR = {(DATA_W){1'b0}};
//	             end
//		
//		
//       else 
//            DataR = {(DATA_W){1'b0}};
//	    end
//	
//	
//	
//assign  display_mem = data_memory[disp_sel_mem/4];
//	
//	
//endmodule
//


module DRAM #(parameter width = 32,parameter addrWidth = 8)(
output [(width)-1:0] DOUT,
input [addrWidth-1:0] ADDR,
input [(width)-1:0] DIN,
input wren, clock,
input [2:0]func3
);
reg [width-1:0] MEM [0:2**(addrWidth)-1];
wire [(width)-1:0] DOUT_temp;
reg [(width)-1:0]out;

initial begin
	$readmemh("dmem.hex",MEM);
end


always @(posedge clock) begin
	if(!wren)begin
		case(func3)
		2'b000:	MEM[ADDR]<=DIN[7:0];
		2'b001: MEM[ADDR]<=DIN[15:0];	
		2'b010:	MEM[ADDR]<=DIN[31:0];
		endcase
	end
end

assign DOUT_temp = MEM[ADDR];

always@(*)begin
		case(func3)
			3'b000:	out = {{24{DOUT_temp[7]}},DOUT_temp[7:0]};	//LB
			3'b001:	out = {{16{DOUT_temp[15]}},DOUT_temp[15:0]};	//LH
			3'b010:	out = DOUT_temp[31:0];	//LW
			3'b100:	out = {{24{1'b0}},DOUT_temp[7:0]};	//LBU
			3'b101:	out = {{16{1'b0}},DOUT_temp[15:0]};	//LHU
			default: out = 32'b0;
		endcase	
	end

assign DOUT = out;

endmodule

//D:\\ammaz study\\internship\\NU RV\\RV MAC Avalon UART\\RV MAC Avalon Q\\
