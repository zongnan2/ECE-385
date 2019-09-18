module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	logic [2:0] C;
	fourbit_ra f0(.A(A[3:0]), .B(B[3:0]), .Cin(0), .S(Sum[3:0]), .Cout(C[0]));
	fourbit_csa f1(.A(A[7:4]), .B(B[7:4]), .Cin(C[0]), .Sout(Sum[7:4]), .Cout(C[1]));
	fourbit_csa f2(.A(A[11:8]), .B(B[11:8]), .Cin(C[1]), .Sout(Sum[11:8]), .Cout(C[2]));
	fourbit_csa f3(.A(A[15:12]), .B(B[15:12]), .Cin(C[2]), .Sout(Sum[15:12]), .Cout(CO));

endmodule



module fourbit_csa
(
	input [3:0] A,
	input [3:0] B,
	input Cin,
	output logic [3:0] Sout,
	output logic Cout
);

	logic [3:0] S0, S1;
	logic Cout0, Cout1;
	assign Cout = (Cin & Cout1) | Cout0;
	fourbit_ra zero(.A(A[3:0]), .B(B[3:0]), .Cin(0), .S(S0[3:0]), .Cout(Cout0));
	fourbit_ra one(.A(A[3:0]), .B(B[3:0]), .Cin(1), .S(S1[3:0]), .Cout(Cout1));
	mux_2 m0(.S0(S0[3:0]), .S1(S1[3:0]), .cin(Cin), .Sout(Sout[3:0]));

endmodule


module mux_2
(
	input [3:0] S0,
	input [3:0] S1,
	input cin,
	output [3:0] Sout
);

	always_comb
	begin
		case (cin)
			1'b0	: Sout[3:0]= S0[3:0];
			1'b1	: Sout[3:0]= S1[3:0];
		endcase
	end
endmodule



module fourbit_ra
(
	input [3:0] A,
	input [3:0] B,
	input Cin,
	output logic [3:0] S,
	output logic Cout
	
);

	logic [2:0] C;
	fulladder fa0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(C[0]));
	fulladder fa1(.A(A[1]), .B(B[1]), .Cin(C[0]), .S(S[1]), .Cout(C[1]));
	fulladder fa2(.A(A[2]), .B(B[2]), .Cin(C[1]), .S(S[2]), .Cout(C[2]));
	fulladder fa3(.A(A[3]), .B(B[3]), .Cin(C[2]), .S(S[3]), .Cout(Cout));

endmodule




module fulladder
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
