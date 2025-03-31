// Between RF Ram and Executing unit 

`default_nettype none

interface rmio_intf #(
    parameter int INPUT_NUM = 1, 
    parameter int OUTPUT_NUM = 1,
    parameter int DATA_W = 176*8
);

logic [DATA_W - 1 : 0]      input_data;
logic [INPUT_NUM - 1 : 0]   input_we; 
logic [DATA_W - 1 : 0]      output_data;
logic [OUTPUT_NUM - 1 : 0]  output_re;

modport eu (
    input  input_data, input_we, output_re,
    output output_data
);

modport rf (
    output input_data, input_we, output_re,
    input  output_data
);

endinterface