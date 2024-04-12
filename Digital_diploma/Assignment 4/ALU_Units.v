module Decoder_Unit 
  (
  input wire [1:0] ALU_FUN,
  output reg       Arith_Enable,Logic_Enable,Shift_Enable,CMP_Enable
  );
  
  always@(*)
  begin
    Arith_Enable=1'b0;
    Logic_Enable=1'b0;
    Shift_Enable=1'b0;
    CMP_Enable=1'b0;
  
    case(ALU_FUN)
      2'b00:Arith_Enable=1'b1;
      2'b01:Logic_Enable=1'b1;
      2'b10:CMP_Enable=1'b1;
      2'b11:Shift_Enable=1'b1;
    endcase
  end
endmodule

///////////////////////////////////////////////////////////////////////

module ARITHMETIC_UNIT #(parameter Width = 16) 
 (
  input wire [Width-1:0]      A,B,
  input wire                  CLK,RST,Arith_Enable,
  input wire [1:0]            ALU_FUN,
  output reg [Width-1:0]      Arith_OUT,
  output reg                  Carry_OUT,Arith_Flag
  );
  
  reg [Width-1:0] Arith_REG;
  reg             Arith_Flag_REG;
  
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Arith_OUT<='b0;
        Arith_Flag<=1'b0;
      end
    
    else
      begin
        Arith_Flag<=Arith_Flag_REG;
        Arith_OUT<=Arith_REG;
      end
  end 
  
  always@(*)
  begin
    if (Arith_Enable)
      begin
        Arith_Flag_REG=1'b1;
        case(ALU_FUN)
          2'b00 : {Carry_OUT, Arith_REG } = A + B ;
          2'b01 : Arith_REG = A - B;
          2'b10 : Arith_REG = A * B;
          2'b11 : Arith_REG = A / B;
        endcase
     end 
   else
     begin
      Arith_REG='b0;
      Arith_Flag_REG=1'b0;
     end  
  end
  
endmodule

////////////////////////////////////////////////////////////////////////////////////////

module LOGIC_UNIT #(parameter Width = 16)
(
  input wire [Width-1:0]      A,B,
  input wire                  CLK,RST,Logic_Enable,
  input wire [1:0]            ALU_FUN,
  output reg [Width-1:0]      Logic_OUT,
  output reg                  Logic_Flag
);
  
  reg [Width-1:0] Logic_REG;
  reg             Logic_Flag_REG;
  
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Logic_Flag<=1'b0;
        Logic_OUT<='b0;
      end
      
    else
      begin        
        Logic_OUT<=Logic_REG;
        Logic_Flag<=Logic_Flag_REG;
      end
      
  end 
  
  always@(*)
  begin
    if (Logic_Enable)
      begin
        Logic_Flag_REG=1'b1;
        case(ALU_FUN)
          2'b00 : Logic_REG = A & B;
          2'b01 : Logic_REG = A | B;
          2'b10 : Logic_REG = ~(A & B);
          2'b11 : Logic_REG = ~(A | B);
        endcase
     end 
   else
    begin
     Logic_REG='b0;
     Logic_Flag_REG=1'b0;
    end 
  end
endmodule

////////////////////////////////////////////////////////////////////////////////////

module SHIFT_UNIT #(parameter Width = 16)
  (
  input wire [Width-1:0]      A,B,
  input wire                  CLK,RST,Shift_Enable,
  input wire [1:0]            ALU_FUN,
  output reg [Width-1:0]      Shift_OUT,
  output reg                  Shift_Flag
);

reg [Width-1:0] Shift_REG;
reg             Shift_Flag_REG;
  
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin        
        Shift_OUT<='b0;
        Shift_Flag<=1'b0;
      end
      
    else
      begin        
        Shift_OUT<=Shift_REG;
        Shift_Flag<=Shift_Flag_REG;
      end
      
  end 
  
  always@(*)
  begin
    if (Shift_Enable)
      begin
        Shift_Flag_REG=1'b1;
        case(ALU_FUN)
          2'b00 : Shift_REG = A>>1;
          2'b01 : Shift_REG = A<<1;
          2'b10 : Shift_REG = B>>1;
          2'b11 : Shift_REG = B<<1;
        endcase
     end 
   else
     begin
      Shift_REG='b0;
      Shift_Flag_REG=1'b0;
     end  
  end
