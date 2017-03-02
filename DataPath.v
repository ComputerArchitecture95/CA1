module DataPath( input[6:0] X1Bus, X2Bus, input[1:0] tBus, input clk, 
	input ldX1, ldX2, ldt, 
	ldW1, initW1, ldW2, initW2, 
	ldB, initB,
	ldYin,
	ldEndFlag, initEndFlag,
	output reg endFlag, output eqFlag,
	output reg [13:0] W1, W2, output reg [13:0] Bias );

	reg signed [6:0] X1, X2;
	reg signed [1:0] t;
	reg signed [13:0] Yin;
	wire signed [1:0] sign;

	// X1 Register
	always @(posedge clk or ldX1) begin
		if(ldX1)
			X1 <= X1Bus;
	end

	// X2 Register
	always @(posedge clk or ldX2) begin
		if(ldX2)
			X2 <= X2Bus;
	end

	// t Register
	always @(posedge clk or ldt) begin
		if(ldt)
			t <= tBus;
	end	

	// W1 Register
	always @(posedge clk or initW1 or ldW1) begin
		if(initW1)
			W1 <= 14'b0;
		if(ldW1)
			W1 <= (5'b0_1100 * X1 * t) + W1;
	end

	// W2 Register
	always @(posedge clk or initW2 or ldW2) begin
		if(initW2)
			W2 <= 14'b0;
		if(ldW2)
			W2 <= (5'b0_1100 * X2 * t) + W2;
	end

	// Bias Register
	always @(posedge clk or initB or ldB) begin
		if(initB)
			Bias <= 14'b0;
		if(ldB)
			Bias <= (12'b0000_11000000 * t) + Bias;
	end

	// Yin Register
	always @(posedge clk or ldYin) begin
		if(ldYin)
			Yin <= (X1 * (W1 << 4) + X2 * (W2 << 4)) + Bias;
	end

	// endFlag Register
	always @(posedge clk or initEndFlag or ldEndFlag) begin
		if (initEndFlag)
			endFlag <= 1'b1;
		if(ldEndFlag)
			endFlag <= (eqFlag & endFlag);
	end


	// sign
	assign sign = Yin[13] ? 2'b11 : 2'b01;
	// comp
	assign eqFlag = (sign == t) ? 1'b1 : 1'b0;
endmodule