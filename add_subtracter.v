
module adder_subtractor #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire             sub,       // 0: Add, 1: Subtract
    output wire [WIDTH-1:0] result,
    output wire             carry_out
);

    wire [WIDTH-1:0] B_mod;
    wire             carry_in;

    // Two's-complement subtraction: A - B = A + ~B + 1
    assign B_mod   = B ^ {WIDTH{sub}};
    assign carry_in = sub;

    // Shared adder datapath
    assign {carry_out, result} =
           {1'b0, A} + {1'b0, B_mod} + carry_in;

endmodule

