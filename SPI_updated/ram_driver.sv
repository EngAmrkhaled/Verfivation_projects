class ram_driver extends uvm_driver #(ram_item);
    `uvm_component_utils(ram_driver)

    virtual ram_intf vif;

    function new(string name = "ram_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_vif", vif))
            `uvm_fatal("RAM_DRV", "Failed to get RAM VIF")
    endfunction

    task run_phase(uvm_phase phase);
        
        
    endtask
endclass