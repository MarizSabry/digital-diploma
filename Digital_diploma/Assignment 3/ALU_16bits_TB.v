`timescale 1 us/1 ns

module ALU_16bits_TB();

//declare testbench signals
reg  [0:15]  A_TB ,B_TB;
reg  [0:3]   ALU_FUN_TB;
reg          CLK_TB;
wire [0:15]  ALU_OUT_TB ,ALU_REG_TB;
wire         Arith_Flag_TB ,Logic_Flag_TB ,CMP_Flag_TB ,Shift_Flag_TB;
 
//Port Mapping
ALU_16bits DUT (
.A(A_TB),
.B(B_TB),
.ALU_FUN(ALU_FUN_TB),
.CLK(CLK_TB),
.ALU_OUT(ALU_OUT_TB),
.ALU_REG(ALU_REG_TB),
.Arith_Flag(Arith_Flag_TB),
.Logic_Flag(Logic_Flag_TB),
.CMP_Flag(CMP_Flag_TB),
.Shift_Flag(Shift_Flag_TB)
);

//Clock Generator
always #5 CLK_TB=~CLK_TB;

//initial
initial
begin
  $dumpfile ("ALU_TB.vrs");
  $dumpvars;
//initial values  
  A_TB=16'b0;
  B_TB=16'b0;
  ALU_FUN_TB=4'b0;
  CLK_TB=1'b0;
  
  $display("Testing addition");
  #5
  A_TB=16'b1;
  B_TB=16'b0;
  ALU_FUN_TB=4'b0;
  #15
  if (Arith_Flag_TB==1'b1 && ALU_OUT_TB==16'b1)
    $display("Addition is correct");
  else
    $display("Addition failed");
    
  $display("Testing subtraction");
  #5
  A_TB=16'b1100;
  B_TB=16'b0101;
  ALU_FUN_TB=4'b1;
  #15
  if (Arith_Flag_TB==1'b1 && ALU_OUT_TB==16'b111)
    $display("Subtraction is correct");
  else
    $display("Subtraction failed");
    
  $display("Testing Multiplication");
  #5
  A_TB=16'b1;
  B_TB=16'b1;
  ALU_FUN_TB=4'b10;
  #15
  if (Arith_Flag_TB==1'B1 && ALU_OUT_TB==16'b1)
    $display("Multiplication is correct");
  else
    $display("Multiplication failed");
    
  $display("Testing Division");
  #5
  A_TB=16'b1000;
  B_TB=16'b0010;
  ALU_FUN_TB=4'b11;
  #15
  if (Arith_Flag_TB==1'B1 && ALU_OUT_TB==16'b0100)
    $display("Division is correct");
  else
    $display("Division failed");
    
  $display("Operation:AND");
  #5
  A_TB=16'b1010;
  B_TB=16'b1011;
  ALU_FUN_TB=4'b0100;
  #15
  if (Logic_Flag_TB==1'B1 && ALU_OUT_TB==16'b1010)
    $display("Operation AND succeeded");
  else
    $display("Operation AND failed");
    
  $display("Operation:OR");
  #5
  A_TB=16'b1001;
  B_TB=16'b1101;
  ALU_FUN_TB=4'b0101;
  #15
  if (Logic_Flag_TB==1'B1 && ALU_OUT_TB==16'b1101)
    $display("Operation OR succeeded");
  else
    $display("Operation OR failed"); 
    
  $display("Operation:NAND");
  #5
  A_TB=16'b10;
  B_TB=16'b11;
  ALU_FUN_TB=4'b0110;
  #15
  if (Logic_Flag_TB==1'b1 && ALU_OUT_TB==16'b1111111111111101)
    $display("Operation NAND succeeded");
  else
    $display("Operation NAND failed"); 
    
  $display("Operation:NOR");
  #5
  A_TB=16'b111001;
  B_TB=16'b110101;
  ALU_FUN_TB=4'b0111;
  #15
  if (Logic_Flag_TB==1'B1 && ALU_OUT_TB==16'b1111111111000010)
    $display("Operation NOR succeeded");
  else
    $display("Operation NOR failed"); 
    
  $display("Operation:XOR");
  #5
  A_TB=16'b1010;
  B_TB=16'b1011;
  ALU_FUN_TB=4'b1000;
  #15
  if (Logic_Flag_TB==1'B1 && ALU_OUT_TB==16'b1)
    $display("Operation XOR succeeded");
  else
    $display("Operation XOR failed");  
    
  $display("Operation:XNOR");
  #5
  A_TB=16'b111000;
  B_TB=16'b101010;
  ALU_FUN_TB=4'b1001;
  #15
  if (Logic_Flag_TB==1'B1 && ALU_OUT_TB==16'b1111111111101101)
    $display("Operation XNOR succeeded");
  else
    $display("Operation XNOR failed");
    
  $display("Testing equality");
  #5
  A_TB=16'b1010;
  B_TB=16'b1010;
  ALU_FUN_TB=4'b1010;
  #15
  if (CMP_Flag_TB==1'B1 && ALU_OUT_TB==16'b1)
    $display("A=B");
  else
    $display("Equality test failed");
    
  $display("Testing non equality");
  #5
  A_TB=16'b1010;
  B_TB=16'b1011;
  ALU_FUN_TB=4'b1010;
  #15
  if (CMP_Flag_TB==1'B1 && ALU_OUT_TB==16'b0)
    $display("A doesn't equal B");
  else
    $display("Non equality test failed"); 
    
  $display("A>B?");
  #5
  A_TB=16'b1011;
  B_TB=16'b1010;
  ALU_FUN_TB=4'b1011;
  #15
  if (CMP_Flag_TB==1'B1 && ALU_OUT_TB==16'b10)
    $display("Yes,A>B");
  else
    $display("Test failed");  
    
  $display("B>A?");
  #5
  A_TB=16'b1011;
  B_TB=16'b1010;
  ALU_FUN_TB=4'b1100;
  #15
  if (CMP_Flag_TB==1'B1 && ALU_OUT_TB==16'b0)
    $display("No,A>B(operation succeeded)");
  else
    $display("Test failed");  
    
  $display("Operation:Shift right");
  #5
  A_TB=16'b1010;
  ALU_FUN_TB=4'b1101;
  #15
  if (Shift_Flag_TB==1'B1 && ALU_OUT_TB==16'b0101)
    $display("Operation Shift right succeeded");
  else
    $display("Operation Shift right failed"); 
    
  $display("Operation:Shift left");
  #5
  A_TB=16'b10;
  ALU_FUN_TB=4'b1110;
  #15
  if (Shift_Flag_TB==1'B1 && ALU_OUT_TB==16'b100)
    $display("Operation Shift left succeeded");
  else
    $display("Operation Shift left failed");   
  
  $display("Testing default");
  #5
  A_TB=16'b10101100;
  B_TB=16'b11001010;
  ALU_FUN_TB=4'b1111;
  #15
  if (Shift_Flag_TB==1'B1||ALU_OUT_TB!=16'b0||Arith_Flag_TB==1'B1||CMP_Flag_TB==1'B1||Logic_Flag_TB==1'B1)
    $display("Error");
  else
    $display("deafault case succeeded"); 
  
  #20
$finish;

end
endmodule
