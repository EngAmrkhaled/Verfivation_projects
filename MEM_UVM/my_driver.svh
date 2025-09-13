import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_driver extends uvm_driver#(my_sequence_item);

`uvm_component_utils(my_driver)

    my_sequence_item local_item;
    virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_driver build_phase");
      
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("DRIVER", "Failed to get virtual interface from config DB")
      end
      
      local_item = my_sequence_item::type_id::create("local_item");
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_driver connect_phase");
    endfunction

    
task run_phase(uvm_phase phase);
    my_sequence_item item;
    super.run_phase(phase);
    $display("my_driver run_phase");
    
    // Initialize interface signals
    vif.Wr_En = 0;
    vif.Rd_En = 0;
    vif.Data_in = 0;
    vif.Address = 0;
    
    forever begin
        seq_item_port.get_next_item(item);
        `uvm_info("DRV", $sformatf("Driving item: %s", item.convert2string()), UVM_MEDIUM)
        
        // Drive signals to interface synchronized with clock
        @(posedge vif.CLK);
        vif.Wr_En <= item.Wr_En;
        vif.Rd_En <= item.Rd_En;
        vif.Data_in <= item.Data_in;
        vif.Address <= item.Address;
        
        // Deassert signals after one cycle
        @(posedge vif.CLK);
        vif.Wr_En <= 0;
        vif.Rd_En <= 0;
        
        seq_item_port.item_done();
    end
endtask
  endclass