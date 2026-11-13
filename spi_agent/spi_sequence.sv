class spi_sequence extends uvm_sequence #(spi_transaction);

    `uvm_object_utils(spi_sequence)

    int unsigned num_bytes = 1;

    function new(string name = "spi_sequence");
        super.new(name);
    endfunction

    virtual task body();
        spi_transaction tr;

        repeat (num_bytes) begin
            tr = spi_transaction::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize())
                `uvm_error("SPI_SEQ", "Randomization failed")
            finish_item(tr);
        end
    endtask

endclass
