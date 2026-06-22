package timer_uvm_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "timer_bus_item.sv"
    `include "reg_tmr_ctrl.sv"
    `include "reg_tmr_prd.sv"
    `include "reg_tmr_stat.sv"
    `include "reg_tmr_cnt.sv"
    `include "timer_reg_block.sv"
    `include "timer_adapter.sv"
    `include "timer_agent_components.sv" 
    `include "timer_scoreboard.sv"       
    `include "timer_env.sv"              
    `include "run_timer_sequence.sv"
    `include "timer_test.sv"
endpackage