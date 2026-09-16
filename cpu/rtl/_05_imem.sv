module _05_imem#(parameter INSTR_WIDTH = 32, parameter ADDR_WIDTH = 32, parameter IMEM_SIZE = 1024)(
    input logic[ADDR_WIDTH-1:0] pc_address,
    output logic[INSTR_WIDTH-1:0] instr_fetched
);

logic[INSTR_WIDTH-1:0] imem[0:IMEM_SIZE-1]; //4 KiB
assign instr_fetched = imem[pc_address >> 2]; //pc address is a byte address but we need instruction index

initial begin
    $readmemh("init.mem",imem);
end
endmodule