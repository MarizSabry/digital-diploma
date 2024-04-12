module MUX (
  input wire         parity_bit, serial_data, CLK, RST,
  input wire [1:0]   mux_sel,
  output reg         TX_OUT
  );
  
  reg TX_OUT_start;
  
  always @ (posedge CLK  or negedge RST)
  begin
    if (!RST)
      TX_OUT <= 1'b1;
    else
      begin
      case (mux_sel)
        2'b00: begin
               TX_OUT_start <= 1'b0;
               TX_OUT <= TX_OUT_start;
               end
        
        2'b01: TX_OUT <= serial_data;
        2'b10: TX_OUT <= parity_bit;
        2'b11: TX_OUT <= 1'b1;
      endcase
      end
    end
  endmodule
