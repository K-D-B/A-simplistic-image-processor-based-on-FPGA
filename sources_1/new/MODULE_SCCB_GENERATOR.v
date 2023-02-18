`timescale 1ns/1ps
module MODULE_SCCB_GENERATOR (
    input camera_clk,
    input rst,
    inout siod,
    output reg sioc,
    output next_reg,
    input reg_not_done,
    input [7:0] device_addr,reg_addr,value
    
);
reg[15:0]cnt=0;
reg flag;

always @(posedge camera_clk)
    if(!cnt)
        cnt<=reg_not_done;
    else
    begin
        if(cnt[15:11]==5'b11111)
            cnt<=0;
        else
            cnt<=cnt+1;
    end
assign next_reg=!cnt&&reg_not_done;

always @(posedge camera_clk)
case(cnt[15:11])
    5'b00000,5'b11110,5'b11111:sioc<=1;
    5'b00001:
    begin
        if(cnt[10:9]==2'b11)
            sioc<=0;
        else
            sioc<=1;
    end
    5'b11101:
    begin
        if(cnt[10:9]==2'b00)
            sioc<=0;
        else
            sioc<=1;
    end
    default:
    begin
        if(cnt[10:9]==2'b01||cnt[10:9]==2'b10)
            sioc<=1;
        else
            sioc<=0;
    end
endcase

always @(posedge camera_clk)
case(cnt[15:11])
    5'b01010,5'b10011,5'b11100:flag<=0;
    default:flag<=1;
endcase
reg[31:0]tmp;
reg now=0;
always @(posedge camera_clk)
begin
    if(!cnt&&reg_not_done)
    begin
        tmp<={2'b10,device_addr,1'bx,reg_addr,1'bx,value,1'bx,3'b011};
    end
    else
    begin
        now<=tmp[31-cnt[15:11]];
    end
end
assign siod=flag?now:1'bz;

endmodule //MODULE_SCCB_GENERATOR