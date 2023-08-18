`timescale 1ns / 1ps

module test_2x2(input clk);

    localparam    PERIOD = 8;
    reg rst = 0;

    // parameters and values for tests where the number of masters is equal to the number of slaves

    localparam    T_DATA_WIDTH_E = 8;
    localparam    S_DATA_COUNT_E = 2;
    localparam    M_DATA_COUNT_E = 2;
    localparam    T_ID___WIDTH_E = $clog2(S_DATA_COUNT_E);
    localparam    T_DEST_WIDTH_E = $clog2(M_DATA_COUNT_E);

    reg [(T_DATA_WIDTH_E) * (S_DATA_COUNT_E) - 1 : 0] s_data_i_e;
    reg [(T_DEST_WIDTH_E) * (S_DATA_COUNT_E) - 1 : 0] s_dest_i_e;
    reg [S_DATA_COUNT_E-1:0] s_last_i_e;
    reg [S_DATA_COUNT_E-1:0] s_valid_i_e;
    wire [S_DATA_COUNT_E-1:0] s_ready_o_e;

    wire [(T_DATA_WIDTH_E) * (M_DATA_COUNT_E) - 1 : 0] m_data_o_e;
    wire [(T_ID___WIDTH_E) * (M_DATA_COUNT_E) - 1 : 0] m_id_o_e;
    wire [M_DATA_COUNT_E-1:0] m_last_o_e;
    wire [M_DATA_COUNT_E-1:0] m_valid_o_e;
    reg [M_DATA_COUNT_E-1:0] m_ready_i_e;

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_E),
        .S_DATA_COUNT(S_DATA_COUNT_E),
        .M_DATA_COUNT(M_DATA_COUNT_E),
        .T_ID___WIDTH(T_ID___WIDTH_E),
        .T_DEST_WIDTH(T_DEST_WIDTH_E)
    ) crossbar_2x2(
        .clk(clk),
        .rst(rst),

        .s_data_i(s_data_i_e),
        .s_dest_i(s_dest_i_e),        
        .s_last_i(s_last_i_e),
        .s_valid_i(s_valid_i_e),
        .s_ready_o(s_ready_o_e),

        .m_data_o(m_data_o_e),
        .m_id_o(m_id_o_e),
        .m_last_o(m_last_o_e),
        .m_valid_o(m_valid_o_e),
        .m_ready_i(m_ready_i_e)
    );

    task clear();
        begin
            rst = 1;
            #PERIOD
            rst = 0;
        end
    endtask

    task test_2x2_1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i_e <= 16'b11111111_10101010;
            s_dest_i_e <= 2'b10;
            s_last_i_e <= 2'b11;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b11 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 1 : Correct \n");
            else $display("STEP 1 : Failed\n");
        end
    endtask

    task test_2x2_2();
        begin
            $display("TEST : Parallel transmission of multiple packets to all output ports");

            s_data_i_e <= 16'b11111111_10101010;
            s_dest_i_e <= 2'b1_0;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_last_i_e <= 2'b01;
            #PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
           
            s_last_i_e <= 2'b10;
            #PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b10 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 3 : Correct \n");
            else $display("STEP 3 : Failed\n");
        end
    endtask

    task test_2x2_3();
        begin
            $display("TEST : test from the task doc");

            s_data_i_e <= 16'b00001100_00001010;
            s_dest_i_e <= 2'b00;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b01;
            #PERIOD
            if(m_data_o_e[7:0] == 8'b00001010 && m_id_o_e == 2'b0_0 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b01) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");
            s_data_i_e <= 16'b00001100_00001011;
            s_dest_i_e <= 2'b00;
            s_last_i_e <= 2'b01;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b01;
            #PERIOD
            if(m_data_o_e[7:0] == 8'b00001011 && m_id_o_e == 2'b0_0 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b01) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
            s_data_i_e <= 16'b00001100_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b10;
            m_ready_i_e <= 2'b11;
            #PERIOD
            if(m_data_o_e[7:0] == 8'b00001100 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b10) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

            s_data_i_e <= 16'b00001101_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b10;
            s_valid_i_e <= 2'b10;
            m_ready_i_e <= 2'b11;
            #PERIOD
            if(m_data_o_e[7:0] == 8'b00001101 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b10) $display("STEP 4 : Correct");
            else $display("STEP 4 : Failed");

            s_data_i_e <= 16'b00001000_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #PERIOD
            if(m_data_o_e == 16'b00001110_00001000 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 5 : Correct");
            else $display("STEP 5 : Failed");

            s_data_i_e <= 16'b00001001_00001111;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b11;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #PERIOD
            //$display("m_data_o_ml = %b   m_id_o_ml = %b   m_last_o_ml = %b   m_valid_o_ml = %b   s_ready_o_ml = %b", m_data_o_e, m_id_o_e, m_last_o_e, m_valid_o_e, s_ready_o_e);
            if(m_data_o_e == 16'b00001111_00001001 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b11 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 6 : Correct\n");
            else $display("STEP 6 : Failed\n");
         
        end
    endtask

    task run_test();
        begin
            $display("TEST COUNT MASTER EQUALS COUNT SLAVE");
            clear();
            test_2x2_1();
            clear();

            test_2x2_2();
            clear();

            test_2x2_3();
            clear();

        end 
    endtask

endmodule
