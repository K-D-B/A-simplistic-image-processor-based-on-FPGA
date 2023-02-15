`timescale 1ns / 1ps

module MODULE_PROCESS_DIVIDER(
    input I_CLK,
    input rst,
    output reg O_CLK
    );
    
    parameter cycle=2;
    
    reg [1:0] cnt=0;
    initial begin
    O_CLK=0;
    end
    always @ (posedge I_CLK)
    begin
    if(!rst==1)
    begin
    O_CLK=0;
    cnt=0;
    end
    else
    
    begin
    cnt=(cnt+1)%cycle;
    if(cnt%(cycle/2)==0)
    begin
    O_CLK=~O_CLK;
    end
    end
    
    end

endmodule
