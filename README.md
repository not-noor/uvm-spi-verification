# UVM Verification of an SPI Core

UVM testbench for the OpenCores `simple_spi` core (Wishbone slave, SPI master).

A Wishbone agent configures the core and writes/reads SPDR, an SPI agent acts as a mode 0 slave, and a scoreboard checks that SPDR writes appear on MOSI and that MISO bytes are read back over Wishbone.

## Structure

```
rtl/          DUT (simple_spi, fifo4)
interface/    Wishbone and SPI interfaces
transaction/  Sequence items
wb_agent/     Wishbone agent
spi_agent/    SPI slave agent
spi_*.sv      Package, scoreboard, env, test
tb_top.sv     Top module
```

## Run

Requires Cadence Xcelium with UVM 1.1d.

```
xrun -f run.f
```

## Credits

RTL by Richard Herveille, from [OpenCores simple_spi](https://opencores.org/projects/simple_spi).
