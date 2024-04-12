module UART_TOP (
  input wire   parity_EN, data_valid, CLK, RST, parity_type,
  input wire [7:0] Parallel_data,
  output wire TX_OUT, busy
  );
  
  //internal signals
  wire serial_done, serial_EN, serial_data, parity_bit;
  wire [1:0] mux_sel;
  
  UART_FSM u_FSM (
  .data_valid(data_valid),
  .parity_EN(parity_EN),
  .serial_done(serial_done),
  .CLK(CLK),
  .RST(RST),
  .busy(busy),
  .serial_EN(serial_EN),
  .mux_sel(mux_sel)
  );
  
  UART_serializer u_serial (
  .CLK(CLK),
  .RST(RST),
  .serial_EN(serial_EN),
  .busy(busy),
  .Parallel_data(Parallel_data),
  .serial_data(serial_data),
  .serial_done(serial_done)
  );
  
  UART_parity u_parity (
  .CLK(CLK),
  .RST(RST),
  .data_valid(data_valid),
  .Parallel_data(Parallel_data),
  .parity_bit(parity_bit),
  .parity_type(parity_type)
  );
  
  MUX u_MUX (
  .CLK(CLK),
  .RST(RST),
  .parity_bit(parity_bit),
  .serial_data(serial_data),
  .mux_sel(mux_sel),
  .TX_OUT(TX_OUT)
  );
  
endmodule 
