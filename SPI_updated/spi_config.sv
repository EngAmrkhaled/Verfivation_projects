class spi_config extends uvm_object;
    `uvm_object_utils(spi_config)
    
  
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    // Interface 
    virtual spi_intf vif;

    function new(string name = "spi_config");
        super.new(name);
    endfunction
endclass