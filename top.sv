//typedef struct packed{
//	    bit [1:0] 		speed_x;
//	    bit [1:0]		speed_y;
//}init_speed;
//
//typedef	struct packed{
//	logic 		h_sync;
//	logic		v_sync;
//	logic 		video_on;
//}sync_data;


module top(
    input       clk_i,
    input       rst_n_i,

    input               start_n_i,
    input   [1:0]       btn_n_i,
    input   init_speed  start_speed_n,

    output  sync_data   sync_signal,

    output  [11:0] BGR

    );


    wire w_pix_clk;

    wire w_frame_clk;

	 
	////////////////////////////Invert for Altera DE-1 Active low signals///////////////////////////
	
	
	wire rst_i;
	wire start_i;
	wire [1:0] 		btn_i;

		
	assign rst_i = ~rst_n_i;
	assign start_i = ~start_n_i;
	assign btn_i = ~btn_n_i;
	
	init_speed		start_speed;
	
	always_comb begin
		start_speed.speed_x = ~start_speed_n.speed_x;
		start_speed.speed_y = ~start_speed_n.speed_y;
	end
	
	////////////////////////////////////////////////////////////////////////////////////////////////
    

    pong_intf 
    pong_intf_uut
    (
        .*
    );

    game_control
    ctrl
    (
        .clk_frame_i     (w_frame_clk),
        .*,
        .intf           (pong_intf_uut.game_control)
    );
    
    vga_sync
    vga_sync_uut
    (
        .*,
        .pix_clk        (w_pix_clk),
        .intf           (pong_intf_uut.vga_sync)
    );


    vga_rgb
    vga_rgb_uut
    (
        .intf           (pong_intf_uut.vga_rgb),
        .*

    
    );
	 assign w_frame_clk = (pong_intf_uut.pixel.pos_x == 10'd0) && (pong_intf_uut.pixel.pos_y == 10'd0) ? 1'b1 : 1'b0;

endmodule
