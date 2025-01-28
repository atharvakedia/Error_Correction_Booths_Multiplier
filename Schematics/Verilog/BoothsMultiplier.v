module DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;

    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end

    assign out = count;
    assign ovf = en? &count : 1'b0;

    initial begin
        count = 'h0;
    end
endmodule

module DIG_D_FF_1bit
#(
    parameter Default = 0
)
(
   input D,
   input C,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q = ~state;

    always @ (posedge C) begin
        state <= D;
    end

    initial begin
        state = Default;
    end
endmodule


module ControlUnit (
  input CLK,
  input RST,
  output \END ,
  output INIT,
  output EX_OP,
  output SHIFT
);
  wire END_temp;
  wire INIT_temp;
  wire s0;
  wire [4:0] s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  DIG_Counter_Nbit #(
    .Bits(5)
  )
  DIG_Counter_Nbit_i0 (
    .en( s0 ),
    .C( CLK ),
    .clr( RST ),
    .out( s1 )
  );
  assign s2 = s1[0];
  assign s3 = s1[1];
  assign s4 = s1[3];
  assign s5 = s1[4];
  assign INIT_temp = ~ (s2 | s3 | s1[2] | s4 | s5);
  assign END_temp = (s5 & s4 & s3 & s2);
  assign s6 = (~ END_temp & s2 & ~ INIT_temp);
  assign s0 = ~ END_temp;
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i1 (
    .D( s6 ),
    .C( CLK ),
    .Q( s7 )
  );
  assign EX_OP = (s6 & ~ CLK);
  assign SHIFT = (s7 & ~ CLK);
  assign \END  = END_temp;
  assign INIT = INIT_temp;
endmodule

module DIG_D_FF_AS_1bit
#(
    parameter Default = 0
)
(
   input Set,
   input D,
   input C,
   input Clr,
   output Q,
   output \~Q
);
    reg state;

    assign Q = state;
    assign \~Q  = ~state;

    always @ (posedge C or posedge Clr or posedge Set)
    begin
        if (Set)
            state <= 1'b1;
        else if (Clr)
            state <= 'h0;
        else
            state <= D;
    end

    initial begin
        state = Default;
    end
endmodule

