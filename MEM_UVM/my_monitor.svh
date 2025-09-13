import uvm_pkg ::*;
import pack1::*;
`include "uvm_macros.svh"
class my_monitor extends uvm_monitor;

 `uvm_component_utils(my_monitor)

    uvm_analysis_port #(my_sequence_item) ap;
    my_sequence_item local_item;
    virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("my_monitor build_phase");
      
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("MONITOR", "Failed to get virtual interface from config DB")
      end
      
      local_item = my_sequence_item::type_id::create("local_item");
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_monitor connect_phase");
    endfunction

task run_phase(uvm_phase phase);
    my_sequence_item item;
    super.run_phase(phase);
    $display("my_monitor run_phase");
    
    forever begin
        // Wait for clock edge
        @(posedge vif.CLK);
        
        // Capture write operations immediately
        if (vif.Wr_En && !vif.Rd_En) begin
            item = my_sequence_item::type_id::create("item");
            item.Address = vif.Address;
            item.Data_in = vif.Data_in;
            item.Wr_En = vif.Wr_En;
            item.Rd_En = vif.Rd_En;
            item.is_write = 1;
            item.is_read = 0;
            `uvm_info("MON", $sformatf("Monitoring write item: %s", item.convert2string()), UVM_MEDIUM)
            ap.write(item);
        end
        
        // Capture read operations with a one-cycle delay to get the correct data
        if (vif.Rd_En && !vif.Wr_En) begin
            // Wait one cycle to get the read data
            @(posedge vif.CLK);
            if (vif.Valid_out) begin
                item = my_sequence_item::type_id::create("item");
                item.Address = vif.Address; // Address might have changed, need to track it
                item.Data_out = vif.Data_out;
                item.Valid_out = vif.Valid_out;
                item.Wr_En = 0;
                item.Rd_En = 1;
                item.is_write = 0;
                item.is_read = 1;
                `uvm_info("MON", $sformatf("Monitoring read item(Valid_out = 1): %s", item.convert2string()), UVM_MEDIUM)
                ap.write(item);
            end
        end
    end
endtask
  endclass