package seven_seg_pkg;

    function automatic logic [6:0] num_to_display(input logic [3:0] num);
        case (num)
            4'd0: num_to_display = 7'b1000000;
            4'd1: num_to_display = 7'b1111001;
            4'd2: num_to_display = 7'b0100100;
            4'd3: num_to_display = 7'b0110000;
            4'd4: num_to_display = 7'b0011001;
            4'd5: num_to_display = 7'b0010010;
            4'd6: num_to_display = 7'b0000010;
            4'd7: num_to_display = 7'b1111000;
            4'd8: num_to_display = 7'b0000000;
            4'd9: num_to_display = 7'b0010000;
            default: num_to_display = 7'b1111111;
        endcase
    endfunction
endpackage

module toggle(
    input logic clk,
    input logic rst,
    output logic [1:0] activate
);
    logic [15:0] refresh_count;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            refresh_count <= 0;
        end else begin
            refresh_count <= refresh_count + 1;
        end
    end
    assign activate = refresh_count[15:14];
endmodule

module blink_display(
    input logic clk, // clock
    input logic rst, // reset
    output logic blink
);
    logic [25:0] count;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 26'd0;
            blink <= 1'b1 ;
        end else begin
            if(count == 26'd50000000) begin
                count <= 26'd0;
                blink <= ~blink;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule