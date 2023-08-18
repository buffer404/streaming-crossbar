`timescale 1ns / 1ps

module round_robin
	#(  parameter   T_DATA_WIDTH = 8,
        parameter   S_DATA_COUNT = 5,
        parameter   M_DATA_COUNT = 3,
        parameter   T_ID___WIDTH = $clog2(S_DATA_COUNT),
        parameter   T_DEST_WIDTH = $clog2(M_DATA_COUNT)
	)
	(	input clk,
		input rst,
		input [S_DATA_COUNT - 1 : 0] request_mask_i,
		input [S_DATA_COUNT - 1 : 0] s_last_i,

		output reg [S_DATA_COUNT - 1 : 0] grant_o, 
		output reg m_last_o,
		output [T_ID___WIDTH - 1 : 0] m_id_o,
		output reg m_valid_o
    );

	reg [T_ID___WIDTH - 1:0] state;
	reg [T_ID___WIDTH - 1:0] last_state;

	reg [T_ID___WIDTH - 1:0] temp_state;
	reg first_one;

	always @ (s_last_i or request_mask_i or rst) begin: next_grant
		integer i;
		temp_state = state;
		first_one = 1'b0;
		m_valid_o = 1'b0;
		m_last_o = 1'b0;
		grant_o = 0;
		if(grant_o[state] && s_last_i[state] == 0 && request_mask_i[state] && state == temp_state) begin
			m_last_o = 0;
		end else if (grant_o[state] && s_last_i[state] && request_mask_i[state] && state == temp_state) begin
			m_last_o = 1;
		end else begin
			for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
				if (request_mask_i[(temp_state + i) % S_DATA_COUNT] && !first_one) begin
					grant_o[(temp_state + i) % S_DATA_COUNT] = 1'b1;
					first_one = 1'b1;
					m_valid_o = 1'b1;
					if (s_last_i[(temp_state + i) % S_DATA_COUNT]) m_last_o = 1'b1;
					else m_last_o = 1'b0;
					temp_state = (temp_state + i) % S_DATA_COUNT;
				end else begin
					grant_o[(temp_state + i) % S_DATA_COUNT] = 1'b0;
				end
			end
		end
	end

	always @ (posedge clk) begin
		if(rst) begin
			state <= 0;
			last_state <= 0;
		end else begin
			if(m_last_o) begin
				if(temp_state == S_DATA_COUNT - 1) begin
					state <= 0;
				end else state <= temp_state + 1;
			end else state <= temp_state;
			last_state <= temp_state;
		end
	end

	assign m_id_o = last_state;

endmodule
