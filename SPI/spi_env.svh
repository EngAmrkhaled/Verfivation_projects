class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_agent      agt;
    spi_scoreboard sb;
    spi_subscriber sub;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = spi_agent::type_id::create("agt", this);
        sb  = spi_scoreboard::type_id::create("sb", this);
        sub = spi_subscriber::type_id::create("sub", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.ap.connect(sb.analysis_export);
        agt.ap.connect(sub.analysis_export);
    endfunction
endclass