import cocotb
from cocotb.triggers import Timer

@cocotb.test
async def imem_test(imem_dut):
    test_vectors = [
    (0x00000000, 0x00500093),
    (0x00000004, 0x00A00113),
    (0x00000008, 0x002081B3),
    (0x0000000C, 0x00310233),
    (0x00000010, 0x004182B3),
    ]

    for pc, expected in test_vectors:
        imem_dut.pc_address.value = pc
        await Timer(1,"ns")
        assert imem_dut.instr_fetched.value.to_unsigned() == expected
    