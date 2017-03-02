module TestBench;
    reg signed [6:0] X1Bus, X2Bus;
    reg signed [1:0] tBus;
    reg clk = 1'b1, start;
    integer n = 0, i;
    reg [31:0] nBus;

    wire signed [13:0] W1, W2, Bias;
    wire done, readyToGetData, updateState, reinitializingState;

    NeuronModule NM(X1Bus, X2Bus, tBus, nBus, clk, start, W1, W2, Bias, done, readyToGetData, updateState, reinitializingState);

    reg signed [6:0] X1Inputs[4:0];
    reg signed [6:0] X2Inputs[4:0];
    reg signed [1:0] tInputs[4:0];
    reg signed [6:0] capturedX1, capturedX2;
    reg signed [1:0] capturedt;
    integer file;
    // setting clock to pulse every 100ns 
    initial repeat(500) begin
        #50
        clk = ~clk ;
    end
    
    initial begin
        file = $fopen("data_set_s.txt", "r");
        $stop;
        while(!$feof(file)) begin
            $fscanf(file, "%b %b %b", capturedX1, capturedX2, capturedt);
            X1Inputs[n] <= capturedX1;
            X2Inputs[n] <= capturedX2;
            tInputs[n] <= capturedt;
            n = n + 1;
        end
        nBus <= n[31:0];
    end  

    
    initial begin
        #90
        $stop;
        start <= 1'b1;
        #110
        // nBus
        start <= 1'b0;
        #100
        $stop;
        while(!done) begin
            i = 0;
            while(i<n) begin
                X1Bus <= X1Inputs[i];
                X2Bus <= X2Inputs[i];
                tBus <= tInputs[i];
                i = i + 1;
                $display("jallaaaaaal %d %d", n, i);    
                #100
                $stop;
                #100
                $stop;
                if (updateState) begin
                    #100
                    $stop;
                end
                if (reinitializingState) begin
                    #100
                    $stop;
                end
            end
            $stop;
        end
    end

endmodule 