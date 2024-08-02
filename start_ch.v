module start_check (
input sampled_bit,strt_chk_en,
output reg strt_glitch);

always@(*)
begin
  casex ({sampled_bit,strt_chk_en})
        2'b01: strt_glitch=0;
        2'b11: strt_glitch=1;
        2'bx0: strt_glitch=1'bx;
    endcase
end

endmodule