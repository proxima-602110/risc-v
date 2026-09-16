import cocotb
from cocotb.triggers import Timer

opr_add  = 0
opr_sub  = 1
opr_srl  = 2
opr_sll  = 3
opr_sra  = 4
opr_and  = 5
opr_or   = 6
opr_xor  = 7
opr_slt  = 8
opr_sltu = 9

async def  coroutine_addition(alu_dut): #Create addition co-routine
    alu_dut.alu_ctrl.value = opr_add
    for i in range(256):
       for j in range(256):
           alu_dut.src_1.value = i;
           alu_dut.src_2.value = j;
           
           await Timer(2,unit="ns")
           assert alu_dut.alu_result.value.to_unsigned() == (i + j) & 0xFFFFFFFF;
           
async def coroutine_subtraction(alu_dut):
    alu_dut.alu_ctrl.value = opr_sub
    for i in range(256):
        for j in range(256):
            alu_dut.src_1.value = i;
            alu_dut.src_2.value = j;

            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_unsigned() == (i - j) & 0xFFFFFFFF;

async def coroutine_srl(alu_dut):
    alu_dut.alu_ctrl.value = opr_srl
    for i in range(256):
        for j in range(32):
            alu_dut.src_1.value = i;
            alu_dut.src_2.value = j;

            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_unsigned() == (i >> j) & 0xFFFFFFFF;

async def coroutine_sll(alu_dut):
    alu_dut.alu_ctrl.value = opr_sll
    for i in range(256):
        for j in range(32):
            alu_dut.src_1.value = i;
            alu_dut.src_2.value = j;

            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_unsigned() == (i << j) & 0xFFFFFFFF;

async def coroutine_sra(alu_dut):
    alu_dut.alu_ctrl.value = opr_sra
    for i in range(256):
        for j in range(32):
            alu_dut.src_1.value = i;
            alu_dut.src_2.value = j;

            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_signed() == (i >> j) & 0xFFFFFFFF;

async def coroutine_logic(alu_dut):
    for i in range(256):
        for j in range(256):
            for k in range(opr_and,opr_slt):
                alu_dut.src_1.value = i;
                alu_dut.src_2.value = j;
                alu_dut.alu_ctrl.value = k;

                await Timer(2,unit="ns")
                match k:
                    case 5:
                        assert alu_dut.alu_result.value.to_unsigned() == (i & j) & 0xFFFFFFFF
                    case 6:
                        assert alu_dut.alu_result.value.to_unsigned() == (i | j) & 0xFFFFFFFF
                    case 7:
                        assert alu_dut.alu_result.value.to_unsigned() == (i ^ j) & 0xFFFFFFFF


def conv_to_signed(val):
    if val & 0x80000000:
        return val - 0x100000000
    return val

test_vectors1 = [0x0,0xF,0xE,0xFFFF,0xFEFE,0xAACCDDFF,0xFFFFEEEE]
test_vectors2 = [0x79999999,0x77776767,0x7FFFFFFF,0x80000000,0xFFFFFFFE,0xFFFFFDDD,0xFFFFFFFF]
async def coroutine_slt(alu_dut):
    alu_dut.alu_ctrl.value = opr_slt
    for i in range(len(test_vectors1)):
        for j in range(len(test_vectors2)):
            alu_dut.src_1.value = test_vectors1[i];
            alu_dut.src_2.value = test_vectors2[j];
            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_unsigned() == int(conv_to_signed(test_vectors1[i]) < conv_to_signed(test_vectors2[j]))

async def coroutine_sltu(alu_dut):
    alu_dut.alu_ctrl.value = opr_sltu
    for i in range(len(test_vectors1)):
        for j in range(len(test_vectors2)):
            alu_dut.src_1.value = test_vectors1[i];
            alu_dut.src_2.value = test_vectors2[j];
            await Timer(2,unit="ns")
            assert alu_dut.alu_result.value.to_unsigned() == int(test_vectors1[i] < test_vectors2[j])

@cocotb.test
async def alu_block_test(alu_dut):
    await coroutine_addition(alu_dut)
    await coroutine_subtraction(alu_dut)
    await coroutine_srl(alu_dut)
    await coroutine_sll(alu_dut)
    await coroutine_sra(alu_dut)
    await coroutine_logic(alu_dut)
    await coroutine_slt(alu_dut)
    await coroutine_sltu(alu_dut)