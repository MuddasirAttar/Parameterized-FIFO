`define CLK @(posedge clk)
module qs_fifo_tb ();
  
    localparam DATA_W = 8;
    localparam DEPTH = 16;
  
    logic clk;
    logic reset;
    logic push_i;
    logic [DATA_W-1:0] push_data_i;
    logic pop_i;
    logic [DATA_W-1:0] pop_data_o;
    logic full_o;
    logic empty_o;
  
    qs_fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) FIFO(
        .*
    );
            
    // Generate clock
    always begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
    end
            
    // Drive our stimulus
    initial begin
        reset = 1'b1;
        push_i = 1'b0;
        pop_i = 1'b0;
        repeat (2) @(posedge clk);
        reset = 1'b0;
        `CLK;

        // Push data into the FIFO until it is full
        push_i = 1'b1;
        for (int i = 0; i < DEPTH; i++) begin
            push_data_i = $random;
            `CLK;
        end
        push_i = 1'b0;

        // Check if the FIFO is full
        if (full_o)
            $display("FIFO is full as expected.");
        else
            $error("FIFO is not full as expected.");

        `CLK;

        // Pop data from the FIFO until it is empty
        pop_i = 1'b1;
        for (int i = 0; i < DEPTH; i++) begin
            `CLK;
        end
        pop_i = 1'b0;

        // Check if the FIFO is empty
        if (empty_o)
            $display("FIFO is empty as expected.");
        else
            $error("FIFO is not empty as expected.");

        repeat (2) `CLK;
        $finish();
    end
            
    // Dump VCD waves
    initial begin
        $dumpfile("qs_fifo.vcd");
        $dumpvars(2, qs_fifo_tb);
    end
  
endmodule
