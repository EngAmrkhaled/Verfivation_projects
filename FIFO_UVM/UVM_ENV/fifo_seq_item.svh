class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    // ctrl
    rand bit is_write;
    rand bit is_read;
    
    // Data
    rand bit [7:0] wdata;
         bit [7:0] rdata;
         bit wfull;
         bit rempty;

    // Constraint: write or read or both
    constraint valid_op {
        is_write || is_read;
    }

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

    virtual function string convert2string();
        string s = "";
        if (is_write) s = {s, $sformatf("WRITE: data=0x%0h ", wdata)};
        if (is_read)  s = {s, $sformatf("READ: data=0x%0h ", rdata)};
        return s;
    endfunction

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        fifo_seq_item rhs_mint;
        if (!$cast(rhs_mint, rhs)) return 0;
        return (super.do_compare(rhs, comparer) &&
                (this.rdata == rhs_mint.rdata)); // نقارن مخرجات القراءة فقط
    endfunction
endclass