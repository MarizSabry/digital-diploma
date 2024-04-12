module Up_Dn_Counter (
input wire [4:0] IN,
input wire load, up,down,CLK,
output wire high,low,
output reg [4:0] counter
);

always@(posedge CLK)
begin
  if(load)
    begin
      counter<=IN;
    end
    
  else if(down&&!low)
    begin
      counter<=counter-5'b00001;
    end
    
  else if(up&&!high)
    begin
      counter<=counter+5'b00001;
    end
  end
  
  assign high=(counter==5'b11111);
  assign low=(counter==5'b00000);
  
endmodule
    
