`timescale 1ns/1ps

//typedef struct packed{
//	logic [9:0] pos_x;
//	logic [9:0] pos_y;
//}pos_data;
//
//typedef	struct packed{
//	logic 		h_sync;
//	logic		v_sync;
//	logic 		video_on;
//}sync_data;

module vga_sync(
	input clk_i,
	input rst_i,
	output reg 			pix_clk,
    pong_intf           intf
	);

		
	parameter HA = 640;
	parameter HF = 16;
	parameter HS = 96;
	parameter HB = 48;
	
	parameter VA = 480;
	parameter VF = 11;
	parameter VS = 2;
	parameter VB = 32;
	
	
	always_ff@(posedge clk_i or posedge rst_i) begin
		if(rst_i) begin
			pix_clk 		<=#1 1'b0;
		end
		else begin
			pix_clk 		<=#1 ~pix_clk;
		end	
	end
	
	always_ff@(posedge clk_i) begin
		if(rst_i) begin
			intf.pixel.pos_x			<=#1 10'd0;
		end
		else begin
			if(pix_clk)
				if(intf.pixel.pos_x >= HA+HF+HS+HB-1)
					intf.pixel.pos_x 	<=#1 10'd0;
				else	
					intf.pixel.pos_x 	<=#1 intf.pixel.pos_x + 10'd1;
			else	
				intf.pixel.pos_x		 	<=#1 intf.pixel.pos_x;
		end
	end
	
	always_ff@(posedge clk_i) begin
		if(rst_i) begin
			intf.pixel.pos_y				<=#1 10'd0;
		end
		else begin
			if(pix_clk && intf.pixel.pos_x >= HA+HF+HS+HB-1)
				if(intf.pixel.pos_y >= VA+VF+VS+VB-1)
					intf.pixel.pos_y 	<=#1 10'd0;
				else	
					intf.pixel.pos_y 	<=#1 intf.pixel.pos_y + 10'd1;
			else	
				intf.pixel.pos_y		 	<=#1 intf.pixel.pos_y;
		end
	end
	
	always_comb begin
		if((intf.pixel.pos_x < HA+HF) || (intf.pixel.pos_x > HA+HF+HS-1))
			intf.sync_signal.h_sync = 1'b1;
		else
			intf.sync_signal.h_sync = 1'b0;
	end
	
	always_comb begin
		if((intf.pixel.pos_y < VA+VF) || (intf.pixel.pos_y > VA+VF+VS-1))
			intf.sync_signal.v_sync = 1'b1;
		else
			intf.sync_signal.v_sync = 1'b0;
	end
	always_comb begin
		intf.sync_signal.video_on 	= (intf.pixel.pos_x < HA) && (intf.pixel.pos_y <VA);
	end


endmodule
