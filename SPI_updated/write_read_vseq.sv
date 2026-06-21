class write_read_vseq extends uvm_sequence;
    `uvm_object_utils(write_read_vseq)

    // link with wrapper_vsqr
    `uvm_declare_p_sequencer(wrapper_vsqr)

    // sub seq for SPI
    spi_write_seq write_seq;
    spi_read_seq  read_seq;

    function new(string name = "write_read_vseq");
        super.new(name);
    endfunction

    task body();
         
        bit [7:0] target_addr;
        bit [7:0] target_data;
        write_seq = spi_write_seq::type_id::create("write_seq");
        read_seq  = spi_read_seq::type_id::create("read_seq");

        //random for addr,data
         target_addr = $urandom_range(0, 255);
         target_data = $urandom_range(0, 255);

        `uvm_info("VSEQ", $sformatf("Starting VSEQ: Write 0x%0h to Addr 0x%0h, then Read it back", target_data, target_addr), UVM_LOW)

        write_seq.addr = target_addr;
        write_seq.data = target_data;
        write_seq.start(p_sequencer.spi_sqr); 

        read_seq.addr = target_addr;
        read_seq.start(p_sequencer.spi_sqr);

    endtask
endclass