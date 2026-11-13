class wb_transaction extends uvm_sequence_item;

    rand bit       write;
    rand bit [2:0] address;
    rand bit [7:0] data;

    `uvm_object_utils_begin(wb_transaction)
        `uvm_field_int(write,   UVM_ALL_ON)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(data,    UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "wb_transaction");
        super.new(name);
    endfunction

endclass
