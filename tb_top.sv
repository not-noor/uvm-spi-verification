module tb_top;

    import uvm_pkg::*;
    import spi_pkg::*;

    bit clk = 0;
    bit rst = 1;

    always #5 clk = ~clk;

    initial #20 rst = 0;

    wishbone_if wb_if(clk, rst);
    spi_if      spi_if_inst(clk);

    simple_spi dut (
        .clk_i (clk),
        .rst_i (rst),
        .adr_i (wb_if.adr),
        .dat_i (wb_if.dat_i),
        .dat_o (wb_if.dat_o),
        .we_i  (wb_if.we),
        .stb_i (wb_if.stb),
        .cyc_i (wb_if.cyc),
        .ack_o (wb_if.ack),
        .inta_o(),
        .sck_o (spi_if_inst.sck),
        .mosi_o(spi_if_inst.mosi),
        .miso_i(spi_if_inst.miso),
        .ss_o  (spi_if_inst.ss)
    );

    initial begin
        uvm_config_db #(virtual wishbone_if)::set(null, "*", "vif", wb_if);
        uvm_config_db #(virtual spi_if)::set(null, "*", "vif", spi_if_inst);
        run_test("spi_basic_test");
    end

endmodule
