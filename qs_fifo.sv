// Parameterized FIFO

module qs_fifo #(
    parameter DATA_W = 8,
    parameter DEPTH = 16
)(
    input logic clk,
    input logic reset,
  
    input logic push_i,
    input logic [DATA_W-1:0] push_data_i,
  
    input logic pop_i,
    output logic [DATA_W-1:0] pop_data_o,
  
    output logic full_o,
    output logic empty_o
);
  
    typedef enum logic[1:0] {
        ST_PUSH = 2'b10,
        ST_POP = 2'b01,
        ST_BOTH = 2'b11
    } state_t;
  
    localparam PTR_W = $clog2(DEPTH);
  
    logic [DATA_W-1:0] fifo_data_q [DEPTH-1:0];
    logic [PTR_W-1:0] rd_ptr_q;
    logic [PTR_W-1:0] wr_ptr_q;
    logic [PTR_W-1:0] nxt_rd_ptr;
    logic [PTR_W-1:0] nxt_wr_ptr;
  
    logic wrapped_rd_ptr_q;
    logic wrapped_wr_ptr_q;
    logic nxt_rd_wrapped_ptr;
    logic nxt_wr_wrapped_ptr;
  
    logic [DATA_W-1:0] nxt_fifo_data;
  
    logic [DATA_W-1:0] pop_data;
  
    logic empty;
    logic full;
  
    // Flops for fifo pointers
    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            rd_ptr_q <= PTR_W'(1'b0);
            wr_ptr_q <= PTR_W'(1'b0);
            wrapped_rd_ptr_q <= 1'b0;
            wrapped_wr_ptr_q <= 1'b0;
        end else begin
            rd_ptr_q <= nxt_rd_ptr;
            wr_ptr_q <= nxt_wr_ptr;
            wrapped_rd_ptr_q <= nxt_rd_wrapped_ptr;
            wrapped_wr_ptr_q <= nxt_wr_wrapped_ptr;
        end
  
    // Pointer logic for push and pop
    always_comb begin
        nxt_fifo_data = fifo_data_q[wr_ptr_q];
        nxt_rd_ptr = rd_ptr_q;
        nxt_wr_ptr = wr_ptr_q;
        nxt_wr_wrapped_ptr = wrapped_wr_ptr_q;
        nxt_rd_wrapped_ptr = wrapped_rd_ptr_q;
        case ({push_i, pop_i}) // 2-bit signal with push as MSB and pop as LSB
            ST_PUSH: begin
                nxt_fifo_data = push_data_i;
                if (wr_ptr_q == PTR_W'(DEPTH-1)) begin
                    nxt_wr_ptr = PTR_W'(1'b0);
                    nxt_wr_wrapped_ptr = ~wrapped_wr_ptr_q;
                end else begin
                    nxt_wr_ptr = wr_ptr_q + PTR_W'(1'b1);
                end
            end
            ST_POP: begin
                pop_data = fifo_data_q[rd_ptr_q[PTR_W-1:0]];
                if (rd_ptr_q == PTR_W'(DEPTH-1)) begin
                    nxt_rd_ptr = PTR_W'(1'b0);
                    nxt_rd_wrapped_ptr = ~wrapped_rd_ptr_q;
                end else begin
                    nxt_rd_ptr = rd_ptr_q + PTR_W'(1'b1);
                end
            end
            ST_BOTH: begin
                nxt_fifo_data = push_data_i;
                if (wr_ptr_q == PTR_W'(DEPTH-1)) begin
                    nxt_wr_ptr = PTR_W'(1'b0);
                    nxt_wr_wrapped_ptr = ~wrapped_wr_ptr_q;
                end else begin
                    nxt_wr_ptr = wr_ptr_q + PTR_W'(1'b1);
                end
                pop_data = fifo_data_q[rd_ptr_q[PTR_W-1:0]];
                if (rd_ptr_q == PTR_W'(DEPTH-1)) begin
                    nxt_rd_ptr = PTR_W'(1'b0);
                    nxt_rd_wrapped_ptr = ~wrapped_rd_ptr_q;
                end else begin
                    nxt_rd_ptr = rd_ptr_q + PTR_W'(1'b1);
                end
            end
            default: begin
                nxt_fifo_data = fifo_data_q[wr_ptr_q[PTR_W-1:0]];
                nxt_rd_ptr = rd_ptr_q;
                nxt_wr_ptr = wr_ptr_q;
            end
        endcase
    end
  
    // Empty
    assign empty = (rd_ptr_q == wr_ptr_q) &
                   (wrapped_rd_ptr_q == wrapped_wr_ptr_q);
  
    assign full = (rd_ptr_q == wr_ptr_q) &
                  (wrapped_rd_ptr_q != wrapped_wr_ptr_q);
        
    // Flops for fifo data
    always_ff @(posedge clk)
        fifo_data_q[wr_ptr_q[PTR_W-1:0]] <= nxt_fifo_data;
      
    // Output assignments
    assign pop_data_o = pop_data;
    assign full_o = full;
    assign empty_o = empty;
  
endmodule
