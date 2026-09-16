import cocotb
from cocotb.triggers import Timer

@cocotb.test
async def regfile_test(regfile_dut):
    # Multiple read & write access
    write_data_1 = [0x11223344,  0xAAAAAAAA, 0xCAFEBABE, 0x87654321,0xAABBCCDD, 0x12345678, 0xDEADBEEF, 0x55555555]
    write_data_2 = [0x12345678, 0xDEADBEEF, 0x55555555,0x11223344, 0xAABBCCDD,  0xAAAAAAAA, 0xCAFEBABE, 0x87654321]
    rs1_addresses = [1, 5, 10, 17, 23, 28, 31, 3]
    rs2_addresses = [2, 7, 12, 18, 24, 29, 30, 4]

    for i1_write in range(len(write_data_1)):
        for i2_write in range(len(write_data_2)):
            for j_read_rs1 in range(len(rs1_addresses)):
                    for k_read_rs2 in range(len(rs2_addresses)):
                        expected_rs1 = write_data_1[i1_write]
                        expected_rs2 = write_data_2[i2_write]
                        regfile_dut.data.value = expected_rs1
                        regfile_dut.wr_enable.value = 1

                        #Write into register 1
                        regfile_dut.addr_dst.value = rs1_addresses[j_read_rs1]
                        
                        #Enable clock pulse of period 10ns
                        regfile_dut.clk.value = 0
                        await Timer(5,"ns")
                        regfile_dut.clk.value = 1
                        await Timer(5,"ns")

                        #Write into register 2
                        regfile_dut.data.value = expected_rs2
                        regfile_dut.addr_dst.value = rs2_addresses[k_read_rs2]

                        #Enable clock pulse of period 10ns
                        regfile_dut.clk.value = 0
                        await Timer(5,"ns")
                        regfile_dut.clk.value = 1
                        await Timer(5,"ns")

                        regfile_dut.rs1_sel.value = rs1_addresses[j_read_rs1]
                        regfile_dut.rs2_sel.value = rs2_addresses[k_read_rs2]

                        await Timer(1,"ns")
                        assert regfile_dut.out_1.value.to_unsigned() == expected_rs1
                        assert regfile_dut.out_2.value.to_unsigned() == expected_rs2
                        


    
    