/* 
 * CS:APP Data Lab 
 * 
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting if the shift amount
     is less than 0 or greater than 31.


EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

/*
 * STEP 2: Modify the following functions according the coding rules.
 */


#endif
/* Copyright (C) 1991-2012 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

/* 
 * specialBits - return bit pattern 0xffca3fff
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 3
 *   Rating: 1
 */
int specialBits(void) {
    int eight_bit_move = 215 << 14;           //215 = 11010111
    return ~eight_bit_move;
}

/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
  //important realization: INT_MAX *and 1...1* is the only case where
  // + 1 and negation result in the same bits
  int neg = ~x;
  int plus_one = x + 1;
  //if these are the same, then x is INT_MAX: use XOR
  int xor_IM = neg ^ plus_one;
  //at this point, xor_IM should be all 0's IFF the goal is met
  //so, what I can do is ! this variable:
  ///this returns "1" if xor_IM is all 0's because !0 = 1
  ///this returns "0" if xor_IM is any other value than 0: !(true) = 0
  //1...1 is also a case where this is true, so need to check that the
  ///input is not 1...1:
  int negative_one_checker = x ^ 0;  //all 1's if x = 1...1
  int should_be_zero = ~negative_one_checker;  //0...0 if x = 1...1
  int clearer = !should_be_zero;  //1 if zhould_be_zero is 0
  return (!xor_IM) & (!clearer);

  /*
  ///OLD METHOD that used shifts
  int torch = 1 << 31;
  int goal = ~torch;
  int xor_IM = goal ^ x;
  //at this point, xor_IM should be all 0's IFF the goal is met
  //so, what I can do is ! this variable:
  ///this returns "1" if xor_IM is all 0's because !0 = 1
  ///this returns "0" if xor_IM is any other value than 0: !(true) = 0
  int mask_little = !xor_IM;
  int mask = (mask_little << 31)>>31;
  */
}

/* 
 * anyEvenBit - return 1 if any even-numbered bit in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples anyEvenBit(0xA) = 0, anyEvenBit(0xE) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int anyEvenBit(int x) {
  int eight_bit = 85 << 8;  //01010101 00000000
  int sixteen_bit = (eight_bit + 85) << 8; //01010101 01010101 00000000
  int twentyfour_bit = (sixteen_bit + 85) << 8;
  int thirtytwo_bit = (twentyfour_bit + 85);
  int and_IM = x & thirtytwo_bit;
  //so, by and-ing these components, there will be "1's" wherever
  ///1's are present in even spots
  ///thus, and_IM will be all 0's in the case that there are no
  ///1's in even spots!
  //again, we invoke the ! operator:
  ///returns "1" if and_IM is all 0's
  ///returns "0" if and_IM has any 1's in even spots
  int check = !and_IM;
  //this is reverse what we want to return, so return the opposite:
  return !check;
}

/* 
 * replaceByte(x,n,c) - Replace byte n in x with c
 *   Bytes numbered from 0 (LSB) to 3 (MSB)
 *   Examples: replaceByte(0x12345678,1,0xab) = 0x1234ab78
 *   You can assume 0 <= n <= 3 and 0 <= c <= 255
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 10
 *   Rating: 3
 */
int replaceByte(int x, int n, int c) {
  int bit_shift = n << 3; //multiply n by 8 to get bits to shift
  int mask = 255 << bit_shift; //11111111 in wherever it is you want to zero
  int zero = ~mask;
  int byte_zeroed = x & zero;
  int c_shifted = c << bit_shift; //c in wherever it is you want to replace
  return byte_zeroed | c_shifted;
}

/* 
 * signMag2TwosComp - Convert from sign-magnitude to two's complement
 *   where the MSB is the sign bit
 *   Example: signMag2TwosComp(0x80000005) = -5.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 4
 */
int signMag2TwosComp(int x) {
  //there are THREE cases:
  /// 1) positive:
  ///    In the positive case, sign-magnitude and two's complement
  ///    are the same
  /// 2) negative:
  ///    In the negative case, you need to convert bits 0 to 30 from
  ///    "unsigned" to "signed"

  //First, isolate the MSB:
  int msb_mask = 1<<31;
  int msb = x & msb_mask;
  //Now, smear it all the way to the write to create your boolean
  //    ***If the input is negative, the flag will be all 1's
  int negative_flag = msb >> 31;
  //Now, isolate everything BUT the MSB:
  int data_mask = ~msb_mask;
  int data = x & data_mask;
  //Now, we create the return value that will be returned if the
  //    input is negative: CONVERT data to the negative rep!
  int data_two = ~data + 1;
  return ((negative_flag & data_two) | (~negative_flag & data));
}

/* 
 * twosComp2SignMag - Convert from two's complement to sign-magnitude 
 *   where the MSB is the sign bit
 *   You can assume that x > TMin
 *   Example: twosComp2SignMag(-5) = 0x80000005.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 4
 */
int twosComp2SignMag(int x) {
  /// ***There is 1 case that is impossible: 10...0
  ///       In this case, you'd need ANOTHER bit to represent this
  ///       value correctly, so I will assume that this works
  ///       systematically or will not be inputted
  /// OTHER THAN THAT IT'S THE SAME CODE AS THE PREVIOUS!!!

  int msb_mask = 1<<31;
  int msb = x & msb_mask;
  int negative_flag = msb >> 31;
  int data_mask = ~msb_mask;
  int data = x & data_mask;
  int data_two = ~data + 1;
  return ((negative_flag & data_two) | (~negative_flag & data));
}

/*
 * intLog2 - return floor(log base 2 of x), where x > 0
 *   Example: intLog2(16) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 90
 *   Rating: 4
 */
int intLog2(int x) {
  //The logic is actually very straightforward: I found that the return
  //    value can be calculated as follows: right-shift until you reach
  //    the MSB. The number of right-shifts performed is the returned 
  //    value. In other words, we JUST want to find WHERE the MSB is!
  //The code logic is pretty brute force: basically you keep shifting
  //    right by 1, and if the remaining segment still has 1's, then you
  //    haven't reached the MSB, so you add 1. Once you reach 0, you've
  //    reached the MSB and don't add anything to ret.
  int ret = 0;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  x >>= 1;
  ret += !!x;
  return ret;
}
