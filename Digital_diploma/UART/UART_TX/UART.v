module UART_FSM (
  input            data_valid, parity_EN, serial_done,
  input            CLK, RST,
  output reg       busy, serial_EN,
  output reg [1:0] mux_sel
  );
  
  //encoding
  localparam idle= 5'b00001,
             start= 5'b00010,
             data= 5'b00100,
             parity= 5'b01000,
             stop= 5'b10000;
             
 // Internal signals
 reg [4:0] current_state,next_state;
 
 //state transition
 always @ (posedge CLK or negedge RST)
 begin
 if (!RST)
 current_state <= idle;
 else
 current_state <= next_state;
 end
 
 //next state and output logic
 always @ (*)
 begin
 case (current_state)
     idle :begin
            serial_EN = 1'b0;
            busy = 1'b0;
            mux_sel = 2'b11;
            if (data_valid)           
             next_state = start;
            else
             next_state = idle;
           end
           
      start: begin
              serial_EN = 1'b1;
              busy = 1'b0;
              mux_sel = 2'b00;
              next_state = data;
             end
             
      data: begin
             serial_EN = 1'b1;
             busy = 1'b1;
             mux_sel = 2'b01;
             if (serial_done)
               begin
                 case (parity_EN)
                   1'b1: next_state = parity;
                   1'b0: next_state = stop;
                 endcase
               end
              else
               next_state = data;
             end
            
      parity: begin
               serial_EN = 1'b0;
               busy = 1'b1;
               mux_sel = 2'b10;
               next_state = stop;
              end
              
      stop: begin
             serial_EN = 1'b0;
             busy = 1'b1;
             mux_sel = 2'b11;
             if (data_valid)
               next_state = start;
             else
               next_state = idle;
            end
            
    endcase
  end
endmodule

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


module UART_parity (
  input  wire        data_valid, CLK, RST, parity_type,
  input  wire  [7:0] Parallel_data,
  output reg         parity_bit
  );
  
  always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      parity_bit <= 1'b0;
    else if (!parity_type && data_valid)              //even parity
      parity_bit <= ^Parallel_data;
    else if (parity_type && data_valid)               //odd parity
      parity_bit <=  ~(^Parallel_data);
    else
      parity_bit <= parity_bit;
  end
      
endmodule

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
  
module UART_TOP (
  input wire   parity_EN, data_valid, CLK, RST, parity_type,
  input wire [7:0] Parallel_data,
  output wire TX_OUT, busy
  );
  
  //internal signals
  wire serial_done, serial_EN, serial_data, parity_bit;
  wire [1:0] mux_sel;
  
  UART_FSM u_FSM (
  .data_valid(data_valid),
  .parity_EN(parity_EN),
  .serial_done(serial_done),
  .CLK(CLK),
  .RST(RST),
  .busy(busy),
  .serial_EN(serial_EN),
  .mux_sel(mux_sel)
  );
  
  UART_serializer u_serial (
  .CLK(CLK),
  .RST(RST),
  .serial_EN(serial_EN),
  .busy(busy),
  .Parallel_data(Parallel_data),
  .serial_data(serial_data),
  .serial_done(serial_done)
  );
  
  UART_parity u_parity (
  .CLK(CLK),
  .RST(RST),
  .data_valid(data_valid),
  .Parallel_data(Parallel_data),
  .parity_bit(parity_bit),
  .parity_type(parity_type)
  );
  
  MUX u_MUX (
  .CLK(CLK),
  .RST(RST),
  .parity_bit(parity_bit),
  .serial_data(serial_data),
  .mux_sel(mux_sel),
  .TX_OUT(TX_OUT)
  );
  
endmodule 