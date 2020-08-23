`timescale 1ns/1ps
typedef struct packed{
	bit [1:0] 		speed_x;
	bit [1:0]		speed_y;
}init_speed;

typedef struct packed{
	reg 	[9:0] 	pos_x;
	reg 	[9:0] 	pos_y;
} pos_data;


module tb_game_ctrl();
	reg 		clk_frame_i;
	reg 		rst_i;
	reg [1:0]	btn_i;
	reg 		start_i;

	init_speed	start_speed;
	pos_data	ball;
	pos_data	pad;
	

	game_control
	uut
	(
		.clk_frame_i	(clk_frame_i),
		.rst_i			(rst_i),
		.btn_i			(btn_i),
		.start_i		(start_i),
		.start_speed	(start_speed),
		.ball 			(ball),
		.pad 			(pad)
		
	);
	

integer f;
integer i;
	initial begin
		f= $fopen("data_out","w");
		clk_frame_i = 0;
		rst_i 		= 1;
		btn_i 		= 0;
		start_i		= 0;
		start_speed.speed_x 	= 1;
		start_speed.speed_y		= 1;
		
		@(posedge clk_frame_i);
		@(posedge clk_frame_i);
		rst_i 		= 0;
		@(posedge clk_frame_i);
		@(posedge clk_frame_i);
		@(posedge clk_frame_i);
		@(posedge clk_frame_i);
		start_i = 1;
		for(i=0;i<1000;i=i+1) begin
			@(posedge clk_frame_i) $fdisplay(f,"%d %d\n",ball.pos_x,ball.pos_y);
		end
		$fclose(f);
		$finish();
 
	

	end
	always #5 clk_frame_i = ~clk_frame_i;

endmodule
