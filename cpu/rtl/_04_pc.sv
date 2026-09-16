/*It is a special-purpose register part of the RISC-V architecture. It is not included in the standard 32 registers between x0-x31.
  Used to inform the processor about which instruction is to be executed next. It holds the address of the current instruction.
  The PC is essentially a pointer to instruction memory. 
  
  SSD stores application/executable -> OS demands executable from SSD and loads it into RAM -> Cache loads instructions for fast access 
  -> PC stores address of desired instruction -> CPU requests instruction from cache -> Instruction goes to decoder
  -> CPU executes the instruction after decoding -> PC updates
  
  PC is loaded with the reset address during start-up. In this case 0x0.

  In a 32-bit architecture, one word is 4 bytes. In RV32-I each instruction is 4 bytes wide, so consecutive instructions are spaced
  4 bytes wide. 

  For normal sequential instructions, the program counter increments by a word corresponding to the next instruction. Branch and jump instructions are a different case.*/ 
module _04_pc#(parameter ADDR_WIDTH = 32)(
  input logic clk,
  input logic reset,
  output logic[ADDR_WIDTH-1:0] pc
);

localparam logic[ADDR_WIDTH-1:0] RESET_ADDR = 32'h0000_0000;

always_ff @(posedge clk) begin
  if(reset)
      pc <= RESET_ADDR;
  else 
      pc <= pc+4;
end
endmodule