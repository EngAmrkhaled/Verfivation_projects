//import uvm_pkg ::*;
//import pack1::*;
//`include "uvm_macros.svh"
class my_driver extends uvm_driver#(my_sequence_item);

`uvm_component_utils(my_driver)
 virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("DRIVER", "Failed to get virtual interface from config DB")
      end
      endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    endfunction

    
task run_phase(uvm_phase phase);
    my_sequence_item item;
    super.run_phase(phase);
    
    // Initialize interface signals
        vif.Wr_En   <= 1'b0;
        vif.Rd_En   <= 1'b0;
        vif.Data_in <= '0;
        vif.Address <= '0;

    wait(vif.Rst_n == 1'b1);
        `uvm_info("DRV_RUN", "Reset released. Driver starts tracking...", UVM_LOW)

    forever begin
        seq_item_port.get_next_item(item);
        `uvm_info("DRV", $sformatf("Driving item: %s", item.convert2string()), UVM_MEDIUM)
        
        // Drive signals to interface synchronized with clock
        @(posedge vif.CLK);
            vif.Wr_En   <= item.Wr_En;
            vif.Rd_En   <= item.Rd_En;
            vif.Address <= item.Address;
            if (item.Wr_En) begin
                vif.Data_in <= item.Data_in;
            end
        
        // Deassert signals after one cycle
        @(posedge vif.CLK);
        vif.Wr_En <= 0;
        vif.Rd_En <= 0;
        
        seq_item_port.item_done();
    end
endtask
  endclass