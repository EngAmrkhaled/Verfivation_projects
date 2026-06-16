//import uvm_pkg ::*;
//import pack1::*;
//`include "uvm_macros.svh"
class my_env extends uvm_env;

  `uvm_component_utils(my_env)

    my_agent       agt;
    my_scoreboard  sb;
    my_subscriber  sub;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      agt = my_agent::type_id::create("agt", this);
      sb  = my_scoreboard::type_id::create("sb", this);
      sub = my_subscriber::type_id::create("sub", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // Connect agent's analysis port to scoreboard and subscriber
      agt.ap.connect(sb.analysis_export);
      agt.ap.connect(sub.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
    endtask
  endclass