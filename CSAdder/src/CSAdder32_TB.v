`timescale 1ns/1ps

module CSAdder32_TB ();

   localparam TEST_DURATION = 64;

   localparam BYTES=4;
   localparam W=BYTES*8;
   
   reg      clk;
   integer  clk_count;
   integer  fail_count;

   // DECLARE SIGNALS
   reg            cin;
   reg  [W-1:0]   a;
   reg  [W-1:0]   b;
   wire [W-1:0]   q;
   wire           cout;

   CSAdder uut
      (
         .cin(cin),
         .a(a),
         .b(b),
         .q(q),
         .cout(cout)
      );

   initial forever #5 clk = ~clk;

   initial begin
      clk = 0;
      cin = 0;
      a   = 0;
      b   = 0;
      clk_count = 0;
      fail_count = 0;
      // Dump waveform
      $dumpfile("CSAdder");
      $dumpvars(2, CSAdder32_TB);
   end

   always @(posedge clk) begin
      cin <= $random();
      a <= $random();
      b <= $random();

      $write("clk:  %d", clk_count);      
      $write("\t0x%h_%h (%d)", a[W-1:W/2], a[(W/2)-1:0], a);
      $write(" + 0x%h_%h (%d)", b[W-1:W/2], b[(W/2)-1:0], b);
      $write(" + %b", cin);
      $write("\t  =  0x%h_%h_%h (%d)", cout, q[W-1:W/2], q[(W/2)-1:0], {cout,q});
      if (a+b+cin != {cout,q}) begin
         $write("\t\tFAIL");
         fail_count = fail_count + 1;
      end
      $write("\n");

      clk_count <= clk_count + 1;
      if (clk_count > TEST_DURATION) begin
         $write("\n");
         if (fail_count > 0) begin
            $write("Failed %d tests\n\n", fail_count);
         end
         else begin
            $write("All tests passed\n\n");
         end
         $finish();
      end
   end
   
endmodule // testbench
