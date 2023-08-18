`timescale 1ns / 1ps

module test_1x3(input clk);

    localparam    PERIOD = 8;
    reg rst = 0;

    // parameters and values for tests where one master and many slaves

    localparam    T_DATA_WIDTH_OM = 8;
    localparam    S_DATA_COUNT_OM = 1;
    localparam    M_DATA_COUNT_OM = 3;
    localparam    T_ID___WIDTH_OM = $clog2(S_DATA_COUNT_OM) == 0 ? 1 : $clog2(S_DATA_COUNT_OM);
    localparam    T_DEST_WIDTH_OM = $clog2(M_DATA_COUNT_OM);

    reg [(T_DATA_WIDTH_OM) * (S_DATA_COUNT_OM) - 1 : 0] s_data_i_om;
    reg [(T_DEST_WIDTH_OM) * (S_DATA_COUNT_OM) - 1 : 0] s_dest_i_om;
    reg [S_DATA_COUNT_OM-1:0] s_last_i_om;
    reg [S_DATA_COUNT_OM-1:0] s_valid_i_om;
    wire [S_DATA_COUNT_OM-1:0] s_ready_o_om;

    wire [(T_DATA_WIDTH_OM) * (M_DATA_COUNT_OM) - 1 : 0] m_data_o_om;
    wire [(T_ID___WIDTH_OM) * (M_DATA_COUNT_OM) - 1 : 0] m_id_o_om;
    wire [M_DATA_COUNT_OM-1:0] m_last_o_om;
    wire [M_DATA_COUNT_OM-1:0] m_valid_o_om;
    reg [M_DATA_COUNT_OM-1:0] m_ready_i_om;

    top # (
        .T_DATA_WIDTH(T_DATA_WIDTH_OM),
        .S_DATA_COUNT(S_DATA_COUNT_OM),
        .M_DATA_COUNT(M_DATA_COUNT_OM),
        .T_ID___WIDTH(T_ID___WIDTH_OM),
        .T_DEST_WIDTH(T_DEST_WIDTH_OM)
    ) crossbar_1x3(
        .clk(clk),
        .rst(rst),

        .s_data_i(s_data_i_om),
        .s_dest_i(s_dest_i_om),        
        .s_last_i(s_last_i_om),
        .s_valid_i(s_valid_i_om),
        .s_ready_o(s_ready_o_om),

        .m_data_o(m_data_o_om),
        .m_id_o(m_id_o_om),
        .m_last_o(m_last_o_om),
        .m_valid_o(m_valid_o_om),
        .m_ready_i(m_ready_i_om)
    );

    task clear();
        begin
            rst = 1;
            #PERIOD
            rst = 0;
        end
    endtask

    task test_1x3_1();
        begin
            $display("\nTEST : Transfer of one packet from input to output");

            s_data_i_om <= 8'b11111111;
            s_dest_i_om <= 2'b00;
            s_last_i_om <= 1'b1;
            s_valid_i_om <= 1'b1;
            m_ready_i_om <= 3'b111;
            #PERIOD
            //$display("m_data_o = %b   m_id_o = %b   m_last_o = %b   m_valid_o = %b   s_ready_o = %b", m_data_o_om, m_id_o_om, m_last_o_om, m_valid_o_om, s_ready_o_om);
            if(m_data_o_om == 24'b00000000_00000000_11111111 && m_id_o_om === 3'b0_0_0 && m_last_o_om == 3'b0_0_1 && m_valid_o_om == 3'b0_0_1 && s_ready_o_om == 1'b1) $display("STEP 1 : Correct \n");
            else $display("STEP 1 : Failed\n");
        end
    endtask

    task test_1x3_2();
        begin

            s_data_i_om <= 8'b11111111;
            s_dest_i_om <= 2'b00;
            s_last_i_om <= 1'b0;
            s_valid_i_om <= 1'b1;
            m_ready_i_om <= 3'b111;
            #PERIOD
            if(m_data_o_om == 24'b00000000_00000000_11111111 && m_id_o_om === 3'b0_0_0 && m_last_o_om == 3'b0_0_0 && m_valid_o_om == 3'b0_0_1 && s_ready_o_om == 1'b1) $display("STEP 1 : Correct ");
            else $display("STEP 1 : Failed");

            s_data_i_om <= 8'b10101010;
            s_dest_i_om <= 2'b00;
            s_last_i_om <= 1'b0;
            s_valid_i_om <= 1'b1;
            m_ready_i_om <= 3'b111;
            #PERIOD
            if(m_data_o_om == 24'b00000000_00000000_10101010 && m_id_o_om === 3'b0_0_0 && m_last_o_om == 3'b0_0_0 && m_valid_o_om == 3'b0_0_1 && s_ready_o_om == 1'b1) $display("STEP 2 : Correct ");
            else $display("STEP 2 : Failed");

            s_data_i_om <= 8'b01010101;
            s_dest_i_om <= 2'b00;
            s_last_i_om <= 1'b1;
            s_valid_i_om <= 1'b1;
            m_ready_i_om <= 3'b111;
            #PERIOD
            if(m_data_o_om == 24'b00000000_00000000_01010101 && m_id_o_om === 3'b0_0_0 && m_last_o_om == 3'b0_0_1 && m_valid_o_om == 3'b0_0_1 && s_ready_o_om == 1'b1) $display("STEP 3 : Correct\n");
            else $display("STEP 3 : Failed\n");
        end
    endtask

    task run_test();
        begin
            $display("\nRUNNING ALL TEST WHERE ONE MASTER AND MANY SLAVE");
            clear();
            test_1x3_1();
            clear();
            test_1x3_2();
            clear();
        end 
    endtask


endmodule
