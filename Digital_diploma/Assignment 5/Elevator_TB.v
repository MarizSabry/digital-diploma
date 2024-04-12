`timescale 1 ns / 1 ps
module Door_Controller_TB ();
 
  // signals_TB 
  reg Activate_TB , UP_max_TB , DN_max_TB , CLK_TB , RST_TB; 
  wire UP_motor_TB , DN_motor_TB;

  
  //Testing
  initial
  begin
    //initial values
    initialization();
    
  $display ("Testing reset");
  #5
  reset();
  #15
  
  $display ("Idle to moving down");
      #10
      Activate_TB=1'b1; 
      UP_max_TB = 1'b1;
      DN_max_TB = 1'b0;
      RST_TB = 1'b1;
      #10
      
  $display ("moving down to idle");
      #10
      UP_max_TB = 1'b0;
      DN_max_TB = 1'b1;
      #10
      
 $display ("Idle to moving up");
      #10
      Activate_TB=1'b1; 
      UP_max_TB = 1'b0;
      DN_max_TB = 1'b1;
      #10
      
  $display ("moving up to idle");
      #10
      UP_max_TB = 1'b1;
      DN_max_TB = 1'b0;
      #10     
  #30
  $finish;
end
  
  //Initial Task
  task initialization();
    begin
      Activate_TB=1'b0; 
      UP_max_TB = 1'b0;
      DN_max_TB = 1'b0;
      CLK_TB = 1'b0;
      RST_TB = 1'b1;
    end
  endtask
  
  //Reset Task
  task reset;
   begin 
     RST_TB=1'b0;
   end
 endtask
 
 // port mapping
  Door_Controller DUT(
  .Activate(Activate_TB),
  .UP_max(UP_max_TB),
  .DN_max(DN_max_TB),
  .CLK(CLK_TB),
  .RST(RST_TB),
  .UP_motor(UP_motor_TB),
  .DN_motor(DN_motor_TB)
  ); 
  
   
  //clockg generator
  always #10 CLK_TB=~CLK_TB;
  
endmodule
