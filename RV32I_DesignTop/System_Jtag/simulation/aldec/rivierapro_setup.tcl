
# (C) 2001-2021 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.0sp1 232 win32 2021.07.28.14:45:30

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize the variable
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
} 

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "System_Jtag"
} 

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
} 

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera/13.0sp1/quartus/"
} 

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/submodules/dmem.hex ./
  file copy -force $QSYS_SIMDIR/submodules/imem.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                  ./libraries/altera_ver      
vmap       altera_ver       ./libraries/altera_ver      
ensure_lib                  ./libraries/lpm_ver         
vmap       lpm_ver          ./libraries/lpm_ver         
ensure_lib                  ./libraries/sgate_ver       
vmap       sgate_ver        ./libraries/sgate_ver       
ensure_lib                  ./libraries/altera_mf_ver   
vmap       altera_mf_ver    ./libraries/altera_mf_ver   
ensure_lib                  ./libraries/altera_lnsim_ver
vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver
ensure_lib                  ./libraries/cycloneii_ver   
vmap       cycloneii_ver    ./libraries/cycloneii_ver   
ensure_lib                                          ./libraries/rst_controller                          
vmap       rst_controller                           ./libraries/rst_controller                          
ensure_lib                                          ./libraries/jtag_uart_0_avalon_jtag_slave_translator
vmap       jtag_uart_0_avalon_jtag_slave_translator ./libraries/jtag_uart_0_avalon_jtag_slave_translator
ensure_lib                                          ./libraries/RISCV_CORE_0_avalon_master_translator   
vmap       RISCV_CORE_0_avalon_master_translator    ./libraries/RISCV_CORE_0_avalon_master_translator   
ensure_lib                                          ./libraries/jtag_uart_0                             
vmap       jtag_uart_0                              ./libraries/jtag_uart_0                             
ensure_lib                                          ./libraries/RISCV_CORE_0                            
vmap       RISCV_CORE_0                             ./libraries/RISCV_CORE_0                            

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog +define+SKIP_KEYWORDS_PRAGMA "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_atoms.v"   -work cycloneii_ver   
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/submodules/altera_reset_controller.v"          -work rst_controller                          
  vlog  "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"        -work rst_controller                          
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"  -work jtag_uart_0_avalon_jtag_slave_translator
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv" -work RISCV_CORE_0_avalon_master_translator   
  vlog  "$QSYS_SIMDIR/submodules/System_Jtag_jtag_uart_0.v"          -work jtag_uart_0                             
  vlog  "$QSYS_SIMDIR/submodules/ALU.v"                              -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/BRANCH_COMP.v"                      -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/CONTROL_UNIT.v"                     -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/DATA_MEM.v"                         -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/Forwarding.v"                       -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/IMM_GEN.v"                          -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/INSTRUCTION_MEM.v"                  -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/MAC_UNIT.v"                         -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/MUX2X1.v"                           -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/PCSel_compute.v"                    -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/PIPES.v"                            -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/PROGRAM_COUNTER.v"                  -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/REG_FILE.v"                         -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/submodules/RISC_V.v"                           -work RISCV_CORE_0                            
  vlog  "$QSYS_SIMDIR/System_Jtag.v"                                                                               
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  vsim +access +r  -t ps -L work -L rst_controller -L jtag_uart_0_avalon_jtag_slave_translator -L RISCV_CORE_0_avalon_master_translator -L jtag_uart_0 -L RISCV_CORE_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  vsim -dbg -O2 +access +r -t ps -L work -L rst_controller -L jtag_uart_0_avalon_jtag_slave_translator -L RISCV_CORE_0_avalon_master_translator -L jtag_uart_0 -L RISCV_CORE_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
