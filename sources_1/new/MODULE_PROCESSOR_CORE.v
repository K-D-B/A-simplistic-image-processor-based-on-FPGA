module MODULE_PROCESSOR_CORE (
    input clk,
    input [18:0] picture_addr,
    input [11:0] raw_color,
    input [3:0] state_info,
    output reg [11:0] ripe_color
);
reg [11:0] buffer;
reg [11:0] buffer1;
reg [11:0] buffer2;
always @(posedge clk) 
begin
    if(state_info==4'b0010) //gray scale
    begin
      buffer=(raw_color[11:8]*8'd30+raw_color[7:4]*8'd59+raw_color[3:0]*8'd11)/8'd100;
      ripe_color={buffer[3:0],buffer[3:0],buffer[3:0]};
    end
    else if(state_info==4'b0011)//melt and mound
    begin
      buffer=raw_color[11:8]*15/(raw_color[7:4]+raw_color[3:0]+1);
      buffer1=raw_color[7:4]*15/(raw_color[11:8]+raw_color[3:0]+1);
      buffer2=raw_color[3:0]*15/(raw_color[7:4]+raw_color[11:8]+1);
      ripe_color={buffer[3:0],buffer1[3:0],buffer2[3:0]};
    end
    else if(state_info==4'b0100) //freezing
    begin
      buffer=(raw_color[11:8]-raw_color[7:4]-raw_color[3:0])*3/2;
      buffer1=(raw_color[7:4]-raw_color[11:8]-raw_color[3:0])*3/2;
      buffer2=(raw_color[3:0]-raw_color[7:4]-raw_color[11:8])*3/2;
      ripe_color={buffer[3:0],buffer1[3:0],buffer2[3:0]};
      
    end
    else if(state_info==4'b0101) //nostalgic
    begin
      buffer=(raw_color[11:8]*393+raw_color[7:4]*769+raw_color[3:0]*189)/1000;
      buffer1=(raw_color[11:8]*349+raw_color[7:4]*686+raw_color[3:0]*168)/1000;
      buffer2=(raw_color[11:8]*272+raw_color[7:4]*534+raw_color[3:0]*131)/1000;
      if(buffer>4'b1111)
        buffer[3:0]=4'b1111;
      if(buffer1>4'b1111)
        buffer1[3:0]=4'b1111;
      if(buffer2>4'b1111)
        buffer2[3:0]=4'b1111;
      ripe_color={buffer[3:0],buffer1[3:0],buffer2[3:0]};
    end

    else if(state_info==3'b110) //reverse
    begin
      buffer=255-raw_color[11:8];
      buffer1=255-raw_color[7:4];
      buffer2=255-raw_color[3:0];
      ripe_color={buffer[3:0],buffer1[3:0],buffer2[3:0]};
    end
    else if(state_info==4'b0001)
      ripe_color=raw_color;
    else 
      ripe_color=raw_color;
end
    
    
endmodule //MODULE_PROCESSOR_CORE