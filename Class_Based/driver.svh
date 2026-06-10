

import pack::*;

class Driver;
    virtual memory_if vif;
    mailbox #(int) req_mbox;      
    mailbox #(Transaction) rsp_mbox;
    event handshake;
    int trans_count;
    
    function new(virtual memory_if vif, mailbox #(int) req, mailbox #(Transaction)rsp, event h);
        this.vif = vif;
        this.req_mbox = req;
        this.rsp_mbox = rsp;
        this.handshake = h;
    endfunction
    
    task run();
         Transaction tr;
        forever begin
            // Request new transaction
            req_mbox.put(trans_count+1);
            
            // Get and drive transaction
           
            rsp_mbox.get(tr);
            trans_count++;
            
            // First cycle - setup address/control
            @(vif.drv_cb);
            vif.drv_cb.Address <= tr.Address;
            vif.drv_cb.Wr_En <= tr.Wr_En;
            vif.drv_cb.Rd_En <= tr.Rd_En;
            if(tr.Wr_En) vif.drv_cb.Data_in <= tr.Data_in;
            
            $display("[DRV-%0d] @%0t Phase1: Addr=%0d %s",
                   trans_count, $time,
                   tr.Address,
                   tr.Wr_En ? "WRITE" : "READ");
            
            // Second cycle - complete operation
            @(vif.drv_cb);
            vif.drv_cb.Wr_En <= 0;
            vif.drv_cb.Rd_En <= 0;
            
            $display("[DRV-%0d] @%0t Phase2: Completed",
                   trans_count, $time);
            
            // Signal completion
            ->handshake;
        end
    endtask
endclass
