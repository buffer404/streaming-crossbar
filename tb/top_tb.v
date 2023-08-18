`timescale 1ns / 1ps

module top_tb;

    localparam  HALF_PERIOD = 4;
    reg         clk = 0;

    test_1x3 test_1x3(.clk(clk));

    test_3x1 test_3x1(.clk(clk));

    test_5x3 test_5x3(.clk(clk));

    test_2x2 test_2x2(.clk(clk));

    test_3x5 test_3x5(.clk(clk));

    initial begin

        test_1x3.run_test;

        test_3x1.run_test;

        test_5x3.run_test;

        test_2x2.run_test;

        test_3x5.run_test;

    end

    always begin
        #HALF_PERIOD  clk =  ! clk;    //создание clk
    end 

endmodule