module UART_serializer (
  input  wire       RST,CLK,serial_EN,busy,
  input  wire [7:0] Parallel_data,
  output reg        serial_data, serial_done
  );
  
  reg [7:0] serial_data_reg;
  reg [3:0] counter;
  
  always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
      serial_data_reg <= 8'b0;
      serial_data <= 1'b0;
      counter = 4'b0;
      end
      
    else if (!busy && serial_EN && !serial_done)
      begin
      serial_data_reg <= Parallel_data;
      end
      
    else if (busy && serial_EN && !serial_done)
      begin
      serial_data <= serial_data_reg[0] ;
      serial_data_reg[0] <= serial_data_reg[1] ;
      serial_data_reg[1] <= serial_data_reg[2] ;
      serial_data_reg[2] <= serial_data_reg[3] ;
      serial_data_reg[3] <= serial_data_reg[4] ;
      serial_data_reg[4] <= serial_data_reg[5] ;
      serial_data_reg[5] <= serial_data_reg[6] ;
      serial_data_reg[6] <= serial_data_reg[7] ;
      serial_data_reg[7] <= 1'b0;
      counter <= counter + 1;
      end
      
    else //serial_EN=0
    begin
      serial_data_reg <= 8'b0;
      serial_data <= 1'b0 ;
      counter <= 4'b0;
    end
  end   
  
  always @(*)
  begin
    if (counter == 4'b1000)
       serial_done = 1'b1;
      else
       serial_done = 1'b0;
  end
  
endmodule

