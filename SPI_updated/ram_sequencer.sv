class ram_sequencer extends uvm_sequencer #(ram_item);
    `uvm_component_utils(ram_sequencer)

    function new(string name = "ram_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass