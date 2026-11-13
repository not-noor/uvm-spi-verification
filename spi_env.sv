class spi_env extends uvm_env;

    `uvm_component_utils(spi_env)

    wb_agent       wb_agt;
    spi_agent      spi_agt;
    spi_scoreboard sb;

    function new(string name = "spi_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wb_agt  = wb_agent::type_id::create("wb_agt", this);
        spi_agt = spi_agent::type_id::create("spi_agt", this);
        sb      = spi_scoreboard::type_id::create("sb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wb_agt.monitor.ap.connect(sb.wb_imp);
        spi_agt.monitor.ap.connect(sb.spi_imp);
    endfunction

endclass
