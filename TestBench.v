module TestBench;
    reg[6:0] X1Bus, X2Bus;
    reg[1:0] tBus;
    reg clk = 1'b1, start;
    reg[31:0] nBus;
    wire [13:0] W1, W2, Bias;
    wire done;

    NeuronModule NM(X1Bus, X2Bus, tBus, nBus, clk, start, W1, W2, Bias, done);

    reg[6:0] X1Inputs[50:0];
    reg[6:0] X2Inputs[50:0];
    reg[1:0] tInputs[50:0];

    // setting clock to pulse every 100ns 
    initial repeat(500) begin
        #50
        clk = ~clk ;
    end
    
    initial begin
        #90
        start <= 1'b1;
        #100
        nBus <= 4'h00000005;
        #100
        start <= 1'b0;
        X1Bus <= 7'b1110000;
        X2Bus <= 7'b1110000;
        tBus <= 2'b11;
        #100
        #100
        #100
        #100

        $stop;
    end
endmodule 