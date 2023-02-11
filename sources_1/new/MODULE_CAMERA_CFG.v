`timescale 1ns/1ps
module MODULE_CAMERA_CFG(
    input camera_clk,
    input rst,
    output sioc,
    output siod,
    output camera_reset,//specically for camera, its value is always 1.
    output pwdn, // whether we need to save energy
    output xclk

);
localparam device_addr=8'h60; 
assign camera_reset=1'b1; // const value
assign pwdn=1'b0;// no need to boot energy-save mode
assign xclk=camera_clk;
pullup up(siod); //pullup the

wire [15:0] register_setting;
wire reg_not_done;
wire next_reg;

MODULE_CAMERA_REG_ROM module_camera_reg_rom(camera_clk,rst,register_setting,reg_not_done,next_reg);
MODULE_SCCB_GENERATOR module_sccb_generator(camera_clk,rst,siod,sioc,next_reg,reg_not_done,device_addr,register_setting[15:8],register_setting[7:0]);

endmodule