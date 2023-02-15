`timescale 1ns/1ps
module MODULE_STATIC_PROCESS (
    input clk,
    input rst,
    input [3:0] state_info,
    input [2:0] state_order,

    input [11:0] read_from_aux,
    input [11:0] read_from_ram,

    output reg [11:0] write2aux,
    output reg [11:0] write2ram,

    output reg [9:0] write2aux_addr,
    output reg [9:0] read_from_aux_addr,

    output reg [18:0] write2ram_addr,
    output reg[18:0] read_from_ram_addr,

    
    output reg ena_write_aux,
    output reg ena_read_aux,
    output reg ena_write_ram,
    output done
);


reg [18:0] cnt=0;
reg done_;
assign done=done_;
reg [4:0] cnt_buffer;
reg [11:0] color_buffer=0;
reg [11:0] buffer;
reg  t=0;

always @(posedge clk) 
begin
    if(done_==0&&state_info==4'b1000)
    begin
          // if(t==1'b1)
          //   t<=1'b0;
          // else
          //   t<=t+1;
          if(cnt_buffer==4'b0000)
          begin
            color_buffer=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*9/8'd100;
            //read_from_ram_addr=cnt-641;
            cnt_buffer=cnt_buffer+1;
            //ena_write_aux=0;
            //ena_write_ram=0;
          end

          else if(cnt_buffer==4'b0001) //left up
          begin
            if(cnt%640==0||cnt<640)
                color_buffer=color_buffer-0;
            else
                begin
                  color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
                end
            //read_from_ram_addr=cnt-640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0010) // up
          begin
            if(cnt<640)
                color_buffer=color_buffer-0;
            else
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
              
            end
            //read_from_ram_addr=cnt-639;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0011) //up right
          begin
            if(cnt<640||(cnt-639)%640==0)
                color_buffer=color_buffer-0;
            else
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
              
            end
            //read_from_ram_addr=cnt-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0100) //left
          begin
            if(cnt%640==0)
                color_buffer=color_buffer-0;
            else
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
            end
            //read_from_ram_addr=cnt+1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0101) //right
          begin
            if(cnt>=639&&(cnt-639)%640==0)
              color_buffer=color_buffer-0;
            else 
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
            end
            //read_from_ram_addr=cnt+640-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0110) //left down
          begin
            if(cnt%640==0||cnt>640*479)
                color_buffer=color_buffer-0;
            else 
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
            end
            //read_from_ram_addr=cnt+640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0111)// down
          begin
            if(cnt>640*479)
                color_buffer=color_buffer-0;
            else
            begin
              color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
            end
            read_from_aux_addr=(cnt-1)%640; // get the pixel dealed (n-1 ,m-1)
            ena_read_aux=1;
            //read_from_ram_addr=cnt;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b1000)  //compute a pixel
          begin
            // if(cnt>640*479||(cnt>=630&&(cnt-639)%640==0))
            //     color_buffer=color_buffer-0;
            // else
            // begin
            //   color_buffer=color_buffer-((read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100);
            // end
            color_buffer=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
            color_buffer={color_buffer[3:0],color_buffer[3:0],color_buffer[3:0]};
           // begin
            // if(cnt<120*640)
            //   color_buffer=12'b111111111111;
            // else if(cnt<360*640)
            //   color_buffer=12'b111100000000;
            // else
            //   color_buffer=12'b000011110000;
            cnt=cnt+1;
            // ena_write_aux=1;
            ena_write_ram=1;
            // ena_read_aux=1;
            read_from_ram_addr=cnt; //**last fix
            cnt_buffer=0;
            write2ram_addr=cnt-640-2;//3
            //add
            read_from_aux_addr=(cnt-2)%640;
            write2ram=read_from_aux;  // write the(n-1,m-1) to ram
            write2aux_addr=(cnt-2)%640;
            write2aux=buffer;
            //write2ram=buffer;
            buffer=color_buffer;
            if(cnt==640*480)
            begin
                done_=1;
                ena_write_ram=0;
                ena_write_aux=0;
                cnt=0;
                cnt_buffer=0;
                t=0;
            end

            end
            // else
            // begin
            //   ena_write_aux<=0;
            //   ena_write_ram<=0;
            // end
          


        
        end
        else if(done_==1'b1&&state_info<4'b1000)
        begin
          done_=1'b0;
          read_from_aux_addr=0;
          read_from_ram_addr=0;
        end
      
    end

initial
begin
  read_from_aux_addr=0;
  read_from_ram_addr=0;
  cnt=0;
  cnt_buffer=0;
end

endmodule //MODULE_STATIC_PROCESS