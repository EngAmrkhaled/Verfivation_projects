class spi_sequence extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_sequence)

    function new(string name = "spi_sequence");
        super.new(name);
    endfunction

    task body();
        spi_seq_item item;
        bit [7:0] test_addrs [5] = '{8'h10, 8'h20, 8'h30, 8'hFF, 8'h00};
        
        `uvm_info("SEQ", "Starting SPI Transaction Sequence...", UVM_LOW)
        
        // Write
        foreach (test_addrs[i]) begin
            // send addr
            item = spi_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { cmd == 2'b00; data == test_addrs[i]; });
            finish_item(item);
            
            // send data
            item = spi_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { cmd == 2'b01; data == test_addrs[i] + 8'hA0; });
            finish_item(item);
        end
        
        // Read from same locations
        foreach (test_addrs[i]) begin
            // send addr
            item = spi_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { cmd == 2'b10; data == test_addrs[i]; });
            finish_item(item);
            
            // read data
            item = spi_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { cmd == 2'b11; });
            finish_item(item);
        end
    endtask
endclass