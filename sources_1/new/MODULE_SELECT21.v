`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/01 12:25:40
// Design Name: 
// Module Name: MODULE_SELECT21
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


module MODULE_SELECT21(
    input [3:0] select_signal,
    input [2:0] title_color,
    input [11:0] camera_color,
    input clk,
    output [11:0] vga_color
    );
    reg [11:0] tmp=0;
    assign vga_color=tmp;
    always @(posedge clk) 
    begin
        if(select_signal!=4'b0000)
            tmp=camera_color;
        else
            tmp={{(9){title_color[2]}},title_color};
    end

endmodule
