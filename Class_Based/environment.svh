
import pack::*;

class Environment;
    Sequencer seq;
    Driver drv;
    Monitor mon;
    Scoreboard scb;
    
    mailbox #(int) req_mbox;
    mailbox #(Transaction) rsp_mbox, scb_mbox;
    event handshake;
    
    function new(virtual memory_if vif);
        req_mbox = new();
        rsp_mbox = new();
        scb_mbox = new();
        
        this.seq = new(req_mbox, rsp_mbox, handshake);
        this.drv = new(vif, req_mbox, rsp_mbox, handshake);
        this.mon = new(vif, scb_mbox);
        this.scb = new(scb_mbox);
    endfunction
    
    task run(int num_trans);
        fork
            seq.run(num_trans);
            drv.run();
            mon.run();
            scb.run();
        join_none
        
        // Timeout protection
        while (scb.trans_count < num_trans) #10;
        $display("Simulation completed with %0d transactions", num_trans);
        $finish;
    endtask
endclass
