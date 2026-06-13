`timescale 1ns/10ps

module Matrix_Multiplier (
    input[7:0] din, input wrt_en, input rst, input clk, output reg[16:0]  dout, output done
);
    
    localparam IDLE=0, LOAD=1, CALC=2, OUT=3;
    reg[1:0] next_state, state;

    reg signed[7:0] matA[0:15], matB[0:15];
    wire signed[31:0] row0, row1, row2, row3;
    wire signed[31:0] colB;
    wire signed[16:0] res0, res1, res2, res3;
    reg signed[16:0] matR[0:15];
    wire signed[7:0] sign_din;

    reg[4:0] loadcount;
    reg[1:0] col;
    reg[3:0] outcount;
    integer i;

    always @(*) begin
        case (state)
            IDLE:   next_state= (wrt_en)? LOAD:IDLE;
            LOAD:   next_state= (loadcount==31)? CALC:LOAD;
            CALC:   next_state= (col==3)? OUT:CALC;
            OUT:    next_state= (outcount==15)? IDLE:OUT;
        endcase
    end

    always @(posedge clk) begin
        if (rst) 
            {state,loadcount,col,outcount}<=13'b0;
        else begin
            state<= next_state;

            if (state==LOAD && loadcount==0) begin
                for (i=0; i<16; i=i+1) 
                    matR[i]<= 17'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (state==LOAD) begin
            loadcount<= loadcount+1'b1;
        end else if (state==CALC) begin
            col<= col+1;
        end else if (state==OUT) begin
            outcount<=outcount+1;
        end else
            {loadcount,col,outcount}<= 11'b0;
    end

    always @(posedge clk) begin
        if (state==LOAD) begin
            if (loadcount<=5'd15)
                matA[loadcount[3:0]]<= sign_din;
            else
                matB[loadcount-16]<= sign_din;
        end else if (state==CALC) begin
            matR[0*4+col]<= res0;
            matR[1*4+col]<= res1;
            matR[2*4+col]<= res2;
            matR[3*4+col]<= res3;
        end else if (state==OUT) 
            dout<= (matR[outcount]>=0)? {1'b0,matR[outcount][15:0]} : {1'b1,~(matR[outcount][15:0]-1'b1)};
    end

    

    assign row0= {matA[0*4+0],matA[0*4+1],matA[0*4+2],matA[0*4+3]};
    assign row1= {matA[1*4+0],matA[1*4+1],matA[1*4+2],matA[1*4+3]};
    assign row2= {matA[2*4+0],matA[2*4+1],matA[2*4+2],matA[2*4+3]};
    assign row3= {matA[3*4+0],matA[3*4+1],matA[3*4+2],matA[3*4+3]};

    assign colB= {matB[0*4+col],matB[1*4+col],matB[2*4+col],matB[3*4+col]};

    Multiplier i0 (.rowA(row0),
                   .colB(colB),
                   .result(res0));
    Multiplier i1 (.rowA(row1),
                   .colB(colB),
                   .result(res1));
    Multiplier i2 (.rowA(row2),
                   .colB(colB),
                   .result(res2));
    Multiplier i3 (.rowA(row3),
                   .colB(colB),
                   .result(res3));


    assign sign_din= (din[7])? -$signed({1'b0,din[6:0]}) : $signed({1'b0,din[6:0]});
    assign done= (state==OUT);


endmodule

