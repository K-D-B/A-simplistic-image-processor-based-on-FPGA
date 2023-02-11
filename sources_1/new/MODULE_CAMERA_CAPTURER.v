module MODULE_CAMERA_CAPTURER (
    input pclk,
    input href,
    input vsyn,
    input rst,
    input [7:0] camera_data,
    output reg wren,
    output reg [11:0] camera_color_write,
    output reg [18:0] store_addr

);
reg[15:0]rgb565=0;
reg[18:0]next=0;
reg[1:0]select=0;

always @(posedge pclk)
begin
    if(!vsyn)
    begin
        store_addr<=0;
        next<=0;
        select<=0;
    end
    else
    begin
        camera_color_write<={rgb565[15:12],rgb565[10:7],rgb565[4:1]};
        store_addr<=next;
        wren<=select[1];
        select<={select[0],!select[0]&&href};
        rgb565<={rgb565[7:0],camera_data};
        if(select[1])
            next<=next+1;
    end
end
endmodule //MODULE_CAMERA_CAPTURER