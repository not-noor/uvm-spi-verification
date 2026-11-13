class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    virtual spi_if vif;

    uvm_analysis_port #(spi_transaction) ap;

    function new(string name = "spi_monitor", uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual spi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "SPI interface not found")
    endfunction

    // mode 0: both lines are sampled on the rising edge of sck
    virtual task run_phase(uvm_phase phase);
        spi_transaction tr;

        forever begin
            tr = spi_transaction::type_id::create("tr");
            for (int i = 7; i >= 0; i--) begin
                @(posedge vif.sck iff vif.ss === 0);
                tr.tx_data[i] = vif.mosi;
                tr.rx_data[i] = vif.miso;
            end
            ap.write(tr);
        end
    endtask

endclass
