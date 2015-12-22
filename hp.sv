module hp(
input [9:0] player_hp1, player_hp2,
output logic [9:0] hp1_w, hp1_x, hp1_y, hp1_h, hp2_w, hp2_x, hp2_y, hp2_h,
output logic ending1, ending2
);

assign hp1_w = player_hp1;
assign hp1_h = 20;
assign hp1_x = 30;
assign hp1_y = 80;
assign hp2_w = player_hp2;
assign hp2_h = 20;
assign hp2_x = 30;
assign hp2_y = 80;
assign ending1 = (player_hp1==0) ? 0 : 1;
assign ending2 = (player_hp2==0) ? 0 : 1;
endmodule 