class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)

    spi_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        spi_sequence seq;
        super.run_phase(phase);
        
        phase.raise_objection(this);
        seq = spi_sequence::type_id::create("seq");
        seq.start(env.agt.sqr);
        #100; 
        phase.drop_objection(this);
    endtask
endclass