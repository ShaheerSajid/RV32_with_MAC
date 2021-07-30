#!/bin/bash
cd ../RV32I_DesignTop/
#Analysis and Synthesis
quartus_map --read_settings_files=on --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#Fitter
quartus_fit --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#Assembler
quartus_asm --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#Timing analyzer
quartus_sta RV32I_DesignTop -c RV32I_DesignTop
#Netlist writer
quartus_eda --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop

cd ../software/



#mv RV32I_DesignTop.ram0_INSTRUCTION_MEM_abd2be51.hdl.mif ../RV32I_DesignTop/db/
#mv RV32I_DesignTop.ram0_DRAM_df80aefc.hdl.mif ../RV32I_DesignTop/db/
#rm dmem.hex
#rm imem.hex 
#rm temp_dmem.txt
#rm temp_imem.txt




