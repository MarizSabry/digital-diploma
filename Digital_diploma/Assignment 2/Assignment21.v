module DigCt(
input IN1,IN2,IN3,IN4,IN5,CLK,
output reg OUT1,OUT2,OUT3,
output reg n1,n2,D1,D2,D3
);

always@(posedge CLK)
begin
  OUT1<= D1;
  OUT2<= D2;
  OUT3<= D3;
end

always@(IN1,IN2,IN3)
begin
  n1=~(IN1|IN2);
  D1=~(n1&IN3);
end

always@(IN2,IN3)
begin 
  D2=~(IN2&IN3);
end

always@(IN3,IN4,IN5)
begin
  n2=(~(IN4)|IN3);
  D3=n2|IN5;
end
endmodule