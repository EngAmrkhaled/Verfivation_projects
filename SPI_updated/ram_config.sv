class ram_config extends uvm_object;
    `uvm_object_utils(ram_config)
    
    
    uvm_active_passive_enum is_active = UVM_PASSIVE;
    
    // Interface 
    virtual ram_intf vif;

    function new(string name = "ram_config");
        super.new(name);
    endfunction
endclass