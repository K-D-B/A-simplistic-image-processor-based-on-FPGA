`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/01 03:27:37
// Design Name: 
// Module Name: MODULE_MIP_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MODULE_MIP_TOP(
    input clk,
    
    //keyboard setting
    input kb_clk,
    input kb_bit_data,
    input rst,
    
    //digital tube 
    output [6:0]display7_data,
    
    //VGA
    output [3:0] vga_color_red,
    output [3:0] vga_color_green,
    output [3:0] vga_color_blue,
    output vga_hs,
    output vga_vs,

    //camera
    input pclk,
    input href,
    input  vsyn,
    input [7:0] camera_data,
    output sioc,
    inout siod,
    output camera_reset,
    output pwdn,
    output xclk

    
    );
wire [7:0] kb_data; 
wire kb_up;
//wire pic_select;
wire [2:0] state_info;
wire [2:0] state_order;
wire [11:0] vga_color;
wire [18:0] picture_addr;// wire between VGA and processor core
wire vga_clk;
wire camera_cfg_clk;

wire [2:0] title_color;
wire [11:0] camera_color_read;
wire [18:0] store_addr;
wire [11:0] camera_color_write;
wire [11:0] final_color;
wire pause;

wire [11:0] read_from_aux;

wire [11:0] write2ram;
wire [11:0] static_dealed_pixel;

wire [18:0] final_write2ram_addr;
wire [18:0] deal_write2ram_addr;

wire wren;
MODULE_SELECT21_1 module_select21_1_inst1(.select_signal(state_info),.addr1(store_addr),.addr2(deal_write2ram_addr),.addr(final_write2ram_addr));

wire [18:0] deal_read_ram_addr;
wire [18:0] final_read_ram_addr;
MODULE_SELECT21_1 module_select21_1_inst2(.select_signal(state_info),.addr1(picture_addr),.addr2(deal_read_ram_addr),.addr(final_read_ram_addr));

MODULE_KB_CONTROL module_kb_control(.clk(kb_clk),.data(kb_bit_data),.rst(rst),.hex(kb_data),.keyup(kb_up));
MODULE_CONTROLLER module_controller(.clk(clk),.rst(rst),.kb_up(kb_up),.kb_data(kb_data),.pic_select(pic_select),.state_info(state_info),.state_order(state_order),.pause(pause));
MODULE_DISPLAY7 module_display7(.iData({3'b0,state_info}),.oData(display7_data),.clk(clk));

MODULE_CLOCK_DIVIDER module_clock_divider(.clk_in1(clk),.clk_out1(vga_clk),.clk_out2(camera_cfg_clk));

MODULE_VGA_DISPLAY module_vga_display(.vga_clk(vga_clk),.rst(rst),.pic_addr(picture_addr),.vga_color(vga_color),.vga_color_red(vga_color_red),.vga_color_green(vga_color_green),.vga_color_blue(vga_color_blue),.hs(vga_hs),.vs(vga_vs));

MODULE_TITLE_ROM module_title_rom(.clka(clk),.ena(1'b1),.addra(picture_addr),.douta(title_color));

MODULE_SELECT21 module_select21(.select_signal(state_info),.title_color(title_color),.camera_color(final_color),.clk(clk),.vga_color(vga_color));



MODULE_CAMERA_CFG module_camera_cfg(.camera_clk(camera_cfg_clk),.rst(rst),.sioc(sioc),.siod(siod),.camera_reset(camera_reset),.pwdn(pwdn),.xclk(xclk));

MODULE_CAMERA_DATA_RAM module_camera_data_ram(.clka(clk),.ena(!pause),.wea(wren),.addra(store_addr),.dina(camera_color_write),.clkb(clk),.enb(1'b1),.addrb(picture_addr),.doutb(camera_color_read));


MODULE_CAMERA_CAPTURER module_camera_capturer(.pclk(pclk),.href(href),.vsyn(vsyn),.rst(rst),.camera_data(camera_data),.wren(wren),.camera_color_write(camera_color_write),.store_addr(store_addr));

MODULE_PROCESSOR_CORE module_processor_core(.clk(clk),.state_info(state_info),.picture_addr(picture_addr),.raw_color(camera_color_read),.ripe_color(final_color));
endmodule
