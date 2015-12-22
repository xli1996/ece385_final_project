//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  [9:0] DrawX, DrawY,cloudX1, cloudY1,cloudX2, cloudY2, cloudW, cloudH,hp1_w, hp1_x, hp1_y, hp1_h,hp2_w, hp2_x, hp2_y, hp2_h,
												player_h, player_w, player_x1, player_y1,player_x2, player_y2, ball_x1, ball_y1, ball_x2, ball_y2, ball_h, ball_w, 
								input [8:0] player_action1, player_action2, ball_action1, ball_action2, 
								input face1, face2, ball_face1, ball_face2, ending1, ending2, summoned_ball1, summoned_ball2,
								input [0:39][0:79][0:3] cloud,
								input [0:79][0:79][0:3] player_w0, player_w1, player_w2, player_w3,
																player_j0, player_j1, player_j2,
																player_a0, player_a1, player_a2,player_a3, player_a4, player_a5,
								input [0:39][0:39][0:3]	ball0, ball1, ball2,
                        output logic [7:0]  Red, Green, Blue );
    
    logic [3:0] cloud_on1, cloud_on2, player_on1, player_on2, ball_on1, ball_on2;
	 logic hp1_on,hp2_on, ground_on;
	 logic [9:0] vDraw1, vDraw2, hDraw1, hDraw2;
	 logic [9:0] vBallDraw1, hBallDraw1;
	 logic [9:0] vBallDraw2, hBallDraw2;
	 
	 assign vDraw1 = DrawY-player_y1;
	 assign vDraw2 = DrawY-player_y2;
	 assign hDraw1 = face1 == 0 ? DrawX-player_x1 : 80-DrawX+player_x1;
	 assign hDraw2 = face2 == 0 ? DrawX-player_x2 : 80-DrawX+player_x2;
	 assign vBallDraw1 = DrawY-ball_y1;
	 assign hBallDraw1 = ball_face1 == 0 ? DrawX-ball_x1 : 40-DrawX+ball_x1;
	 assign vBallDraw2 = DrawY-ball_y2;
	 assign hBallDraw2 = ball_face2 == 0 ? DrawX-ball_x2 : 40-DrawX+ball_x2;

	 
 always_comb
    begin:CloudSprite1
     if ((DrawX >= cloudX1) && (DrawX <= cloudX1 + cloudW) && (DrawY >= cloudY1) &&(DrawY <= cloudY1 + cloudH))
		 begin
		 cloud_on1 = cloud[39-(DrawY-cloudY1)][79-(DrawX-cloudX1)];
		 end
		 
     else 
			begin
           cloud_on1 = 4'b0;	  
			end
		end
		
always_comb
    begin:CloudSprite2
     if ((DrawX >= cloudX2) && (DrawX <= cloudX2 + cloudW) && (DrawY >= cloudY2) &&(DrawY <= cloudY2 + cloudH))
		 cloud_on2 = cloud[DrawY-cloudY2][DrawX-cloudX2];		 
     else 
           cloud_on2 = 4'b0;
		end
		
always_comb
	begin:hp1
		if((DrawX >= hp1_x) && (DrawX < hp1_x+hp1_w) &&(DrawY >= hp1_y) && (DrawY <= hp1_y + hp1_h) )
				hp1_on = 1;
		else
				hp1_on = 0;
	end
	
always_comb
	begin:hp2       
		if((640-DrawX >= hp2_x) && (640-DrawX < hp2_x+hp2_w) &&(DrawY >= hp2_y) && (DrawY <= hp2_y + hp2_h))
			begin
				hp2_on = 1;
			end
		else
			begin
				hp2_on = 0;
			end
	end
	
always_comb
	begin:ground       
		if(DrawY >= 380) 
			begin
				ground_on = 1;
			end
		else	begin
				ground_on = 0;
			end
	end
	
	
