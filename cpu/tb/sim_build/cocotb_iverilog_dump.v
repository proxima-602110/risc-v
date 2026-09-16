module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/_05_imem	.fst");
    $dumpvars(0, _05_imem	);
end
endmodule
