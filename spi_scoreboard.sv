`uvm_analysis_imp_decl(_wb)
`uvm_analysis_imp_decl(_spi)

class spi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(spi_scoreboard)

    uvm_analysis_imp_wb  #(wb_transaction,  spi_scoreboard) wb_imp;
    uvm_analysis_imp_spi #(spi_transaction, spi_scoreboard) spi_imp;

    bit [7:0] tx_q[$];   // bytes written to SPDR, expected on MOSI
    bit [7:0] rx_q[$];   // bytes seen on MISO, expected on SPDR reads

    int unsigned tx_checks;
    int unsigned rx_checks;

    function new(string name = "spi_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wb_imp  = new("wb_imp", this);
        spi_imp = new("spi_imp", this);
    endfunction

    function void write_wb(wb_transaction tr);
        bit [7:0] exp;

        if (tr.address != SPDR_ADDR)
            return;

        if (tr.write) begin
            tx_q.push_back(tr.data);
            `uvm_info("SCOREBOARD", $sformatf("Expected SPI TX = %0h", tr.data), UVM_LOW)
            return;
        end

        if (rx_q.size() == 0) begin
            `uvm_error("SCOREBOARD", $sformatf("SPDR read %0h with no byte received on MISO", tr.data))
            return;
        end

        exp = rx_q.pop_front();
        rx_checks++;
        if (tr.data == exp)
            `uvm_info("SCOREBOARD", $sformatf("PASS : Read Data = %0h", tr.data), UVM_LOW)
        else
            `uvm_error("SCOREBOARD", $sformatf("FAIL : Expected %0h Actual %0h", exp, tr.data))
    endfunction

    function void write_spi(spi_transaction tr);
        bit [7:0] exp;

        rx_q.push_back(tr.rx_data);
        `uvm_info("SCOREBOARD", $sformatf("Expected Wishbone Read = %0h", tr.rx_data), UVM_LOW)

        if (tx_q.size() == 0) begin
            `uvm_error("SCOREBOARD", $sformatf("Unexpected SPI transfer, MOSI = %0h", tr.tx_data))
            return;
        end

        exp = tx_q.pop_front();
        tx_checks++;
        if (tr.tx_data == exp)
            `uvm_info("SCOREBOARD", $sformatf("PASS : MOSI = %0h", tr.tx_data), UVM_LOW)
        else
            `uvm_error("SCOREBOARD", $sformatf("FAIL : Expected MOSI = %0h Actual = %0h", exp, tr.tx_data))
    endfunction

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        if (tx_checks == 0 || rx_checks == 0)
            `uvm_error("SCOREBOARD", "No data was checked")
        if (tx_q.size() != 0)
            `uvm_error("SCOREBOARD", $sformatf("%0d byte(s) written but never sent on MOSI", tx_q.size()))
        if (rx_q.size() != 0)
            `uvm_error("SCOREBOARD", $sformatf("%0d received byte(s) never read back", rx_q.size()))
    endfunction

endclass
