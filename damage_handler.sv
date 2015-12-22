module damage_handler (
	input clk,
	input reset,
	input face1, face2,
	input [9:0] player_x1, player_x2,
	input [9:0] player_y1, player_y2,
	input [8:0] action1, action2,
	input summoned_ball1, summoned_ball2,
	input ball_face1, ball_face2,
	input [9:0] ball_x1, ball_x2, ball_y1, ball_y2,
	output logic [3:0] hit1, hit2,
	output logic [9:0] player_dmg1, player_dmg2
);

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		hit2 <= 0;
		player_dmg2 <= 0;
	end
	else begin
		if (hit2 == 0) begin
			if (((action1 >= 102 && action1 <= 113) || (action1 >= 126 && action1 <= 137) || (action1 >= 150 && action1 <= 161)) && player_y1 + 10'd80 >= player_y2) begin
				if (face1 == 1 && player_x1 >= player_x2 + 10'd10 && player_x1 < player_x2 + 10'd50) begin
					player_dmg2 <= 10;
					hit2 <= 12;
				end
				else if (face1 == 0 && player_x1 + 10'd10 <= player_x2 && player_x1 + 10'd50 > player_x2) begin
					player_dmg2 <= 10;
					hit2 <= 12;
				end
			end
		end
		else begin
			player_dmg2 <= 0;
			hit2 <= hit2 - 4'd1;
		end
		
		if (summoned_ball1 && ball_y1 >= player_y2 + 10'd40) begin
			if (ball_face1 == 1 && ball_x1 + 10'd10 >= player_x2 && ball_x1 < player_x2 + 10'd20)
				player_dmg2 <= player_dmg2 + 10'd1;
			else if (ball_face1 == 0 && ball_x1 <= player_x2 + 10'd10 && ball_x1 + 10'd20 > player_x2)
				player_dmg2 <= player_dmg2 + 10'd1;
		end
	end
end

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		hit1 <= 0;
		player_dmg1 <= 0;
	end		
	else begin
		if (hit1 == 0) begin
			if (((action2 >= 102 && action2 <= 113) || (action2 >= 126 && action2 <= 137) || (action2 >= 150 && action2 <= 161)) && player_y2 + 10'd80 >= player_y1) begin
				if (face2 == 1 && player_x2 >= player_x1 + 10'd10 && player_x2 < player_x1 + 10'd50) begin
					player_dmg1 <= 10;
					hit1 <= 12;
				end
				else if (face2 == 0 && player_x2 + 10'd10 <= player_x1 && player_x2 + 10'd50 > player_x1) begin
					player_dmg1 <= 10;
					hit1 <= 12;
				end
			end
		end
		else begin
			player_dmg1 <= 0;
			hit1 <= hit1 - 4'd1;
		end
		
		if (summoned_ball2 && ball_y2 >= player_y1 + 10'd40) begin
			if (ball_face2 == 1 && ball_x2 + 10'd10 >= player_x1 && ball_x2 < player_x1 + 10'd20)
				player_dmg1 <= player_dmg1 + 10'd1;
			else if (ball_face2 == 0 && ball_x2 <= player_x1 + 10'd10 && ball_x2 + 10'd20 > player_x1)
				player_dmg1 <= player_dmg1 + 10'd1;
		end
	end
end

endmodule 
