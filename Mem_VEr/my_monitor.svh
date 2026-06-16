//import uvm_pkg ::*;
//import pack1::*;
//`include "uvm_macros.svh"
class my_monitor extends uvm_monitor;

 `uvm_component_utils(my_monitor)

    uvm_analysis_port #(my_sequence_item) ap;
    virtual my_intf vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if (!uvm_config_db#(virtual my_intf)::get(this, "", "vif", vif)) begin
        `uvm_error("MONITOR", "Failed to get virtual interface from config DB")
      end
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    endfunction

task run_phase(uvm_phase phase);
    my_sequence_item item;
    super.run_phase(phase);
    
    forever begin
        @(posedge vif.CLK);
            if (vif.Rst_n) begin
                
                if (vif.Wr_En && !vif.Rd_En) begin
                    item = my_sequence_item::type_id::create("item");
                    item.Wr_En    = 1'b1;
                    item.Rd_En    = 1'b0;
                    item.Address  = vif.Address;
                    item.Data_in  = vif.Data_in;
                    item.is_write = 1'b1;
                    item.is_read  = 1'b0;
                    ap.write(item);
                end
               if (vif.Rd_En && !vif.Wr_En) begin
                    fork
                        capture_read_data(vif.Address);
                    join_none
                end
            end
        end
    endtask

    task capture_read_data(bit [4:0] captured_addr);
        my_sequence_item r_item;
        @(posedge vif.CLK); 
        if (vif.Valid_out) begin
            r_item = my_sequence_item::type_id::create("r_item");
            r_item.Wr_En     = 1'b0;
            r_item.Rd_En     = 1'b1;
            r_item.Address   = captured_addr;
            r_item.Data_out  = vif.Data_out;
            r_item.Valid_out = vif.Valid_out;
            r_item.is_write  = 1'b0;
            r_item.is_read   = 1'b1;
            ap.write(r_item);
        end
    endtask

  endclass