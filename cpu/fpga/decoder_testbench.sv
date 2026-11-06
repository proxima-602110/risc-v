module decoder_testbench#(parameter DATA_WIDTH = 32,parameter ADDR_WIDTH = 32, parameter INSTR_WIDTH = 32, parameter REG_COUNT = 32, parameter BUS_WIDTH = 32)(
input logic clk,
input logic rst,
output logic[DATA_WIDTH-1:0] alu_out
);

typedef enum logic {
    STATE_FETCH_DECODE = 1'b0,
    STATE_WRITEBACK = 1'b1
} state_t;
logic[INSTR_WIDTH-1:0] instruction;
logic[DATA_WIDTH-1:0] data_in;
logic[3:0] alu_ctrl;
logic[$clog2(ADDR_WIDTH)-1:0] rd;
logic[$clog2(ADDR_WIDTH)-1:0] rs1_sel;
logic[$clog2(ADDR_WIDTH)-1:0] rs2_sel;
logic wr_enable;
logic[DATA_WIDTH-1:0] out_1;
logic[DATA_WIDTH-1:0] out_2;

logic[BUS_WIDTH-1:0] registers_isa[0:REG_COUNT-1]; //Unpacked array containing initialzed register data (x0 - x31)
logic[INSTR_WIDTH-1:0] instructions[0:9]; //Unpacked array of instructions (R-type)
logic[4:0] ins_index;


decoder U1(.instruction(instruction),.alu_ctrl(alu_ctrl),.rd(rd),.rs1_sel(rs1_sel),.rs2_sel(rs2_sel));
regfile U2(.clk(clk),.rs1_sel(rs1_sel),.rs2_sel(rs2_sel),.data(alu_out),.addr_dst(rd),.wr_enable(1'b0),.out_1(out_1),.out_2(out_2));
alu U3(.src_1(out_1),.src_2(out_2),.alu_ctrl(alu_ctrl),.alu_result(alu_out));

initial begin
$readmemh("register_init.hex",registers_isa);   //Initialized register data
$readmemh("rtypeinstructions.hex",instructions); //Instruction data (32-bit)
end

always_ff @(posedge clk) begin 
    if(rst)
        ins_index <= '0;
    end else
        ins_index <= ins_index + 1;
    end
end

always_comb begin
    instruction = instructions[ins_index];
end
        

endmodule