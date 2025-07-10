module pipelined_multiplier(
    input clk,
    input reset,
    input start,
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] product,
    output reg valid
);

    reg [2:0] stage;

    // Pipeline registers
    reg [3:0] a_reg0, a_reg1, a_reg2, a_reg3;
    reg       b0, b1, b2, b3;
    reg [7:0] stage_sum0, stage_sum1, stage_sum2, stage_sum3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= 0;
            valid <= 0;
            product <= 0;

            a_reg0 <= 0; a_reg1 <= 0; a_reg2 <= 0; a_reg3 <= 0;
            b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0;

            stage_sum0 <= 0;
            stage_sum1 <= 0;
            stage_sum2 <= 0;
            stage_sum3 <= 0;
        end else begin
            case (stage)
                0: begin
                    if (start) begin
                        a_reg0 <= a;
                        b0 <= b[0];
                        stage_sum0 <= (b[0]) ? (a << 0) : 8'b0;
                        valid <= 0;
                        stage <= 1;
                    end
                end

                1: begin
                    a_reg1 <= a_reg0;
                    b1 <= b[1];
                    stage_sum1 <= stage_sum0 + ((b[1]) ? (a_reg0 << 1) : 8'b0);
                    stage <= 2;
                end

                2: begin
                    a_reg2 <= a_reg1;
                    b2 <= b[2];
                    stage_sum2 <= stage_sum1 + ((b[2]) ? (a_reg1 << 2) : 8'b0);
                    stage <= 3;
                end

                3: begin
                    a_reg3 <= a_reg2;
                    b3 <= b[3];
                    stage_sum3 <= stage_sum2 + ((b[3]) ? (a_reg2 << 3) : 8'b0);
                    stage <= 4;
                end

                4: begin
                    product <= stage_sum3;
                    valid <= 1;
                    stage <= 0; // Ready for next multiplication
                end
            endcase
        end
    end

endmodule
