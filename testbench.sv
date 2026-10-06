`timescale 1ns / 1ps

// ============================================================
// Generic testbench for parameterized register file
// ============================================================

module register_file_test #(
    parameter DATA_WIDTH = 32,
    parameter NUM_REGS   = 32
);

    localparam ADDR_WIDTH = $clog2(NUM_REGS);

    logic clk;
    logic rst;

    logic [ADDR_WIDTH-1:0] READREG1;
    logic [ADDR_WIDTH-1:0] READREG2;
    logic [ADDR_WIDTH-1:0] WRITEREG;

    logic [DATA_WIDTH-1:0] WRITEDATA;
    logic WRITEENABLE;

    logic [DATA_WIDTH-1:0] REGOUT1;
    logic [DATA_WIDTH-1:0] REGOUT2;


    // ========================================================
    // DUT
    // ========================================================

    register_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_REGS(NUM_REGS)
    ) dut (
        .clk(clk),
        .rst(rst),

        .READREG1(READREG1),
        .READREG2(READREG2),

        .WRITEREG(WRITEREG),
        .WRITEDATA(WRITEDATA),
        .WRITEENABLE(WRITEENABLE),

        .REGOUT1(REGOUT1),
        .REGOUT2(REGOUT2)
    );


    // ========================================================
    // CLOCK
    // ========================================================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    // ========================================================
    // TEST
    // ========================================================

    initial begin

        // Initial values
        rst        = 0;
        WRITEENABLE = 0;
        READREG1   = 0;
        READREG2   = 0;
        WRITEREG   = 0;
        WRITEDATA  = '0;

        #2;

        $display("");
        $display("================================================");
        $display("        %0dx%0d REGISTER FILE TEST", DATA_WIDTH, NUM_REGS);
        $display("================================================");


        // ----------------------------------------------------
        // RESET TEST
        // ----------------------------------------------------

        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;

        READREG1 = 0;
        READREG2 = NUM_REGS-1;

        #1;

        $display("");
        $display("RESET TEST");
        $display("R0  = %0h", REGOUT1);
        $display("R%0d = %0h", NUM_REGS-1, REGOUT2);


        // ----------------------------------------------------
        // WRITE TEST
        // ----------------------------------------------------

        WRITEENABLE = 1;

        // Write R0
        WRITEREG  = 0;
        WRITEDATA = 'h1;
        @(posedge clk);
        #1;

        // Write R1
        WRITEREG  = 1;
        WRITEDATA = 'h2;
        @(posedge clk);
        #1;

        // Write middle register
        WRITEREG  = NUM_REGS/2;
        WRITEDATA = 'hA;
        @(posedge clk);
        #1;

        // Write last register
        WRITEREG  = NUM_REGS-1;
        WRITEDATA = 'hF;
        @(posedge clk);
        #1;

        WRITEENABLE = 0;


        // ----------------------------------------------------
        // READ TEST
        // ----------------------------------------------------

        READREG1 = 1;
        READREG2 = NUM_REGS-1;

        #1;

        $display("");
        $display("READ TEST");
        $display("R1      = %0h", REGOUT1);
        $display("R%0d     = %0h", NUM_REGS-1, REGOUT2);


        // ----------------------------------------------------
        // MIDDLE REGISTER TEST
        // ----------------------------------------------------

        READREG1 = NUM_REGS/2;
        READREG2 = 0;

        #1;

        $display("");
        $display("MIDDLE REGISTER TEST");
        $display("R%0d     = %0h", NUM_REGS/2, REGOUT1);
        $display("R0      = %0h", REGOUT2);


        // ----------------------------------------------------
        // DUAL READ TEST
        // ----------------------------------------------------

        READREG1 = NUM_REGS/2;
        READREG2 = NUM_REGS/2;

        #1;

        $display("");
        $display("DUAL READ TEST");
        $display("REGOUT1  = %0h", REGOUT1);
        $display("REGOUT2  = %0h", REGOUT2);


        // ----------------------------------------------------
        // WRITE ENABLE TEST
        // ----------------------------------------------------

        // Try to overwrite R1 while WRITEENABLE = 0
        WRITEREG   = 1;
        WRITEDATA  = 'hF;
        WRITEENABLE = 0;

        @(posedge clk);
        #1;

        READREG1 = 1;
        #1;

        $display("");
        $display("WRITE ENABLE TEST");
        $display("R1 should remain  %0h", 'h2);
        $display("R1 = %0h", REGOUT1);


        // ----------------------------------------------------
        // FINAL RESULT
        // ----------------------------------------------------

        $display("");
        $display("================================================");
        $display("        %0dx%0d TEST COMPLETED", DATA_WIDTH, NUM_REGS);
        $display("================================================");
        $display("");

    end

endmodule

module tb_register_file;

    // --------------------------------------------------------
    // VCD
    // --------------------------------------------------------

    initial begin
        $dumpfile("register_file_all.vcd");
        $dumpvars(0, tb_register_file);
    end


    // --------------------------------------------------------
    // 32 x 32
    // --------------------------------------------------------

    register_file_test #(
        .DATA_WIDTH(32),
        .NUM_REGS(32)
    ) test_32x32();


    // --------------------------------------------------------
    // 16 x 16
    // --------------------------------------------------------

    register_file_test #(
        .DATA_WIDTH(16),
        .NUM_REGS(16)
    ) test_16x16();


    // --------------------------------------------------------
    // 8 x 8
    // --------------------------------------------------------

    register_file_test #(
        .DATA_WIDTH(8),
        .NUM_REGS(8)
    ) test_8x8();


    // --------------------------------------------------------
    // 4 x 4
    // --------------------------------------------------------

    register_file_test #(
        .DATA_WIDTH(4),
        .NUM_REGS(4)
    ) test_4x4();


    // Keep simulation alive until all tests finish
    initial begin
        #200;
        $finish;
    end

endmodule
