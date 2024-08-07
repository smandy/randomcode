#!/usr/bin/env rdmd

import std.exception;
import std.format;
import std.stdio;
import std.algorithm;
import std.range;
import std.functional;

struct TestRun {
  uint  solution;
  auto solved  = false;
  auto torches = 2;
  int[] guesses;

  this(uint n) {
    solution = n;
  };

  auto guess(int x) {
    enforce( torches >= 0, "No torches");
    guesses ~= x;
    auto ret = x <= solution;
    if (!ret) torches--;
    writefln("Guess #%s : %s -> %5s, torches left = %s", guesses.length, x, ret, torches);
    return ret;
  };
  
  void assertValue(uint x ) {
    enforce( x == solution, format("Guess %s value is %s", x, solution));
    writefln("Correct assertion %s", x);
    solved = true;
  };
}

struct TestHarness(StratType) {
  int[][int] guesses;
  void test( ref StratType strat ) {
    for(uint i = 1;i<100;++i) {
      writefln("\nTesting %s", i);
      auto r = TestRun(i);
      strat.newRun(r);
      enforce( r.solved, "No solutiojn at %s".format(i));
      guesses[i] = r.guesses;
    };
    if (false) {
      foreach( q,v ; guesses) {
        writefln("%s : %s", q, v);
      };
    }
    auto worst = guesses.values
      .map!"a.length"
      .reduce!max;
    writefln("\n\nWorst is %s".format(worst));
  };
};

struct BuyOpt {
  int[] xs;
  this( int[] xs) {
    this.xs = xs;
  };
  void newRun( ref TestRun s) {
    auto xs = xs[]; // piecewise copy
    auto floor = 1;
    int guess;
    while (true) {
      guess = xs.front;
      xs.popFront;
      auto torchIsSafe = s.guess(guess);
      //writefln("Guess #%s - %s %s".format(s.guesses.length, guess, torchIsSafe));
      if (torchIsSafe) {
        floor = guess + 1;
      } else {
        writefln("Were between %s and %s with %s torches left".format(floor, guess, s.torches));
        break;
      };
    }

    auto haveAsserted = false;
    for (int y = floor;y<guess;++y) {
      auto torchSafe = s.guess(y);
      //writefln("Guess #%s - %s %s".format(s.guesses.length, y, torchSafe));
      if (!torchSafe) {
        //writefln("Asserting %s".format(y-1));
        s.assertValue( y - 1 );
        haveAsserted = true;
        break;
      } 
    };

    if (!haveAsserted) {
      //writefln("Must be %s" , guess - 1 );
      s.assertValue( guess - 1);
    };
  };
};

void main() {
  auto gaps = [14,13,12,11,10,9,8,7,6,5,4,4];
  int[] xs;
  auto s = 0;
  foreach( int i ; gaps) {
    s += i;
    xs ~= s;
  };
  writefln("Woot");
  TestHarness!BuyOpt a;
  writefln("Calling test %s", a);
  auto b = BuyOpt(xs); 
  writefln("%s",b);
  a.test( b);
};
