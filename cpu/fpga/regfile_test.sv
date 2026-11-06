module regfile_test#(parameter FMAX = 27_000_000)(
    input logic clk,
    input logic rst,
    output logic[4:0] result
);

logic[51:0] test[0:31];
logic[31:0] test_index;
logic[25:0] count;
logic[31:0] out_1;           
logic[31:0] out_2;
logic[31:0] alu_out;

regfile U1(.clk(clk),.rs1_sel(test[test_index][4:0]),.rs2_sel(test[test_index][5:9]),.data(test[test_index][10:41]),.addr_dst(test[test_index][42:47]),.wr_enable(test[test_index][48]),.out_1(out_1),.out_2(out_2));
alu U2(.src_1(out_1),.src_2(out_2),.alu_ctrl(test[test_index][49:52]),.alu_result(alu_out));