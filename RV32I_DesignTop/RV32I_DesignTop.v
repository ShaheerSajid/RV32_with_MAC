module RV32I_DesignTop
( 
input CLOCK_50,
input [3:2]KEY
);


wire CLOCK_1MHZ;


scaler_1MHZ  ss1 (CLOCK_50,CLOCK_1MHZ);



//    System_Jtag u0 (
//        .clk_clk                               (CLOCK_50),                               //                      clk.clk
//        .reset_reset_n                         (KEY[3]),                         //                    reset.reset_n
//        .riscv_core_0_conduit_end_disp_sel     (),     // riscv_core_0_conduit_end.disp_sel
//        .riscv_core_0_conduit_end_display      (),      //                         .display
//        .riscv_core_0_conduit_end_av_writedata (), //                         .av_writedata
//        .clk_1mega_clk                         (CLOCK_50),                         //                clk_1mega.clk
//        .reset_1mega_reset_n                   (KEY[3])                    //              reset_1mega.reset_n
//    );


 System_Jtag u0 (
        .clk_clk                               (CLOCK_50),                               //                      clk.clk
        .reset_reset_n                         (KEY[3]),                         //                    reset.reset_n
        .riscv_core_0_conduit_end_disp_sel     (),     // riscv_core_0_conduit_end.disp_sel
        .riscv_core_0_conduit_end_display      (),      //                         .display
        .riscv_core_0_conduit_end_av_writedata ()  //                         .av_writedata
    );

endmodule



module scaler_1MHZ(clock_in,clock_out);
input clock_in; 
output clock_out; 
reg[27:0] counter=28'd0;
wire [27:0]DIVISOR = (28'd50_000_000)/(28'd50_000_000);


// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR

always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
end
assign clock_out = (counter<DIVISOR/2)?1'b0:1'b1;
endmodule

 



module tb;
	reg rst_n,clk;
   wire [31:0]Data_jtag;
	wire [31:0]Data_display;
	
RV32_core inst
(
.clock(clk),
.reset(~rst_n),
.disp_sel(5'd2),
.display(Data_display),
//for uart
.av_address(),
.av_readdata(),
.av_writedata(),
.av_writedata_reg(Data_jtag),
.av_write_n(),
.av_read_n(),
.av_waitrequest(1'b1)
);

	
	
	integer j;
	initial begin

		#0 rst_n = 1; clk = 0;
		#1 rst_n = 0; #1 rst_n = 1 ;#1
		
		for(j = 0;j < 1000;j = j + 1) begin
			#1 clk = ~clk; #1 clk = ~clk;
		end
	end
endmodule








