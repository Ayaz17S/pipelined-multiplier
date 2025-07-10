`timescale 1ns/1ps

module pipelined_multiplier_tb;

parameter WIDTH = 8;

reg clk, reset, start;
reg [WIDTH-1:0] a, b;
wire [(2*WIDTH)-1:0] product;
wire valid;

// Instantiate the DUT
pipelined_multiplier #(WIDTH) dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .a(a),
    .b(b),
    .product(product),
    .valid(valid)
);

// Clock generation
always #5 clk = ~clk;

// VCD waveform dump
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, pipelined_multiplier_tb);
end

// Main test logic
initial begin
    $display("Starting pipelined multiplier test...");
    clk = 0;
    reset = 1;
    start = 0;
    a = 0;
    b = 0;

    #10;  // Allow some time in reset
    reset = 0;

    test_case(8'd5,   8'd3);     // 5 x 3 = 15
    test_case(8'd15,  8'd15);    // 15 x 15 = 225
    test_case(8'd128, 8'd2);     // 128 x 2 = 256
    test_case(8'd0,   8'd200);   // 0 x 200 = 0
    test_case(8'd255, 8'd255);   // 255 x 255 = 65025

    // Give time for final wave to register
    @(posedge clk);
    #10;

    $display("All test cases completed.");
    $stop;
end

// Task to apply and verify each test case
task test_case(input [WIDTH-1:0] A, input [WIDTH-1:0] B);
    reg [2*WIDTH-1:0] expected;
    begin
        @(negedge clk);
        a = A;
        b = B;
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait for result
        wait(valid == 1);

        expected = A * B;

        $display("a = %3d, b = %3d, product = %5d, expected = %5d %s",
                 A, B, product, expected, (product == expected) ? "yes" : "NO");

        @(negedge clk); // Wait a cycle before next input
    end
endtask

endmodule
