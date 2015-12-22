module player_ball2 (
	input Reset, frame_clk,
	input [9:0] player_x, player_y,
	input face,
	input summon_ball,
	output logic ball_face,
	output logic summoned_ball,
	output logic [9:0]  ball_x, ball_y,
	output logic [8:0]  ball_action
	);
	
logic [9:0] ball_X, ball_Y, ball_xm;
logic [8:0] next_ball_action;

always_comb begin
	next_ball_action = 0;
	
	if (ball_action < 17)
		next_ball_action = ball_action + 1;
	else
		next_ball_action = 0;
end

always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if(Reset)
		begin
			ball_face <= face;
			summoned_ball <= 0;
			ball_X <= player_x;
			ball_Y <= player_y + 20;
			ball_xm <= 0;
			ball_action <= 0;
		end
		else begin
			if (summon_ball && summoned_ball == 0) begin
				ball_face <= face;
				summoned_ball <= 1;
				ball_X <= face == 0 ? player_x + 10'd30 : player_x - 10'd30;
				ball_Y <= player_y + 10'd20;
				ball_action <= 0;
				ball_xm <= face == 0 ? 4 : -4;
			end
			else if (summoned_ball) begin
				if (ball_X >= 10'd590 || ball_X <= 10'd10) begin
					summoned_ball <= 0;
					ball_xm <= 0;
				end
				else begin
					ball_action <= next_ball_action;
				end
			end
			
			ball_X <= ball_X + ball_xm;
		end
	end
	
assign ball_x = ball_X;
assign ball_y = ball_Y;

endmodule
			
