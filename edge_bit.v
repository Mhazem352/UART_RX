module edge_bit_counter #(parameter prescale_w=6,
                        edge_w=6)(
input wire CLK,RST,
input wire counter_en,deser_en,
input wire [prescale_w-1:0] Prescale,
output bit_cnt_done,
output edge_cnt_done,
output sampling_timing
);

reg [edge_w-1:0] edge_cnt;
reg [2:0] bit_cnt;
assign bit_cnt_done=&bit_cnt;
assign edge_cnt_done=(edge_cnt == (Prescale-1));
assign sampling_timing=( (edge_cnt == (Prescale>>1)) || (edge_cnt == ((Prescale>>1)+1)) || edge_cnt == (((Prescale>>1)-1)));  

always @(posedge CLK , negedge RST) begin
    if(!RST)
    edge_cnt<=0;
    else if((counter_en) && (!edge_cnt_done))
    edge_cnt<=edge_cnt+1;
    else 
    edge_cnt<=0;
end

always @(posedge CLK , negedge RST) begin
    if(!RST)
    bit_cnt<=0;
    else if(counter_en && edge_cnt_done && deser_en && !bit_cnt_done)
    bit_cnt<=bit_cnt+1;
    else if(bit_cnt_done && edge_cnt_done)
    bit_cnt<=0;
end
endmodule