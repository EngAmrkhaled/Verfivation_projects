class fifo_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_driver)

    virtual fifo_intf vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Failed to get VIF")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_seq_item item;
        
        vif.winc  <= 0;
        vif.wdata <= 0;
        vif.rinc  <= 0;
        
        wait(vif.wrst_n && vif.rrst_n);
        
        forever begin
            seq_item_port.get_next_item(item);
            
            // parllel write, read
            fork
                
                begin
                    if (item.is_write && !vif.wfull) begin
                        @(posedge vif.wclk);
                        vif.winc  <= 1;
                        vif.wdata <= item.wdata;
                        @(posedge vif.wclk);
                        vif.winc  <= 0;
                    end
                end
                
                begin
                    if (item.is_read && !vif.rempty) begin
                        @(posedge vif.rclk);
                        vif.rinc <= 1;
                        @(posedge vif.rclk);
                        vif.rinc <= 0;
                    end
                end
            join
            
            seq_item_port.item_done();
        end
    endtask
endclass