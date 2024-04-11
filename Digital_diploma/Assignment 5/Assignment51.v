module LFSR #(parameter Taps=8'b01000100)(
input         DATA , 
input         ACTIVE, CLK, RST,
output reg    CRC,
output reg    VALID
);

reg [7:0] LFSR; 
wire      feedback;

assign feedback= DATA^LFSR[0];
integer N;

always @ (posedge CLK or negedge RST)
begin
  VALID<=1'b0;
  
  if (!RST)
    begin
      LFSR <= 8'b0;
    end
  else if (ACTIVE)
    begin
      LFSR[7]<=feedback;
      for (N=0; N<=6; N=N+1)
      if (Taps[N] == 0)
        LFSR[N]<=LFSR[N+1];
      else 
        LFSR[N]<=LFSR[N+1]^feedback;
    end
  else
    {LFSR[6:0],CRC}<=LFSR;
    VALID<=1'b1;
end
endmodule