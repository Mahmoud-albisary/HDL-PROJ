// ****** Next State Logic and Data Updates ******
// Note that we combined the next state logic and the data updates in one always_ff block for simplicity, but they can be separated if desired.
import state_types_pkg::*;

module update_state_data(
    input logic clk,
    input logic rst,
    input logic btnU_c,
    input logic btnD_c,
    input logic btnL_c,
    input logic btnR_c,
    input logic [5:0] tc_right_value,
    input logic [4:0] tc_left_value,
    output state_t state,
    output logic [5:0] right_value,
    output logic [4:0] left_value
);      

    logic btnU_prev;
    logic btnD_prev;
    logic btnR_prev;
    logic btnL_prev;
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin 
            state <= SET_MINUTES;
            right_value <= 6'd0;
            left_value <= 5'd0;
            btnU_prev <= 1'd0;
            btnD_prev <= 1'd0;
            btnR_prev <= 1'd0;
            btnL_prev <= 1'd0;
        end else begin
                btnU_prev <= btnU_c;
                btnD_prev <= btnD_c;
                btnR_prev <= btnR_c;
                btnL_prev <= btnL_c;
                case (state) 
                    SET_MINUTES: begin
                        if(btnU_c && !btnU_prev) begin
                            if(right_value == 6'd59) right_value <= 0;
                            else right_value <= right_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(right_value == 0) right_value <= 6'd59;
                            else right_value <= right_value - 1;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= SET_HOURS;
                        end
                    end

                    SET_HOURS: begin
                        if(btnU_c && !btnU_prev) begin
                            if(left_value == 5'd23) left_value <= 0;
                            else left_value <= left_value + 1;
                        end else if(btnD_c && !btnD_prev) begin
                            if(left_value == 0) left_value <= 5'd23;
                            else left_value <= left_value - 1;
                        end else if(btnL_c && !btnL_prev) begin
                            state <= DISPLAY;
                        end else if(btnR_c && !btnR_prev) begin
                            state <= SET_MINUTES;
                        end
                    end

                    DISPLAY: begin
                        if(btnL_c && !btnL_prev) begin
                            state <= SET_MINUTES;
                        end else begin
                            right_value <= tc_right_value;
                            left_value <= tc_left_value;
                        end
                    end
                endcase
        end
    end
// ***********************************************
endmodule
