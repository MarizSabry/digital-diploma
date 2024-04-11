`timescale 1 us/1 ns
 
module Register_TB();
   
   //declare testbench signals
    reg             WrEn_TB, RdEn_TB;
    reg             clk_TB,reset_TB;
    reg    [2:0]    address_TB;
    reg    [15:0]   WrData_TB;
    wire   [15:0]   RdData_TB;
    reg    [15:0]   Register_File_TB [7:0];
    
    //port mapping
    Register DUT(
    .WrEn(WrEn_TB),
    .RdEn(RdEn_TB),
    .clk(clk_TB),
    .reset(reset_TB),
    .address(address_TB),
    .WrData(WrData_TB),
    .RdData(RdData_TB)
    );
    
    //Clock Generator
    always #5 clk_TB=~clk_TB;
    
    
    initial
    begin
    $dumpfile ("Register_TB.vrs");
    $dumpvars;
    
    //initial values
    WrEn_TB=1'b0;
    RdEn_TB=1'b0;
    clk_TB=1'b0;
    reset_TB=1'b1;
    address_TB=3'b0;
    WrData_TB=16'b0;
    
    $display("Testing Asynchronous Active low Reset");
    #3
    reset_TB=1'b0;
    #7
    
    $display("Testing Write1 Operation");
    #3
    reset_TB=1'b1;
    WrEn_TB=1'b1;
    RdEn_TB=1'b0;
    address_TB=3'b0;
    WrData_TB=16'b10101;
    #7
    
    $display("Testing Read1 Operation");
    #3
    WrEn_TB=1'b0;
    RdEn_TB=1'b1;
    address_TB=3'b111;
    #7
    if (RdData_TB==16'b0)
       $display("Read1 Operation succeeded");
    else
       $display("Read1 Operation failed");
    
    $display ("Testing Write2 Operation");
    #3
    WrEn_TB=1'b1;
    RdEn_TB=1'b0;
    address_TB=3'b110;
    WrData_TB=16'b1111;
    #7
   
      
    $display("Testing Read2 Operation");
    #3
    WrEn_TB=1'b0;
    RdEn_TB=1'b1;
    address_TB=3'b110;
    #7
    if (RdData_TB==16'b1111)
       $display("Read2 Operation succeeded");
    else
       $display("Read2 Operation failed");   
  
  
#20
$finish;

end
endmodule 