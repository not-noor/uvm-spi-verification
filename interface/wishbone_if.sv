interface wishbone_if(input logic clk, input logic rst);

    logic       cyc;
    logic       stb;
    logic       we;
    logic [2:0] adr;
    logic [7:0] dat_i;
    logic [7:0] dat_o;
    logic       ack;

endinterface
