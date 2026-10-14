
`timescale 1ns/1ps

module tb_adder_subtractor;

    reg  [31:0] A, B;
    reg         sub;
    wire [31:0] result;
    wire        carry_out;

    integer errors = 0;

    adder_subtractor #(.WIDTH(32)) dut (
        .A(A),
        .B(B),
        .sub(sub),
        .result(result),
        .carry_out(carry_out)
    );

    task check;
        input [31:0] a, b;
        input        s;
        input [31:0] expected;
        begin
            A = a;
            B = b;
            sub = s;
            #10;

            if (result !== expected) begin
                $display("FAIL: A=%h B=%h sub=%b result=%h expected=%h",
                         A, B, sub, result, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: A=%h B=%h sub=%b result=%h",
                         A, B, sub, result);
            end
        end
    endtask

    initial begin
        check(32'd10, 32'd5,  1'b0, 32'd15);
        check(32'd10, 32'd5,  1'b1, 32'd5);
        check(32'd5,  32'd10, 1'b1, 32'hFFFFFFFB);
        check(32'hFFFFFFFF, 32'd1, 1'b0, 32'd0);
        check(32'd0,  32'd0,  1'b1, 32'd0);
        check(32'h7FFFFFFF, 32'd1, 1'b0, 32'h80000000);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $finish;
    end

endmodule

