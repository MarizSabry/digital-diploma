`timescale 1 us/1 ns
module UART_TX_TB #(parameter CLK_CYCLE = 104 )(); //frequency = 9.615 KHz
  
  // declare testbench signals
  reg          parity_EN_TB, data_valid_TB, CLK_TB, RST_TB, parity_type_TB;
  reg [7:0]    Parallel_data_TB;
  wire         TX_OUT_TB, busy_TB;
  //wire         serial_done_TB, serial_EN_TB, mux_sel_TB, serial_data_TB, parity_bit_TB;
  
  //port mapping
  UART_TOP DUT (
  .parity_EN(parity_EN_TB),
  .data_valid(data_valid_TB),
  .CLK(CLK_TB),
  .RST(RST_TB),
  .parity_type(parity_type_TB),
  .Parallel_data(Parallel_data_TB),
  .TX_OUT(TX_OUT_TB),
  .busy(busy_TB)
  );

//clock generator
always #(0.5*CLK_CYCLE) CLK_TB =~CLK_TB;

//initial
initial
begin
  $dumpfile ("UART_TOP_TB.vrs");
  $dumpvars;
  
  CLK_TB=1'b0;
  RST_TB=1'b1; 
  parity_EN_TB=1'b0;
  data_valid_TB=1'b0;
  parity_type_TB=1'b0;
  Parallel_data_TB=8'b0;
  
  $display ("Reset");
  #(0.5*CLK_CYCLE)
  RST_TB=1'b0;
  #(0.5*CLK_CYCLE)
  if (!busy_TB && TX_OUT_TB)
    $display ("Reset succeded");
  else
    $display ("Reset Failed");
    
  $display ("data isn't valid yet");
  #(0.5*CLK_CYCLE)
  RST_TB=1'b1;
  Parallel_data_TB= 8'b10101010;
  parity_EN_TB=1'b0;
  data_valid_TB= 1'b0;
  #(2*CLK_CYCLE)
  if (!busy_TB && TX_OUT_TB)
    $display ("Data isn't taken(success)");
  else
    $display ("Test Failed");
  
  $display ("data is valid with no parity");
  #(0.3*CLK_CYCLE)
  data_valid_TB= 1'b1;
  #(CLK_CYCLE)
  data_valid_TB=1'b0;
  #(11*CLK_CYCLE) //10 for the data to be transmitted, 1 to return to idle state
  
  $display ("data is valid with even parity");
  #(0.3*CLK_CYCLE)
  data_valid_TB= 1'b1;
  parity_EN_TB=1'b1;
  parity_type_TB=1'b0;
  #(CLK_CYCLE)
  data_valid_TB=1'b0;
  #(12*CLK_CYCLE) //11 for the data to be transmitted, 1 to return to idle state
   
  $display ("data is valid with odd parity");
  #(CLK_CYCLE)
  data_valid_TB= 1'b1;
  parity_EN_TB=1'b1;
  parity_type_TB=1'b1;
  #(CLK_CYCLE)
  data_valid_TB=1'b0;
  #(12*CLK_CYCLE) //11 for the data to be transmitted, 1 to return to idle state
  
  $display ("sending data to TX while busy flag=1");
  #(CLK_CYCLE)
  data_valid_TB= 1'b1;
  parity_EN_TB=1'b0;
  #(CLK_CYCLE)
  data_valid_TB=1'b0;
  #(5*CLK_CYCLE)
  Parallel_data_TB=8'b11100100; //sending data in the middle of transmitting
  #(6*CLK_CYCLE) //5 for the data to finish transmitting, 1 to return to idle state
  
  $display("transmitting 2 frames");
  #(CLK_CYCLE)
  data_valid_TB= 1'b1;
  parity_EN_TB=1'b0;
  #(CLK_CYCLE)
  data_valid_TB=1'b0;
  #(10*CLK_CYCLE)
  data_valid_TB= 1'b1;
  parity_EN_TB=1'b1;
  parity_type_TB=1'b0;
  Parallel_data_TB=8'b11101100;
  #(CLK_CYCLE)
  data_valid_TB= 1'b0;
  #(13*CLK_CYCLE) //12 for the data to finish transmitting, 1 to return to idle state
  
  #(10*CLK_CYCLE)
  $finish;
  
end // end initial
endmodule
