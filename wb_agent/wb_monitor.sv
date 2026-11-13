class wb_monitor extends uvm_monitor;

    `uvm_component_utils(wb_monitor)

    virtual wishbone_if vif;

    uvm_analysis_port #(wb_transaction) ap;

    function new(string name = "wb_monitor", uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual wishbone_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Wishbone interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        wb_transaction tr;

        forever begin
            @(posedge vif.clk);
            if (vif.cyc && vif.stb && vif.ack) begin
                tr = wb_transaction::type_id::create("tr");
                tr.write   = vif.we;
                tr.address = vif.adr;
                tr.data    = vif.we ? vif.dat_i : vif.dat_o;
                ap.write(tr);
            end
        end
    endtask

endclass
