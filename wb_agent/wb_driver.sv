class wb_driver extends uvm_driver #(wb_transaction);

    `uvm_component_utils(wb_driver)

    virtual wishbone_if vif;

    function new(string name = "wb_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual wishbone_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Wishbone interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        wb_transaction tr;

        vif.cyc   <= 0;
        vif.stb   <= 0;
        vif.we    <= 0;
        vif.adr   <= 0;
        vif.dat_i <= 0;

        wait (vif.rst === 0);

        forever begin
            seq_item_port.get_next_item(tr);
            drive_transfer(tr);
            seq_item_port.item_done();
        end
    endtask

    task drive_transfer(wb_transaction tr);
        @(posedge vif.clk);
        vif.cyc <= 1;
        vif.stb <= 1;
        vif.we  <= tr.write;
        vif.adr <= tr.address;
        if (tr.write)
            vif.dat_i <= tr.data;

        do @(posedge vif.clk); while (!vif.ack);

        // return read data to the sequence
        if (!tr.write)
            tr.data = vif.dat_o;

        vif.cyc <= 0;
        vif.stb <= 0;
        vif.we  <= 0;
    endtask

endclass
