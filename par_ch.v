module parity_check #(parameter OUT_data=8
                  )(
input CLK,RST,
input PAR_TYP,par_chk_en,
input sampled_bit,
input [OUT_data-1:0] P_DATA,
output reg Parity_Error);

assign  parity_bit=(PAR_TYP)? ~^(P_DATA): ^(P_DATA);
always @(posedge CLK or negedge RST)
begin
  if(!RST)
    Parity_Error<=0;
  else 
    begin
      case({sampled_bit,parity_bit,par_chk_en})
        3'b001:Parity_Error<=0;
        3'b011:Parity_Error<=1;
        3'b111:Parity_Error<=0;
        3'b101:Parity_Error<=1;
        3'bxx0:Parity_Error<=Parity_Error; 
        endcase
      end
      
end


endmodule
