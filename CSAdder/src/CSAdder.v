`timescale 1ns/1ps

module CSAdder
    #(
        parameter BYTES=4
    )
    (
        input                       cin,
        input       [(BYTES*8)-1:0] a,
        input       [(BYTES*8)-1:0] b,

        output reg  [(BYTES*8)-1:0] q,
        output wire                 cout
    );

    reg [(BYTES*8)-1:8] sum0;
    reg [(BYTES*8)-1:8] sum1;
    reg [BYTES-1:1] carry0;
    reg [BYTES-1:1] carry1;
    reg [BYTES-1:0] carry;


    always @(*) begin
        {carry[0], q[7:0]} = a[7:0] + b[7:0] + cin;
    end

    generate
        genvar i;
        for (i=1; i<BYTES; i=i+1) begin
            always @(*) begin
                {carry0[i], sum0[(i*8)+7:i*8]} <= a[(i*8)+7:i*8] + b[(i*8)+7:i*8];
                {carry1[i], sum1[(i*8)+7:i*8]} <= a[(i*8)+7:i*8] + b[(i*8)+7:i*8] + 1;
                if (carry[i-1] == 0) begin
                    q[(i*8)+7:i*8] <= sum0[(i*8)+7:i*8];
                    carry[i] <= carry0[i];
                end
                else begin
                    q[(i*8)+7:i*8] <= sum1[(i*8)+7:i*8];
                    carry[i] <= carry1[i];
                end
            end
        end
    endgenerate

    assign cout = carry[BYTES-1];

endmodule // add_bits

   
