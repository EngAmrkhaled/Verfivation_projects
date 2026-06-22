class timer_env extends uvm_env;
    `uvm_component_utils(timer_env)

    timer_agent                        agent;
    timer_reg_block                reg_model;
    timer_adapter                  adapter;
    uvm_reg_predictor#(timer_bus_item) predictor;
    timer_scoreboard              scoreboard; 
    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent      = timer_agent::type_id::create("agent", this);
        reg_model  = timer_reg_block::type_id::create("reg_model");
        reg_model.build();
        adapter    = timer_adapter::type_id::create("adapter");
        predictor  = uvm_reg_predictor#(timer_bus_item)::type_id::create("predictor", this);
        scoreboard = timer_scoreboard::type_id::create("scoreboard", this); 
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        predictor.map     = reg_model.timer_map;
        predictor.adapter = adapter;
        agent.mon.ap.connect(predictor.bus_in);
        reg_model.timer_map.set_sequencer(agent.sqr, adapter);

        agent.mon.ap.connect(scoreboard.bus_export); 
        scoreboard.regmodel = reg_model;             
    endfunction
endclass