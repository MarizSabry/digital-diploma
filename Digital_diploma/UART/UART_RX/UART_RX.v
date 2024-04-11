module UART_RX_FSM (
  
input        CLK,RST,
input        parity_en, parity_type, 
input [3:0]  bit_count,
input [4:0]  edge_count,
input        start_glitch, parity_error, stop_error,
input        RX_IN,
output reg   data_sample_en, start_chk, stop_chk, 
output reg   counter_en, parity_chk, deserial_en, data_valid

);

//encoding
localparam  idle         = 6'b000001,
            start_check  = 6'b000010,
            deserializer = 6'b000100,
            parity_check = 6'b001000,
            stop_check   = 6'b010000,
            error_free   = 6'b100000;
            
//internal signals
reg [5:0] current_state, next_state;

//state transition
always @ (posedge CLK or negedge RST)
begin
if (!RST)
  current_state <= idle;
else
  next_state <= current_state;
end

//output and next state logic

always @ (*)
begin
case (current_state)
idle : begin
        data_sample_en = 1'b0;
        start_chk = 1'b0;
        stop_chk = 1'b0;
        counter_en = 1'b0;
        parity_chk = 1'b0;
        deserial_en = 1'b0;
        data_valid  = 1'b0;
        
     if (RX_IN==0)
        next_state = start_check;
     else
        next_state = idle;
     end
     
start_check : 
    begin
        data_sample_en = 1'b1;
        start_chk = 1'b1;
        stop_chk = 1'b0;
        counter_en = 1'b1;
        parity_chk = 1'b0;
        deserial_en = 1'b0;
        data_valid  = 1'b0;
        
     if (start_glitch==0 && bit_count==1 && edge_count==0)
        next_state = deserializer;
     else if(start_glitch==1 && bit_count==1 && edge_count==0)
        next_state = idle;
     else
        next_state = start_check;
     end
    

deserializer:
    begin
        data_sample_en = 1'b1;
        start_chk = 1'b0;
        stop_chk = 1'b0;
        counter_en = 1'b1;
        parity_chk = 1'b0;
        deserial_en = 1'b1;
        data_valid  = 1'b0;
        
     if (parity_en==0 && bit_count==4'd8 && edge_count==5'd7)
        next_state = stop_check;
     else if (parity_en==1 && bit_count==4'd8 && edge_count==5'd7)
        next_state = parity_check;
     else
        next_state = deserializer;
     end
    
parity_check:
    begin
        data_sample_en = 1'b1;
        start_chk = 1'b0;
        stop_chk = 1'b0;
        counter_en = 1'b1;
        parity_chk = 1'b1;
        deserial_en = 1'b0;
        data_valid  = 1'b0;
        
     if (parity_error==0 && bit_count==4'd9 && edge_count==5'd7)
        next_state = stop_check;
     else if (parity_error==1 && bit_count==4'd9 && edge_count==5'd7)
        next_state = idle;
     else
        next_state = parity_check;
     end
    
stop_check:
    begin
        data_sample_en = 1'b1;
        start_chk = 1'b0;
        stop_chk = 1'b1;
        counter_en = 1'b1;
        parity_chk = 1'b0;
        deserial_en = 1'b0;
        data_valid  = 1'b0;
        
     if (stop_error==0 && bit_count==4'd10 && edge_count==5'd7)
        next_state = error_free;
     else if (stop_error==1 && bit_count==4'd10 && edge_count==5'd7)
        next_state = idle;
     else 
        next_state = stop_check;
     end
    
error_free:
    begin
        data_sample_en = 1'b0;
        start_chk = 1'b0;
        stop_chk = 1'b0;
        counter_en = 1'b0;
        parity_chk = 1'b0;
        deserial_en = 1'b1;
        data_valid  = 1'b1;
        next_state = idle;
    end
endcase
end

endmodule

module UART_RX_strt_chk (
  input sampled_bit, start_chk_en, CLK,RST,
  output reg start_glitch
  );

always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      start_glitch <= 1'b0;
    else if (start_chk_en && !sampled_bit) 
      start_glitch <= 1'b0;
    else if (start_chk_en && sampled_bit)
      start_glitch <= 1'b1;
  end
endmodule

module UART_RX_stop_chk (
  input sampled_bit, stop_chk_en, CLK,RST,
  output reg stop_error
  );

always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      stop_error <= 1'b0;
    else if (stop_chk_en && sampled_bit) 
      stop_error <= 1'b0;
    else if (stop_chk_en && !sampled_bit)
      stop_error <= 1'b1;
  end
endmodule 

module parity_check (
  input      sampled_bit, parity_check_en, CLK, RST,
  input      parity_type, Parallel_data,                  //parallel data come from deserializer
  output reg parity_error
  );
  
  reg parity_bit;
  
  always @ (posedge CLK  or negedge RST)
  begin
  parity_error <= 1'b0;
  parity_bit <= 1'b0;
  
    if (!RST)
      parity_error <= 1'b0;
      
    else if (!parity_type)                            //even parity
      begin
      parity_bit <= ^Parallel_data;
      if (parity_bit == sampled_bit)
        parity_error <= 1'b0;
      else
        parity_error <= 1'b1;
      end
      
    else                                             //odd parity
      begin
      parity_bit <=  ~(^Parallel_data);
      if (parity_bit == sampled_bit)
        parity_error <= 1'b0;
      else
        parity_error <= 1'b1;
      end
  end
endmodule

module deserializer (
  input            deserial_en, sampled_bit, CLK, RST,
  output reg [7:0] Parallel_data
  );
  
  reg [7:0] shift_reg;
  
always @(posedge CLK or negedge RST)
begin 
  Parallel_data <= 8'b0;
  shift_reg <= 8'b0;
  
  if (!RST)
    begin
      Parallel_data <= 8'b0;
      shift_reg <= 8'b0;
    end
    
  else if (deserial_en)
    begin
      shift_reg <= {sampled_bit, shift_reg[7:1]};
      Parallel_data <= shift_reg;
    end
    
  else
    Parallel_data <= Parallel_data;
end
endmodule

module edge_bit_counter (
  input            counter_en, RST, CLK, parity_en,
  input [4:0]      prescale,            //prescale max = 16
  output reg [4:0] edge_count,
  output reg [3:0] bit_count
  );
  
  always @ (posedge CLK or negedge RST)
  begin
  if (!RST)
    begin
      bit_count <= 4'b0;
      edge_count <= 5'b0;
    end
    
  else if (counter_en && edge_count!= prescale)    //edge count = !prescale
    begin
    edge_count <= edge_count + 5'b1;
    bit_count <= bit_count;
    end  
    
  else if (counter_en && edge_count==prescale && parity_en==1'b1)
    begin
      if (bit_count==4'b1011)
        begin
        bit_count <= 4'b0;
        edge_count <= 5'b0;
        end
        
      else 
        begin
        bit_count <= bit_count + 4'b1;
        edge_count <= 5'b0;
        end
    end
    
  else if (counter_en && edge_count==prescale && parity_en==1'b0)
    begin
      if (bit_count==4'b1010)
        begin
        bit_count <= 4'b0;
        edge_count <= 5'b0;
        end
        
      else 
        begin
        bit_count <= bit_count + 4'b1;
        edge_count <= 5'b0;
        end
    end
  end
endmodule

module data_sampling (
  input       data_sample_en, CLK,RST, RX_IN,
  input [4:0] prescale,     // maximum prescale =16
  input [3:0] edge_count,
  output reg  sampled_bit
  );
  
  reg [2:0] s;  //oversampling = 3 //samples
  
  always @ (posedge CLK or negedge RST)
  begin
    sampled_bit <=1'b0;
    s <= 3'b0;
    if (!RST)
      begin
      sampled_bit <=1'b0;
      s <= 3'b0;
      end
      
    else if (data_sample_en && edge_count==prescale>>2)
      s[0] <= RX_IN; 
    
    else if (data_sample_en && edge_count==(prescale>>2)+'b1)
      begin
      s[1] <= RX_IN;
      s[0] <= s[0]; 
      end
    
    else if (data_sample_en && edge_count==(prescale>>2)-'b1)
      begin
      s[2] <= RX_IN; 
      s[1] <= s[1];
      s[0] <= s[0];
      sampled_bit <= ((s[0] & s[1]) | s[2] & (s[0] ^ s[1]));
      end
    
    else 
      sampled_bit <=1'b0;
  end
endmodule

module UART_RX_top (
  input          RX_IN, parity_en, parity_type, CLK, RST,
  input [4:0]    prescale,
  output         data_valid, parity_error, stop_error,
  output [7:0]   parallel_data
  );
  
  //INTERNAL SIGNALS
  
wire   [3:0]           bit_count ;
wire   [4:0]           edge_count ;
wire                   count_en ,deserial_en , parity_chk, stop_chk ,start_chk,data_sample_en; 
wire                   start_glitch, sampled_bit;

UART_RX_FSM U0_RX_FSM (
.CLK(CLK),
.RST(RST),
.parity_en(parity_en),
.parity_type(parity_type), 
.bit_count(bit_count),
.edge_count(edge_count),
.start_glitch(start_glitch),
.parity_error(parity_error),
.stop_error(stop_error),
.RX_IN(RX_IN),
.data_sample_en(data_sample_en),
.start_chk(start_chk),
.stop_chk(stop_chk), 
.counter_en(count_en),
.parity_chk(parity_chk),
.deserial_en(deserial_en),
.data_valid(data_valid)
);

UART_RX_strt_chk U1_start_chk(
.sampled_bit(sampled_bit),
.start_chk_en(start_chk),
.CLK(CLK),
.RST(RST),
.start_glitch(start_glitch)
);

UART_RX_stop_chk U2_stop_chk(
.sampled_bit(sampled_bit),
.stop_chk_en(stop_chk),
.CLK(CLK),
.RST(RST),
.stop_error(stop_error)
  );
  
parity_check U3_parity_chk (
.sampled_bit(sampled_bit),
.parity_check_en(parity_chk),
.CLK(CLK),
.RST(RST),
.parity_type(parity_type),
.Parallel_data(parallel_data),
.parity_error(parity_error)
  );
  
deserializer U4_deserial(
.deserial_en(deserial_en),
.sampled_bit(sampled_bit),
.CLK(CLK),
.RST(RST),
.Parallel_data(parallel_data)
);

edge_bit_counter U5_Count(
.counter_en(count_en),
.RST(RST),
.CLK(CLK),
.parity_en(parity_en),
.prescale(prescale),
.edge_count(edge_count),
.bit_count(bit_count)
);

data_sampling U6_data_sampling(
.data_sample_en(data_sample_en),
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.prescale(prescale),
.edge_count(edge_count),
.sampled_bit(sampled_bit)
);

endmodule