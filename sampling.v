module data_sampling #(parameter prescale_w=6)(
input CLK,RST,
input RX_IN,
input dat_samp_en,sampling_timing,
input [prescale_w-1:0] Prescale,
output reg sampled_bit 
);

reg [2:0] sampled_data;

always@(posedge CLK or negedge RST)
begin
  if(!RST)
    begin
    sampled_bit<=0;
    sampled_data<=0;
  end
  else if(sampling_timing  && dat_samp_en)
        sampled_data<={RX_IN,sampled_data[2:1]};
  else
        sampled_bit<=((sampled_data[2] & (sampled_data[1] | sampled_data[0])) | (sampled_data[1] & sampled_data[0]));
end

endmodule