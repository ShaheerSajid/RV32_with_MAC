#!/bin/bash
riscv64-unknown-elf-gcc conv_1d_mac.c -nostdlib -T link_simple.ld -march=rv32i -mabi=ilp32  -o test.elf 
riscv64-unknown-elf-objdump -D test.elf  > test.txt
riscv64-unknown-elf-objdump -d -w test.elf | sed '1,7d' > temp_imem.txt
riscv64-unknown-elf-objdump -s -j .rodata test.elf | sed '1,4d' > temp_dmem.txt
python memory_script.py
cp dmem.hex ../Core-files/
cp imem.hex ../Core-files/
cp dmem.hex ../RV32I_DesignTop/simulation/modelsim/
cp imem.hex ../RV32I_DesignTop/simulation/modelsim/
cp dmem.hex ../RV32I_DesignTop/System_Jtag/simulation/submodules/
cp imem.hex ../RV32I_DesignTop/System_Jtag/simulation/submodules/
cp dmem.hex ../RV32I_DesignTop/System_Jtag/synthesis/submodules/
cp imem.hex ../RV32I_DesignTop/System_Jtag/synthesis/submodules/
#mv RV32I_DesignTop.ram0_INSTRUCTION_MEM_abd2be51.hdl.mif ../RV32I_DesignTop/db/
#mv RV32I_DesignTop.ram0_DRAM_df80aefc.hdl.mif ../RV32I_DesignTop/db/
#rm dmem.hex
#rm imem.hex 
#rm temp_dmem.txt
#rm temp_imem.txt




