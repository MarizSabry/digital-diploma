`timescale 1 ns / 1 ps

module LFSR_TB  #(parameter CLK_Period=100) ();
  
  //TB signals
  reg     ACTIVE_TB, CLK_TB, RST_TB;
  reg     DATA_TB;
  wire    CRC_TB,VALID_TB;
  
  //Port mapping
  LFSR DUT (
  .DATA(DATA_TB),
  .ACTIVE(ACTIVE_TB),
  .CLK(CLK_TB),
  .RST(RST_TB),
  .CRC(CRC_TB),
  .VALID(VALID_TB)
  );
  
  
  //Clock Generator
  always #50 CLK_TB=~CLK_TB;
  
  //initial
  initial
  begin
   DATA_TB=1'b0;
   ACTIVE_TB=1'b0;
   CLK_TB=1'b0;
   RST_TB=1'b1; 
   
   $display ("Asynchronous Reset");
   #40
   RST_TB=1'b0; 
   #60
   
   $display("Data in:1 byte");
   
   ACTIVE_TB=1'b1;
   RST_TB=1'b1; 
   data_in(1);
   data_in(0);
   data_in(0);
   data_in(0);
   data_in(1);
   data_in(1);
   data_in(1);
   data_in(0);
   #CLK_Period
   
   $display("CRC out(1 byte in)");
   ACTIVE_TB=1'b0;
   #(8*CLK_Period)
   
   $display("Data in:3 bytes");
   ACTIVE_TB=1'b1;
   data_in(1);
   data_in(0);
   data_in(0);
   data_in(1);
   data_in(0);
   data_in(1);
   data_in(0);
   data_in(1);
   
   data_in(1);
   data_in(1);
   data_in(1);
   data_in(0);
   data_in(0);
   data_in(1);
   data_in(0);
   data_in(1);
   
   data_in(0);
   data_in(0);
   data_in(1);
   data_in(0);
   data_in(1);
   data_in(1);
   data_in(1);
   data_in(1);
   #CLK_Period
   
   $display("CRC out(3 bytes in)");
   ACTIVE_TB=1'b0;
   #(8*CLK_Period)
   
 
 #200
 $finish;
 end

task data_in;
  input A;
begin
  #CLK_Period
  DATA_TB<=A;
end
endtask
endmodule