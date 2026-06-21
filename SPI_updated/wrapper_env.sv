class wrapper_env extends uvm_env;
    `uvm_component_utils(wrapper_env)

    spi_agent          spi_agt;
    ram_agent          ram_agt;
    wrapper_vsqr       v_sqr;    
    wrapper_scoreboard sb;        

    function new(string name = "wrapper_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        spi_agt = spi_agent::type_id::create("spi_agt", this);
        ram_agt = ram_agent::type_id::create("ram_agt", this);
        v_sqr   = wrapper_vsqr::type_id::create("v_sqr", this);
        sb      = wrapper_scoreboard::type_id::create("sb", this);
    endfunction

    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (spi_agt.cfg.is_active == UVM_ACTIVE) begin
            v_sqr.spi_sqr = spi_agt.sqr; 
        end

        spi_agt.agt_ap.connect(sb.spi_export);
        ram_agt.agt_ap.connect(sb.ram_export);
    endfunction
endclass