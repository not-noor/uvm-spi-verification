class wb_sequence extends uvm_sequence #(wb_transaction);

    `uvm_object_utils(wb_sequence)

    bit [7:0] tx_bytes[$] = '{8'hA5};

    int unsigned poll_limit = 1000;

    function new(string name = "wb_sequence");
        super.new(name);
    endfunction

    virtual task body();
        bit [7:0] status;
        bit [7:0] rdata;
        int unsigned polls;

        write_reg(SS_ADDR,   8'h01);   // ss_o is active low: ss_r=1 selects the slave
        write_reg(SPCR_ADDR, 8'h40);   // SPE=1, mode 0, fastest clock

        foreach (tx_bytes[i]) begin
            write_reg(SPDR_ADDR, tx_bytes[i]);

            // wait for the received byte instead of a fixed delay (SPSR[0] = rfempty)
            polls = 0;
            do begin
                read_reg(SPSR_ADDR, status);
                if (++polls > poll_limit)
                    `uvm_fatal("WB_SEQ", "Timeout waiting for SPI transfer to complete")
            end while (status[0]);

            read_reg(SPDR_ADDR, rdata);
        end

        write_reg(SS_ADDR, 8'h00);
    endtask

    task write_reg(bit [2:0] addr, bit [7:0] data);
        wb_transaction tr = wb_transaction::type_id::create("tr");
        start_item(tr);
        tr.write   = 1;
        tr.address = addr;
        tr.data    = data;
        finish_item(tr);
    endtask

    task read_reg(bit [2:0] addr, output bit [7:0] data);
        wb_transaction tr = wb_transaction::type_id::create("tr");
        start_item(tr);
        tr.write   = 0;
        tr.address = addr;
        tr.data    = 0;
        finish_item(tr);
        data = tr.data;
    endtask

endclass
