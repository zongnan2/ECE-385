module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	logic Cf0,Cf1,Cf2;
	four_bit_ra FRA0(.A(A[3:0]), .B(B[3:0]), .Cin(0), .S(Sum[3:0]), .Cout(Cf0));
	four_bit_ra FRA1(.A(A[7:4]), .B(B[7:4]), .Cin(Cf0), .S(Sum[7:4]), .Cout(Cf1));
	four_bit_ra FRA2(.A(A[11:8]), .B(B[11:8]), .Cin(Cf1), .S(Sum[11:8]), .Cout(Cf2));
	four_bit_ra FRA3(.A(A[15:12]), .B(B[15:12]), .Cin(Cf2), .S(Sum[15:12]), .Cout(CO));
     
endmodule

module four_bit_ra
(
	input [3:0] A,
	input [3:0] B,
	input Cin,
	output logic [3:0] S,
	output logic Cout
	
);

	logic C0,C1,C2;
	full_adder fa0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(C0));
	full_adder fa1(.A(A[1]), .B(B[1]), .Cin(C0), .S(S[1]), .Cout(C1));
	full_adder fa2(.A(A[2]), .B(B[2]), .Cin(C1), .S(S[2]), .Cout(C2));
	full_adder fa3(.A(A[3]), .B(B[3]), .Cin(C2), .S(S[3]), .Cout(Cout));

endmodule




module full_adder
(
	input A,
	input B,
	input Cin,
	output logic S,
	output logic Cout

);


	assign S = A^B^Cin;
	assign Cout = (A&B)|(A&Cin)|(B&Cin);
	

endmodule

