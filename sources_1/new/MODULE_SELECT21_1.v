`timescale 1ns/1ps
module MODULE_SELECT21_1 (
    input [3:0] select_signal,
    input is_deal_done,
    input [18:0] addr1,
    input [18:0] addr2,
    output [18:0] addr
);
assign addr=(select_signal>=4'b1000&&is_deal_done==0)?addr2:addr1;

endmodule //MODULE_SELECT21_1