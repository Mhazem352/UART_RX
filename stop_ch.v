module stop_check (
input CLK,RST,
input sampled_bit,stp_chk_en,
output reg Stop_Error);

always@(posedge CLK or negedge RST)
begin
  if(!RST)
    Stop_Error<=0;
  else begin
  casex ({sampled_bit,stp_chk_en})
        2'b01: Stop_Error<=1;
        2'b11: Stop_Error<=0;
        2'bx0: Stop_Error<=Stop_Error;
    endcase
    end
end

endmodule
