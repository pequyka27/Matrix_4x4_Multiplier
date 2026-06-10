module Multiplier (
    input [31:0] rowA, 
    input [31:0] colB, 
    output signed [16:0] result
);

    wire signed[7:0] a0= rowA[0  +: 8];
    wire signed[7:0] a1= rowA[8  +: 8];
    wire signed[7:0] a2= rowA[16 +: 8];
    wire signed[7:0] a3= rowA[24 +: 8];

    wire signed[7:0] b0= colB[0  +: 8];
    wire signed[7:0] b1= colB[8  +: 8];
    wire signed[7:0] b2= colB[16 +: 8];
    wire signed[7:0] b3= colB[24 +: 8];

    assign result = (a0*b0) + (a1*b1) + (a2*b2) + (a3*b3);

endmodule
