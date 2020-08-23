`timescale 1ns/1ps

//typedef struct packed{
//	bit [1:0] 		speed_x;
//	bit [1:0]		speed_y;
//}init_speed;
//
//typedef struct packed{
//	logic 	[9:0] 	pos_x;
//	logic 	[9:0] 	pos_y;
//} pos_data;

typedef struct packed{
	reg 	signed [9:0] s_x;
	reg 	signed [9:0] s_y;
}speed_data;
	typedef enum bit {INIT=1'b0,TO_WALL=1'b1} state_param;	
module game_control(
    input                           clk_frame_i,
    input                           rst_i,
    input               [1:0]       btn_i,
    input                           start_i,


    pong_intf                       intf   

    );

    
	speed_data 						ball_speed;	
	state_param 					st;


	reg 							state;
	reg		[7:0]					pad_portion;
    
    always@(posedge clk_frame_i) begin
		if(rst_i) begin
			ball_speed		<= {10'd0,10'd0};
			intf.ball		<= {10'd36,10'd8};
			state			<= INIT; 
		end
		else begin
        	case (state)
        	    INIT : begin
        	        ball_speed	<= {{8'd0,intf.start_speed.speed_x},{8'd0,intf.start_speed.speed_y}};
					intf.ball		<= {10'd36,10'd8};
        	        if(start_i)
        	            state   <= TO_WALL;
        	        else
        	            state   <= INIT;
        	    end
        	    TO_WALL : begin
        	        //////////////////////////X DIRECTION CONTROL////////////////////////////
        	        if(intf.ball.pos_x < 10'd623 && intf.ball.pos_x >= intf.pad.pos_x+ 10'd8) //631-8    
        	            intf.ball.pos_x      		<= intf.ball.pos_x + ball_speed.s_x;

        	        else if(intf.ball.pos_x < intf.pad.pos_x + 10'd8) begin
        	            case(pad_portion)
        	                8'b00000001 : begin 
        	                    ball_speed.s_x 	<= -ball_speed.s_x;
        	                end
        	                8'b00000010 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd1;
        	                end
        	                8'b00000100 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd2;
        	                end
        	                8'b00001000 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd3;
        	                end
        	                8'b00010000 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd3;
        	                end
        	                8'b00100000 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd2;
        	                end
        	                8'b01000000 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd1;
        	                end
        	                8'b10000000 : begin
        	                    ball_speed.s_x 	<= -ball_speed.s_x + 4'd0;
        	                end
        	                8'd0 : begin
        	                    ball_speed.s_x 	<= ball_speed.s_x;
								state			<= INIT;
        	                end
        	            endcase
        	            intf.ball.pos_x     			<= intf.ball.pos_x -ball_speed.s_x; 
        	        end
        	        else begin
        	            intf.ball.pos_x     			<= intf.ball.pos_x - ball_speed.s_x;
        	            ball_speed.s_x         	<= (-1)*ball_speed.s_x;
        	        end


        	        ///////////////////// Y DIRECTION CONTROL /////////////////////

        	        if(intf.ball.pos_x >= intf.pad.pos_x + 10'd8) begin
        	            if(intf.ball.pos_y < 10'd463 && intf.ball.pos_y >=10'd7)
        	                intf.ball.pos_y      <= intf.ball.pos_y + ball_speed.s_y;
        	            else if(intf.ball.pos_y < 10'd7) begin
        	                intf.ball.pos_y      	<= intf.ball.pos_y - ball_speed.s_y;
        	                ball_speed.s_y      <= (-1)*ball_speed.s_y;
        	            end
        	            else begin
        	                intf.ball.pos_y      	<= intf.ball.pos_y - ball_speed.s_y;
        	                ball_speed.s_y      <= (-1)*ball_speed.s_y;
        	            end
        	        end
        	        else begin
        	            case(pad_portion)
        	                8'b00000001 : begin 
        	                    ball_speed.s_y 	<= ball_speed.s_y + 4'd3;
        	                end
        	                8'b00000010 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y + 4'd2;
        	                end
        	                8'b00000100 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y + 4'd1;
        	                end
        	                8'b00001000 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y;
        	                end
        	                8'b00010000 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y;
        	                end
        	                8'b00100000 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y - 4'd1;
        	                end
        	                8'b01000000 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y - 4'd2;
        	                end
        	                8'b10000000 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y - 4'd3;
        	                end
        	                8'd0 : begin
        	                    ball_speed.s_y 	<= ball_speed.s_y;
        	                end
        	            endcase
        	            intf.ball.pos_y      		<= intf.ball.pos_y + ball_speed.s_y;
        	        end
        	    end

        	endcase
		end

    end    
    always@(posedge clk_frame_i or posedge rst_i)begin
		if(rst_i) begin
			intf.pad			<= {10'd28,10'd207};
		end
		else begin
			if(btn_i[0]) begin
				if(intf.pad.pos_y < 10'd472)
					intf.pad.pos_y	<= intf.pad.pos_y + 10'd1;
				else
					intf.pad.pos_y 	<= intf.pad.pos_y;
			end
			else if(btn_i[1]) begin
				if(intf.pad.pos_y >= 10'd8)
					intf.pad.pos_y 	<= intf.pad.pos_y -10'd1;
				else
					intf.pad.pos_y 	<= intf.pad.pos_y;
			end
			else
					intf.pad.pos_y	<= intf.pad.pos_y;
            intf.pad.pos_x          <= 10'd28;
		end

	end
    always@(*) begin
        if(intf.ball.pos_y < intf.pad.pos_y +10'd8 & intf.ball.pos_y >= intf.pad.pos_y)
            pad_portion = 8'b00000001;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd16 & intf.ball.pos_y >= intf.pad.pos_y+10'd8)
            pad_portion = 8'b00000010;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd24 & intf.ball.pos_y >= intf.pad.pos_y+10'd16)
            pad_portion = 8'b00000100;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd32 & intf.ball.pos_y >= intf.pad.pos_y+10'd24)
            pad_portion = 8'b00001000;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd40 & intf.ball.pos_y >= intf.pad.pos_y+10'd32)
            pad_portion = 8'b00010000;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd48 & intf.ball.pos_y >= intf.pad.pos_y+10'd40)
            pad_portion = 8'b00100000;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd56 & intf.ball.pos_y >= intf.pad.pos_y+10'd48)
            pad_portion = 8'b01000000;
        else if(intf.ball.pos_y < intf.pad.pos_y +10'd64 & intf.ball.pos_y >= intf.pad.pos_y+10'd56)
            pad_portion = 8'b10000000;
        else
            pad_portion = 8'd0;
    end
    


endmodule
