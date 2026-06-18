class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_intf vif;
    uvm_analysis_port #(fifo_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Failed to get VIF")
    endfunction

    task run_phase(uvm_phase phase);
        fork
            // Write monitor
            forever begin
                @(posedge vif.wclk);
                if (vif.wrst_n && vif.winc && !vif.wfull) begin
                    fifo_seq_item w_item = fifo_seq_item::type_id::create("w_item");
                    w_item.is_write = 1;
                    w_item.is_read  = 0;
                    w_item.wdata    = vif.wdata;
                    ap.write(w_item);
                end
            end

            // read monitor
            forever begin
                @(posedge vif.rclk);
                if (vif.rrst_n && vif.rinc && !vif.rempty) begin
                    fifo_seq_item r_item = fifo_seq_item::type_id::create("r_item");
                    r_item.is_write = 0;
                    r_item.is_read  = 1;
                    r_item.rdata    = vif.rdata; 
                    ap.write(r_item);
                end
            end
        join
    endtask
endclass