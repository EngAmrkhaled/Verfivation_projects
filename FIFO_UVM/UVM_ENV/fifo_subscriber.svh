class fifo_subscriber extends uvm_subscriber #(fifo_seq_item);
    `uvm_component_utils(fifo_subscriber)

    fifo_seq_item local_item;
    
    covergroup fifo_cg;
        write_cp: coverpoint local_item.is_write;
        read_cp:  coverpoint local_item.is_read;
        data_cp:  coverpoint local_item.wdata {
            bins zero = {0};
            bins low  = {[1:127]};
            bins high = {[128:255]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_cg = new();
    endfunction

    virtual function void write(fifo_seq_item t);
        this.local_item = t;
        fifo_cg.sample();
    endfunction
endclass