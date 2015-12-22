module cloud(
	input Reset, frame_clk,
	output[9:0] cloudX1, cloudY1,cloudX2, cloudY2, cloudW, cloudH
	
);

logic [9:0] cloud_X_Pos1, cloud_X_Pos2, cloud_X_Motion1, cloud_X_Motion2, cloud_Y_Pos1, cloud_Y_Pos2, cloud_Y_Motion, cloud_Width, cloud_Height;
parameter [9:0] cloud_Y_Center=20;  // Center position on the Y axis
parameter [9:0] cloud_X_Center=20;  // Center position on the Y axis
parameter [9:0] cloud_X_Min=0;       // Leftmost point on the X axis
parameter [9:0] cloud_X_Max=639;     // Rightmost point on the X axis
parameter [9:0] cloud_Y_Min=0;       // Topmost point on the Y axis
parameter [9:0] cloud_Y_Max=479;     // Bottommost point on the Y axis
 
parameter [9:0] cloud_X_Step=1;      // Step size on the X axis
parameter [9:0] cloud_Y_Step=0;      // Step size on the Y axis
assign cloud_Width = 80;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
assign cloud_Height = 40; 

always_ff @ (posedge Reset or posedge frame_clk )
	begin: Move_cloud
        if (Reset)  // Asynchronous Reset
			begin 
            cloud_Y_Motion <= 10'd0; //cloud_Y_Step;
				cloud_X_Motion1 <= 10'd0; //cloud_X_Step;
				cloud_Y_Pos1 <= cloud_Y_Center;
				cloud_X_Pos1 <= cloud_X_Center;
				cloud_Y_Pos2 <= cloud_Y_Center;
				cloud_X_Pos2 <= cloud_X_Center+200;					
			end
			else
				begin
				if (cloud_X_Pos1 >=700 )
						begin
							cloud_X_Motion1 <= cloud_X_Step;
							cloud_X_Pos1 <= 0;
						end
				else if(cloud_X_Pos2 <= 0)
					begin
							cloud_X_Motion1 <= 0;
							cloud_X_Motion2 <= -cloud_X_Step;
							cloud_X_Pos2 <= 700;
					end					
				else 
				begin
				 cloud_X_Motion1 <= cloud_X_Step;
				 cloud_X_Motion2 <= -cloud_X_Step;
				 cloud_Y_Motion <= 0;
				end
			
			 cloud_Y_Pos1 <= (cloud_Y_Pos1 + cloud_Y_Motion);  // Update cloud position
			 cloud_X_Pos1 <= (cloud_X_Pos1 + cloud_X_Motion1);	
			 cloud_Y_Pos2 <= (cloud_Y_Pos2 + cloud_Y_Motion);  // Update cloud position
			 cloud_X_Pos2 <= (cloud_X_Pos2 + cloud_X_Motion2);
		end
	
			
    end
       
    assign cloudX1 = cloud_X_Pos1;  
    assign cloudY1 = cloud_Y_Pos1;
    assign cloudX2 = cloud_X_Pos2;  
    assign cloudY2 = cloud_Y_Pos2;
    assign cloudW = cloud_Width;
	 assign cloudH = cloud_Height;
endmodule
	