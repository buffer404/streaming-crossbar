`timescale 1ns / 1ps

module test_3x1(input clk);

    localparam    PERIOD = 8;
    reg rst = 0;

    // parameters and values for tests where many master and one slave

    localparam    T_DATA_WIDTH_MO = 8;
    localparam    S_DATA_COUNT_MO = 3;
    localparam    M_DATA_COUNT_MO = 1;
    localparam    T_ID___WIDTH_MO = $clog2(S_DATA_COUNT_MO) == 0 ? 1 : $clog2(S_DATA_COUNT_MO);
    localparam    T_DEST_WIDTH_MO = $clog2(M_DATA_COUNT_MO) == 0 ? 1 : $clog2(M_DATA_COUNT_MO);

    reg [(T_DATA_WIDTH_MO) * (S_DATA_COUNT_MO) - 1 : 0] s_data_i_mo;
    reg [(T_DEST_WIDTH_MO) * (S_DATA_COUNT_MO) - 1 : 0] s_dest_i_mo;
    reg [S_DATA_COUNT_MO-1:0] s_last_i_mo;
    reg [S_DATA_COUNT_MO-1:0] s_valid_i_mo;
    wire [S_DATA_COUNT_MO-1:0] s_ready_o_mo;

    wire [(T_DATA_WIDTH_MO) * (M_DATA_COUNT_MO) - 1 : 0] m_data_o_mo;
    wire [(T_ID___WIDTH_MO) * (M_DATA_COUNT_MO) - 1 : 0] m_id_o_mo;
    wire [M_DATA_COUNT_MO-1:0] m_last_o_mo;
    wire [M_DATA_COUNT_MO-1:0] m_valid_o_mo;
    reg [M_DATA_COUNT_MO-1:0] m_ready_i_mo;

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_MO),
        .S_DATA_COUNT(S_DATA_COUNT_MO),
        .M_DATA_COUNT(M_DATA_COUNT_MO),
        .T_ID___WIDTH(T_ID___WIDTH_MO),
        .T_DEST_WIDTH(T_DEST_WIDTH_MO)
    ) crossbar_3x1(
        .clk(clk),
        .rst(rst),

        .s_data_i(s_data_i_mo),
        .s_dest_i(s_dest_i_mo),        
        .s_last_i(s_last_i_mo),
        .s_valid_i(s_valid_i_mo),
        .s_ready_o(s_ready_o_mo),

        .m_data_o(m_data_o_mo),
        .m_id_o(m_id_o_mo),
        .m_last_o(m_last_o_mo),
        .m_valid_o(m_valid_o_mo),
        .m_ready_i(m_ready_i_mo)
    );

    task clear();
        begin
            rst = 1;
            #PERIOD
         rst = 0;
        end
    endtask

    task test_3x1_1();
        begin
            $display("TEST : Transfer of one packet from input to output");

            s_data_i_mo <= 24'b11111111_10101010_01010101;
            s_dest_i_mo <= 3'b000;
            s_last_i_mo <= 3'b001;
            s_valid_i_mo <= 1'b001;
            m_ready_i_mo <= 1'b1;
            #PERIOD
            //$display("m_data_o = %b   m_id_o = %b   m_last_o = %b   m_valid_o = %b   s_ready_o = %b", m_data_o_mo, m_id_o_mo, m_last_o_mo, m_valid_o_mo, s_ready_o_mo);
            if(m_data_o_mo == 8'b01010101 && m_id_o_mo == 2'b0 && m_last_o_mo == 1'b1 && m_valid_o_mo == 1'b1 && s_ready_o_mo == 3'b001) $display("STEP 1 : Correct \n");
            else $display("STEP 1 : Failed");
        end
    endtask

    task test_3x1_2();
        begin
            $display("TEST : Transfer of many packet from input to output\n");

            s_data_i_mo <= 24'b11111111_10101010_01010101;
            s_dest_i_mo <= 3'b000;
            s_last_i_mo <= 3'b000;
            s_valid_i_mo <= 1'b001;
            m_ready_i_mo <= 1'b1;
            #PERIOD
         if(m_data_o_mo == 8'b01010101 && m_id_o_mo == 2'b0 && m_last_o_mo == 1'b0 && m_valid_o_mo == 1'b1 && s_ready_o_mo == 3'b001) $display("STEP 1 : Correct ");
            else $display("STEP 1 : Failed");

            s_data_i_mo <= 24'b11111111_10101010_11111111;
            s_dest_i_mo <= 3'b000;
            s_last_i_mo <= 3'b000;
            s_valid_i_mo <= 1'b001;
            m_ready_i_mo <= 1'b1;
            #PERIOD
         if(m_data_o_mo == 8'b11111111 && m_id_o_mo == 2'b0 && m_last_o_mo == 1'b0 && m_valid_o_mo == 1'b1 && s_ready_o_mo == 3'b001) $display("STEP 2 : Correct ");
            else $display("STEP 2 : Failed");

            s_data_i_mo <= 24'b11111111_10101010_11110000;
            s_dest_i_mo <= 3'b000;
            s_last_i_mo <= 3'b001;
            s_valid_i_mo <= 1'b001;
            m_ready_i_mo <= 1'b1;
            #PERIOD
         if(m_data_o_mo == 8'b11110000 && m_id_o_mo == 2'b0 && m_last_o_mo == 1'b1 && m_valid_o_mo == 1'b1 && s_ready_o_mo == 3'b001) $display("STEP 3 : Correct ");
            else $display("STEP 3 : Failed");
        end
    endtask

    task run_test();
        begin
            $display("RUNNING ALL TEST WHERE MANY MASTER AND ONE SLAVE \n");
            clear();
            test_3x1_1();
            clear();
            test_3x1_2();
            clear();
        end 
    endtask


endmodule
