`timescale 1ns/100ps

module Matrix_Multiplier_tb;
    reg[7:0] din;
    reg wrt_en, rst, clk;
    wire done;
    wire[16:0] dout;

    reg signed[7:0] matIn[31:0];
    reg signed[16:0] matExpect[15:0];
    reg [1023:0] input_file;

    Matrix_Multiplier instance_1(.din(din),
                    .wrt_en(wrt_en),
                    .rst(rst),
                    .clk(clk),
                    .done(done),
                    .dout(dout));

    initial begin
        clk=0;
        forever #5 clk=~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, Matrix_Multiplier_tb);
    end

    initial begin
        if (!$value$plusargs("INPUT=%s", input_file))
            input_file= "input/basic_positive.hex";
        $display("Loaded %0s", input_file);
        $readmemh(input_file, matIn, 0, 31);
    end

    initial begin
        #1000;
        $display("Timeout reached!");
        $finish;
    end

    task reset_dut;
        begin
            rst=1;
            wrt_en=0;
            din=8'b0;
        end
    endtask

    task input_load;
        integer i;
        begin
            wrt_en=1;

            @(posedge clk);

            for (i=0; i<32; i=i+1) begin
                @(negedge clk);
                din= S2CtoS(matIn[i]);
            end
            wrt_en=0;
        end
    endtask

    task calc_expect;
        integer r,c,k;
        reg signed[16:0] sum;
        begin
            for (r=0; r<4; r=r+1) begin
                for (c=0; c<4; c=c+1) begin
                    sum= 17'b0;
                    for (k=0; k<4; k=k+1) begin
                        sum= sum + matIn[r*4+k]*matIn[k*4+c+16];
                    end
                    matExpect[r*4+c]= sum;
                end
            end
        end
    endtask


    task check_dout;
        integer i, pass;
        begin
            pass=0;
            for (i=0;i <16; i=i+1) begin
                @(posedge clk);
                #1;
                if (StoS2C(dout)!==matExpect[i]) 
                    $display("%0d expected %0d got %0d.",i,matExpect[i],StoS2C(dout));
                else
                    pass= pass+1;
            end
            $display("%0d/16 passed!",pass);
        end
    endtask

    function [16:0] StoS2C;
        input[16:0] sign;
        begin
            StoS2C= (sign[16])? -$signed({1'b0,sign[15:0]}) : $signed({1'b0,sign[15:0]});
        end
    endfunction

    function [7:0] S2CtoS;
        input signed[7:0] S2C;
        begin
            S2CtoS= (S2C>=0)? {1'b0,S2C[6:0]} : {1'b1,~(S2C[6:0]-1'b1)};
        end
    endfunction

    initial begin
        reset_dut();

        #10 rst=0;
        input_load();

        calc_expect();

        wait(done);
        check_dout();

        $display("Simulation complete.");
        $finish;
    end


endmodule
