`timescale 1ns/1ps
module MODULE_SELECT21_2 (
    input [3:0] select_signal,
    input [11:0] write2_ram1,
    input [11:0] write2_ram2,
    output [11:0] write2_ram
);
assign write2_ram=(select_signal>=4'b0111)?write2_ram1:write2_ram2;

endmodule //MODULE_SELECT21_2