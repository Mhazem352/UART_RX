module FSM (
input wire CLK,RST,
input wire RX_IN,
input wire edge_cnt_done,
input wire bit_cnt_done,
input wire Parity_Error,
input wire strt_glitch,
input wire Stop_Error,
input wire PAR_EN,
output reg counter_en,
output reg dat_samp_en,
output reg deser_en,
output reg par_chk_en,
output reg strt_chk_en,
output reg stp_chk_en,
output reg  data_valid );

localparam  IDLE=0,
            START=1,
            DATA=2,
            PARITY=3,
            STOP=4,
            ERR_CH=5;
            
reg [2:0] current_state,next_state;

always@(posedge CLK or negedge RST)
begin
 if(!RST)
   current_state<=IDLE;
 else
   current_state<=next_state;
 end
  
  ////////// NEXT STATE TRANSITION////////
 always@(*)
 begin
   next_state=IDLE;
   case(current_state)
     IDLE: begin
             if(RX_IN)
               next_state=IDLE;
             else
               next_state=START;
           end
          
     START: begin
              if(strt_glitch)
                 next_state=IDLE;
               else if(edge_cnt_done)
                 next_state=DATA;
               else
                 next_state=START;
            end
            
     DATA: begin
            if(!bit_cnt_done || !edge_cnt_done)
              next_state=DATA;
            else
              begin
                if(PAR_EN)
                 next_state=PARITY;
                else
                 next_state=STOP; 
              end
            end
    PARITY : begin
           if(edge_cnt_done)
               next_state=STOP;
           else
             next_state=PARITY;
           end
    STOP:begin
            if(edge_cnt_done)
               next_state=ERR_CH;
           else
             next_state=STOP;
          end
          
    ERR_CH:begin
             if(RX_IN)
              next_state=IDLE;
             else
              next_state=START;
           end 
      default: next_state=IDLE;
  endcase
end
  
  
  ////////// NEXT STATE LOGIC////////
always@(*)
 begin
   counter_en=1;
   dat_samp_en=1;
   deser_en=0;
   par_chk_en=0;
   strt_chk_en=0;
   stp_chk_en=0;
  case(current_state)
     IDLE: begin
             counter_en=0;
             dat_samp_en=0;
           end
          
     START: begin
              if(edge_cnt_done)
                strt_chk_en=1;
              else
                strt_chk_en=0;
            end
            
     DATA: begin
             if(edge_cnt_done)
               deser_en=1;
             else
               deser_en=0;
              end
    PARITY:begin
           if(edge_cnt_done)
                par_chk_en=1;
              else
                par_chk_en=0;
            end
           
    STOP:begin
            if(edge_cnt_done)
                stp_chk_en=1;
              else
                stp_chk_en=0;
            end
          
    ERR_CH: begin
              counter_en=0;
             if(Stop_Error || Parity_Error)
            data_valid=0;
            else
            data_valid=1;
           end 
      default: begin
                 counter_en=1;
                 dat_samp_en=1;
                 deser_en=0;
                 par_chk_en=0;
                 strt_chk_en=0;
                 stp_chk_en=0;
               end
  endcase
   
 end    
 
 endmodule