`timescale 1ns/1ps
module MODULE_SELECT21_2 (
    input [3:0] select_signal,
    input [11:0] write2ram1,
    input [11:0] write2ram2,
    output [11:0] write2ram
);
assign write2ram=(select_signal>=4'b1000)?write2ram2:write2ram1;

endmodule //MODULE_SELECT21_2