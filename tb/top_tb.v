`timescale 1ns / 1ps

module top_tb;

    localparam    T_DATA_WIDTH = 8;
    localparam    S_DATA_COUNT = 5;
    localparam    M_DATA_COUNT = 3;
    localparam    T_ID___WIDTH = $clog2(S_DATA_COUNT);
    localparam    T_DEST_WIDTH = $clog2(M_DATA_COUNT);

    localparam    HALF_PERIOD = 4;

    reg clk = 0;
    reg rst = 0;

    reg [(T_DATA_WIDTH) * (S_DATA_COUNT) - 1 : 0] s_data_i;
    reg [(T_DEST_WIDTH) * (S_DATA_COUNT) - 1 : 0] s_dest_i;
    reg [S_DATA_COUNT-1:0] s_last_i;
    reg [S_DATA_COUNT-1:0] s_valid_i;
    wire [S_DATA_COUNT-1:0] s_ready_o;

    wire [(T_DATA_WIDTH) * (M_DATA_COUNT) - 1 : 0] m_data_o;
    wire [(T_ID___WIDTH) * (M_DATA_COUNT) - 1 : 0] m_id_o;
    wire [M_DATA_COUNT-1:0] m_last_o;
    wire [M_DATA_COUNT-1:0] m_valid_o;
    reg [M_DATA_COUNT-1:0] m_ready_i;

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH),
        .S_DATA_COUNT(S_DATA_COUNT),
        .M_DATA_COUNT(M_DATA_COUNT),
        .T_ID___WIDTH(T_ID___WIDTH),
        .T_DEST_WIDTH(T_DEST_WIDTH)
    ) top(
        .rst_n(rst),

        .s_data_i(s_data_i),
        .s_dest_i(s_dest_i),        
        .s_last_i(s_last_i),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),

        .m_data_o (m_data_o),
        .m_id_o (m_id_o),
        .m_last_o(m_last_o),
        .m_valid_o(m_valid_o),
        .m_ready_i(m_ready_i)
    );

    initial begin

        clear();
        test1();
        clear();

        test2();
        clear();

        test3();
        clear();

        test4();
        clear();

    end

    task clear();
        begin
            s_data_i = 0;
            s_dest_i = 0;
            s_last_i = 0;
            s_valid_i = 0;
            m_ready_i = 0;
            rst = 1;
            #HALF_PERIOD
            rst = 0;
        end
    endtask

    task test1();
        begin
            $display("\nTEST : Parallel transmission of a single packet to all output ports");

            s_data_i <= 40'b11111111_00000000_10101010_00000000_11110000;
            s_dest_i <= 10'b10_00_01_00_00;
            s_last_i <= 5'b10101;
            s_valid_i <= 5'b10101;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b11111111_10101010_11110000 && m_id_o == 9'b100_010_000 && m_last_o == 3'b111 && m_valid_o == 3'b111 && s_ready_o == 5'b10101) begin
                $display("STEP 1 : Correct \n\n");
            end
            else $display("STEP 1 : Failed\n\n");
        end
    endtask

    task test2();
        begin
            $display("TEST : Parallel transmission of multiple packets to all output ports");

            s_data_i <= 40'b11110000_00000000_11110000_00000000_11110000;
            s_dest_i <= 10'b10_00_01_00_00;
            s_last_i <= 5'b00001;
            s_valid_i <= 5'b10101;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b11110000_11110000_11110000 && m_id_o == 9'b100_010_000 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b10101) begin
                $display("STEP 1 : Correct");
            end
            else $display("STEP 1 : Failed");

            s_data_i <= 40'b10101010_00000000_10101010_00000000_10101010;
            s_dest_i <= 10'b10_00_01_00_00;
            s_last_i <= 5'b00100;
            s_valid_i <= 5'b10100;
            m_ready_i <= 3'b110;
            if(m_data_o == 24'b11110000_11110000_11110000 && m_id_o == 9'b100_010_000 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b10101) begin
                $display("STEP 2 : Correct");
            end
            else $display("STEP 2 : Failed");
            #HALF_PERIOD
            s_data_i <= 40'b11111111_00000000_11111111_00000000_11111111;
            s_dest_i <= 10'b10_00_01_00_00;
            s_last_i <= 5'b10000;
            s_valid_i <= 5'b10000;
            m_ready_i <= 3'b100;
            #HALF_PERIOD
            if(m_data_o == 24'b11111111_10101010_11110000 && m_id_o == 9'b100_011_001 && m_last_o == 3'b100 && m_valid_o == 3'b100 && s_ready_o == 5'b10000) begin
                $display("STEP 3 : Correct \n\n");
            end
            else $display("STEP 3 : Failed\n\n");
        end
    endtask

    task test3();
        begin
            $display("TEST : Transmission of packets to one output port with arbitration of all input ports");

            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b00_00_00_00_00;
            s_last_i <= 5'b00001;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b00000000_00000000_00000000 && m_id_o == 9'b000_000_000 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 1 : Correct");
            end
            else $display("STEP 1 : Failed");
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b00_00_00_00_00;
            s_last_i <= 5'b00010;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b00000000_00000000_00001111 && m_id_o == 9'b000_000_001 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 2 : Correct");
            end
            else $display("STEP 2 : Failed");            
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b00_00_00_00_00;
            s_last_i <= 5'b00100;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b00000000_00000000_11110000 && m_id_o == 9'b000_000_010 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 3 : Correct");
            end
            else $display("STEP 3 : Failed");            
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b00_00_00_00_00;
            s_last_i <= 5'b01000;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b00000000_00000000_10101010 && m_id_o == 9'b000_000_011 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 4 : Correct");
            end
            else $display("STEP 4 : Failed");            
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b00_00_00_00_00;
            s_last_i <= 5'b10000;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o === 24'b00000000_00000000_11111111 && m_id_o == 9'b000000100 && m_last_o == 3'b001 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 5 : Correct\n\n");
            end
            else $display("STEP 5 : Failed\n\n");            
        end
    endtask

    task test4();
        begin
            $display("TEST : Packet transfer to multiple output ports with arbitration");

            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b10_10_01_01_00;
            s_last_i <= 5'b00000;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b10101010_00001111_00000000 && m_id_o == 9'b011_001_000 && m_last_o == 3'b000 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 1 : Correct");
            end
            else $display("STEP 1 : Failed");
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b10_10_01_01_00;
            s_last_i <= 5'b01011;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b10101010_00001111_00000000 && m_id_o == 9'b011_001_000 && m_last_o == 3'b111 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 2 : Correct");
            end
            else $display("STEP 2 : Failed");
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b10_10_01_01_01;
            s_last_i <= 5'b10100;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            if(m_data_o == 24'b11111111_11110000_00000000 && m_id_o == 9'b100_010_001 && m_last_o == 3'b110 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 3 : Correct");
            end
            else $display("STEP 3 : Failed");
            s_data_i <= 40'b11111111_10101010_11110000_00001111_00000000;
            s_dest_i <= 10'b10_10_01_01_01;
            s_last_i <= 5'b00001;
            s_valid_i <= 5'b11111;
            m_ready_i <= 3'b111;
            #HALF_PERIOD
            // $display("m_data_o = %b   m_id_o = %b   m_last_o = %b   m_valid_o = %b   s_ready_o = %b", m_data_o, m_id_o, m_last_o, m_valid_o, s_ready_o);
            if(m_data_o === 24'b10101010_00000000_00000000 && m_id_o == 9'b011_000_001 && m_last_o == 3'b010 && m_valid_o == 3'b111 && s_ready_o == 5'b11111) begin
                $display("STEP 4 : Correct \n");
            end
            else $display("STEP 4 : Failed");            
        end
    endtask

    always begin
        #HALF_PERIOD  clk =  ! clk;    //создание clk
    end 

endmodule
