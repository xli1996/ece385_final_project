//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  //output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  output [7:0] LEDG,
							  
							  // VGA Interface 
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
    logic Reset_h, Reset_s, vssig, Clk;
	 logic face1, face2, ending1, ending2;
	 logic ball_face1, ball_face2;
    logic [9:0] drawxsig, drawysig;
	 logic [15:0] keycode0, keycode1, keycode2;
	 logic [0:39][0:79][0:3] cloud;
	 logic [0:30][0:39][0:3] ball0, ball1, ball2;
	 logic [0:79][0:79][0:3] player_w0, player_w1, player_w2, player_w3, player_j0, player_j1, player_j2, player_a0, player_a1, player_a2, player_a3, player_a4, player_a5;
	 logic [9:0] cloudX1, cloudY1, cloudX2, cloudY2, cloudW, cloudH, hp1_w, hp1_x, hp1_y, hp1_h, hp2_w, hp2_x, hp2_y, hp2_h, player_x1, player_y1, player_x2, player_y2,
					ball_x1, ball_y1, ball_x2, ball_y2, ball_h, ball_w;
	 logic summoned_ball1, summoned_ball2;
	 logic summon_ball1, summon_ball2;
	 logic [8:0] player_action1, player_action2, ball_action1, ball_action2;
	 logic [3:0] hit1, hit2;
	 logic [9:0] player_hp1, player_hp2;
	 logic [9:0] player_dmg1, player_dmg2;
	
	 assign Clk = CLOCK_50;
    assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low
	 assign {Reset_s} = ~(KEY[1]);
	 assign LEDG[0] = ~summoned_ball1;
	 assign LEDG[1] = summon_ball1;
	
	 
	 wire [1:0] hpi_addr;
	 wire [31:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_clk_clk(DRAM_CLK),
										 .keycode0_export(keycode0),
										 .keycode1_export(keycode1),
										 .keycode2_export(keycode2), 
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w));
	
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(
	 .Clk,
	 .Reset(Reset_h | Reset_s),
	 .hs(VGA_HS),
	 .vs(VGA_VS),        // Vertical sync pulse.  Active low
	 .pixel_clk(VGA_CLK), // 25 MHz pixel clock output
	 .blank(VGA_BLANK_N),     // Blanking interval indicator.  Active low.
	 .sync(VGA_SYNC_N),      // Composite Sync signal.  Active low.  We don't use it in this lab,
												           
	 .DrawX(drawxsig),     // horizontal coordinate
	 .DrawY(drawysig) );
	 
	 sprite_table s1(
	 .clk(Clk),
	 .cloud(cloud),
	 .player_w0(player_w0),
	 .player_w1(player_w1),
	 .player_w2(player_w2),
	 .player_w3(player_w3),
	 .player_j0(player_j0),
	 .player_j1(player_j1),
	 .player_j2(player_j2),
	 .player_a0(player_a0),
	 .player_a1(player_a1),
	 .player_a2(player_a2),
	 .player_a3(player_a3),
	 .player_a4(player_a4),
	 .player_a5(player_a5),
	 .ball0(ball0),
	 .ball1(ball1),
	 .ball2(ball2)
	 );
	 
	 cloud c1 (
	 .Reset(Reset_h | Reset_s),
	 .frame_clk(VGA_VS),
	 .cloudX1(cloudX1),
	 .cloudY1(cloudY1),
	 .cloudX2(cloudX2),
	 .cloudY2(cloudY2),
	 .cloudW(cloudW),
	 .cloudH(cloudH)
	 );
	 
	 hp hp1(
	 .player_hp1(player_hp1),
	 .player_hp2(player_hp2),
	 .hp1_x(hp1_x),
	 .hp1_y(hp1_y),
	 .hp1_h(hp1_h),
	 .hp1_w(hp1_w),
	 .hp2_x(hp2_x),
	 .hp2_y(hp2_y),
	 .hp2_h(hp2_h),
	 .hp2_w(hp2_w),
	 .ending1(ending1),
	 .ending2(ending2)
	 );
	 
	 player1 p1(
	 .Reset(Reset_h | Reset_s),
	 .frame_clk(VGA_VS),
	 .keycode0(keycode0),
	 .keycode1(keycode1),
	 .keycode2(keycode2),
	 .damage(player_dmg1),
	 .combo(hit2),
	 .ball_ready(~summoned_ball1),
	 .player_hp(player_hp1),
	 .player_x(player_x1),
	 .player_y(player_y1),
	 .face(face1),
	 .summon_ball(summon_ball1),
	 .action(player_action1),
	 .ending(ending1 && ending2)	 
	 );
	 
	 player2 p2(
	 .Reset(Reset_h | Reset_s),
	 .frame_clk(VGA_VS),
	 .keycode0(keycode0),
	 .keycode1(keycode1),
	 .keycode2(keycode2),
	 .damage(player_dmg2),
	 .combo(hit1),
	 .ball_ready(~summoned_ball2),
	 .player_hp(player_hp2),
	 .player_x(player_x2),
	 .player_y(player_y2),
	 .face(face2),
	 .summon_ball(summon_ball2),
	 .action(player_action2),
	 .ending(ending1 && ending2)
	 );
	 
	 player_ball1 player_ball1 (
	 .Reset(Reset_h | Reset_s),
	 .frame_clk(VGA_VS),	 
	 .player_x(player_x1),
	 .player_y(player_y1),
	 .face(face1),
	 .summon_ball(summon_ball1),
	 .ball_face(ball_face1),
	 .summoned_ball(summoned_ball1),
	 .ball_x(ball_x1),
	 .ball_y(ball_y1),
	 .ball_action(ball_action1)
	 );
	 
	 player_ball2 player_ball2 (
	 .Reset(Reset_h | Reset_s),
	 .frame_clk(VGA_VS),	 
	 .player_x(player_x2),
	 .player_y(player_y2),
	 .face(face2),
	 .summon_ball(summon_ball2),
	 .ball_face(ball_face2),
	 .summoned_ball(summoned_ball2),
	 .ball_x(ball_x2),
	 .ball_y(ball_y2),
	 .ball_action(ball_action2)
	 );
	 
	 color_mapper color_mapper (
	 .cloud(cloud),
	 .player_w0(player_w0),
	 .player_w1(player_w1),
	 .player_w2(player_w2),
	 .player_w3(player_w3),
	 .player_j0(player_j0),
	 .player_j1(player_j1),
	 .player_j2(player_j2),
	 .player_a0(player_a0),
	 .player_a1(player_a1),
	 .player_a2(player_a2),
	 .player_a3(player_a3),
	 .player_a4(player_a4),
	 .player_a5(player_a5),
	 .ball0(ball0),
	 .ball1(ball1),
	 .ball2(ball2),
	 .cloudX1(cloudX1),
	 .cloudY1(cloudY1),
	 .cloudX2(cloudX2),
	 .cloudY2(cloudY2),
	 .cloudH(cloudH),
	 .cloudW(cloudW),
	 .hp1_x(hp1_x),
	 .hp1_y(hp1_y),
	 .hp1_h(hp1_h),
	 .hp1_w(hp1_w),
	 .hp2_x(hp2_x),
	 .hp2_y(hp2_y),
	 .hp2_h(hp2_h),
	 .hp2_w(hp2_w),
	 .ending1(ending1),
	 .ending2(ending2),
	 .summoned_ball1(summoned_ball1),
	 .summoned_ball2(summoned_ball2),
	 .player_h(10'd80),
	 .player_w(10'd80),
	 .player_x1(player_x1),
	 .player_y1(player_y1),
	 .player_x2(player_x2),
	 .player_y2(player_y2),
	 .player_action1(player_action1),
	 .face1(face1),
	 .player_action2(player_action2),
	 .face2(face2),
	 .ball_face1(ball_face1),
	 .ball_face2(ball_face2),
	 .ball_x1(ball_x1),
	 .ball_y1(ball_y1),
	 .ball_x2(ball_x2),
	 .ball_y2(ball_y2),
	 .ball_h(10'd40),
	 .ball_w(10'd40),
	 .ball_action1(ball_action1),
	 .ball_action2(ball_action2),
	 .DrawX(drawxsig),
	 .DrawY(drawysig),
    .Red(VGA_R),
	 .Green(VGA_G),
	 .Blue(VGA_B)
	 );
	 
	 damage_handler damage_handler (
	  .clk(VGA_VS),
	  .reset(Reset_h | Reset_s),
	  .face1(face1),
	  .face2(face2),
	  .player_x1(player_x1),
	  .player_x2(player_x2),
	  .player_y1(player_y1),
	  .player_y2(player_y2),
	  .action1(player_action1),
	  .action2(player_action2),
	  .summoned_ball1(summoned_ball1),
	  .summoned_ball2(summoned_ball2),
	  .ball_face1(ball_face1),
	  .ball_face2(ball_face2),
	  .ball_x1(ball_x1),
	  .ball_x2(ball_x2),
	  .ball_y1(ball_y1),
	  .ball_y2(ball_y2),
	  .hit1(hit1),
	  .hit2(hit2),
	  .player_dmg1(player_dmg1),
	  .player_dmg2(player_dmg2)
	 );
	 
/*
	 HexDriver hex_inst_0 (keycode0[3:0], HEX0);
	 HexDriver hex_inst_1 (keycode0[7:4], HEX1);
	 HexDriver hex_inst_2 (keycode0[11:8], HEX2);
	 HexDriver hex_inst_3 (keycode0[15:12], HEX3);
	 HexDriver hex_inst_4 (keycode1[3:0], HEX4);
	 HexDriver hex_inst_5 (keycode1[7:4], HEX5);
	 HexDriver hex_inst_6 (keycode1[11:8], HEX6);
	 HexDriver hex_inst_7 (keycode1[15:12], HEX7);
	 */
endmodule
