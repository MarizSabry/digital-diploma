module Register(
    input  wire          WrEn, RdEn,
    input  wire          clk,reset,
    input  wire  [2:0]   address,
    input  wire  [15:0]  WrData, 
    output reg   [15:0]  RdData
);

    reg [15:0] Register_File [7:0]; 

    always @(posedge clk or negedge reset)
      begin
        
        if(!reset)
            begin
              Register_File[0] <= 16'b0 ;
              Register_File[1] <= 16'b0 ;
              Register_File[2] <= 16'b0 ;
              Register_File[3] <= 16'b0 ;
              Register_File[4] <= 16'b0 ;
              Register_File[5] <= 16'b0 ;
              Register_File[6] <= 16'b0 ;
              Register_File[7] <= 16'b0 ;
              
            end 
		    else if (WrEn)
            Register_File[address] <= WrData;
          
        else if (RdEn)
            RdData<=Register_File[address];
              
      end
      
           
endmodule
