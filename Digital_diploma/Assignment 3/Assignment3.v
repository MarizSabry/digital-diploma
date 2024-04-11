module ALU_16bits (
input wire [0:15] A,B,
input wire CLK,
input wire [0:3] ALU_FUN,
output reg [0:15] ALU_OUT,ALU_REG,
output wire Arith_Flag,Logic_Flag,CMP_Flag,Shift_Flag
);

always@(posedge CLK)
begin
  ALU_OUT<=ALU_REG;
end

always@(*)
begin
  case(ALU_FUN)
    
    4'b0000:ALU_REG=A+B;
    4'b0001:ALU_REG=A-B;
    4'b0010:ALU_REG=A*B;
    4'b0011:ALU_REG=A/B;

    4'b0100:ALU_REG=A&B;
    4'b0101:ALU_REG=A|B;
    4'b0110:ALU_REG=~(A&B);
    4'b0111:ALU_REG=~(A|B);
    4'b1000:ALU_REG=A^B;
    4'b1001:ALU_REG=A~^B;
    
    4'b1010:
    begin
     if(A==B)
       ALU_REG=16'b1;
     else
       ALU_REG=16'b0;
    end
   
    4'b1011:
    begin
     if(A>B)
       ALU_REG=16'b10; 
     else
       ALU_REG=16'b0;  
    end
    
    4'b1100:
    begin
     if(A<B) 
      ALU_REG=16'b11;
     else 
      ALU_REG=16'b0;   
    end
    
    4'b1101:ALU_REG=A>>1;
    4'b1110:ALU_REG=A<<1;
     
    default:ALU_REG=16'b0;
     
  endcase
 end
 
 assign Arith_Flag=((ALU_FUN>=4'b0)&&(ALU_FUN<=4'b11));
 assign Logic_Flag=((ALU_FUN>=4'b0100)&&(ALU_FUN<=4'b1001));
 assign CMP_Flag=((ALU_FUN>=4'b1010)&&(ALU_FUN<=4'b1100));
 assign Shift_Flag=((ALU_FUN==4'b1101)||(ALU_FUN==4'b1110));
endmodule
