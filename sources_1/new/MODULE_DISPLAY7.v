`timescale 1ns / 1ps
module MODULE_DISPLAY7(
    input [3:0] iData_,
    output reg[6:0] oData,
    input clk
    );

    reg [3:0] iData=0;
    initial
    begin
    oData=0;
    end
    
  
    
    always@(posedge clk)
    begin
        if(iData_>=4'b0111)
            iData=4'b0111;
        else
            iData=iData_;


    
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
