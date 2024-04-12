module UART_parity (
  input  wire        data_valid, CLK, RST, parity_type,
  input  wire  [7:0] Parallel_data,
  output reg         parity_bit
  );
  
  always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      parity_bit <= 1'b0;
    else if (!parity_type && data_valid)              //even parity
      parity_bit <= ^Parallel_data;
    else if (parity_type && data_valid)               //odd parity
      parity_bit <=  ~(^Parallel_data);
    else
      parity_bit <= parity_bit;
  end
      
endmodule
