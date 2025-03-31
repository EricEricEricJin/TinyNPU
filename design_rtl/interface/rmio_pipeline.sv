`default_nettype none

module rmio_pipeline (
    input wire clk, 
    // input wire rst_n,

    // === RMIO ===
    rmio_intf rmio_rf,
    rmio_intf rmio_eu
);

always_ff @( posedge clk ) begin
    rmio_eu.input_data <= rmio_rf.input_data;
    rmio_eu.input_we   <= rmio_rf.input_we;
    rmio_eu.output_re <= rmio_rf.output_re;
    rmio_rf.output_data <= rmio_eu.output_data;
end

endmodule

`default_nettype wire