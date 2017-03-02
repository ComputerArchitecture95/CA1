module TestBench;
    signed reg[6:0] X1Bus, X2Bus;
    signed reg[1:0] tBus;
    reg clk = 1'b1, start;
    reg[31:0] nBus;
    signed wire [13:0] W1, W2, Bias;
    wire done;

    NeuronModule NM(X1Bus, X2Bus, tBus, nBus, clk, start, W1, W2, Bias, done);

    signed reg[6:0] X1Inputs[500:0];
    signed reg[6:0] X2Inputs[500:0];
    signed reg[1:0] tInputs[500:0];
    signed reg[6:0] capturedX1, capturedX2;
    signed reg[1:0] capturedt;
    integer file;
    // setting clock to pulse every 100ns 
    initial repeat(500) begin
        #50
        clk = ~clk ;
    end
    


    initial begin
        nBus <= 32'b0;
        file = $fopen("data_set.txt", "r");
        while(!$feof(file)) {
            $fscanf(file, "%b %b %b", capturedX1, capturedX2, capturedt);
            X1Inputs[nBus] <= capturedX1;
            X2Inputs[nBus] <= capturedX2;
            capturedt[nBus] <= capturedt;
            nBus = nBus + 1;
        }

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