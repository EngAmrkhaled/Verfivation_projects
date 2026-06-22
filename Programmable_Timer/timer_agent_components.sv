// 1. Sequencer
typedef uvm_sequencer#(timer_bus_item) timer_sequencer;

// 2. Driver
class timer_driver extends uvm_driver#(timer_bus_item);
    `uvm_component_utils(timer_driver)

    virtual timer_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual timer_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Could not get virtual interface vif!!!")
        end
           endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        vif.bus_addr  <= 32'h0;
        vif.bus_wdata <= 32'h0;
        vif.bus_write <= 1'b0;
        vif.bus_sel   <= 1'b0;

        @(posedge vif.rst_n);

        forever begin
            
            seq_item_port.get_next_item(req);
            
           
            @(posedge vif.clk);
            
         
            vif.bus_sel   <= 1'b1;
            vif.bus_addr  <= req.addr;
            vif.bus_write <= req.is_write;
            
            if (req.is_write) begin
                vif.bus_wdata <= req.data; 
            end

            @(posedge vif.clk);
            
            if (!req.is_write) begin
                req.data = vif.bus_rdata;
            end

            vif.bus_sel   <= 1'b0;
            vif.bus_write <= 1'b0;

            seq_item_port.item_done();
        end
    endtask
endclass

// 3. Monitor 
class timer_monitor extends uvm_monitor;
    `uvm_component_utils(timer_monitor)
    
    virtual timer_if vif;
    uvm_analysis_port#(timer_bus_item) ap; 

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual timer_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Could not get virtual interface vif!")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        @(posedge vif.rst_n);
        
        forever begin
            @(posedge vif.clk);
            if (vif.bus_sel) begin
                timer_bus_item item = timer_bus_item::type_id::create("item");
                
                item.addr     = vif.bus_addr;
                item.is_write = vif.bus_write;
                
                if (vif.bus_write) begin
                    item.data = vif.bus_wdata; 
                end else begin
                    @(posedge vif.clk);
                    item.data = vif.bus_rdata;
                end
                
                ap.write(item);
            end
        end
    endtask
endclass

// ==========================================
// 4. الـ Agent Container
// ==========================================
class timer_agent extends uvm_agent;
    `uvm_component_utils(timer_agent)
    timer_sequencer sqr;
    timer_driver    drv;
    timer_monitor   mon;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr = timer_sequencer::type_id::create("sqr", this);
        drv = timer_driver::type_id::create("drv", this);
        mon = timer_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass