module ControlUnit(
	input start, clk, endFlag, eqFlag, input [32:0] nBus,
	output reg ldX1, ldX2, ldt, ldW1, initW1, ldW2, initW2, ldB,
		initB, ldYin, initEndFlag, ldEndFlag, doneSignal
	);

	reg [2:0] ns, ps;
	reg [32:0] n, cnt;
	reg cntUp, initCnt, co;
	parameter [2:0] waiting=0, initializing=1, getData=2, computeYin=3,
		updateWiAndBias=4, reinitializing=5, done=6; 

	// setting next state
	always @(*) begin
		ns = waiting;
		case(ps)
			waiting: if(start == 1) ns=initializing; else ns=waiting;
			initializing: ns=getData;
			getData: ns=computeYin; 
			computeYin: 
				if(eqFlag == 0) 
					ns=updateWiAndBias;
				else
					if (co == 0)
						ns=getData;
					else
						if (endFlag == 0)
							ns=reinitializing;
						else
							ns=done;
			updateWiAndBias:
				if (co == 0)
					ns=getData;
				else
					if (endFlag == 1)
						ns=done;
					else
						ns=reinitializing;
			reinitializing: ns=getData;
			done: ns=waiting;
		endcase
	end

	// setting controller signals
	always @(*) begin
		{ldX1, ldX2, ldt, ldW1, initW1, ldW2, initW2, ldB, initB,
		 ldYin, initCnt, cntUp, initEndFlag, doneSignal, ldEndFlag} = 15'b0;
		case(ps)
			initializing: begin
				initW1=1'b1;
				initW2=1'b1;
				initB=1'b1;
				initCnt=1'b1;
				initEndFlag=1'b1;
				n = nBus;
			end
			getData: begin
				ldX1=1'b1;
				ldX2=1'b1;
				ldt=1'b1;
				cntUp=1'b1;
			end 
			computeYin: begin
				ldYin=1'b1;
				ldEndFlag=1'b1;
			end
			updateWiAndBias: begin
				ldW1=1'b1;
				ldW2=1'b1;
				ldB=1'b1;
			end
			reinitializing: begin
				initCnt=1'b1;
				initEndFlag=1'b1;
			end
			done: doneSignal=1'b1;
		endcase
	end

	// assigning next state to present state
	always@(posedge clk)begin
		ps <= ns;
	end

	// clock operations
	always @(posedge clk) begin
		if (initCnt) 
			cnt <= 32'b0;
		if (cntUp)
			cnt <= cnt + 1;
		co <= (cnt == n) ? 1'b1 : 1'b0;
	end

endmodule