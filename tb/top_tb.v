`timescale 1ns / 1ps

module top_tb;

    localparam    HALF_PERIOD = 4;

    reg clk = 0;
    reg rst = 0;

    // parameters and values for tests where the number of masters is greater than the number of slaves

    localparam    T_DATA_WIDTH_ML = 8;
    localparam    S_DATA_COUNT_ML = 5;
    localparam    M_DATA_COUNT_ML = 3;
    localparam    T_ID___WIDTH_ML = $clog2(S_DATA_COUNT_ML);
    localparam    T_DEST_WIDTH_ML = $clog2(M_DATA_COUNT_ML);

    reg [(T_DATA_WIDTH_ML) * (S_DATA_COUNT_ML) - 1 : 0] s_data_i_ml;
    reg [(T_DEST_WIDTH_ML) * (S_DATA_COUNT_ML) - 1 : 0] s_dest_i_ml;
    reg [S_DATA_COUNT_ML-1:0] s_last_i_ml;
    reg [S_DATA_COUNT_ML-1:0] s_valid_i_ml;
    wire [S_DATA_COUNT_ML-1:0] s_ready_o_ml;

    wire [(T_DATA_WIDTH_ML) * (M_DATA_COUNT_ML) - 1 : 0] m_data_o_ml;
    wire [(T_ID___WIDTH_ML) * (M_DATA_COUNT_ML) - 1 : 0] m_id_o_ml;
    wire [M_DATA_COUNT_ML-1:0] m_last_o_ml;
    wire [M_DATA_COUNT_ML-1:0] m_valid_o_ml;
    reg [M_DATA_COUNT_ML-1:0] m_ready_i_ml;


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
        .T_DATA_WIDTH(T_DATA_WIDTH_ML),
        .S_DATA_COUNT(S_DATA_COUNT_ML),
        .M_DATA_COUNT(M_DATA_COUNT_ML),
        .T_ID___WIDTH(T_ID___WIDTH_ML),
        .T_DEST_WIDTH(T_DEST_WIDTH_ML)
    ) crossbar_5x3(
        .rst_n(rst),

        .s_data_i(s_data_i_ml),
        .s_dest_i(s_dest_i_ml),        
        .s_last_i(s_last_i_ml),
        .s_valid_i(s_valid_i_ml),
        .s_ready_o(s_ready_o_ml),

        .m_data_o(m_data_o_ml),
        .m_id_o(m_id_o_ml),
        .m_last_o(m_last_o_ml),
        .m_valid_o(m_valid_o_ml),
        .m_ready_i(m_ready_i_ml)
    );

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_E),
        .S_DATA_COUNT(S_DATA_COUNT_E),
        .M_DATA_COUNT(M_DATA_COUNT_E),
        .T_ID___WIDTH(T_ID___WIDTH_E),
        .T_DEST_WIDTH(T_DEST_WIDTH_E)
    ) crossbar_2x2(
        .rst_n(rst),

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

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_LM),
        .S_DATA_COUNT(S_DATA_COUNT_LM),
        .M_DATA_COUNT(M_DATA_COUNT_LM),
        .T_ID___WIDTH(T_ID___WIDTH_LM),
        .T_DEST_WIDTH(T_DEST_WIDTH_LM)
    ) crossbar_3x5(
        .rst_n(rst),

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

    initial begin

        test_5x3();

        test_2x2();

        test_3x5();

    end

    task clear();
        begin
            s_data_i_ml = 0;
            s_dest_i_ml = 0;
            s_last_i_ml = 0;
            s_valid_i_ml = 0;
            m_ready_i_ml = 0;

            s_data_i_e = 0;
            s_dest_i_e = 0;
            s_last_i_e = 0;
            s_valid_i_e = 0;
            m_ready_i_e = 0;

            s_data_i_lm = 0;
            s_dest_i_lm = 0;
            s_last_i_lm = 0;
            s_valid_i_lm = 0;
            m_ready_i_lm = 0;

            rst = 1;
            #HALF_PERIOD
            rst = 0;
        end
    endtask

    // running all test where count of master more than slave

    task test_5x3();
        begin
            $display("RUNNING ALL TEST WHERE COUNT OF MASTER MORE THAN SLAVE");
            clear();
            test_5x3_1();
            clear();

            test_5x3_2();
            clear();

            test_5x3_3();
            clear();

            test_5x3_4();
            clear();
        end 
    endtask

    task test_2x2();
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

    task test_3x5();
        begin
            $display("RUNNING ALL TEST WHERE COUNT OF MASTER MORE THAN SLAVE");
            clear();
            test_3x5_1();
            clear();

            test_3x5_2();
            clear();

            test_3x5_3();
            clear();

            test_3x5_4();
            clear();
        end 
    endtask
    
    //More master, less slave test

    task test_5x3_1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i_ml <= 40'b11111111_00000000_10101010_00000000_11110000;
            s_dest_i_ml <= 10'b10_00_01_00_00;
            s_last_i_ml <= 5'b10101;
            s_valid_i_ml <= 5'b10101;
            m_ready_i_ml <= 3'b111;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b11111111_10101010_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b111 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b10101) $display("STEP 1 : Correct \n");
            else $display("STEP 1 : Failed\n");
        end
    endtask

    task test_5x3_2();
        begin
            $display("TEST : Parallel transmission of multiple packets to all output ports");

            s_data_i_ml <= 40'b11110000_00000000_11110000_00000000_11110000;
            s_dest_i_ml <= 10'b10_00_01_00_00;
            s_last_i_ml <= 5'b00001;
            s_valid_i_ml <= 5'b10101;
            m_ready_i_ml <= 3'b111;

            #HALF_PERIOD
            if(m_data_o_ml == 24'b11110000_11110000_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b10101) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_ml <= 40'b10101010_00000000_10101010_00000000_10101010;
            s_last_i_ml <= 5'b00100;
            s_valid_i_ml <= 5'b10100;
            m_ready_i_ml <= 3'b110;
            if(m_data_o_ml == 24'b11110000_11110000_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b10101) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
            #HALF_PERIOD
            s_data_i_ml <= 40'b11111111_00000000_11111111_00000000_11111111;
            s_last_i_ml <= 5'b10000;
            s_valid_i_ml <= 5'b10000;
            m_ready_i_ml <= 3'b100;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b11111111_11111111_10101010 && m_id_o_ml == 9'b100_011_001 && m_last_o_ml == 3'b100 && m_valid_o_ml == 3'b100 && s_ready_o_ml == 5'b10000) $display("STEP 3 : Correct \n");
            else $display("STEP 3 : Failed\n");
        end
    endtask

    task test_5x3_3();
        begin
            $display("TEST : Transmission of packets to one output port with arbitration of all input ports");

            s_data_i_ml <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i_ml <= 10'b00_00_00_00_00;
            s_last_i_ml <= 5'b00001;
            s_valid_i_ml <= 5'b11111;
            m_ready_i_ml <= 3'b111;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b00000000_00000000_00000000 && m_id_o_ml == 9'b000_000_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b11111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");
            s_last_i_ml <= 5'b00010;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b00000000_00000000_00001111 && m_id_o_ml == 9'b000_000_001 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b11111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");   
            s_last_i_ml <= 5'b00100;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b00000000_00000000_11110000 && m_id_o_ml == 9'b000_000_010 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b11111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");  
            s_last_i_ml <= 5'b01000;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b00000000_00000000_10101010 && m_id_o_ml == 9'b000_000_011 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b11111) $display("STEP 4 : Correct");
            else $display("STEP 4 : Failed");  
            s_last_i_ml <= 5'b10000;
            #HALF_PERIOD
            if(m_data_o_ml === 24'b00000000_00000000_11111111 && m_id_o_ml == 9'b000000100 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b11111) $display("STEP 5 : Correct\n");
            else $display("STEP 5 : Failed\n");            
        end
    endtask

    task test_5x3_4();
        begin
            $display("TEST : Packet transfer to multiple output ports with arbitration");

            s_data_i_ml <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i_ml <= 10'b10_10_01_01_00;
            s_last_i_ml <= 5'b00000;
            s_valid_i_ml <= 5'b11111;
            m_ready_i_ml <= 3'b111;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b10101010_00001111_00000000 && m_id_o_ml == 9'b011_001_000 && m_last_o_ml == 3'b000 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b11111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");
            s_dest_i_ml <= 10'b10_10_01_01_00;
            s_last_i_ml <= 5'b01011;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b10101010_00001111_00000000 && m_id_o_ml == 9'b011_001_000 && m_last_o_ml == 3'b111 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b11111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
            s_dest_i_ml <= 10'b10_10_01_01_01;
            s_last_i_ml <= 5'b10100;
            #HALF_PERIOD
            if(m_data_o_ml == 24'b11111111_11110000_00000000 && m_id_o_ml == 9'b100_010_001 && m_last_o_ml == 3'b110 && m_valid_o_ml == 3'b110 && s_ready_o_ml == 5'b11111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");
            s_last_i_ml <= 5'b00001;
            #HALF_PERIOD
            //$display("m_data_o_ml = %b   m_id_o_ml = %b   m_last_o_ml = %b   m_valid_o_ml = %b   s_ready_o_ml = %b", m_data_o_ml, m_id_o_ml, m_last_o_ml, m_valid_o_ml, s_ready_o_ml);
            if(m_data_o_ml === 24'b10101010_00000000_00000000 && m_id_o_ml == 9'b011_000_001 && m_last_o_ml == 3'b010 && m_valid_o_ml == 3'b110 && s_ready_o_ml == 5'b11111) $display("STEP 4 : Correct \n");
            else $display("STEP 4 : Failed\n");            
        end
    endtask



    // count master equals count slave

    task test_2x2_1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i_e <= 16'b11111111_10101010;
            s_dest_i_e <= 2'b10;
            s_last_i_e <= 2'b11;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #HALF_PERIOD
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
            #HALF_PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_last_i_e <= 2'b01;
            #HALF_PERIOD
            if(m_data_o_e == 16'b11111111_10101010 && m_id_o_e == 2'b1_0 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
           
            s_last_i_e <= 2'b10;
            #HALF_PERIOD
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
            #HALF_PERIOD
            if(m_data_o_e == 16'b00000000_00001010 && m_id_o_e == 2'b0_0 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b11) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_e <= 16'b00001100_00001011;
            s_dest_i_e <= 2'b00;
            s_last_i_e <= 2'b01;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b01;
            #HALF_PERIOD
            if(m_data_o_e == 16'b00000000_00001011 && m_id_o_e == 2'b0_0 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b11) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_data_i_e <= 16'b00001100_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b10;
            m_ready_i_e <= 2'b11;
            #HALF_PERIOD
            if(m_data_o_e == 16'b00000000_00001100 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b10) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

            s_data_i_e <= 16'b00001101_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b10;
            s_valid_i_e <= 2'b10;
            m_ready_i_e <= 2'b11;
            #HALF_PERIOD
            if(m_data_o_e == 16'b00000000_00001101 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b01 && m_valid_o_e == 2'b01 && s_ready_o_e == 2'b10) $display("STEP 4 : Correct");
            else $display("STEP 4 : Failed");

            s_data_i_e <= 16'b00001000_00001110;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b00;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #HALF_PERIOD
            if(m_data_o_e == 16'b00001110_00001000 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b00 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 5 : Correct");
            else $display("STEP 5 : Failed");

            s_data_i_e <= 16'b00001001_00001111;
            s_dest_i_e <= 2'b01;
            s_last_i_e <= 2'b11;
            s_valid_i_e <= 2'b11;
            m_ready_i_e <= 2'b11;
            #HALF_PERIOD
            //$display("m_data_o_ml = %b   m_id_o_ml = %b   m_last_o_ml = %b   m_valid_o_ml = %b   s_ready_o_ml = %b", m_data_o_e, m_id_o_e, m_last_o_e, m_valid_o_e, s_ready_o_e);
            if(m_data_o_e == 16'b00001111_00001001 && m_id_o_e == 2'b0_1 && m_last_o_e == 2'b11 && m_valid_o_e == 2'b11 && s_ready_o_e == 2'b11) $display("STEP 6 : Correct\n");
            else $display("STEP 6 : Failed\n");
         
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
            #HALF_PERIOD
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
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_10101010_11110000 && m_id_o_lm == 10'b00_00_10_01_00 && m_last_o_lm == 5'b00000 && m_valid_o_lm == 5'b00111 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_lm <= 24'b11111111_10101010_00001111;
            s_last_i_lm <= 3'b001;
            s_valid_i_lm <= 3'b111;
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_10101010_00001111 && m_id_o_lm == 10'b0000100100 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00111 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_data_i_lm <= 24'b11111111_01010101_00001111;
            s_last_i_lm <= 3'b010;
            s_valid_i_lm <= 3'b110;
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_11111111_01010101_00001111 && m_id_o_lm == 10'b0000100101 && m_last_o_lm == 5'b00010 && m_valid_o_lm == 5'b00110 && s_ready_o_lm == 3'b110) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

            s_data_i_lm <= 24'b00000000_01010101_00001111;
            s_last_i_lm <= 3'b100;
            s_valid_i_lm <= 3'b100;
            #HALF_PERIOD
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
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_11110000 && m_id_o_lm == 10'b0000000000 && m_last_o_lm ==53'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_last_i_lm <= 3'b010;
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_10101010 && m_id_o_lm == 10'b0000000001 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_last_i_lm <= 3'b100;
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00000000_11111111 && m_id_o_lm == 10'b0000000010 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 3 : Correct\n");
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
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_11111111_11110000 && m_id_o_lm == 10'b0000001000 && m_last_o_lm == 5'b00001 && m_valid_o_lm == 5'b00011 && s_ready_o_lm == 3'b111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_lm <= 24'b00001111_10101010_11110000;
            s_dest_i_lm <= 9'b001_000_001;
            s_last_i_lm <= 3'b110;
            #HALF_PERIOD
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00001111_10101010 && m_id_o_lm == 10'b0000001001 && m_last_o_lm == 5'b00011 && m_valid_o_lm == 5'b00011 && s_ready_o_lm == 3'b111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");

            s_data_i_lm <= 24'b00001111_10101010_11110000;
            s_dest_i_lm <= 9'b000_000_000;
            s_last_i_lm <= 3'b000;
            #HALF_PERIOD
            //$display("m_data_o_ml = %b   m_id_o_ml = %b   m_last_o_ml = %b   m_valid_o_ml = %b   s_ready_o_ml = %b", m_data_o_lm, m_id_o_lm, m_last_o_lm, m_valid_o_lm, s_ready_o_lm);
            if(m_data_o_lm == 40'b00000000_00000000_00000000_00001111_00001111 && m_id_o_lm == 10'b0000000010 && m_last_o_lm == 5'b00000 && m_valid_o_lm == 5'b00001 && s_ready_o_lm == 3'b111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");

        end
    endtask


    always begin
        #HALF_PERIOD  clk =  ! clk;    //создание clk
    end 

endmodule
