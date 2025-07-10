`timescale 1ns / 1ps

module pipelined_multiplier_tb;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [7:0] product;
    wire valid;

    // Instantiate the Unit Under Test (UUT)
    pipelined_multiplier uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .product(product),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        reset = 1;
        start = 0;
        a = 0;
        b = 0;

        // Wait for global reset
        #20;
        reset = 0;

        // Apply inputs (3 * 5 = 15)
        @(posedge clk);
        a = 4'd3;
        b = 4'd5;
        start = 1;

        @(posedge clk);
        start = 0; // one-cycle pulse

        // Wait enough cycles to get the output
        repeat (6) @(posedge clk);

        // Check result
        if (valid && product == 8'd15)
            $display("✅ Test Passed: 3 * 5 = %d", product);
        else
            $display("❌ Test Failed: Output = %d, valid = %b", product, valid);

        // You can add more test cases here
        #20;
        $finish;
    end

endmodule
