/*Each instruction is of 32-bits. The last  bits determine the type of instruction i.e. it is the opcode.
  R-type instruction: All R-type instructions have the same opcode. Information on which R-type instruction comes from function codes.
  bits 0-6 : opcode, bits , bit 12-14 : func3, bits 25-31 : func7, destination reg (rd) : bits 7-11, bits 15-19 : src1, bits 20-24 : src2
 */
 
 module decoder#(parameter INSTR_WIDTH = 32)(
	input logic[INSTR_WIDTH-1:0] instruction,
    output logic[3:0] alu_ctrl,
    output logic[4:0] rd,
    output logic[4:0] rs1_sel,
    output logic[4:0] rs2_sel
);

typedef enum logic [3:0] {
    opr_add = 4'd0,
    opr_sub = 4'd1,
    opr_srl = 4'd2,
    opr_sll = 4'd3,
    opr_sra = 4'd4,
    opr_and = 4'd5,
    opr_or = 4'd6,
    opr_xor = 4'd7,
    opr_slt = 4'd8,
    opr_sltu = 4'd9
} alu_opc_t;


logic[6:0] opcode;
logic[2:0] func3;
logic[6:0] func7;


localparam logic[6:0] rtype_opcode = 7'b0010011;

assign opcode = instruction[6:0];
assign func3 = instruction[14:12];
assign func7 = instruction[31:25];
assign rd = instruction[11:7];
assign rs1_sel = instruction[19:15];
assign rs2_sel = instruction[24:20];


always_comb begin
	alu_ctrl = opr_add;
	case(opcode)
		rtype_opcode : begin
			case(func3)
				3'b000 : begin 
					case(func7)
						7'b0000000 : alu_ctrl = opr_add;
						7'b0100000 : alu_ctrl = opr_sub;
						default : alu_ctrl = opr_add;
					endcase
				end
				
				3'b001 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_sll;
						default : alu_ctrl = opr_add;
					endcase
				end
				
				3'b010 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_slt;
						default : alu_ctrl = opr_add;
					endcase
				end
				
				3'b011 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_sltu;
						default : alu_ctrl = opr_add;
					endcase	
				end
	
				3'b100 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_xor;
						default : alu_ctrl = opr_add;
					endcase		
				end
			
				3'b101 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_srl;
						7'b0100000 : alu_ctrl = opr_sra;
						default : alu_ctrl = opr_add;
					endcase	
				end
				
				3'b110 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_or;
						default : alu_ctrl = opr_add;
					endcase
				end
				
				3'b111 : begin
					case(func7)
						7'b0000000 : alu_ctrl = opr_and;
						default : alu_ctrl = opr_add;
					endcase
				end
			endcase
		end
		
		default : alu_ctrl = opr_add;
	endcase
end

endmodule