always_comb
begin: player_draw
    if ((DrawX >= player_x1) && (DrawX <= player_x1 + player_w) && (DrawY >= player_y1) &&(DrawY <= player_y1 + player_h))
	 begin			
		if(player_action1 <= 5)
			player_on1 = player_w0[vDraw1][hDraw1];
		else if(player_action1 <= 11)
			player_on1 = player_w1[vDraw1][hDraw1];
		else if (player_action1 <= 17)
			player_on1 = player_w2[vDraw1][hDraw1];
		else if(player_action1 <= 23)
			player_on1 = player_w3[vDraw1][hDraw1];
			
		else if (player_action1 <= 29)
			player_on1 = player_j0[vDraw1][hDraw1];
		else if (player_action1 <= 35)
			player_on1 = player_j1[vDraw1][hDraw1];
			
		else if (player_action1 <= 71)
			player_on1 = player_j2[vDraw1][hDraw1];
			
		else if (player_action1 <= 77)
			player_on1 = player_j1[vDraw1][hDraw1];
		else if (player_action1 <= 83)
			player_on1 = player_j0[vDraw1][hDraw1];
		else if (player_action1 <= 89)
			player_on1 = player_w0[vDraw1][hDraw1];
			
		else if (player_action1 <= 101)
			player_on1 = player_a0[vDraw1][hDraw1];
		else if (player_action1 <= 113)
			player_on1 = player_a1[vDraw1][hDraw1];
		else if (player_action1 <= 125)
			player_on1 = player_a2[vDraw1][hDraw1];
		else if (player_action1 <= 137)
			player_on1 = player_a3[vDraw1][hDraw1];
		else if (player_action1 <= 149)
			player_on1 = player_a4[vDraw1][hDraw1];
		else if (player_action1 <= 161)
			player_on1 = player_a5[vDraw1][hDraw1];
			
		else if (player_action1 <= 173)
			player_on1 = player_a4[vDraw1][hDraw1];
			
		else if (player_action1 <= 185)
			player_on1 = player_w0[vDraw1][hDraw1];
			
		else if (player_action1 <= 197)
			player_on1 = player_a0[vDraw1][hDraw1];
		else
			player_on1 = player_a1[vDraw1][hDraw1];
	end
	else 
		  player_on1 = 4'b0;	  
end
		 
 always_comb
 begin: player_draw2
	if ((DrawX >= player_x2) && (DrawX <= player_x2 + player_w) && (DrawY >= player_y2) &&(DrawY <= player_y2 + player_h))
	begin
		player_on2 = player_w0[vDraw2][hDraw2];
		if(player_action2 <= 5)
			player_on2 = player_w0[vDraw2][hDraw2];
		else if(player_action2 <= 11)
			player_on2 = player_w1[vDraw2][hDraw2];
		else if (player_action2 <= 17)
			player_on2 = player_w2[vDraw2][hDraw2];
		else if(player_action2 <= 23)
			player_on2 = player_w3[vDraw2][hDraw2];
			
		else if (player_action2 <= 29)
			player_on2 = player_j0[vDraw2][hDraw2];
		else if (player_action2 <= 35)
			player_on2 = player_j1[vDraw2][hDraw2];
			
		else if (player_action2 <= 71)
			player_on2 = player_j2[vDraw2][hDraw2];
			
		else if (player_action2 <= 77)
			player_on2 = player_j1[vDraw2][hDraw2];
		else if (player_action2 <= 83)
			player_on2 = player_j0[vDraw2][hDraw2];
		else if (player_action2 <= 89)
			player_on2 = player_w0[vDraw2][hDraw2];
		
		else if (player_action2 <= 101)
			player_on2 = player_a0[vDraw2][hDraw2];
		else if (player_action2 <= 113)
			player_on2 = player_a1[vDraw2][hDraw2];
		else if (player_action2 <= 125)
			player_on2 = player_a2[vDraw2][hDraw2];
		else if (player_action2 <= 137)
			player_on2 = player_a3[vDraw2][hDraw2];
		else if (player_action2 <= 149)
			player_on2 = player_a4[vDraw2][hDraw2];
		else if (player_action2 <= 161)
			player_on2 = player_a5[vDraw2][hDraw2];
			
		else if (player_action2 <= 173)
			player_on2 = player_a4[vDraw2][hDraw2];
			
		else if (player_action2 <= 185)
			player_on2 = player_w0[vDraw2][hDraw2];
			
		else if (player_action2 <= 197)
			player_on2 = player_a0[vDraw2][hDraw2];
		else
			player_on2 = player_a1[vDraw2][hDraw2];
	end
	else 
		player_on2 = 4'b0;	  
end

