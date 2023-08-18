`timescale 1ns / 1ps

module test_3x5(input clk);

    localparam    PERIOD = 8;
    reg rst = 0;

    // parameters and values for tests where the number of masters is less than the number of slaves

    localparam    T_DATA_WIDTH_LM = 8;
    localparam    S_DATA_COUNT_LM = 3;
    localparam    M_DATA_COUNT_LM = 5;
    localparam    T_ID___WIDTH_LM = $clog2(S_DATA_COUNT_LM);
    localparam    T_DEST_WIDTH_LM = $clog2(M_DATA_COUNT_LM);

    reg [(T_DATA_WIDTH_LM) * (S_DATA_COUNT_LM) - 1 : 0] s_data_i_lm;
    reg [(T_DEST_WIDTH_LM) * (S_DATA_COUNT_LM) - 1 : 0] s_dest_i_lm;
    reg [S_DATA_COUNT_LM-1:0] s_last_i_lm;
    reg [S_DATA_COUNT_LM-1:0] s_valid_i_lm;
    wire [S_DATA_COUNT_LM-1:0] s_ready_o_lm;

    wire [(T_DATA_WIDTH_LM) * (M_DATA_COUNT_LM) - 1 : 0] m_data_o_lm;
    wire [(T_ID___WIDTH_LM) * (M_DATA_COUNT_LM) - 1 : 0] m_id_o_lm;
    wire [M_DATA_COUNT_LM-1:0] m_last_o_lm;
    wire [M_DATA_COUNT_LM-1:0] m_valid_o_lm;
    reg [M_DATA_COUNT_LM-1:0] m_ready_i_lm;

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_LM),
        .S_DATA_COUNT(S_DATA_COUNT_LM),
        .M_DATA_COUNT(M_DATA_COUNT_LM),
        .T_ID___WIDTH(T_ID___WIDTH_LM),
        .T_DEST_WIDTH(T_DEST_WIDTH_LM)
    ) crossbar_3x5(
        .clk(clk),
        .rst(rst),

        .s_data_i(s_data_i_lm),
        .s_dest_i(s_dest_i_lm),        
        .s_last_i(s_last_i_lm),
        .s_valid_i(s_valid_i_lm),
        .s_ready_o(s_ready_o_lm),

        .m_data_o(m_data_o_lm),
        .m_id_o(m_id_o_lm),
        .m_last_o(m_last_o_lm),
        .m_valid_o(m_valid_o_lm),
        .m_ready_i(m_ready_i_lm)
    );
    
    task clear();
        begin
            rst = 1;
            #PERIOD
            rst = 0;
        end
    endtask

    task test_3x5_1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i_lm <= 24'b11111111_10101010_11110000;
            s_dest_i_lm <= 9'b010_001_000;
            s_last_i_lm <= 3'b111;
            s_valid_i_lm <= 3'b111;
            m_ready_i_lm <= 5'b11111;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_10101010_11110000 && m_id_o_lm == 10'b00_00_10_01_00 && m_last_o_lm == 5'b00111 && m_valid_o_lm == 5'b00111 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct \n");
            else $display("STEP 1 : Failed\n");
        end
    endtask

    task test_3x5_2();
        begin
            $display("TEST : Parallel transmission of multiple packets to all output ports");
            s_data_i_lm <= 24'b11111111_10101010_11110000;
            s_dest_i_lm <= 9'b010_001_000;
            s_last_i_lm <= 3'b000;
            s_valid_i_lm <= 3'b111;
            m_ready_i_lm <= 5'b11111;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_10101010_11110000 && m_id_o_lm == 10'b00_00_10_01_00 && m_last_o_lm == 5'b00000 && m_valid_o_lm == 5'b00111 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_lm <= 24'b11111111_10101010_00001111;
            s_last_i_lm <= 3'b001;
            s_valid_i_lm <= 3'b111;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_10101010_00001111 && m_id_o_lm == 10'b0000100100 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00111 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_data_i_lm <= 24'b11111111_01010101_00001111;
            s_last_i_lm <= 3'b010;
            s_valid_i_lm <= 3'b110;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_01010101_00001111 && m_id_o_lm == 10'b00_00_10_01_01 && m_last_o_lm == 5'b00010 && m_valid_o_lm == 5'b00110 && s_ready_o_lm == 3'b110) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

            s_data_i_lm <= 24'b00000000_01010101_00001111;
            s_last_i_lm <= 3'b100;
            s_valid_i_lm <= 3'b100;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_01010101_00001111 && m_id_o_lm == 10'b0000101001 && m_last_o_lm == 5'b00100 && m_valid_o_lm == 5'b00100 && s_ready_o_lm == 3'b100) $display("STEP 4 : Correct \n");
            else $display("STEP 4 : Failed\n");
        end
    endtask

    task test_3x5_3();
        begin
            $display("TEST : Transmission of packets to one output port with arbitration of all input ports");
            s_data_i_lm <= 24'b11111111_10101010_11110000;
            s_dest_i_lm <= 9'b000_000_000;
            s_last_i_lm <= 3'b001;
            s_valid_i_lm <= 3'b111;
            m_ready_i_lm <= 5'b11111;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_11110000 && m_id_o_lm === 10'b0000000000 && m_last_o_lm ==53'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_last_i_lm <= 3'b010;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_10101010 && m_id_o_lm === 10'b0000000001 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_last_i_lm <= 3'b100;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_11111111 && m_id_o_lm === 10'b0000000010 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 3 : Correct\n");
            else $display("STEP 3 : Failed\n");

        end
    endtask

    task test_3x5_4();
        begin
            $display("TEST : Packet transfer to multiple output ports with arbitration");

            s_data_i_lm <= 24'b11111111_10101010_11110000;
            s_dest_i_lm <= 9'b001_000_000;
            s_last_i_lm <= 3'b001;
            s_valid_i_lm <= 3'b111;
            m_ready_i_lm <= 5'b11111;
            #PERIOD

            if(m_data_o_lm == 40'b00000000_00000000_00000000_11111111_11110000 && m_id_o_lm === 10'b0000001000 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00011 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_lm <= 24'b00001111_10101010_11110000;
            s_dest_i_lm <= 9'b001_000_001;
            s_last_i_lm <= 3'b110;
            #PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00001111_10101010 && m_id_o_lm === 10'b0000001001 && m_last_o_lm == 5'b00011 && m_valid_o_lm == 5'b00011 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_data_i_lm <= 24'b00001111_10101010_11110000;
            s_dest_i_lm <= 9'b000_000_000;
            s_last_i_lm <= 3'b000;
            #PERIOD
            //$display("m_data_o_ml = %b   m_id_o_ml = %b   m_last_o_ml = %b   m_valid_o_ml = %b   s_ready_o_ml = %b", m_data_o_lm, m_id_o_lm, m_last_o_lm, m_valid_o_lm, s_ready_o_lm);
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00001111_00001111 && m_id_o_lm === 10'b0000000010 && m_last_o_lm == 5'b00000 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

        end
    endtask
    
    task run_test();
        begin
            $display("RUNNING ALL TEST WHERE COUNT OF MASTER LESS THAN SLAVE");
            clear();  
            test_3x5_3();
            clear();
            test_3x5_4();
            clear();
            test_3x5_1();
            clear();
            test_3x5_2();
            clear();
        end 
    endtask


endmodule
