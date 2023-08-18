`timescale 1ns / 1ps

module schedule
	#(  parameter   T_DATA_WIDTH = 8,
        parameter   S_DATA_COUNT = 5,
        parameter   M_DATA_COUNT = 3,
        parameter   T_ID___WIDTH = $clog2(S_DATA_COUNT),
        parameter   T_DEST_WIDTH = $clog2(M_DATA_COUNT)
	)
	(	input clk,
        input rst,
		input [T_DEST_WIDTH * S_DATA_COUNT - 1 : 0] s_dest_i,
		input [S_DATA_COUNT - 1 : 0] s_valid_i,
        input [M_DATA_COUNT - 1 : 0] m_ready_i,
		input [S_DATA_COUNT - 1 : 0] s_last_i,

		output [M_DATA_COUNT * T_ID___WIDTH - 1 : 0] m_id_o,
        output [M_DATA_COUNT - 1 : 0] m_last_o,
        output [M_DATA_COUNT - 1 : 0] m_valid_o,
        output [S_DATA_COUNT - 1 : 0] s_ready_o,
        output [S_DATA_COUNT * M_DATA_COUNT - 1 : 0] grant_o
    );

    reg [M_DATA_COUNT * S_DATA_COUNT - 1 : 0] request_mask;
    reg [M_DATA_COUNT * S_DATA_COUNT - 1 : 0] last_mask;   

    generate
        genvar i;
            for (i = 0; i < M_DATA_COUNT;  i = i + 1) begin
                round_robin  # (
                    .T_DATA_WIDTH(T_DATA_WIDTH),
                    .S_DATA_COUNT(S_DATA_COUNT),
                    .M_DATA_COUNT(M_DATA_COUNT),
                    .T_ID___WIDTH(T_ID___WIDTH),
                    .T_DEST_WIDTH(T_DEST_WIDTH)
                )  round_robin(
                    .clk(clk),
                    .rst(rst),
                    .request_mask_i(request_mask[i * S_DATA_COUNT +: S_DATA_COUNT]),
                    .s_last_i(last_mask[i * S_DATA_COUNT +: S_DATA_COUNT]),
                    .grant_o(grant_o[i * S_DATA_COUNT +: S_DATA_COUNT]), 
                    .m_last_o(m_last_o[i]), 
                    .m_id_o( m_id_o[i * T_ID___WIDTH +: T_ID___WIDTH]), // [Synth 8-2908] range width must be a positive integer
                                                                    // в граничные моменты (например кроссбар 1 мастер на несколько слейвов или наоборот несколько слейвов в 1 мастер индекс выходит за границы массива
                    .m_valid_o(m_valid_o[i])
                );
            end
    endgenerate

    always @(*) begin: calc_request_last
        integer i;
        request_mask = 0;
        last_mask = 0;

        if(rst) begin
            request_mask = 0;
            last_mask = 0;
        end

        else begin
            for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
                if(m_ready_i[s_dest_i[i*T_DEST_WIDTH +: T_DEST_WIDTH]] && s_valid_i[i]) begin
                    request_mask[s_dest_i[i*T_DEST_WIDTH +: T_DEST_WIDTH] * S_DATA_COUNT + i] = 1;
                end  
                if(s_last_i[i]) begin
                    last_mask[s_dest_i[i*T_DEST_WIDTH +: T_DEST_WIDTH] * S_DATA_COUNT + i] = 1;
                end  
            end
        end
    end

    assign s_ready_o = s_valid_i & m_ready_i;  // s_ready_o может ли подняться, когда нет готовности со стороны m?
                                      // m_ready не учитывается, можем потерять пакет?

endmodule