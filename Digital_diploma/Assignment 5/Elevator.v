module Door_Controller (
  input      Activate , UP_max , DN_max,
  input      CLK,RST,
  output reg UP_motor,DN_motor
  );
 
 //Encoding 
  localparam IDLE = 3'b001,
            Mv_UP = 3'b010,
            Mv_DN = 3'b100;
 
 
 //Transition
 reg [2:0] current_state,next_state;
 always@(posedge CLK or negedge RST)
    begin
      if (!RST)  
       next_state<= IDLE;
      else
       current_state<=next_state;
    end          
            
 always @(*) 
  begin
    case(current_state) 
    IDLE: if (!Activate)
           begin 
            next_state=IDLE;
            UP_motor=1'b0;
            DN_motor=1'b0;
           end
           
          else if (Activate == 1 && DN_max == 1 && UP_max == 0)        
            begin 
             next_state=Mv_UP;
             UP_motor=1'b1;
             DN_motor=1'b0;
            end
         
         else if (Activate == 1 && DN_max == 0 && UP_max == 1)        
            begin 
             next_state=Mv_DN;
             UP_motor=1'b0;
             DN_motor=1'b1;
            end
  
  Mv_UP:  if (UP_max)
           begin 
             next_state=IDLE;
             UP_motor=1'b0;
             DN_motor=1'b0;
            end
          
          else
            begin 
             next_state=Mv_UP;
             UP_motor=1'b1;
             DN_motor=1'b0;
            end
            
 Mv_DN :  if (DN_max)
           begin 
             next_state=IDLE;
             UP_motor=1'b0;
             DN_motor=1'b0;
            end
          
          else
            begin 
             next_state=Mv_DN;
             UP_motor=1'b0;
             DN_motor=1'b1;
            end            
     endcase
   end
 endmodule         
