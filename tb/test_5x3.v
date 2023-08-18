`timescale 1ns / 1ps

module test_5x3(input clk);

    localparam    PERIOD = 8;
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

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_ML),
        .S_DATA_COUNT(S_DATA_COUNT_ML),
        .M_DATA_COUNT(M_DATA_COUNT_ML),
        .T_ID___WIDTH(T_ID___WIDTH_ML),
        .T_DEST_WIDTH(T_DEST_WIDTH_ML)
    ) crossbar_5x3(
        .clk(clk),
        .rst(rst),

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

    task clear();
        begin
            rst = 1;
            #PERIOD
            rst = 0;
        end
    endtask

     task test_5x3_1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i_ml <= 40'b11111111_00000000_10101010_00000000_11110000;
            s_dest_i_ml <= 10'b10_00_01_00_00;
            s_last_i_ml <= 5'b10101;
            s_valid_i_ml <= 5'b10101;
            m_ready_i_ml <= 3'b111;
            #PERIOD
            if(m_data_o_ml == 24'b11111111_10101010_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b111 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b00101) $display("STEP 1 : Correct \n");
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

            #PERIOD
            if(m_data_o_ml == 24'b11110000_11110000_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b00101) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");

            s_data_i_ml <= 40'b10101010_00000000_10101010_00000000_10101010;
            s_last_i_ml <= 5'b00100;
            s_valid_i_ml <= 5'b10100;
            m_ready_i_ml <= 3'b110;
            if(m_data_o_ml == 24'b11110000_11110000_11110000 && m_id_o_ml == 9'b100_010_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b00101) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
            #PERIOD
            s_data_i_ml <= 40'b11111111_00000000_11111111_00000000_11111111;
            s_last_i_ml <= 5'b10000;
            s_valid_i_ml <= 5'b10000;
            m_ready_i_ml <= 3'b100;
            #PERIOD
            if(m_data_o_ml == 24'b11111111_11111111_10101010 && m_id_o_ml == 9'b100_011_001 && m_last_o_ml == 3'b100 && m_valid_o_ml == 3'b100 && s_ready_o_ml == 5'b00000) $display("STEP 3 : Correct \n");
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
            #PERIOD
            if(m_data_o_ml === 24'b00000000_00000000_00000000 && m_id_o_ml === 9'b000_000_000 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b00111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");
            s_last_i_ml <= 5'b00010;
            #PERIOD
            if(m_data_o_ml === 24'b00000000_00000000_00001111 && m_id_o_ml === 9'b000_000_001 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b00111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");   
            s_last_i_ml <= 5'b00100;
            #PERIOD
            if(m_data_o_ml === 24'b00000000_00000000_11110000 && m_id_o_ml === 9'b000_000_010 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b00111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed"); 
            s_last_i_ml <= 5'b01000;
            #PERIOD
            if(m_data_o_ml === 24'b00000000_00000000_10101010 && m_id_o_ml === 9'b000_000_011 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b00111) $display("STEP 4 : Correct");
            else $display("STEP 4 : Failed");  
            s_last_i_ml <= 5'b10000;
            #PERIOD
//            $display("m_data_o = %b   m_id_o = %b   m_last_o = %b   m_valid_o = %b   s_ready_o = %b", m_data_o_ml, m_id_o_ml, m_last_o_ml, m_valid_o_ml, s_ready_o_ml);
            if(m_data_o_ml === 24'b00000000_00000000_11111111 && m_id_o_ml === 9'b000_000_100 && m_last_o_ml == 3'b001 && m_valid_o_ml == 3'b001 && s_ready_o_ml == 5'b00111) $display("STEP 5 : Correct\n");
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
            #PERIOD
            if(m_data_o_ml == 24'b10101010_00001111_00000000 && m_id_o_ml == 9'b011_001_000 && m_last_o_ml == 3'b000 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b00111) $display("STEP 1 : Correct");
            else $display("STEP 1 : Failed");
            s_last_i_ml <= 5'b01011;
            #PERIOD
            if(m_data_o_ml == 24'b10101010_00001111_00000000 && m_id_o_ml == 9'b011_001_000 && m_last_o_ml == 3'b111 && m_valid_o_ml == 3'b111 && s_ready_o_ml == 5'b00111) $display("STEP 2 : Correct");
            else $display("STEP 2 : Failed");
            s_dest_i_ml <= 10'b10_10_01_01_01;
            s_last_i_ml <= 5'b10100;
            #PERIOD
            if(m_data_o_ml == 24'b11111111_11110000_00000000 && m_id_o_ml == 9'b100_010_001 && m_last_o_ml == 3'b110 && m_valid_o_ml == 3'b110 && s_ready_o_ml == 5'b00111) $display("STEP 3 : Correct");
            else $display("STEP 3 : Failed");
            s_last_i_ml <= 5'b00001;
            #PERIOD
            if(m_data_o_ml === 24'b10101010_00000000_00000000 && m_id_o_ml == 9'b011_000_001 && m_last_o_ml == 3'b010 && m_valid_o_ml == 3'b110 && s_ready_o_ml == 5'b00111) $display("STEP 4 : Correct \n");
            else $display("STEP 4 : Failed\n");           
        end
    endtask


    task run_test();
        begin
            $display("\nRUNNING ALL TEST WHERE COUNT OF MASTER MORE THAN SLAVE");
            clear();
            test_5x3_3();
            clear();
            test_5x3_1();
            clear();

            test_5x3_2();
            clear();


            test_5x3_4();
            clear();
        end 
    endtask

endmodule