class timer_adapter extends uvm_reg_adapter;
    `uvm_object_utils(timer_adapter)

    function new(string name = "timer_adapter");
        super.new(name);
    endfunction

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        timer_bus_item bus_item = timer_bus_item::type_id::create("bus_item");
        bus_item.addr     = rw.addr;
        bus_item.data     = rw.data;
        bus_item.is_write = (rw.kind == UVM_WRITE);
        return bus_item;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        timer_bus_item item;
        if (!$cast(item, bus_item)) begin
            `uvm_fatal("ADAPTER", "Wrong bus item type!")
        end
        rw.addr   = item.addr;
        rw.data   = item.data;
        rw.kind   = item.is_write ? UVM_WRITE : UVM_READ;
        rw.status = UVM_IS_OK;
    endfunction
endclass