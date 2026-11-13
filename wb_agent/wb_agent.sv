class wb_agent extends uvm_agent;

    `uvm_component_utils(wb_agent)

    wb_driver    driver;
    wb_monitor   monitor;
    wb_sequencer sequencer;

    function new(string name = "wb_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver    = wb_driver::type_id::create("driver", this);
        monitor   = wb_monitor::type_id::create("monitor", this);
        sequencer = wb_sequencer::type_id::create("sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass
