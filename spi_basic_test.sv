class spi_basic_test extends uvm_test;

    `uvm_component_utils(spi_basic_test)

    spi_env env;

    function new(string name = "spi_basic_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        wb_sequence  wb_seq;
        spi_sequence spi_seq;

        phase.raise_objection(this);

        wb_seq  = wb_sequence::type_id::create("wb_seq");
        spi_seq = spi_sequence::type_id::create("spi_seq");
        spi_seq.num_bytes = wb_seq.tx_bytes.size();

        fork
            wb_seq.start(env.wb_agt.sequencer);
            spi_seq.start(env.spi_agt.sequencer);
        join

        #100;
        phase.drop_objection(this);
    endtask

endclass
