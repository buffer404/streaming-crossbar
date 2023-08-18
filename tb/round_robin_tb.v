`timescale 1ns / 1ps

module round_robin_tb;

    localparam    T_DATA_WIDTH = 8;
    localparam    S_DATA_COUNT = 5;
    localparam    M_DATA_COUNT = 3;
    localparam    T_ID___WIDTH = $clog2(S_DATA_COUNT);
    localparam    T_DEST_WIDTH = $clog2(M_DATA_COUNT);

    reg clk = 1;
    reg rst = 0;
    reg [S_DATA_COUNT - 1 : 0] request_mask = 0;
    reg [S_DATA_COUNT - 1 : 0] s_last = 0;

    wire [S_DATA_COUNT - 1 : 0] request_mask_w = request_mask;
    wire [S_DATA_COUNT - 1 : 0] s_last_w = s_last;
    wire [S_DATA_COUNT - 1 : 0] grant_o; 
    wire m_last_w;
    wire [T_ID___WIDTH - 1 : 0] m_id_w;
    wire m_valid_w;

    round_robin round_robin(
        .clk(clk),
        .rst(rst),
        .request_mask_i(request_mask_w),
        .s_last_i(s_last_w),

        .grant_o(grant_o), 
        .m_last_o(m_last_w),
		.m_id_o(m_id_w),
        .m_valid_o(m_valid_w)
    );

    initial begin
        rst = 1;
        #4
        rst = 0;
        #4
        request_mask <= 5'b01000;
        s_last <= 5'b00000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b01000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b10101;
        s_last <= 5'b00000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b10000;
        s_last <= 5'b00000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b10000;
        s_last <= 5'b10000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b00000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b00001;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b00010;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b00100;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b11111;
        s_last <= 5'b01000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
        request_mask <= 5'b00000;
        s_last <= 5'b10000;
        #4
        $display("grant = %h, last = %h, id = %h, valid = %h", grant_o, m_last_w, m_id_w, m_valid_w);
    end


    always begin
        #2  clk =  ! clk;    //создание clk
    end 

endmodule
