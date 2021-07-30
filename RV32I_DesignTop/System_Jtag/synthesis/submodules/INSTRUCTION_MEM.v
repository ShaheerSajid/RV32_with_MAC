//module RISC_V
module INSTRUCTION_MEM
# (parameter DATA_WIDTH=32, ADDR_W_IMEM=12)
(
   input [(ADDR_W_IMEM-1):0] addr,
	output reg [(DATA_WIDTH-1):0] instr
);

	reg [DATA_WIDTH-1:0] rom[2**(ADDR_W_IMEM-2)-1:0];

	
	wire [(ADDR_W_IMEM-3):0] mem_addr;
	assign mem_addr=(addr/4);
	
	
	initial
	begin
		$readmemh("imem.hex",rom);
	end

	always @ (rom,mem_addr)
	begin
		instr <= rom[mem_addr];
	end

endmodule

//D:\\ammaz study\\internship\\NU RV\\RV MAC Avalon UART\\RV MAC Avalon Q\\


