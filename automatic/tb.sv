`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    function integer static_factorial (input [31:0] operand);
        if (operand >= 2)
            static_factorial = static_factorial (operand - 1) * operand;
        else
            static_factorial = 1;
    endfunction

    integer result;

    function automatic integer automatic_factorial (input [31:0] operand);
        if (operand >= 2)
            automatic_factorial = automatic_factorial (operand - 1) * operand;
        else
            automatic_factorial = 1;
    endfunction

    integer result;

    initial begin
        for (int n = 0; n <= 7; n++) begin
            result = static_factorial(n);
            $display("%0d static_factorial=%0d", n, result);
        end
        for (int n = 0; n <= 7; n++) begin
            result = automatic_factorial(n);
            $display("%0d automatic_factorial=%0d", n, result);
        end
        for (int i=0; i<3; i++) begin
            automatic int loop3 = 0;
            for (int j=0; j<3; j++) begin
                loop3++;
                $display("automatic int: %0d", loop3);
            end
        end
        for (int i=0; i<3; i++) begin
            static int loop2 = 0;
            for (int j=0; j<3; j++) begin
                loop2++;
                $display("static int: %0d", loop2);
            end
        end
        for (int i=0; i<3; i++) begin
            int loop3 = 0;
            for (int i=0; i<3; i++) begin
                loop3++;
                $display("int: %0d", loop3);
            end
        end
    end
endmodule
