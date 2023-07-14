`timescale 1ns / 1ps

module crossbar
    #(  parameter   T_DATA_WIDTH = 8,
        parameter   S_DATA_COUNT = 5,
        parameter   M_DATA_COUNT = 3,
        parameter   T_ID___WIDTH = $clog2(S_DATA_COUNT),
        parameter   T_DEST_WIDTH = $clog2(M_DATA_COUNT)
	)
	(	input rst,

        input [S_DATA_COUNT * M_DATA_COUNT - 1 : 0] grant_i,
        input [T_DATA_WIDTH * S_DATA_COUNT - 1 : 0] s_data_i,

        output reg [T_DATA_WIDTH * M_DATA_COUNT - 1 : 0] m_data_o
    );

    integer i;
    integer j;

    always @(*) begin
        if(rst) begin
            for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
                for (j = 0; j < M_DATA_COUNT; j = j + 1) begin
                     m_data_o[j * T_DATA_WIDTH +: T_DATA_WIDTH] = 0;
                end
            end
        end else begin    
            for (i = 0; i < M_DATA_COUNT; i = i + 1) begin
                for (j = 0; j < S_DATA_COUNT; j = j + 1) begin
                    if(grant_i[i * S_DATA_COUNT + j] == 1) begin
                        m_data_o[i * T_DATA_WIDTH +: T_DATA_WIDTH] = s_data_i[j * T_DATA_WIDTH +: T_DATA_WIDTH];
                    end
                end
            end
        end
    end

endmodule