`timescale 1ns/1ps

 module MODULE_KB_CONTROL(input clk,input data,input rst,output [7:0] hex,
 output reg keyup);

 reg [21:0] shift;

 assign hex[7:0]=shift[19:12];
 

 always@(negedge clk)
 begin
   if(!rst)
    begin
        shift<=22'b0;
        end
   else
    shift<={data,shift[21:1]};

 end

always @(posedge clk) 
begin
    if(shift[8:1] == 8'hF0) begin
        keyup <= 1'b1;
    end
    else begin
        keyup <= 1'b0;
    end    
end
 
 endmodule