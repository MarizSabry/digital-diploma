`timescale 1 us/1 ns

module ALU_TOP_TB ();
  
//declare Testbench signals
reg   [15:0]          A_TB , B_TB;
reg                   CLK_TB , RST_TB;
reg   [3:0]           ALU_FUN_TB;
wire  [15:0]          Arith_OUT_TB , Logic_OUT_TB , CMP_OUT_TB , Shift_OUT_TB;
wire                  Carry_OUT_TB , Arith_Flag_TB , Logic_Flag_TB , CMP_Flag_TB , Shift_Flag_TB;
wire                  Arith_Enable_TB ,Logic_Enable_TB ,Shift_Enable_TB ,CMP_Enable_TB;
   
//Port Mapping
ALU_TOP #(16)DUT (
.A(A_TB),
.B(B_TB),
.ALU_FUN(ALU_FUN_TB),
.CLK(CLK_TB),
.RST(RST_TB),
.Arith_OUT(Arith_OUT_TB),
.Logic_OUT(Logic_OUT_TB),
.CMP_OUT(CMP_OUT_TB),
.Shift_OUT(Shift_OUT_TB),
.Carry_OUT(Carry_OUT_TB),
.Arith_Flag(Arith_Flag_TB),
.Logic_Flag(Logic_Flag_TB),
.CMP_Flag(CMP_Flag_TB),
.Shift_Flag(Shift_Flag_TB)
);

//Clock Generator
always 
begin
  if (CLK_TB)
   #6 CLK_TB= (~CLK_TB);
  else
   #4 CLK_TB= (~CLK_TB);
end

//initial
initial
begin
  $dumpfile ("ALU_TOP_TB.vrs");
  $dumpvars;
//initial values    
  A_TB='b0;
  B_TB='b0;
  CLK_TB=1'b0;
  RST_TB=1'b1;
  ALU_FUN_TB=4'b0;
  
  $display("Testing addition");
  #4
  A_TB='b1;
  B_TB='b0;
  ALU_FUN_TB=4'b0;
  #16
  if (Arith_Flag_TB==1'b1 && Arith_OUT_TB=='b1)
    $display("Addition is correct");
  else
    $display("Addition failed");
    
  $display("Testing subtraction");
  #4
  A_TB='b1100;
  B_TB='b0101;
  ALU_FUN_TB=4'b1;
  #16
  if (Arith_Flag_TB==1'b1 && Arith_OUT_TB=='b111)
    $display("Subtraction is correct");
  else
    $display("Subtraction failed");
    
  $display("Testing Multiplication");
  #4
  A_TB='b10;
  B_TB='b100;
  ALU_FUN_TB=4'b10;
  #16
  if (Arith_Flag_TB==1'B1 && Arith_OUT_TB=='b1000)
    $display("Multiplication is correct");
  else
    $display("Multiplication failed");
    
  $display("Testing Division");
  #4
  A_TB='b1000;
  B_TB='b0010;
  ALU_FUN_TB=4'b11;
  #16
  if (Arith_Flag_TB==1'B1 && Arith_OUT_TB=='b100)
    $display("Division is correct");
  else
    $display("Division failed");
    
  $display("Operation:AND");
  #4
  A_TB='b1010;
  B_TB='b1011;
  ALU_FUN_TB=4'b0100;
  #16
  if (Logic_Flag_TB==1'B1 && Logic_OUT_TB=='b1010)
    $display("Operation AND succeeded");
  else
    $display("Operation AND failed");
    
  $display("Operation:OR");
  #4
  A_TB='b1001;
  B_TB='b1101;
  ALU_FUN_TB=4'b0101;
  #16
  if (Logic_Flag_TB==1'B1 && Logic_OUT_TB=='b1101)
    $display("Operation OR succeeded");
  else
    $display("Operation OR failed"); 
    
  $display("Operation:NAND");
  #4
  A_TB='b10;
  B_TB='b11;
  ALU_FUN_TB=4'b0110;
  #16
  if (Logic_Flag_TB == 1'b1 && Logic_OUT_TB=='b1111111111111101)
    $display("Operation NAND succeeded");
  else
    $display("Operation NAND failed"); 
    
  $display("Operation:NOR");
  #4
  A_TB='b111001;
  B_TB='b110101;
  ALU_FUN_TB=4'b0111;
  #16
  if (Logic_Flag_TB==1'B1 && Logic_OUT_TB=='b1111111111000010)
    $display("Operation NOR succeeded");
  else
    $display("Operation NOR failed"); 

$display("Testing No Operation");
#4
A_TB='b111001;
B_TB='b110101;
ALU_FUN_TB=4'b1000;
#16
if (CMP_Flag_TB==1'b1 && CMP_OUT_TB=='b0)
  $display ("Testing no operation passed");
else
  $display("Testing no operation failed");
  
  $display("Testing equality");
  #4
  A_TB='b1010;
  B_TB='b1010;
  ALU_FUN_TB=4'b1001;
  #16
  if (CMP_Flag_TB==1'B1 && CMP_OUT_TB=='b1)
    $display("A=B");
  else
    $display("Equality test failed");
    
  $display("Testing non equality");
  #4
  A_TB='b1010;
  B_TB='b1011;
  ALU_FUN_TB=4'b1001;
  #16
  if (CMP_Flag_TB==1'B1 && CMP_OUT_TB=='b0)
    $display("A doesn't equal B");
  else
    $display("Non equality test failed"); 
    
  $display("A>B?");
  #4
  A_TB='b1011;
  B_TB='b1010;
  ALU_FUN_TB=4'b1010;
  #16
  if (CMP_Flag_TB==1'B1 && CMP_OUT_TB=='b10)
    $display("Yes,A>B");
  else
    $display("Test failed");  
   
  $display("Testing Asynchronous Active low Reset");
  #4
  RST_TB=1'b0;
  #16
  if (Arith_OUT_TB=='b0 && Logic_OUT_TB=='b0 && CMP_OUT_TB=='b0 && Shift_OUT_TB=='b0 && Carry_OUT_TB==1'b0 && Arith_Flag_TB==1'b0 && Logic_Flag_TB==1'b0 && CMP_Flag_TB ==1'b0 && Shift_Flag_TB==1'b0)
    $display("Reset succeeded");
  else
    $display("Reset Failed");
    
    
  $display("B>A?");
  #4
  RST_TB=1'b1;
  A_TB='b1011;
  B_TB='b1010;
  ALU_FUN_TB=4'b1011;
  #16
  if (CMP_Flag_TB==1'B1 && CMP_OUT_TB=='b0)
    $display("No,A>B(operation succeeded)");
  else
    $display("Test failed");  
    
  $display("Operation:A Shift right");
  #4
  A_TB='b1010;
  ALU_FUN_TB=4'b1100;
  #16
  if (Shift_Flag_TB==1'B1 && Shift_OUT_TB=='b0101)
    $display("A Shift right succeeded");
  else
    $display("A Shift right failed"); 
    
  $display("Operation:A Shift left");
  #4
  A_TB='b10;
  ALU_FUN_TB=4'b1101;
  #16
  if (Shift_Flag_TB==1'B1 && Shift_OUT_TB=='b100)
    $display("A Shift left succeeded");
  else
    $display("A Shift left failed");   
  
    $display("Operation:B Shift right");
  #4
  B_TB='b100;
  ALU_FUN_TB=4'b1110;
  #16
  if (Shift_Flag_TB==1'B1 && Shift_OUT_TB=='b010)
    $display("B Shift right succeeded");
  else
    $display("B Shift right failed"); 
    
  $display("Operation:B Shift left");
  #4
  B_TB='b100;
  ALU_FUN_TB=4'b1111;
  #16
  if (Shift_Flag_TB==1'B1 && Shift_OUT_TB=='b1000)
    $display("B Shift left succeeded");
  else
    $display("B Shift left failed");   
  
  #20
$finish;

end
endmodule 