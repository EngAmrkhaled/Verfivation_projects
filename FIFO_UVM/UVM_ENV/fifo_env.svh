class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent      agt;
    fifo_scoreboard sb;
    fifo_subscriber sub;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = fifo_agent::type_id::create("agt", this);
        sb  = fifo_scoreboard::type_id::create("sb", this);
        sub = fifo_subscriber::type_id::create("sub", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.ap.connect(sb.analysis_export);
        agt.ap.connect(sub.analysis_export);
    endfunction
endclass