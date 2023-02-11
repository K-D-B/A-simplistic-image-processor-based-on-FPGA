`timescale 1ns / 1ps
module MODULE_DISPLAY7(
    input [3:0] iData,
    output reg[6:0] oData,
    input clk
    );
    initial
    begin
    oData=0;
    end
    
  
    
    always@(posedge clk)
    begin
    
     oData[0]=(iData[0]&~iData[1]&~iData[2]&~iData[3]) | 
                    (~iData[0]&~iData[1]&iData[2]&~iData[3]);
        oData[1]=(iData[0]&~iData[1]&iData[2]&~iData[3])|
                        (~iData[0]&iData[1]&iData[2]&~iData[3]);
        oData[2]=(~iData[0]&iData[1]&~iData[2]&~iData[3]);
        oData[3]=(iData[0]&~iData[1]&~iData[2]&~iData[3])|
                       (~iData[0]&~iData[1]&iData[2]&~iData[3])|
                       (iData[0]&iData[1]&iData[2]&~iData[3]);
        oData[4]=(iData[0]&~iData[1]&~iData[2]&~iData[3])|
                       (iData[0]&iData[1]&~iData[2]&~iData[3])|
                       (~iData[0]&~iData[1]&iData[2]&~iData[3])|
                       (iData[0]&~iData[1]&iData[2]&~iData[3])|
                       (iData[0]&iData[1]&iData[2]&~iData[3])|
                       (iData[0]&~iData[1]&~iData[2]&iData[3]);
       
        oData[5]=(iData[0]&~iData[1]&~iData[2]&~iData[3])|
                        (~iData[0]&iData[1]&~iData[2]&~iData[3])|
                        (iData[0]&iData[1]&~iData[2]&~iData[3])|
                        (iData[0]&iData[1]&iData[2]&~iData[3]);
        oData[6]=(~iData[0]&~iData[1]&~iData[2]&~iData[3])|
                        (iData[0]&~iData[1]&~iData[2]&~iData[3])|
                        (iData[0]&iData[1]&iData[2]&~iData[3]);
       
    end
    
endmodule