module Mux_2x1
(
    input [0:0] sel,
    input in_0,
    input in_1,
    output reg out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule


module ShiftBit (
  input EN,
  input SHIFT_IN,
  input LOAD,
  input BIT_IN,
  input CLR,
  input CLK,
  output OUT
);
  wire s0;
  wire s1;
  wire s2;
  wire OUT_temp;
  assign s0 = ((EN & SHIFT_IN) | (LOAD & BIT_IN));
  assign s1 = (LOAD | EN);
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i0 (
    .Set( 1'b0 ),
    .D( s2 ),
    .C( CLK ),
    .Clr( CLR ),
    .Q( OUT_temp )
  );
  Mux_2x1 Mux_2x1_i1 (
    .sel( s1 ),
    .in_0( OUT_temp ),
    .in_1( s0 ),
    .out( s2 )
  );
  assign OUT = OUT_temp;
endmodule

module Shifter (
  input CLK,
  input CLR,
  input LOAD,
  input SHIFT,
  input SHIFT_IN,
  input [12:0] DATA_IN,
  output [12:0] DATA_OUT
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire s11;
  wire s12;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  wire s18;
  wire s19;
  wire s20;
  wire s21;
  wire s22;
  wire s23;
  wire s24;
  wire s25;
  assign s24 = DATA_IN[0];
  assign s7 = DATA_IN[1];
  assign s5 = DATA_IN[2];
  assign s3 = DATA_IN[3];
  assign s1 = DATA_IN[4];
  assign s16 = DATA_IN[5];
  assign s14 = DATA_IN[6];
  assign s12 = DATA_IN[7];
  assign s10 = DATA_IN[8];
  assign s23 = DATA_IN[9];
  assign s21 = DATA_IN[10];
  assign s19 = DATA_IN[11];
  assign s17 = DATA_IN[12];
  ShiftBit ShiftBit_i0 (
    .EN( SHIFT ),
    .SHIFT_IN( SHIFT_IN ),
    .LOAD( LOAD ),
    .BIT_IN( s17 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s18 )
  );
  ShiftBit ShiftBit_i1 (
    .EN( SHIFT ),
    .SHIFT_IN( s18 ),
    .LOAD( LOAD ),
    .BIT_IN( s19 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s20 )
  );
  ShiftBit ShiftBit_i2 (
    .EN( SHIFT ),
    .SHIFT_IN( s20 ),
    .LOAD( LOAD ),
    .BIT_IN( s21 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s22 )
  );
  ShiftBit ShiftBit_i3 (
    .EN( SHIFT ),
    .SHIFT_IN( s22 ),
    .LOAD( LOAD ),
    .BIT_IN( s23 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s9 )
  );
  ShiftBit ShiftBit_i4 (
    .EN( SHIFT ),
    .SHIFT_IN( s9 ),
    .LOAD( LOAD ),
    .BIT_IN( s10 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s11 )
  );
  ShiftBit ShiftBit_i5 (
    .EN( SHIFT ),
    .SHIFT_IN( s11 ),
    .LOAD( LOAD ),
    .BIT_IN( s12 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s13 )
  );
  ShiftBit ShiftBit_i6 (
    .EN( SHIFT ),
    .SHIFT_IN( s13 ),
    .LOAD( LOAD ),
    .BIT_IN( s14 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s15 )
  );
  ShiftBit ShiftBit_i7 (
    .EN( SHIFT ),
    .SHIFT_IN( s15 ),
    .LOAD( LOAD ),
    .BIT_IN( s16 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s0 )
  );
  ShiftBit ShiftBit_i8 (
    .EN( SHIFT ),
    .SHIFT_IN( s0 ),
    .LOAD( LOAD ),
    .BIT_IN( s1 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s2 )
  );
  ShiftBit ShiftBit_i9 (
    .EN( SHIFT ),
    .SHIFT_IN( s2 ),
    .LOAD( LOAD ),
    .BIT_IN( s3 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s4 )
  );
  ShiftBit ShiftBit_i10 (
    .EN( SHIFT ),
    .SHIFT_IN( s4 ),
    .LOAD( LOAD ),
    .BIT_IN( s5 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s6 )
  );
  ShiftBit ShiftBit_i11 (
    .EN( SHIFT ),
    .SHIFT_IN( s6 ),
    .LOAD( LOAD ),
    .BIT_IN( s7 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s8 )
  );
  ShiftBit ShiftBit_i12 (
    .EN( SHIFT ),
    .SHIFT_IN( s8 ),
    .LOAD( LOAD ),
    .BIT_IN( s24 ),
    .CLR( CLR ),
    .CLK( CLK ),
    .OUT( s25 )
  );
  assign DATA_OUT[0] = s25;
  assign DATA_OUT[1] = s8;
  assign DATA_OUT[2] = s6;
  assign DATA_OUT[3] = s4;
  assign DATA_OUT[4] = s2;
  assign DATA_OUT[5] = s0;
  assign DATA_OUT[6] = s15;
  assign DATA_OUT[7] = s13;
  assign DATA_OUT[8] = s11;
  assign DATA_OUT[9] = s9;
  assign DATA_OUT[10] = s22;
  assign DATA_OUT[11] = s20;
  assign DATA_OUT[12] = s18;
endmodule
module DIG_Add
#(
    parameter Bits = 1
)
(
    input [(Bits-1):0] a,
    input [(Bits-1):0] b,
    input c_i,
    output [(Bits - 1):0] s,
    output c_o
);
   wire [Bits:0] temp;

   assign temp = a + b + c_i;
   assign s = temp [(Bits-1):0];
   assign c_o = temp[Bits];
endmodule



module DIG_Sub #(
    parameter Bits = 2
)
(
    input [(Bits-1):0] a,
    input [(Bits-1):0] b,
    input c_i,
    output [(Bits-1):0] s,
    output c_o
);
    wire [Bits:0] temp;

    assign temp = a - b - c_i;
    assign s = temp[(Bits-1):0];
    assign c_o = temp[Bits];
endmodule


module DIG_Register
(
    input C,
    input en,
    input D,
    output Q
);

    reg  state = 'h0;

    assign Q = state;

    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule

module Mux_2x1_NBits #(
    parameter Bits = 2
)
(
    input [0:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule


module BoothsMultiplier (
  input CLK,
  input CLR,
  input [12:0] MULTIPLIER,
  input [12:0] MULTIPLICAND,
  output [25:0] RESULT,
  output DONE,
  output [1:0] OP_DONE
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire [12:0] s5;
  wire [12:0] s6;
  wire s7;
  wire [12:0] s8;
  wire [25:0] RESULT_temp;
  wire [12:0] s9;
  wire [12:0] s10;
  wire [12:0] s11;
  wire [12:0] s12;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  ControlUnit ControlUnit_i0 (
    .CLK( CLK ),
    .RST( CLR ),
    .\END ( DONE ),
    .INIT( s0 ),
    .EX_OP( s1 ),
    .SHIFT( s2 )
  );
  // ACCUMULATOR
  Shifter Shifter_i1 (
    .CLK( CLK ),
    .CLR( CLR ),
    .LOAD( s3 ),
    .SHIFT( s2 ),
    .SHIFT_IN( s4 ),
    .DATA_IN( s5 ),
    .DATA_OUT( s6 )
  );
  // MULTIPLIER
  Shifter Shifter_i2 (
    .CLK( CLK ),
    .CLR( CLR ),
    .LOAD( s0 ),
    .SHIFT( s2 ),
    .SHIFT_IN( s7 ),
    .DATA_IN( MULTIPLIER ),
    .DATA_OUT( s8 )
  );
  DIG_Add #(
    .Bits(13)
  )
  DIG_Add_i3 (
    .a( s9 ),
    .b( MULTIPLICAND ),
    .c_i( 1'b0 ),
    .s( s10 )
  );
  DIG_Sub #(
    .Bits(13)
  )
  DIG_Sub_i4 (
    .a( s11 ),
    .b( MULTIPLICAND ),
    .c_i( 1'b0 ),
    .s( s12 )
  );
  assign s3 = ((s14 ^ s15) & s1);
  assign s17 = (MULTIPLICAND[12] ^ s13);
  // F2
  DIG_D_FF_AS_1bit #(
    .Default(0)
  )
  DIG_D_FF_AS_1bit_i5 (
    .Set( 1'b0 ),
    .D( s17 ),
    .C( s3 ),
    .Clr( CLR ),
    .Q( s4 )
  );
  assign RESULT_temp[12:0] = s8;
  assign RESULT_temp[25:13] = s6;
  assign s9 = RESULT_temp[25:13];
  assign s11 = RESULT_temp[25:13];
  assign s7 = RESULT_temp[13];
  assign s16 = RESULT_temp[0];
  assign s15 = RESULT_temp[0];
  // F1
  DIG_Register DIG_Register_i6 (
    .D( s16 ),
    .C( CLK ),
    .en( 1'b1 ),
    .Q( s14 )
  );
  assign s13 = (~ s14 & s15);
  assign OP_DONE[0] = RESULT_temp[0];
  assign OP_DONE[1] = s14;
  Mux_2x1_NBits #(
    .Bits(13)
  )
  Mux_2x1_NBits_i7 (
    .sel( s13 ),
    .in_0( s10 ),
    .in_1( s12 ),
    .out( s5 )
  );
  assign RESULT = RESULT_temp;
endmodule
