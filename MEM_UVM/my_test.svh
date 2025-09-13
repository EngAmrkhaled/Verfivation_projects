import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_test extends uvm_test;

 `uvm_component_utils(my_test)

    my_env env;
    virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_test build_phase");
      
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("TEST", "Failed to get virtual interface from config DB")
      end
      
      uvm_config_db#(virtual my_intf)::set(this, "env", "vif", vif);
      
      env = my_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_test connect_phase");
    endfunction

    task run_phase(uvm_phase phase);
      my_sequence seq;
      super.run_phase(phase);
      $display("my_test run_phase");
      phase.raise_objection(this);

      seq = my_sequence::type_id::create("seq");
      seq.start(env.agt.sqr);

      #200;
      phase.drop_objection(this);
    endtask
endclass