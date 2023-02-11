`timescale 1ns/1ps
module MODULE_SELECT21_1 (
    input [3:0] select_signal,
    input [18:0] addr1,
    input [18:0] addr2,
    output [18:0] addr
);
assign addr=(select_signal>=4'b0111)?addr1:addr2;

endmodule //MODULE_SELECT21_1