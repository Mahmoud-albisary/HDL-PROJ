module debounce( //The debounce module to solve the bouncing problem for mechanincal buttons
    input logic clk,
    input logic btn,
    output logic clean
    );
    localparam int COUNT_MAX = 1000000; //Clock frequency is 100 MHz, so 1,000,000 counts will be 10ms to check that the calue is unchanged
    logic [$clog2(COUNT_MAX+1)-1: 0] count;
    always_ff @(posedge clk) begin

        if(clean == btn) begin  
            count <= 0;
        end 
        else if (COUNT_MAX == count) begin
            clean <= btn;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule