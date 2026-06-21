class spi_subscriber extends uvm_subscriber #(spi_seq_item);
    `uvm_component_utils(spi_subscriber)

    spi_seq_item local_item;
    
    covergroup spi_cg;
        cmd_cp: coverpoint local_item.cmd {
            bins wr_addr = {2'b00};
            bins wr_data = {2'b01};
            bins rd_addr = {2'b10};
            bins rd_data = {2'b11};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        spi_cg = new();
    endfunction

    virtual function void write(spi_seq_item t);
        this.local_item = t;
        spi_cg.sample();
    endfunction
endclass