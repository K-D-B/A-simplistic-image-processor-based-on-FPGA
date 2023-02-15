`timescale 1ns/1ps
module MODULE_CONTROLLER(
    input clk,
    input rst,
    input kb_up,
    input [7:0] kb_data,
    output reg pic_select,
    output reg [3:0] state_info,
    output reg pause
    );

reg [1:0] states=0;
reg [2:0] states_order=0;

always @(negedge clk) // control all signals at the negedge
begin
    if(kb_up==1'b1)
        begin
            if(states==2'b00 && kb_data==8'h16)//1
                begin
                  pic_select=1'b1;
                  states=2'b01;
                  state_info=4'b0001;
            
                end
            else if(states==2'b00 && kb_data==8'h1E)//2
                begin
                  pic_select=1'b1;
                  states=2'b01;
                  state_info=4'b0010;
                  
                end
            
            else if(states==2'b00 && kb_data==8'h26)//3
                begin
                  pic_select=1'b1;
                  states=2'b01;
                  state_info=4'b0011;
                  
                end
            else if(states==2'b00&&kb_data==8'h25) //4 
              begin
                states=2'b01;
                state_info=4'b0100;
                
              end
            else if(states==2'b00&&kb_data==8'h2E) //5
              begin
                states=2'b01;
                state_info=4'b0101;
                
              end
            else if(states==2'b00&&kb_data==8'h36) //6 //reverse effect
              begin
                states=2'b01;
                state_info=4'b0110;
                
              end
            
            else if(states==2'b01 &&kb_data==8'h4d) //p means pause , write operation to the ram is forbidden
            begin
              states=2'b10;
              state_info=4'b0111;
              
              pause=1;
            end

            else if(states==2'b10&&kb_data==8'h1C)
            begin
              states=2'b11;
              state_info=4'b1000;
              
              pause=1;
            end

            else if(states==2'b10&&kb_data==8'h1B)
            begin
              states=2'b11;
              state_info=4'b1001;
              
              pause=1;
            end

            else if(states==2'b10&&kb_data==8'h23)
            begin
              states=2'b11;
              state_info=4'b1010;
              
              pause=1;
            end

            else if(states==2'b10&&kb_data==8'h2B)
            begin
              states=2'b11;
              state_info=4'b1011;
              
              pause=1;
            end

            else if(states==2'b10&&kb_data==8'h34)
            begin
              states=2'b11;
              state_info=4'b1100;
              
              pause=1;
            end

            else if(kb_data==8'h15) //q means quit
            begin
              
              states=2'b00;
              state_info=4'b0000;
              
              pause=0;
            end
        end
end


initial 
begin
    states=2'b00;
    pic_select=1'b0;
    state_info=3'b0;
    
    pause=0;
end

endmodule