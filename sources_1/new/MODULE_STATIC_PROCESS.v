`timescale 1ns/1ps
module MODULE_STATIC_PROCESS (
    input clk,
    input rst,
    input [3:0] state_info,
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
reg [11:0] color_reduced=0;


reg [15:0] color_cnt_1=0;
reg [15:0] color_cnt_2=0;
reg [15:0] color_cnt_3=0;
reg [15:0] color_cnt_4=0;
reg [15:0] color_cnt_5=0;
reg [15:0] color_cnt_6=0;
reg [15:0] color_cnt_7=0;
reg [15:0] color_cnt_8=0;
reg [15:0] color_cnt_9=0;
reg [15:0] color_cnt_10=0;
reg [15:0] color_cnt_11=0;
reg [15:0] color_cnt_12=0;
reg [15:0] color_cnt_13=0;
reg [15:0] color_cnt_14=0;
reg [15:0] color_cnt_15=0;
reg [15:0] color_cnt_16=0;
reg is_read_done=0;

always @(posedge clk) 
begin
    if(done_==0&&(state_info==4'b1000||state_info==4'b1001))
    begin
      if(cnt_buffer==4'b0000)
      begin
        if(state_info==4'b1000)
          color_buffer=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*9/8'd100;
        else if(state_info==4'b1001)
          color_buffer=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*8/8'd100;
        read_from_ram_addr=cnt-641;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0001) //left up
      begin
        if(cnt%640==0||cnt<640)
            color_buffer=color_buffer-0;
        else
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt-640;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0010) // up
      begin
        if(cnt<640)
            color_buffer=color_buffer-0;
        else
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt-639;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0011) //up right
      begin
        if(cnt<640||(cnt-639)%640==0)
            color_buffer=color_buffer-0;
        else
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt-1;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0100) //left
      begin
        if(cnt%640==0)
            color_buffer=color_buffer-0;
        else
        begin
        color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt+1;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0101) //right
      begin
        if(cnt>=639&&(cnt-639)%640==0)
          color_buffer=color_buffer-0;
        else 
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt+640-1;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0110) //left down
      begin
        if(cnt%640==0||cnt>640*479)
            color_buffer=color_buffer-0;
        else 
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_ram_addr=cnt+640;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b0111)// down
      begin
        if(cnt>640*479)
            color_buffer=color_buffer-0;
        else
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        read_from_aux_addr=(cnt-1)%640; // get the pixel dealed (n-1 ,m-1)
        ena_read_aux=1;
        read_from_ram_addr=cnt+640+1;
        cnt_buffer=cnt_buffer+1;
      end

      else if(cnt_buffer==4'b1000)  //compute a pixel
      begin
        if(cnt>640*479||(cnt>=630&&(cnt-639)%640==0))
            color_buffer=color_buffer-0;
        else
        begin
          color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
          if(color_buffer<color_reduced)
            color_buffer=0;
          else
            color_buffer=color_buffer-color_reduced;
        end
        color_buffer={color_buffer[3:0],color_buffer[3:0],color_buffer[3:0]};
        cnt=cnt+1;
        ena_write_ram=1;
        read_from_ram_addr=cnt; 
        cnt_buffer=0;
        write2ram_addr=cnt-640-2;
        read_from_aux_addr=(cnt-2)%640;
        write2ram=read_from_aux;  // write the(n-1,m-1) to ram
        write2aux_addr=(cnt-2)%640;
        write2aux=buffer;
        buffer=color_buffer;
        if(cnt==640*480)
        begin
            done_=1;
            ena_write_ram=0;
            ena_write_aux=0;
            cnt=0;
            cnt_buffer=0;
            
        end
      end
    end
      
    else if(done_==0&& state_info==4'b1010)
    begin
          if(cnt_buffer==4'b0000)
          begin
            color_buffer=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*4/8'd100;
            read_from_ram_addr=cnt-641;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0001) //left up
          begin
            if(cnt%640==0||cnt<640)
                color_buffer=color_buffer+0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt-640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0010) // up
          begin
            if(cnt<640)
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*2/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt-639;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0011) //up right
          begin
            if(cnt<640||(cnt-639)%640==0)
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0100) //left
          begin
            if(cnt%640==0)
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*2/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt+1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0101) //right
          begin
            if(cnt>=639&&(cnt-639)%640==0)
              color_buffer=color_buffer-0;
            else 
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*2/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt+640-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0110) //left down
          begin
            if(cnt%640==0||cnt>640*479)
                color_buffer=color_buffer-0;
            else 
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt+640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0111)// down
          begin
            if(cnt>640*479)
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)*2/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_aux_addr=(cnt-1)%640; // get the pixel dealed (n-1 ,m-1)
            ena_read_aux=1;
            read_from_ram_addr=cnt+640+1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b1000)  //compute a pixel
          begin
            if(cnt>640*479||(cnt>=630&&(cnt-639)%640==0))
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            color_buffer=color_buffer/16;
            color_buffer={color_buffer[3:0],color_buffer[3:0],color_buffer[3:0]};
            cnt=cnt+1;
            // ena_write_aux=1;
            ena_write_ram=1;
            // ena_read_aux=1;
            read_from_ram_addr=cnt; //**last fix cnt->cnt-640-1
            cnt_buffer=0;
            write2ram_addr=cnt-640-2;//3
            //add
            read_from_aux_addr=(cnt-2)%640;
            write2ram=read_from_aux;  // write the(n-1,m-1) to ram
            write2aux_addr=(cnt-2)%640;
            write2aux=buffer;
            buffer=color_buffer;
            if(cnt==640*480)
            begin
                done_=1;
                ena_write_ram=0;
                ena_write_aux=0;
                cnt=0;
                cnt_buffer=0;
            end

          end
    end

    else if(done_==0&& state_info==4'b1011)
    begin
          if(cnt_buffer==4'b0000)
          begin
            color_buffer=12'b000000000111;
            read_from_ram_addr=cnt-641;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0001) //left up
          begin
            if(cnt%640==0||cnt<640)
                color_buffer=color_buffer+0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              color_buffer=color_buffer+color_reduced;
            end
            read_from_ram_addr=cnt-640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0010) // up
          begin
            color_buffer=color_buffer-0;
            
            read_from_ram_addr=cnt-639;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0011) //up right
          begin
            
            color_buffer=color_buffer-0;
            
            read_from_ram_addr=cnt-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0100) //left
          begin
            
            color_buffer=color_buffer-0;
            
            read_from_ram_addr=cnt+1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0101) //right
          begin
           
            color_buffer=color_buffer-0;
            read_from_ram_addr=cnt+640-1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0110) //left down
          begin
            color_buffer=color_buffer-0;
            
            read_from_ram_addr=cnt+640;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b0111)// down
          begin
            
            color_buffer=color_buffer-0;
            read_from_aux_addr=(cnt-1)%640; // get the pixel dealed (n-1 ,m-1)
            ena_read_aux=1;
            read_from_ram_addr=cnt+640+1;
            cnt_buffer=cnt_buffer+1;
          end

          else if(cnt_buffer==4'b1000)  //compute a pixel
          begin
            if(cnt>640*479||(cnt>=630&&(cnt-639)%640==0))
                color_buffer=color_buffer-0;
            else
            begin
              color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
              if(color_buffer>color_reduced)
                color_buffer=color_buffer-color_reduced;
              else
                color_buffer=0;
            end
            color_buffer={color_buffer[3:0],color_buffer[3:0],color_buffer[3:0]};
            cnt=cnt+1;
            // ena_write_aux=1;
            ena_write_ram=1;
            // ena_read_aux=1;
            read_from_ram_addr=cnt; //**last fix cnt->cnt-640-1
            cnt_buffer=0;
            write2ram_addr=cnt-640-2;//3
            //add
            read_from_aux_addr=(cnt-2)%640;
            write2ram=read_from_aux;  // write the(n-1,m-1) to ram
            write2aux_addr=(cnt-2)%640;
            write2aux=buffer;
            buffer=color_buffer;
            if(cnt==640*480)
            begin
                done_=1;
                ena_write_ram=0;
                ena_write_aux=0;
                cnt=0;
                cnt_buffer=0;
            end

          end
    end

    else if(done_==1'b1&&state_info<4'b1000)
    begin
      done_=1'b0;
      read_from_aux_addr=0;
      read_from_ram_addr=0;
      cnt=0;
      color_cnt_1=0;
      color_cnt_2=0;
      color_cnt_3=0;
      color_cnt_4=0;
      color_cnt_5=0;
      color_cnt_6=0;
      color_cnt_7=0;
      color_cnt_8=0;
      color_cnt_9=0;
      color_cnt_10=0;
      color_cnt_11=0;
      color_cnt_12=0;
      color_cnt_13=0;
      color_cnt_14=0;
      color_cnt_15=0;
      color_cnt_16=0;
      is_read_done=0;
    end

    else if(done_==1'b0 && state_info==4'b1100)
    begin
      ena_write_ram=1;
      if(cnt==480*640&&is_read_done==0)
      begin
        is_read_done=1;
        cnt=0;
      end
      if(is_read_done==0&&cnt<480*640)
      begin
        read_from_ram_addr=cnt;
        color_reduced=(read_from_ram[11:8]*8'd30+read_from_ram[7:4]*8'd59+read_from_ram[3:0]*8'd11)/8'd100;
        if(color_reduced[3:0]==4'b0000)
          color_cnt_1=color_cnt_1+1;
        else if(color_reduced[3:0]==4'b0001)
          color_cnt_2=color_cnt_2+1;
        else if(color_reduced[3:0]==4'b0010)
          color_cnt_3=color_cnt_3+1;
        else if(color_reduced[3:0]==4'b0011)
          color_cnt_4=color_cnt_4+1;
        else if(color_reduced[3:0]==4'b0100)
          color_cnt_5=color_cnt_5+1;
        else if(color_reduced[3:0]==4'b0101)
          color_cnt_6=color_cnt_6+1;
        else if(color_reduced[3:0]==4'b0110)
          color_cnt_7=color_cnt_7+1;
        else if(color_reduced[3:0]==4'b0111)
          color_cnt_8=color_cnt_8+1;
        else if(color_reduced[3:0]==4'b1000)
          color_cnt_9=color_cnt_9+1;
        else if(color_reduced[3:0]==4'b1001)
          color_cnt_10=color_cnt_10+1;
        else if(color_reduced[3:0]==4'b1010)
          color_cnt_11=color_cnt_11+1;
        else if(color_reduced[3:0]==4'b1011)
          color_cnt_12=color_cnt_12+1;
        else if(color_reduced[3:0]==4'b1100)
          color_cnt_13=color_cnt_13+1;
        else if(color_reduced[3:0]==4'b1101)
          color_cnt_14=color_cnt_14+1;
        else if(color_reduced[3:0]==4'b1110)
          color_cnt_15=color_cnt_15+1;
        else if(color_reduced[3:0]==4'b1111)
          color_cnt_16=color_cnt_16+1;
        cnt=cnt+1;

      end

      else if(is_read_done==1&&done_==0)
      begin
        if(cnt==640*480)
        begin
          done_=1;
          ena_write_ram=0;
        end
        else
        begin
          write2ram_addr=cnt;
          if(cnt%640<40) //0000 counter
          begin
            if((480-(cnt/640))<color_cnt_1/160)
              write2ram=12'hFFD;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<80)
          begin
            if((480-(cnt/640))<color_cnt_2/160)
              write2ram=12'hFF0;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<120)
          begin
            if((480-(cnt/640))<color_cnt_3/160)
              write2ram=12'hFFF;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<160)
          begin
            if((480-(cnt/640))<color_cnt_4/160)
              write2ram=12'h0f0;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<200)
          begin
            if((480-(cnt/640))<color_cnt_5/160)
              write2ram=12'hFFE;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<240)
          begin
            if((480-(cnt/640))<color_cnt_6/160)
              write2ram=12'hCFC;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<280)
          begin
            if((480-(cnt/640))<color_cnt_7/160)
              write2ram=12'hfed;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<320)
          begin
            if((480-(cnt/640))<color_cnt_8/160)
              write2ram=12'h9ff;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<360)
          begin
            if((480-(cnt/640))<color_cnt_9/160)
              write2ram=12'hfdb;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<400)
          begin
            if((480-(cnt/640))<color_cnt_10/160)
              write2ram=12'hbff;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<440)
          begin
            if((480-(cnt/640))<color_cnt_11/160)
              write2ram=12'hfeb;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<480)
          begin
            if((480-(cnt/640))<color_cnt_12/160)
              write2ram=12'h8cf;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<520)
          begin
            if((480-(cnt/640))<color_cnt_13/160)
              write2ram=12'heef;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<560)
          begin
            if((480-(cnt/640))<color_cnt_14/160)
              write2ram=12'h9f9;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<600)
          begin
            if((480-(cnt/640))<color_cnt_15/160)
              write2ram=12'hfee;
            else
              write2ram=12'b000000000000;
          end

          else if(cnt%640<640)
          begin
            if((480-(cnt/640))<color_cnt_16/160)
              write2ram=12'hfcc;
            else
              write2ram=12'b000000000000;
          end
          cnt=cnt+1;


        end
      end
      

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