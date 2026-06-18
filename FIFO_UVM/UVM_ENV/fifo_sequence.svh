class fifo_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_sequence)

    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item item;
        `uvm_info("SEQ", "Starting FIFO Sequence...", UVM_LOW)
        
        // (16 Writes)
        for (int i = 0; i < 16; i++) begin
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { is_write == 1; is_read == 0; });
            finish_item(item);
        end
        
        //(16 Reads)
        for (int i = 0; i < 16; i++) begin
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { is_write == 0; is_read == 1; });
            finish_item(item);
        end
        
        // (Concurrent) 
        for (int i = 0; i < 10; i++) begin
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with { is_write == 1; is_read == 1; });
            finish_item(item);
        end
    endtask
endclass