module top #(parameter OUT_data=8,
                        prescale_w=6,
                        edge_w=8)(
input wire CLK,RST,
input wire RX_IN,
input wire [prescale_w-1:0] Prescale,
input wire PAR_EN,
input wire PAR_TYP,
output wire data_valid,Parity_Error,Stop_Error,
output wire [OUT_data-1:0] P_DATA );


wire bit_cnt_done;
wire edge_cnt_done;
wire smapling_timing;
wire dat_samp_en;
wire sampled_bit;
wire par_chk_en;
wire strt_chk_en, strt_glitch;
wire stp_chk_en;
wire deser_en;
wire counter_en;

FSM u_fsm(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.counter_en(counter_en),
.edge_cnt_done(edge_cnt_done),
.bit_cnt_done(bit_cnt_done),
.Stop_Error(Stop_Error),
.strt_glitch(strt_glitch),
.Parity_Error(Parity_Error),
.PAR_EN(PAR_EN),
.dat_samp_en(dat_samp_en),
.deser_en(deser_en),
.par_chk_en(par_chk_en),
.strt_chk_en(strt_chk_en),
.stp_chk_en(stp_chk_en),
.data_valid(data_valid)
);

edge_bit_counter u_edge_bit(
.CLK(CLK),
.RST(RST),
.counter_en(counter_en),
.deser_en(deser_en),
.edge_cnt_done(edge_cnt_done),
.bit_cnt_done(bit_cnt_done),
.Prescale(Prescale),
.sampling_timing(sampling_timing)
);

data_sampling u_sampling(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.Prescale(Prescale),
.dat_samp_en(dat_samp_en),
.sampling_timing(sampling_timing),
.sampled_bit(sampled_bit)
);

parity_check u_parity_check (
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.par_chk_en(par_chk_en),
.PAR_TYP(PAR_TYP),
.Parity_Error(Parity_Error),
.P_DATA(P_DATA)
);

start_check u_start_check (
.sampled_bit(sampled_bit),
.strt_chk_en(strt_chk_en),
.strt_glitch(strt_glitch)
);

stop_check u_stop_check (
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.stp_chk_en(stp_chk_en),
.Stop_Error(Stop_Error)
);

deserializer u_deserializer (
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.deser_en(deser_en),
.P_DATA(P_DATA)
);

endmodule