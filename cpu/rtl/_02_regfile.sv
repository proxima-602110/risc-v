/*RISC-V has 32 registers in total
    register - enables CPU to access data, addresses and instructions
               fastest storage elements in a microprocessor (register > cache > dram)
               x0 - zero register : stores the value 0, anything written to it will be discarded.
               x1 - ra - return address register : stores the address of the next instruction to be executed after the current instruction
               has finished executing.
               x2 - sp - stack pointer : points to the top of the stack memory by default. Used for storing local variables, handling
                         function calls etc. Pushing causes sp to decrement by 1, then pushes the value into the stack. Popping 
                         removes the data from the stack at the current location of the sp (LIFO order) then increments value of sp.
                Stack memory - Located at higher address sections of main memory, moves down to lower memory addresses as more local variables are created and as functions are called
                Heap memory - Located at lower address sections of main memory, moves up to higher memory addresses. For malloc()/dynamically allocation
                global_b -> BSS segment - for global/static variables that are either uninitialized or set to zero
                global_a -> Data segment - for storing global variables
                Local Variable - Created in stack memory during function/block call and deleted from memory once execution of block is completed
                Global Variable - Stored in data segment memory for the entire application as long as the application is running.
               
               
               */


module _02_regfile#(parameter BUS_WIDTH = 32,
                    parameter REG_COUNT = 32)(
    input logic clk,
    input logic[$clog2(REG_COUNT)-1:0] rs1_sel,  //Source 1 address
    input logic[$clog2(REG_COUNT)-1:0] rs2_sel,  //Source 2 address
    input logic[BUS_WIDTH-1:0] data,             //Input data
    input logic[$clog2(REG_COUNT)-1:0] addr_dst, //Destination register address                             
    input logic wr_enable,                       //Write enable
    output logic[BUS_WIDTH-1:0] out_1,           //Output 1 (src_1 to alu)
    output logic[BUS_WIDTH-1:0] out_2            //Output 2 (src_2 to alu)
);

logic[BUS_WIDTH-1:0] registers_isa[0:REG_COUNT-1];

//Writing into registers is a sequential process and occurs at every positive edge of the clock    
always_ff @(posedge clk) begin
   if(wr_enable && (addr_dst != '0)) //Prevents writes to register x0 
        registers_isa[addr_dst] <= data;
end

//Reading registers is a combinational process
assign out_1 = (rs1_sel == '0) ? '0 : registers_isa[rs1_sel];
assign out_2 = (rs2_sel == '0) ? '0 : registers_isa[rs2_sel];
endmodule
