class wrapper_test extends uvm_test;
    `uvm_component_utils(wrapper_test)

    wrapper_env env;
    spi_config  spi_cfg;
    ram_config  ram_cfg;

    function new(string name = "wrapper_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        spi_cfg = spi_config::type_id::create("spi_cfg");
        ram_cfg = ram_config::type_id::create("ram_cfg");

       // (Active vs Passive)
        spi_cfg.is_active = UVM_ACTIVE;   
        ram_cfg.is_active = UVM_PASSIVE;  
        
        uvm_config_db#(spi_config)::set(this, "env.spi_agt", "spi_cfg", spi_cfg);
        uvm_config_db#(ram_config)::set(this, "env.ram_agt", "ram_cfg", ram_cfg);

       
        env = wrapper_env::type_id::create("env", this);
    endfunction

   
    task run_phase(uvm_phase phase);
      
        write_read_vseq vseq;
        vseq = write_read_vseq::type_id::create("vseq");

        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting Virtual Sequence on Virtual Sequencer...", UVM_LOW)
        vseq.start(env.v_sqr); 
        
        #100; 
        phase.drop_objection(this);
    endtask
endclass