
import pack::*;

class Sequencer;
    mailbox #(int) req_mbox;
    mailbox #(Transaction) rsp_mbox;
    event handshake;
    int trans_count;
    
    function new(mailbox #(int) req, mailbox #(Transaction) rsp, event h);
        this.req_mbox = req;
        this.rsp_mbox = rsp;
        this.handshake = h;
    endfunction
    
    task run(int num_trans);
         Transaction tr;
         int dummy;
        for(int i=0; i<num_trans; i++) begin
            req_mbox.get(dummy); // Wait for driver request
             tr = new();
            assert(tr.randomize());
            trans_count++;
            
            $display("\n=== SEQ Iteration %0d @%0t ===", trans_count, $time);
            $display("[SEQ] Generated: Addr=%0d %s Data=0x%h",
                   tr.Address, 
                   tr.Wr_En ? "WRITE" : "READ",
                   tr.Data_in);
                   
            rsp_mbox.put(tr);
            @(handshake); // Wait for driver to complete
        end
    endtask
endclass