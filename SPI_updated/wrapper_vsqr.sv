class wrapper_vsqr extends uvm_sequencer;
    `uvm_component_utils(wrapper_vsqr)

    
    spi_sequencer spi_sqr; 

    function new(string name = "wrapper_vsqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass