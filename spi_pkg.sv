`ifndef SPI_PKG_SV
`define SPI_PKG_SV

package spi_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // simple_spi register map
    localparam bit [2:0] SPCR_ADDR = 3'b000;
    localparam bit [2:0] SPSR_ADDR = 3'b001;
    localparam bit [2:0] SPDR_ADDR = 3'b010;
    localparam bit [2:0] SPER_ADDR = 3'b011;
    localparam bit [2:0] SS_ADDR   = 3'b100;

    `include "transaction/spi_transaction.sv"
    `include "transaction/wb_transaction.sv"

    `include "wb_agent/wb_sequence.sv"
    `include "wb_agent/wb_sequencer.sv"
    `include "wb_agent/wb_driver.sv"
    `include "wb_agent/wb_monitor.sv"
    `include "wb_agent/wb_agent.sv"

    `include "spi_agent/spi_sequence.sv"
    `include "spi_agent/spi_sequencer.sv"
    `include "spi_agent/spi_driver.sv"
    `include "spi_agent/spi_monitor.sv"
    `include "spi_agent/spi_agent.sv"

    `include "spi_scoreboard.sv"
    `include "spi_env.sv"
    `include "spi_basic_test.sv"

endpackage

`endif
