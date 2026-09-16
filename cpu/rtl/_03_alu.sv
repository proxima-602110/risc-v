module _03_alu#(parameter DATA_WIDTH = 32)(
    input logic[DATA_WIDTH-1:0] src_1,
    input logic[DATA_WIDTH-1:0] src_2,
    input logic [3:0] alu_ctrl,
    output logic[DATA_WIDTH-1:0] alu_result
);

typedef enum logic [3:0] {
    opr_add  = 0,
    opr_sub  = 1,
    opr_srl  = 2,
    opr_sll  = 3,
    opr_sra  = 4,
    opr_and  = 5,
    opr_or   = 6,
    opr_xor  = 7,
    opr_slt  = 8,
    opr_sltu = 9
} alu_opc_t;

always_comb begin
    case(alu_ctrl)
        opr_add : alu_result = src_1 + src_2;
        opr_sub : alu_result = src_1 - src_2;
        opr_srl : alu_result = src_1 >> src_2[4:0];
        opr_sll : alu_result = src_1 << src_2[4:0]; //Max shift by 31 bits
        opr_sra : alu_result = $signed(src_1) >>> src_2[4:0];
        opr_and : alu_result = src_1 & src_2;
        opr_or : alu_result = src_1 | src_2;
        opr_xor : alu_result = src_1 ^ src_2;
        opr_slt : alu_result = ($signed(src_1) < $signed(src_2)) ? {{(DATA_WIDTH-1){1'b0}},1'b1} : '0;
        opr_sltu : alu_result = (src_1 < src_2) ? {{(DATA_WIDTH-1){1'b0}},1'b1} : '0;

        default :
            alu_result = '0;
    endcase
end
endmodule