endmodule

///////////////////////////////////////////////////////////////////

module CMP_UNIT #(parameter Width = 16)
 ( 
  input wire [Width-1:0]      A,B,
  input wire                  CLK,RST,CMP_Enable,
  input wire [1:0]            ALU_FUN,
  output reg [Width-1:0]      CMP_OUT,
  output reg                  CMP_Flag
);

reg [Width-1:0] CMP_REG;
reg             CMP_Flag_REG;
  
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin        
        CMP_OUT<='b0;
        CMP_Flag<=1'b0;
      end
      
    else
      begin        
        CMP_OUT<=CMP_REG;
        CMP_Flag<=CMP_Flag_REG;
      end
      
  end 
  
  always@(*)
  begin
    if (CMP_Enable)
      begin
        CMP_Flag_REG=1'b1;
        case(ALU_FUN)
          2'b00:CMP_REG='b0;
          
          2'b01:
             begin
              if(A==B)
                CMP_REG='b1;
              else
                CMP_REG='b0;
              end
   
          2'b10:
             begin
              if(A>B)
                 CMP_REG='b10; 
              else
                 CMP_REG='b0;  
              end
    
          2'b11:
             begin
              if(A<B) 
                 CMP_REG='b11;
              else 
                 CMP_REG='b0;   
              end
   
        endcase
      end 
   else
    begin
     CMP_REG='b0;
     CMP_Flag_REG=1'b0;  
    end  
  end
endmodule

////////////////////////////////////////////////////////////////////

module ALU_TOP #(parameter Width = 16)
  (
  input wire [Width-1:0]       A,B,
  input wire                   CLK,RST,
  input wire   [3:0]            ALU_FUN,
  output wire  [Width-1:0]      Arith_OUT,Logic_OUT,CMP_OUT,Shift_OUT,
  output wire                  Carry_OUT,Arith_Flag,Logic_Flag,CMP_Flag,Shift_Flag
  );
  
  //internal signals
  wire  Arith_Enable,Logic_Enable,Shift_Enable,CMP_Enable;
  
  
  
  Decoder_Unit u_Decoder
  (
  .ALU_FUN(ALU_FUN[3:2]),
  .Arith_Enable(Arith_Enable),
  .Logic_Enable(Logic_Enable),
  .Shift_Enable(Shift_Enable),
  .CMP_Enable(CMP_Enable)
  );
  
  ARITHMETIC_UNIT u_Arith_Unit
  (
  .A(A),
  .B(B),
  .CLK(CLK),
  .RST(RST),
  .Arith_Enable(Arith_Enable),
  .ALU_FUN(ALU_FUN[1:0]),
  .Arith_OUT(Arith_OUT),
  .Carry_OUT(Carry_OUT),
  .Arith_Flag(Arith_Flag)
  );
  
  LOGIC_UNIT u_Logic_Unit
  (
  .A(A),
  .B(B),
  .CLK(CLK),
  .RST(RST),
  .Logic_Enable(Logic_Enable),
  .ALU_FUN(ALU_FUN[1:0]),
  .Logic_OUT(Logic_OUT),
  .Logic_Flag(Logic_Flag)
  );
  
  SHIFT_UNIT u_Shift_Unit
  (
  .A(A),
  .B(B),
  .CLK(CLK),
  .RST(RST),
  .Shift_Enable(Shift_Enable),
  .ALU_FUN(ALU_FUN[1:0]),
  .Shift_OUT(Shift_OUT),
  .Shift_Flag(Shift_Flag)
  );
  
  CMP_UNIT u_CMP_Unit
  (
  .A(A),
  .B(B),
  .CLK(CLK),
  .RST(RST),
  .CMP_Enable(CMP_Enable),
  .ALU_FUN(ALU_FUN[1:0]),
  .CMP_OUT(CMP_OUT),
  .CMP_Flag(CMP_Flag)
  );
  
endmodule   
