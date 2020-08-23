typedef struct packed{
    bit [1:0] 		speed_x;
    bit [1:0]		speed_y;
}init_speed;

typedef	struct packed{
    logic 		h_sync;
    logic		v_sync;
    logic 		video_on;
}sync_data;


typedef struct packed{
	logic [9:0] pos_x;
	logic [9:0] pos_y;
}pos_data;



interface pong_intf(

    input init_speed    start_speed,
    output  sync_data    sync_signal
    );
   

    
    pos_data        ball;
    pos_data        pad; 


    pos_data        pixel;

    modport game_control (input start_speed , output ball , output pad);

    modport vga_sync(output sync_signal , output pixel);

    modport vga_rgb(input pixel, input ball, input pad); 

endinterface
