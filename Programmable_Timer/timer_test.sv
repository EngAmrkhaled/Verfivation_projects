class timer_test extends uvm_test;
    `uvm_component_utils(timer_test)
    timer_env env;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        env = timer_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        run_timer_sequence seq = run_timer_sequence::type_id::create("seq");
        phase.raise_objection(this);
        
        seq.rmodel = env.reg_model;
        seq.start(env.agent.sqr);
        
        phase.drop_objection(this);
    endtask
endclass