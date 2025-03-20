`default_nettype none

interface ln_fetch_intf #(
    parameter int DATA_W = 176*8
);

logic [DATA_W - 1 : 0]  data;
logic                   gamma_low_we;
logic                   gamma_high_we;
logic                   beta_we;

modport fetch ( output data, gamma_low_we, gamma_high_we, beta_we );
modport eu    ( input  data, gamma_low_we, gamma_high_we, beta_we );

endinterface 

`default_nettype wire