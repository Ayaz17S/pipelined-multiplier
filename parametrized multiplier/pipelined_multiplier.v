module pipelined_multiplier #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input start,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [(2*WIDTH)-1:0] product,
    output reg valid
);

reg [$clog2(WIDTH): 0] stage;

    // Pipeline registers
    reg [WIDTH-1:0] a_reg0, a_reg1, a_reg2, a_reg3,a_reg4,a_reg5,a_reg6,a_reg7;
    
    reg [(2*WIDTH)-1:0] stage_sum0, stage_sum1, stage_sum2, stage_sum3,stage_sum4,stage_sum5,stage_sum6,stage_sum7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid<=0;
            product<=0;
            stage<=0;
            a_reg0 <= 0; a_reg1 <= 0; a_reg2 <= 0; a_reg3 <= 0;
            a_reg4<=0;a_reg5<=0;a_reg6<=0;a_reg7<=0;
            

            stage_sum0 <= 0;
            stage_sum1 <= 0;
            stage_sum2 <= 0;
            stage_sum3 <= 0;
            stage_sum4<=0;
            stage_sum5 <=0;
            stage_sum6 <=0;
            stage_sum7<=0;
        end else begin
            case (stage)
                0:begin
                    if (start) begin
                        a_reg0<= a;
                        stage_sum0<=(b[0])?(a<<0):{(2*WIDTH){1'b0}};
                        valid<=0;
                        stage<=1;
                    end
                end 
                1: begin
                    a_reg1<=a_reg0;
                    
                    stage_sum1<=stage_sum0+((b[1])?(a_reg0<<1):{(2*WIDTH){1'b0}});
                    stage<=2;
                end
                2: begin
                    a_reg2<=a_reg1;
                    
                    stage_sum2<=stage_sum1+((b[2])?(a_reg1<<2):{(2*WIDTH){1'b0}});
                    stage<=3;
                end
                3: begin
                    a_reg3<=a_reg2;
                    
                    stage_sum3<=stage_sum2+((b[3])?(a_reg2<<3):{(2*WIDTH){1'b0}});
                    stage<=4;
                end
                4: begin
                    a_reg4<=a_reg3;
                    
                    stage_sum4<=stage_sum3+((b[4])?(a_reg3<<4):{(2*WIDTH){1'b0}});
                    stage<=5;
                end
                5: begin
                    a_reg5<=a_reg4;
                    ;
                    stage_sum5<=stage_sum4+((b[5])?(a_reg4<<5):{(2*WIDTH){1'b0}});
                    stage<=6; 
                end
                6: begin
                    a_reg6<=a_reg5;
                    
                    stage_sum6<=stage_sum5+((b[6])?(a_reg5<<6):{(2*WIDTH){1'b0}});
                    stage<=7;
                end
                7: begin
                    a_reg7<=a_reg6;
                    
                    stage_sum7<=stage_sum6+((b[7])?(a_reg6<<7):{(2*WIDTH){1'b0}});
                    stage<=8;
                end
                8:begin
                    product <= stage_sum7;
                    valid <= 1;
                    stage <= 0;
                end 
            endcase
        end
    end
endmodule