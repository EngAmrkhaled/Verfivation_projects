
import pack::*;

class Monitor;
    virtual memory_if vif;
    mailbox #(Transaction) scb_mbox;
    int trans_count;
    
    function new(virtual memory_if vif, mailbox #(Transaction) scb);
        this.vif = vif;
        this.scb_mbox = scb;
    endfunction
    
    task run();
         Transaction tr;
        forever begin
            // Wait for valid operation
            @(vif.mon_cb);
            if (vif.mon_cb.Wr_En || vif.mon_cb.Rd_En) begin
            
             tr = new();
            tr.Address = vif.mon_cb.Address;
            tr.Wr_En = vif.mon_cb.Wr_En;
            tr.Rd_En = vif.mon_cb.Rd_En;
            
            if(vif.Wr_En) begin
                tr.Data_in = vif.mon_cb.Data_in;
                //@(posedge vif.CLK); // Wait one cycle for write ack
                $display("[MON-%0d] @%0t WriteCaptured: Addr=%0d Data=0x%h",
                       ++trans_count, $time,
                       tr.Address, tr.Data_in);
                scb_mbox.put(tr);       
            end
             else if (tr.Rd_En) begin
               tr.Data_out = vif.mon_cb.Data_out;
               tr.Valid_out = vif.mon_cb.Valid_out;
                $display("[MON-%0d] @%0t ReadCaptured: Addr=%0d Data=0x%h Valid=%b",
                       ++trans_count, $time,
                       tr.Address, tr.Data_out, tr.Valid_out);
               scb_mbox.put(tr);        
            end
            
        end
        end
    endtask
endclass
