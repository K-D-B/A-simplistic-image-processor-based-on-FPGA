`timescale 1ns/1ps
module MODULE_VGA_DISPLAY(
           input vga_clk,
           input rst,
           output [18:0] pic_addr,
           output hs,
           output vs,
           input [11:0] vga_color,
           output [3:0] vga_color_red,
           output [3:0]vga_color_blue,
           output [3:0]vga_color_green
       );

parameter       C_H_SYNC_PULSE      =   96  ,
                C_H_BACK_PORCH      =   48  ,
                C_H_ACTIVE_TIME     =   640 ,
                C_H_FRONT_PORCH     =   16  ,
                C_H_LINE_PERIOD     =   800 ;

parameter       C_V_SYNC_PULSE      =   2   ,
                C_V_BACK_PORCH      =   33  ,
                C_V_ACTIVE_TIME     =   480 ,
                C_V_FRONT_PORCH     =   10  ,
                C_V_FRAME_PERIOD    =   525 ;
reg [11:0]hs_cnt;
reg [11:0]vs_cnt;
wire active;
assign active=(hs_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
       (hs_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  &&
       (vs_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
       (vs_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ;

always @(posedge vga_clk or posedge rst)
begin
    if(!rst)
        hs_cnt<=12'd0;
    else if(hs_cnt==C_H_LINE_PERIOD-1'b1)
        hs_cnt<=12'd0;
    else
        hs_cnt<=hs_cnt+1'd1;
end

assign hs=hs_cnt<C_H_SYNC_PULSE?1'b0:1'b1;

always @(posedge vga_clk or posedge rst)
begin
    if(!rst)
        vs_cnt<=12'd0;
    else if(vs_cnt==C_V_FRAME_PERIOD-1'b1)
        vs_cnt<=12'd0;
    else if(hs_cnt==C_H_LINE_PERIOD-1'b1)
        vs_cnt<=vs_cnt+1'd1;
    else
        vs_cnt<=vs_cnt;
end
assign vs=vs_cnt<C_V_SYNC_PULSE?1'b0:1'b1;

assign vga_color_red=rst==1'b1&&active?vga_color[11:8]:4'b0;
assign vga_color_green=rst==1'b1&&active?vga_color[7:4]:4'b0;
assign vga_color_blue=rst==1'b1&&active?vga_color[3:0]:4'b0;
assign pic_addr=rst==1'b1&&active?(hs_cnt-C_H_SYNC_PULSE - C_H_BACK_PORCH+1'b1)
       +(vs_cnt-C_V_SYNC_PULSE - C_V_BACK_PORCH)*640:19'b0;

endmodule