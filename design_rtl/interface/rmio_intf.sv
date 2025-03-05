// Between RF Ram and Executing unit 

`default_nettype none

interface rmio_intf #(
    parameter int INPUT_NUM = 1, 
    parameter int OUTPUT_NUM = 1,
    parameter int DATA_W = 176*8,
    parameter int ADDR_W = 10,
    parameter logic [ADDR_W - 1 : 0] INPUT_ADDR = 32'h0,
    parameter logic [ADDR_W - 1 : 0] OUTPUT_ADDR = 32'h0
);

logic [DATA_W - 1 : 0] input_data   [0 : INPUT_NUM - 1];
logic                  input_we     [0 : INPUT_NUM - 1]; 
logic [DATA_W - 1 : 0] output_data  [0 : OUTPUT_NUM - 1];
logic                  output_re    [0 : OUTPUT_NUM - 1];

modport EU (
    input  input_data, input_we, output_re,
    output output_data
);

modport RF (
    output input_data, input_we, output_re,
    input  output_data
);

endinterface