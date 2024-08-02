module deserializer #(parameter OUT_data=8)(
input CLK,RST,
input sampled_bit,
input deser_en,
output reg [OUT_data-1:0] P_DATA
);


always@(posedge CLK or negedge RST)
begin
  if(!RST)
    begin
    P_DATA<=0;
    end
  else if(deser_en)
    begin
      P_DATA<={sampled_bit,P_DATA[OUT_data-1:1]};
    end
end

endmodule