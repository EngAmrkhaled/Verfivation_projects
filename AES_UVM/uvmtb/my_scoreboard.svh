
import uvm_pkg::*;
import pack1::*;
`include "uvm_macros.svh"

class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    
    uvm_analysis_imp#(my_sequence_item, my_scoreboard) item_export;
    my_sequence_item item_queue[$];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_export = new("item_export", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void write(my_sequence_item item);
        // Declare all variables at the beginning of the function
        int key_file, output_file;
        bit [127:0] exp_data_out;
        int scan_count;
        string line;
        
        item_queue.push_back(item);
        `uvm_info("SCOREBOARD", $sformatf("Received item: Key=0x%h, Data_in=0x%h, Data_out=0x%h, Start=%0d, Ready=%0d, Done=%0d", 
                 item.key, item.data_in, item.data_out, item.start, item.ready, item.done), UVM_LOW)
        
        // Write key and data to file for Python script
        key_file = $fopen("key.txt", "w");
        if (key_file) begin
            $fdisplay(key_file, "%h", item.key);
            $fdisplay(key_file, "%h", item.data_in);
            $fclose(key_file);
        end else begin
            `uvm_error("SCOREBOARD", "Failed to open key.txt for writing")
        end
        
        // Run Python encryption script
        if ($system("python aes_enc.py") != 0) begin
            `uvm_error("SCOREBOARD", "Python script execution failed")
        end
        
        // Read expected output from Python script
        output_file = $fopen("output.txt", "r");
        if (output_file) begin
            scan_count = $fscanf(output_file, "%h", exp_data_out);
            $fclose(output_file);
            
            if (scan_count != 1) begin
                `uvm_error("SCOREBOARD", "Failed to read expected output from file")
            end else begin
                // Compare with actual output
                if (item.data_out === exp_data_out) begin
                    `uvm_info("SCOREBOARD", "PASS: Output matches expected value", UVM_LOW)
                end else begin
                    `uvm_error("SCOREBOARD", $sformatf("FAILURE: OUT=0x%h, EXP_OUT=0x%h", 
                             item.data_out, exp_data_out))
                end
            end
        end else begin
            `uvm_error("SCOREBOARD", "Failed to open output.txt for reading")
        end
    endfunction
endclass
