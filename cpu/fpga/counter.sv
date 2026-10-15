module counter#(parameter N = 32, parameter CLK_SPEED = 27_000_000)(
    input logic rst,
    input logic clk,
    output logic[5:0] led_res);

localparam COUNT_WIDTH = $clog2(CLK_SPEED);

logic[N-1:0] A;
logic[N-1:0] B;
logic[3:0] opcode;
logic clk_en;
logic[COUNT_WIDTH-1:0] count;
logic[67:0] alu_mem[31:0]; //32 test data , 68 bit word (A + B + opcode)
logic[4:0] test_index;
logic[N-1:0] result;
initial begin
    $readmemh("test_mem.mem",alu_mem);
end
alu dut(.src_1(A),.src_2(B),.alu_ctrl(opcode),.alu_result(result));

//Generate 1 Hz pulse
always_ff @(posedge clk) begin
    if(rst) begin
        count <= '0;
        clk_en <= '0;
        test_index <= '0;
    end else if(count == (CLK_SPEED)/2 - 1) begin
        count <= '0;
        clk_en <= ~clk_en;

        if(clk_en) begin
            if(test_index == 4)
                test_index <= 0;
            else
                test_index <= test_index + 1'b1;
        end
    end else begin
        count <= count + 1'b1;
    end
end

        
//Load memory into ALU inputs
always_ff @(posedge clk) begin
    if(rst) begin //Synchronous reset 
        A <= '0;
        B <= '0;
        opcode = '0;
    end else if(clk_en) begin
        A <= alu_mem[test_index][31:0];
        B <= alu_mem[test_index][63:32];
        opcode <= alu_mem[test_index][67:64];
    end
end

assign led_res = result[5:0];
endmodule
        
