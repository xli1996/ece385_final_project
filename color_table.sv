module color_table(input int color,
							input logic [9:0] DrawX,
						 output logic [7:0]  R, G, B);

	logic [7:0] Red, Green, Blue;
						 
	always_comb
	begin
	unique case (color)
			0:	begin //background
				Red = 8'h00;
            Green = 8'hff - DrawX[9:3];
            Blue = 8'ha0 + DrawX[9:3]; 
			end
			1: begin //black
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
			2: begin //pink
				Red = 8'hff;
				Green = 8'hae;
				Blue = 8'hc9;
						end
			3: begin //grey
				Red = 8'h4a;
				Green = 8'h4a;
				Blue = 8'h4a;
				endcase
	end
	assign R = Red;
	assign G = Green;
	assign B = Blue;
endmodule