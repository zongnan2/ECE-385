module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
   logic [3:0] C;
	logic [3:0] P;
	logic [3:0] G;
	logic P_g;
	logic G_g;
	assign CO = C[3];
	carry_lookahead_unit CLU(.P(P[3:0]), .G(G[3:0]), .cin(cin), .cout(C[3:0]), .P_G(P_g), .G_G(G_g));
	fourbit_lookahead four0(.A(A[3:0]),   .B(B[3:0]),   .cin(0),  .S(Sum[3:0]), .P_g(P[0]), .G_g(G[0]));
	fourbit_lookahead four1(.A(A[7:4]),   .B(B[7:4]),   .cin(C[0]), .S(Sum[7:4]), .P_g(P[1]), .G_g(G[1]));
	fourbit_lookahead four2(.A(A[11:8]),  .B(B[11:8]),  .cin(C[1]), .S(Sum[11:8]), .P_g(P[2]), .G_g(G[2]));
	fourbit_lookahead four3(.A(A[15:12]), .B(B[15:12]), .cin(C[2]), .S(Sum[15:12]), .P_g(P[3]), .G_g(G[3]));
endmodule


module fourbit_lookahead
(
	 input	[3:0] A,
	 input	[3:0] B,
	 input	cin,
	 output logic [3:0] S,
	 output logic P_g,
	 output logic G_g,
	 output logic cout
);
	logic [3:0] C;
	logic [3:0] P;
	logic [3:0] G;
	assign cout = C[3];
	carry_lookahead_unit CLU(.P(P[3:0]), .G(G[3:0]), .cin(cin), .cout(C[3:0]), .P_G(P_g), .G_G(G_g));
	single_lookahead_adder four0(.A_single(A[0]), .B_single(B[0]), .Cin(cin),  .S_single(S[0]), .P_single(P[0]), .G_single(G[0]));
	single_lookahead_adder four1(.A_single(A[1]), .B_single(B[1]), .Cin(C[0]), .S_single(S[1]), .P_single(P[1]), .G_single(G[1]));
	single_lookahead_adder four2(.A_single(A[2]), .B_single(B[2]), .Cin(C[1]), .S_single(S[2]), .P_single(P[2]), .G_single(G[2]));
	single_lookahead_adder four3(.A_single(A[3]), .B_single(B[3]), .Cin(C[2]), .S_single(S[3]), .P_single(P[3]), .G_single(G[3]));
	
endmodule



module carry_lookahead_unit
(
	 input	[3:0] P,
	 input	[3:0] G,
	 input	cin,
	 output logic [3:0] cout,
	 output logic P_G,
	 output logic G_G
	 
);
	always_comb
	begin: OUT
		cout[0] = cin;
		cout[1] = cout[0] & P[0] | G[0];
		cout[2] = cout[1] & P[1] | G[1];
		cout[3] = cout[2] & P[2] | G[2];
	end: OUT
	assign P_G = P[0] & P[1] & P[2] & P[3];
	assign G_G = G[3] | (G[2]&P[3]) | (G[1]&P[3]&P[2]) | (G[0]&P[3]&P[2]&P[1]);
	
endmodule

module single_lookahead_adder
(
	 input	A_single,
	 input	B_single,
	 input	Cin,
	 output logic S_single,
	 output logic P_single,
	 output logic G_single
	 
);
	assign S_single = A_single ^ B_single ^ Cin;
	assign G_single = A_single & B_single;
	assign P_single = A_single ^ B_single;
	
endmodule
