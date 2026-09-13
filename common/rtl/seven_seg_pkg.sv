`timescale 1ns / 1ps
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
            4'd10: num_to_display = 7'b0001000; // S
            4'd11: num_to_display = 7'b0000011; // t
            default: num_to_display = 7'b1111111;
        endcase
    endfunction
endpackage

module toggle #(
    parameter int REFRESH_BITS_HIGH = 15,
    parameter int REFRESH_BITS_LOW  = 14
)(
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
    assign activate = refresh_count[REFRESH_BITS_HIGH:REFRESH_BITS_LOW];
endmodule

module blink_display # (
    parameter int REFRESH_COUNT = 50000000 // 50 ms blink at 100 MHz
)(
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
            if(count == REFRESH_COUNT) begin
                count <= 26'd0;
                blink <= ~blink;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule