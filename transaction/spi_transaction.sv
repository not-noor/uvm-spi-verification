class spi_transaction extends uvm_sequence_item;

    rand bit [7:0] tx_data;   // master -> slave (MOSI)
    rand bit [7:0] rx_data;   // slave -> master (MISO)

    `uvm_object_utils_begin(spi_transaction)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "spi_transaction");
        super.new(name);
    endfunction

endclass
