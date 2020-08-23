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

module tb_vga_sync();
	reg clk_i;
	reg rst_i;
	sync_data			sync;
	
	wire	 			pix_clk;
	pos_data			pixel;


	/////////////////////////////////////////////////////////////////////////////////////
	//////////////////////// Check HSYNC signal/////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////	
	property h_sync_high;
		@( posedge pix_clk) disable iff(rst_i)
		 ((pixel.pos_x < 656) || (pixel.pos_x >= 752 )) |-> (sync.h_sync == 1'b1);
	endproperty : h_sync_high
	
	property h_sync_low;
		@(posedge pix_clk) disable iff(rst_i)
		((pixel.pos_x>=656) && (pixel.pos_x <752)) |-> (sync.h_sync == 1'b0);
	endproperty : h_sync_low

	assert_h_sync_low  : assert property (h_sync_low);	
	assert_h_sync_high : assert property (h_sync_high); 

	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////// Check VSYNC Signal /////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////
	property v_sync_high;
		@( posedge pix_clk) disable iff(rst_i)
		 ((pixel.pos_y <491 ) || (pixel.pos_y >=493  )) |-> (sync.v_sync == 1'b1);
	endproperty : v_sync_high
	
	property v_sync_low;
		@(posedge pix_clk) disable iff(rst_i)
		((pixel.pos_y>= 491) && (pixel.pos_y <493)) |-> (sync.v_sync == 1'b0);
	endproperty : v_sync_low

	assert_v_sync_low  : assert property (v_sync_low);	
	assert_v_sync_high : assert property (v_sync_high); 
	
	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////// Check VideoOn Signal //////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////

	property Video_On_high;
		@( posedge pix_clk) disable iff(rst_i)
			( (pixel.pos_x < 640) && (pixel.pos_y < 480)) |-> (sync.video_on == 1'b1);
	endproperty : Video_On_high
	
	property Video_On_low;
		@( posedge pix_clk) disable iff(rst_i)
			( (pixel.pos_x >=640) && (pixel.pos_y >=480)) |-> (sync.video_on == 1'b0);
	endproperty : Video_On_low

	assert_Video_on_high : assert property (Video_On_high);
	assert_Video_on_low  : assert property (Video_On_low); 


	cover_v_sync_low	:	cover property (v_sync_high);
	cover_v_sync_high	:	cover property (v_sync_low);
	cover_h_sync_low	:	cover property (h_sync_high);
	cover_h_sync_high	:	cover property (h_sync_low);
	cover_vid_on_high	:	cover property (Video_On_high);
	cover_vid_on_low	:	cover property (Video_On_low);

	vga_sync 
	uut
	(
		.clk_i			(clk_i),
		.rst_i			(rst_i),
		.sync			(sync),
		.pix_clk 		(pix_clk),
		.pixel			(pixel)  
	);
	
	initial begin
		clk_i = 0;
		rst_i = 1;
		@(posedge clk_i);
		@(posedge clk_i);
		rst_i = 0;
		#10000000;
		$finish();
	end

	always #5 clk_i = ~clk_i;
endmodule
