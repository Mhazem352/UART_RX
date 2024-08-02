`timescale 1us/1ps
/*parameter OUT_data=8;
parameter prescale_w=6;*/

module URX_tb();
reg CLK_tx_tb,CLK_rx_tb,RST_tb;
reg RX_IN_tb;
reg [5:0] Prescale_tb;
reg PAR_EN_tb;
reg PAR_TYP_tb;
wire data_valid_tb,Parity_Error_tb,Stop_Error_tb;
wire [7:0] P_DATA_tb;

top DUT(
.CLK(CLK_rx_tb),
.RST(RST_tb),
.RX_IN(RX_IN_tb),
.Prescale(Prescale_tb),
.PAR_EN(PAR_EN_tb),
.PAR_TYP(PAR_TYP_tb),
.data_valid(data_valid_tb),
.Parity_Error(Parity_Error_tb),
.Stop_Error(Stop_Error_tb),
.P_DATA(P_DATA_tb)
);

localparam T_tx=8.68;
initial
begin
  Prescale_tb='d8;
end

always #(T_tx/(2*Prescale_tb)) CLK_rx_tb=~CLK_rx_tb;

always #(T_tx/(2)) CLK_tx_tb=~CLK_tx_tb;
  



initial
begin
  reset;
  initialize;
  $display("testing with prescale=8");
  Prescale_tb=8;
  #(2*T_tx);
  @(negedge CLK_rx_tb) 
  glitch_ch;
  
  ///////////////// test correct frames///////////////
  $display("test correct frames_8_prescale");
@(negedge CLK_rx_tb)
no_parity(10'b0110101001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);



 @(negedge CLK_rx_tb)
odd_parity(11'b01001010111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010011);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)
no_parity(10'b0110101111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b11101011);


 @(negedge CLK_rx_tb)
even_parity(11'b00101011001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b01101010);

  
  //////////////////wrong frames//////////////////
  $display("test wrong frames_8_prescale");
  @(negedge CLK_rx_tb)
 no_parity(10'b0110101000);  
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010000); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)  
odd_parity(11'b01001010100); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);

#((5*T_tx)/(2*Prescale_tb));
////////////////////////////////////////////
////////test with 16 prescale///////////////
////////////////////////////////////////////
reset;
$display("testing with prescale=16 ");
$display("test correct frames_16_prescale");
Prescale_tb=16;
@(negedge CLK_rx_tb)
no_parity(10'b0110101001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);



 @(negedge CLK_rx_tb)
odd_parity(11'b01001010111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010011);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)
no_parity(10'b0110101111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b11101011);


 @(negedge CLK_rx_tb)
even_parity(11'b00101011001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b01101010);

  
  //////////////////wrong frames//////////////////
  $display("test wring frames_16_prescale");
  @(negedge CLK_rx_tb)
 no_parity(10'b0110101000);  
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010000); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)  
odd_parity(11'b01001010100); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);

#((7*T_tx)/(Prescale_tb)); ///// for uart_32_prescale to capture right
////////////////////////////////////////////
////////test with 16 prescale///////////////
////////////////////////////////////////////
reset;
$display("testing with prescale=32 ");
$display("test correct frames_32_prescale");
Prescale_tb=32;
@(negedge CLK_rx_tb)
no_parity(10'b0110101001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);



 @(negedge CLK_rx_tb)
odd_parity(11'b01001010111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010011);
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)
no_parity(10'b0110101111);
#(T_tx/(Prescale_tb));
correct_data_check(8'b11101011);


 @(negedge CLK_rx_tb)
even_parity(11'b00101011001);
#(T_tx/(Prescale_tb));
correct_data_check(8'b01101010);

  
  //////////////////wrong frames//////////////////
  $display("test wrong frames_32_prescale");
  @(negedge CLK_rx_tb)
 no_parity(10'b0110101000);  
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101011);

 @(negedge CLK_rx_tb)
even_parity(11'b00101010000); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b00101010);

 @(negedge CLK_rx_tb)  
odd_parity(11'b01001010100); 
#(T_tx/(Prescale_tb));
correct_data_check(8'b10101001);
#(T_tx);   
$stop; 
end



/////////////////////////////////
//////////TASKS//////////////////
/////////////////////////////////

//task initialize////
task initialize();
   begin
     CLK_rx_tb=0;
     CLK_tx_tb=0;
     RX_IN_tb=1;
    PAR_EN_tb=1;
    PAR_TYP_tb=0;
    end 
endtask


////////gen_clks///////




///////task reset//////////
task reset();
  begin
    RST_tb=0;
    #(T_tx/(2* Prescale_tb))
    RST_tb=1;  
  end
endtask
  
/*  
//////////task config///////////
task RX_config ;
  input                   PAR_EN ;
  input                   PAR_TYP;

  begin
	PAR_EN_tb = PAR_EN   ;
	PAR_TYP_tb = PAR_TYP  ;
  end
endtask   */


/////////////task glitch check/////////////////
task glitch_ch;
  begin
RX_IN_tb=0;
#(T_tx/(Prescale_tb));
RX_IN_tb=1;
#(3*T_tx);
end
endtask

/*
//////////////task frame_size_check//////////////
task frame_size_check;
  input [10:0] frame_rec; 
  integer i;
  begin
    if(PAR_EN_tb)
      begin
        for(i=10;i>=0;i=i-1)
        begin
        RX_IN_tb=frame_rec[i];
        #(T_tx);
        end
      end
    else
      for(i=10;i>0;i=i-1)
        begin
        RX_IN_tb=frame_rec[i];
        #(T_tx);
      end
  end
endtask
*/

task no_parity;
  input[9:0] frame_rec;
  integer i;
  begin
    PAR_EN_tb=0;
    for(i=9;i>=0;i=i-1)
     begin
        RX_IN_tb=frame_rec[i];
        #(T_tx);
     end 
  end
endtask


task even_parity;
  input[10:0] frame_rec;
  integer i;
  begin
    PAR_EN_tb=1;
    PAR_TYP_tb=0;
    for(i=10;i>=0;i=i-1)
     begin
       RX_IN_tb=frame_rec[i];
       #(T_tx);
     end
  end
endtask

task odd_parity;
  input[10:0] frame_rec;
  integer i;
  begin
    PAR_EN_tb=1;
    PAR_TYP_tb=1;
    for(i=10;i>=0;i=i-1)
     begin
       RX_IN_tb=frame_rec[i];
       #(T_tx);
     end
  end
endtask


//////////////////task correct_data_check/////////////
task correct_data_check;
  parameter OUT_data=8;
  input [OUT_data-1:0] data_rec;
  begin
    if(data_valid_tb && (data_rec==P_DATA_tb))
      $display("frame data bits recieved is correct");
    else
      $display("frame data bits recieved is wrong");
  end
endtask

endmodule 