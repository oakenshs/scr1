`include "scr1_arch_description.svh"
`include "scr1_csr.svh"
`include "scr1_arch_types.svh"
`include "scr1_riscv_isa_decoding.svh"
`ifdef SCR1_IPIC_EN
`include "scr1_ipic.svh"
`endif // SCR1_IPIC_EN
`ifdef SCR1_DBG_EN
`include "scr1_hdu.svh"
`endif // SCR1_DBG_EN
`ifdef SCR1_TDU_EN
`include "scr1_tdu.svh"
`endif // SCR1_TDU_EN

module scr1_tb_log_cmd();


always_ff @(posedge scr1_top_tb_ahb.i_top.i_imem_ahb.clk) begin
    if (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_resp == 2'b01) begin
        // valid data from ahb router
        if (
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[6 : 0] == 7'b0110011) &    // R-type
            // (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[14 : 12] == 3'b111)
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[14 : 12] == 3'b000) &      // funct3: 000 - SUB
            (scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata[31 : 25] == 7'b0100000)        // funct7: 0100000 - SUB
        ) begin
            // detect and command
            $display("=== DETECTED SUB COMMAND ===");
            $display("--- Machine Information Registers --- ");
            $display("MVENDORID: %b", SCR1_CSR_MVENDORID);
            $display("MARCHID: %b", SCR1_CSR_MARCHID);
            $display("MIMPID: %b", SCR1_CSR_MIMPID);
            $display("mhartid: 0x%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.soc2csr_fuse_mhartid_i);
            $display("--- Machine Trap Setup --- ");
            $display("mstatus: 0x%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mstatus);
            $display("MISA: 0x%b", SCR1_CSR_MISA);
            $display("mie: 0x%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mie);
            $display("--- Machine Trap Handling --- ");
            $display("mepc: 0x%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mepc);
            $display("mip: 0x%b", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.i_pipe_csr.csr_mip);

            $display("--- Other Info --- ");
            $display("imem_rdata: 0x%h", scr1_top_tb_ahb.i_top.i_imem_ahb.imem_rdata);
            $display("imem_resp: 0x%h", scr1_top_tb_ahb.i_top.i_imem_ahb.imem_resp);
            $display("curr_pc: 0x%h", scr1_top_tb_ahb.i_top.i_core_top.i_pipe_top.curr_pc);
            $display("=================================");
        end
    end
end

endmodule
