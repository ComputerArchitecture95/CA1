module NeuronModule(input[6:0] X1Bus, X2Bus, input[1:0] tBus, input[31:0]nBus,
	input clk, start, output [13:0] W1, W2, Bias, output done, readyToGetData, updateState, reinitializingState);

	wire ldX1, ldX2, ldt, ldW1, initW1, ldW2, initW2, ldB, initB,
		ldYin, ldEndFlag, initEndFlag, endFlag, eqFlag;

	ControlUnit CU(start, clk, endFlag, eqFlag, nBus,
		ldX1, ldX2, ldt, ldW1, initW1, ldW2, initW2, ldB,
		initB, ldYin, initEndFlag, ldEndFlag, done, readyToGetData
		,updateState, reinitializingState
	);

	DataPath DP(X1Bus, X2Bus, tBus, clk, 
		ldX1, ldX2, ldt, ldW1, initW1, ldW2, initW2, 
		ldB, initB, ldYin, ldEndFlag, initEndFlag,
		endFlag, eqFlag, W1, W2, Bias );
endmodule 