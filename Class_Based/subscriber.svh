// File: subscriber.svh
import pack::*;
class Subscriber;
    mailbox mon_mbox;
    
    function new(mailbox mbox);
        this.mon_mbox = mbox;
    endfunction
    
    task run();
        forever begin
            Transaction tr;
            mon_mbox.get(tr);
            $display("Subscriber: Addr=%0d Data=0x%h", tr.Address, tr.Data_out);
        end
    endtask
endclass
