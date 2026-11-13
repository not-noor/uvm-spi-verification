// SPI slave model, mode 0 (CPOL=0, CPHA=0)
class spi_driver extends uvm_driver #(spi_transaction);

    `uvm_component_utils(spi_driver)

    virtual spi_if vif;

    function new(string name = "spi_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual spi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "SPI interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        spi_transaction tr;

        vif.miso <= 0;

        forever begin
            seq_item_port.get_next_item(tr);
            drive_byte(tr);
            seq_item_port.item_done();
        end
    endtask

    // MSB must be on MISO before the first rising edge; later bits change on falling edges
    task drive_byte(spi_transaction tr);
        wait (vif.ss === 0);
        vif.miso <= tr.rx_data[7];
        for (int i = 6; i >= 0; i--) begin
            @(negedge vif.sck);
            vif.miso <= tr.rx_data[i];
        end
        @(negedge vif.sck);
    endtask

endclass
