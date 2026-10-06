module register_file #(
    parameter DATA_WIDTH = 32,
    parameter NUM_REGS = 32
)(

    input logic clk,
    input logic rst,

    input logic [$clog2(NUM_REGS) - 1:0] READREG1,
    input logic [$clog2(NUM_REGS) - 1:0] READREG2,

    input logic [$clog2(NUM_REGS) - 1:0] WRITEREG,
    input logic [DATA_WIDTH - 1:0] WRITEDATA,
    input logic WRITEENABLE,

    output logic [DATA_WIDTH - 1:0] REGOUT1,
    output logic [DATA_WIDTH - 1:0] REGOUT2

);

    logic [DATA_WIDTH - 1:0] register [0:NUM_REGS - 1];

    assign REGOUT1 = register[READREG1];
    assign REGOUT2 = register[READREG2];

    always_ff @( posedge clk ) begin : write_block
        
        if(rst) begin

            for(int i = 0; i < NUM_REGS; i++) register[i] <= '0;

        end

        else if(WRITEENABLE) begin

            register[WRITEREG] <= WRITEDATA;
            
        end

    end

endmodule
