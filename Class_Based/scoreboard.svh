import pack::*;

class Scoreboard;
    mailbox #(Transaction) mon_mbox;
    bit [31:0] ref_mem[32];
    int trans_count;
    
    function new(mailbox #(Transaction) mbox);
        this.mon_mbox = mbox;
        this.trans_count = 0;
    endfunction
    
    task run();
        forever begin
            Transaction tr;
            mon_mbox.get(tr);
            
            $display("\n[SCB] Checking transaction %0d", trans_count+1);
            $display("[SCB] Operation: %s", tr.Wr_En ? "WRITE" : "READ");
            $display("[SCB] Addr=%0d RefData=0x%h DUTData=0x%h",
                   tr.Address, ref_mem[tr.Address], tr.Data_out);
            
            if(tr.Wr_En) begin
                ref_mem[tr.Address] = tr.Data_in;
                $display("[SCB] Write updated: Addr=%0d Data=0x%h",
                       tr.Address, tr.Data_in);
            end
            else if(tr.Rd_En) begin
                if(ref_mem[tr.Address] == tr.Data_out)
                    $display("[SCB] PASS: Read match");
                else
                    $error("[SCB] FAIL: Addr=%0d Expected=0x%h Actual=0x%h",
                          tr.Address, ref_mem[tr.Address], tr.Data_out);
            end
            
            trans_count++;
            $display("----------------------------");
        end
    endtask
endclass
