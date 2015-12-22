module player2(
input Reset, frame_clk,
input [15:0] keycode0, keycode1, keycode2,
input [9:0] damage,
input [3:0] combo,
input ball_ready,
input ending,
output logic face,
output logic summon_ball,
output logic [9:0] player_hp,
output logic [9:0] player_x, player_y,
output logic [8:0] action
);

logic [9:0] player_X, player_Y, player_xm, player_ym;
logic [8:0] next_action;
logic jump;
logic keysdown [5];

parameter [9:0] player_ycenter=300;
parameter [9:0] player_xcenter=480;

always_comb begin
	next_action = 0;

	if (action >= 24 && action < 89)
		next_action = action + 1;
	else if ((action >= 90 && action < 113) || (action >= 114 && action < 137) || (action >= 138 && action < 171) || (action >= 162 && action < 173) || (action >= 174 && action < 185) || (action >= 186 && action < 201))
		next_action = action + 1;
	else if (action == 173)
		next_action = 90;

	if ((keysdown[0] || keysdown[1]) && jump == 0) begin
		if ((keysdown[0] && keysdown[1]) || action == 23)
			next_action = 0;
		else if (action <= 23)
			next_action = action + 1;
	end 
	
	if (keysdown[2] && action <= 23)
		next_action = 24;
	else if (keysdown[4] && ball_ready && action <= 23)
		next_action = 186;
	else if (keysdown[3]) begin
		if (action <= 23 || action >= 174 || (combo == 4'd0 && (action == 113 || action == 137 || action == 161)))
			next_action = 90;
		else if (combo > 4'd0 && action >= 90 && action < 173)
			next_action = action + 1;
	end
end

always_ff @ (posedge Reset or posedge frame_clk )
begin: player_cloud
	keysdown[0] = (keycode0[15:8] == 4 || keycode0[7:0] == 4 || keycode1[15:8] == 4 || keycode1[7:0] == 4 || keycode2[15:8] == 4 || keycode2[7:0] == 4) && ending;;
	keysdown[1] = (keycode0[15:8] == 7 || keycode0[7:0] == 7 || keycode1[15:8] == 7 || keycode1[7:0] == 7 || keycode2[15:8] == 7 || keycode2[7:0] == 7) && ending;;
	keysdown[2] = (keycode0[15:8] == 26 || keycode0[7:0] == 26 || keycode1[15:8] == 26 || keycode1[7:0] == 26 || keycode2[15:8] == 26 || keycode2[7:0] == 26) && ending;;
	keysdown[3] = (keycode0[15:8] == 14 || keycode0[7:0] == 14 || keycode1[15:8] == 14 || keycode1[7:0] == 14 || keycode2[15:8] == 14 || keycode2[7:0] == 14) && ending;;
	keysdown[4] = (keycode0[15:8] == 15 || keycode0[7:0] == 15 || keycode1[15:8] == 15 || keycode1[7:0] == 15 || keycode2[15:8] == 15 || keycode2[7:0] == 15) && ending;;

	if (Reset)  // Asynchronous Reset
	begin 
		player_ym <= 10'd0; //cloud_Y_Step;
		player_xm <= 10'd0; //cloud_X_Step;
		player_hp <= 150;
		player_Y <= player_ycenter;
		player_X <= player_xcenter;
		action <= 0;
		face <= 1;
		jump <= 0;
		summon_ball <= 0;
	end
	else begin
		player_xm <= 0;
		player_ym <= 0;
		summon_ball <= 0;
		
		if (action <= 71) begin
			if (keysdown[0] && !keysdown[1]) begin
				player_xm <= -3;
				face <= 1;
			end
			else if (keysdown[1] && !keysdown[0]) begin
				player_xm <= 3;
				face <= 0;
			end
		end
			
		if (action == 24)
			jump <= 1;
		else if (action == 89)
			jump <= 0;	
		else if (action >= 36 && action <= 71) begin
			if (action <= 38)
				player_ym <= -30;
			else if (action <= 41)
				player_ym <= -10;
			else if (action <= 47)
				player_ym <= -3;
			else if (action <= 53)
				player_ym <= 0;
			else if (action <= 59)
				player_ym <= 3;
			else
				player_ym <= 10;
		end
		else if ((action >= 102 && action <= 104) || (action >= 114 && action <= 116) || (action >= 138 && action <= 140))
			player_xm <= face == 0 ? 1 : -1;
		else if (action >= 150 && action < 152)
			player_xm <= face == 0 ? 3 : -3;
		else if ((action >= 162 && action <= 173))
			player_xm <= face == 1 ? 1 : -1;
		else if (action == 186)
			summon_ball <= 1;
		
		if (player_X + player_xm < 10'd10)
			player_X <= 10;
		else if (player_X + player_xm > 10'd550)
			player_X <= 550;
		else
			player_X <= player_X + player_xm;
			
		player_Y <= player_Y + player_ym;
		
		action <= next_action;
		
		if (player_hp < damage)
			player_hp <= 10'd0;
		else
			player_hp <= player_hp - damage;
	end
end

assign player_x = player_X;
assign player_y = player_Y;
endmodule