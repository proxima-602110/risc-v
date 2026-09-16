import cocotb
from cocotb.triggers import Timer

@cocotb.test
async def pc_test(pc_dut):
    pc_dut.reset.value = 1
    pc_dut.clk.value = 0
    await Timer(5,"ns")
    pc_dut.clk.value = 1
    await Timer(5,"ns")
    assert pc_dut.pc.value.to_unsigned() == 0
    pc_dut.reset.value = 0

    for pulses in range(5):
        pc_val_old = pc_dut.pc.value
        pc_dut.clk.value = 0
        await Timer(5,"ns")
        pc_dut.clk.value = 1
        await Timer(5,"ns")
        
    assert pc_dut.pc.value.to_unsigned() == pc_val_old.to_unsigned() + 4  