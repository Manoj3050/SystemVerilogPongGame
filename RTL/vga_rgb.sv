`timescale 1ns/1ps
//typedef struct packed{
//	logic	[9:0] 	pos_x;
//	logic	[9:0]	pos_y;
//} pos_data;

module vga_rgb(
	pong_intf intf,
    	
	output reg [11:0] BGR
	);
	always@* begin

		if(intf.pixel.pos_x >= intf.ball.pos_x &  intf.pixel.pos_x < intf.ball.pos_x + 10'd8 & intf.pixel.pos_y >= intf.ball.pos_y & intf.pixel.pos_y < intf.ball.pos_y+10'd8)
			BGR         = 12'b1111000000;
		else begin 
			//draw area before pad
			if(intf.pixel.pos_x < 10'd28) begin
				if(intf.pixel.pos_y < 10'd8 || intf.pixel.pos_y > 10'd470) // draw wall
					BGR = 12'b000000001111;
				else 
					BGR = 12'b000000000000; //draw elsewhere
			end
			//area includeing pad
			else if(intf.pixel.pos_x >= 10'd28 & intf.pixel.pos_x < 10'd36)begin
				if(intf.pixel.pos_y < 10'd8 || intf.pixel.pos_y > 10'd470)
					BGR = 12'b000000001111; // draw wall
				else if(intf.pixel.pos_y >= 10'd8 & (intf.pixel.pos_y >= intf.pad.pos_y & intf.pixel.pos_y < intf.pad.pos_y+ 10'd64))
					BGR = 12'b111111111111; // draw pad
				else
					BGR = 12'b000000000000; // draw else where
			end
			else if(intf.pixel.pos_x >= 10'd36 & intf.pixel.pos_x < 10'd631) // draw wall
				if(intf.pixel.pos_y < 10'd8 || intf.pixel.pos_y > 10'd470)
					BGR = 12'b000000001111; // draw wall
				else
					BGR = 12'b000000000000;
			else
				BGR     = 12'b000000001111;
			
		end	 
    end


endmodule