always_comb
begin:draw_ball1
	if(summoned_ball1 && (DrawX >= ball_x1) &&(DrawX <= ball_x1 + ball_w) && (DrawY >= ball_y1) && (DrawY <= ball_y1 + ball_h)) begin		
		if(ball_action1 <= 5)
			ball_on1 = ball0[vBallDraw1][hBallDraw1];
		else if(ball_action1 <= 11)
			ball_on1 = ball1[vBallDraw1][hBallDraw1];
		else if(ball_action1 <= 17)
			ball_on1 = ball2[vBallDraw1][hBallDraw1];
		else
			ball_on1 = ball0[vBallDraw1][hBallDraw1];
	end
	else
		ball_on1 = 4'b0;
end

always_comb
begin:draw_ball2
	if(summoned_ball2 && (DrawX >= ball_x2) &&(DrawX <= ball_x2 + ball_w) && (DrawY >= ball_y2) && (DrawY <= ball_y2 + ball_h)) begin		
		if(ball_action2 <= 5)
			ball_on2 = ball0[vBallDraw2][hBallDraw2];
		else if(ball_action2 <= 11)
			ball_on2 = ball1[vBallDraw2][hBallDraw2];
		else if(ball_action2 <= 17)
			ball_on2 = ball2[vBallDraw2][hBallDraw2];
		else
			ball_on2 = ball0[vBallDraw2][hBallDraw2];
	end
	else
		ball_on2 = 4'b0;
end
		 
    always_comb
    begin:RGB_Display
			if(cloud_on1 == 4'b0110)
			begin
				Red <=   8'hBD;
				Green <= 8'hBD;
				Blue  <= 8'hBD;	
			end
			
			else if(cloud_on1 == 4'b0100)
			begin
				Red <= 8'hFF;
				Green <=  8'hFF;
				Blue <=  8'hFF;
			end
			
			else if(cloud_on1 == 4'b0111)
			begin
				Red <=   8'hE7;
				Green <= 8'hE7;
				Blue  <= 8'hE7;
			end
			else if(cloud_on2 == 4'b0110)
			begin
				Red <=   8'hBD;
				Green <= 8'hBD;
				Blue  <= 8'hBD;	
			end
			
			else if(cloud_on2 == 4'b0100)
			begin
				Red <= 8'hFF;
				Green <=  8'hFF;
				Blue <=  8'hFF;
			end
			
			else if(cloud_on2 == 4'b0111)
			begin
				Red <=   8'hE7;
				Green <= 8'hE7;
				Blue  <= 8'hE7;
			end
			else if(hp1_on == 1||hp2_on == 1)
			begin
				Red <= 8'hFF;
				Green <=  8'h00;
				Blue <=  8'h00;
			end
			else if(ball_on1 == 4'b0001)
			begin
				Red<=8'hff;
				Green<=8'hff;
				Blue<=8'hff;
			end
			else if(ball_on1 == 4'b0010)
			begin
				Red<=8'ha6;
				Green<=8'h08;
				Blue<=8'h00;
			end
			else if(ball_on1 == 4'b0011)
			begin
				Red<=8'hff;
				Green<=8'he2;
				Blue<=8'h00;
			end
			else if(ball_on2 == 4'b0001)
			begin
				Red<=8'hff;
				Green<=8'hff;
				Blue<=8'hff;
			end
			else if(ball_on2 == 4'b0010)
			begin
				Red<=8'hb1;
				Green<=8'h9c;
				Blue<=8'hd9;
			end
			else if(ball_on2 == 4'b0011)
			begin
				Red<=8'h6c;
				Green<=8'h00;
				Blue<=8'h6c;
			end
			else if(ground_on == 1)
			begin
				Red <= 8'h66;
            Green <= 8'h33;
            Blue <= 8'h00;
			end
			else if(player_on1==4'b1 && ending1 == 1)
			begin
				Red <= 8'hdc;
				Green <= 8'h14;
				Blue <= 8'h3c;
			end
			else if(player_on2==4'b1 && ending2 == 1)
			begin
				Red <= 8'h00;
				Green <= 8'h00;
				Blue <= 8'h84;
			end
		  else 
        begin 
			   Red = 8'h0;
            Green = 8'hBF;
            Blue = 8'hFF; 
        end 
	 end
    
endmodule