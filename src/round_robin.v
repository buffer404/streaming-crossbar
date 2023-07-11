`timescale 1ns / 1ps

module round_robin
	#(  parameter   T_DATA_WIDTH = 8,
        parameter   S_DATA_COUNT = 5,
        parameter   M_DATA_COUNT = 3,
        parameter   T_ID___WIDTH = $clog2(S_DATA_COUNT),
        parameter   T_DEST_WIDTH = $clog2(M_DATA_COUNT)
	)
	(	input rst,
		input [S_DATA_COUNT - 1 : 0] request_mask_i,
		input [S_DATA_COUNT - 1 : 0] s_last_i,

		output reg [S_DATA_COUNT - 1 : 0] grant_o, 
		output reg m_last_o,
		output [T_ID___WIDTH - 1 : 0] m_id_o
    );

	reg [T_ID___WIDTH - 1:0] state;

	always @ (*) begin: next_grant
		integer i;
		integer first_one;
		first_one = 0;
		grant_o = 0;

		if(rst) begin
			state = 0;
			m_last_o = 0;
		end else begin

			if(m_last_o) begin
				if(state == S_DATA_COUNT - 1) begin
					state = 0;
				end	else begin
					state = state + 1;
				end
			
			end

			for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
				if (request_mask_i[(state + i) % S_DATA_COUNT] && !first_one) begin
					grant_o[(state + i) % S_DATA_COUNT] = 1'b1;
					first_one = 1;
					state = (state + i) % S_DATA_COUNT;
				end else begin
					grant_o[(state + i) % S_DATA_COUNT] = 1'b0;
				end
			end

			if (s_last_i[state]) begin
				m_last_o = 1;
			end else m_last_o = 0;

		end
	end

	assign m_id_o = state;

endmodule