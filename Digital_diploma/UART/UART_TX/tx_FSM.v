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
