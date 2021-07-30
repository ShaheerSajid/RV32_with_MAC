#!/bin/bash

cd ../RV32I_DesignTop/
quartus_cdb --update_mif RV32I_DesignTop #quartus_cdb --update_mif <project name>
quartus_asm RV32I_DesignTop #quartus_asm <project name>


#Analysis and Synthesis
#Fitter
#Assembler
#Timing analyzer
#Netlist writer
#quartus_map --read_settings_files=on --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#quartus_fit --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#quartus_asm --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop
#quartus_sta RV32I_DesignTop -c RV32I_DesignTop
#quartus_eda --read_settings_files=off --write_settings_files=off RV32I_DesignTop -c RV32I_DesignTop


cd output_files/
quartus_pgm -c USB-Blaster RV32I_DesignTop.cdf
cd ../../software/
nios2-terminal
