//import uvm_pkg ::*;
//import pack1::*;
//`include "uvm_macros.svh"
class my_test extends uvm_test;

 `uvm_component_utils(my_test)

    my_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     // uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt", "is_active", UVM_PASSIVE);   
      env = my_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
      my_sequence seq;
      super.run_phase(phase);
      phase.raise_objection(this);

      seq = my_sequence::type_id::create("seq");
      seq.start(env.agt.sqr);

      phase.drop_objection(this);
    endtask
endclass